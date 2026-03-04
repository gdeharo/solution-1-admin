#!/usr/bin/env node

import fs from 'node:fs/promises';
import path from 'node:path';
import crypto from 'node:crypto';

async function loadDotEnv(filepath = path.resolve(process.cwd(), '.env')) {
  try {
    const text = await fs.readFile(filepath, 'utf8');
    for (const rawLine of text.split(/\r?\n/)) {
      const line = rawLine.trim();
      if (!line || line.startsWith('#')) continue;

      const eq = line.indexOf('=');
      if (eq <= 0) continue;

      const key = line.slice(0, eq).trim();
      let value = line.slice(eq + 1).trim();
      if (
        (value.startsWith('"') && value.endsWith('"')) ||
        (value.startsWith("'") && value.endsWith("'"))
      ) {
        value = value.slice(1, -1);
      }

      if (!(key in process.env)) {
        process.env[key] = value;
      }
    }
  } catch (error) {
    if (error?.code !== 'ENOENT') throw error;
  }
}

function printHelp() {
  console.log(`
Apple Music Batch Importer

Usage:
  node src/import-songs.mjs --input <songs.csv> [options]

Required:
  --input <path>              CSV with headers: song,artist,album (artist/album optional)

Options:
  --playlist <name>           Playlist name to create when using --apply
  --storefront <code>         Apple storefront code (default: env APPLE_STOREFRONT or us)
  --top <n>                   Search results per song (default: 5)
  --threshold <0..1>          Auto-match threshold (default: 0.62)
  --output-dir <path>         Output directory (default: ./output)
  --apply                     Create playlist + add matched songs
  --help                      Show this help

Environment:
  APPLE_TEAM_ID
  APPLE_KEY_ID
  APPLE_PRIVATE_KEY_PATH      Path to .p8 key file (preferred)
  APPLE_PRIVATE_KEY           Raw private key content (optional alternative)
  APPLE_MUSIC_USER_TOKEN      User token from MusicKit authorization
  APPLE_STOREFRONT            Optional default storefront code
`);
}

function parseArgs(argv) {
  const args = {
    top: 5,
    threshold: 0.62,
    apply: false,
    outputDir: path.resolve(process.cwd(), 'output')
  };

  for (let i = 2; i < argv.length; i += 1) {
    const token = argv[i];
    if (token === '--help' || token === '-h') {
      args.help = true;
      continue;
    }
    if (token === '--apply') {
      args.apply = true;
      continue;
    }

    const [key, value] = token.startsWith('--') ? token.split('=') : [token, null];
    const next = value ?? argv[i + 1];

    const consumeNext = () => {
      if (value == null) i += 1;
      return next;
    };

    if (key === '--input') args.input = path.resolve(process.cwd(), consumeNext());
    else if (key === '--playlist') args.playlist = consumeNext();
    else if (key === '--storefront') args.storefront = consumeNext();
    else if (key === '--top') args.top = Number.parseInt(consumeNext(), 10);
    else if (key === '--threshold') args.threshold = Number.parseFloat(consumeNext());
    else if (key === '--output-dir') args.outputDir = path.resolve(process.cwd(), consumeNext());
    else throw new Error(`Unknown argument: ${token}`);
  }

  return args;
}

function parseCsvRow(row) {
  const out = [];
  let current = '';
  let inQuotes = false;

  for (let i = 0; i < row.length; i += 1) {
    const ch = row[i];

    if (ch === '"') {
      const isEscaped = row[i + 1] === '"';
      if (isEscaped) {
        current += '"';
        i += 1;
      } else {
        inQuotes = !inQuotes;
      }
      continue;
    }

    if (ch === ',' && !inQuotes) {
      out.push(current.trim());
      current = '';
      continue;
    }

    current += ch;
  }

  out.push(current.trim());
  return out;
}

function parseCsv(text) {
  const lines = text
    .split(/\r?\n/)
    .map((line) => line.trim())
    .filter(Boolean);

  if (!lines.length) return [];

  const headers = parseCsvRow(lines[0]).map((h) => h.toLowerCase());
  const songIndex = headers.indexOf('song');
  const artistIndex = headers.indexOf('artist');
  const albumIndex = headers.indexOf('album');

  if (songIndex === -1) {
    throw new Error("CSV must include a 'song' header");
  }

  return lines.slice(1).map((line, rowIdx) => {
    const values = parseCsvRow(line);
    return {
      row: rowIdx + 2,
      song: (values[songIndex] || '').trim(),
      artist: artistIndex >= 0 ? (values[artistIndex] || '').trim() : '',
      album: albumIndex >= 0 ? (values[albumIndex] || '').trim() : ''
    };
  }).filter((entry) => entry.song);
}

function normalize(value) {
  return (value || '')
    .toLowerCase()
    .replace(/[\u2018\u2019']/g, '')
    .replace(/[^a-z0-9\s]/g, ' ')
    .replace(/\s+/g, ' ')
    .trim();
}

function bigrams(value) {
  const cleaned = normalize(value).replace(/\s/g, '');
  if (cleaned.length <= 1) return [cleaned];
  const grams = [];
  for (let i = 0; i < cleaned.length - 1; i += 1) {
    grams.push(cleaned.slice(i, i + 2));
  }
  return grams;
}

function diceSimilarity(a, b) {
  const aGrams = bigrams(a);
  const bGrams = bigrams(b);
  if (!aGrams.length || !bGrams.length) return 0;

  const counts = new Map();
  for (const gram of aGrams) {
    counts.set(gram, (counts.get(gram) || 0) + 1);
  }

  let matches = 0;
  for (const gram of bGrams) {
    const count = counts.get(gram) || 0;
    if (count > 0) {
      matches += 1;
      counts.set(gram, count - 1);
    }
  }

  return (2 * matches) / (aGrams.length + bGrams.length);
}

function scoreCandidate(input, candidate) {
  const titleScore = diceSimilarity(input.song, candidate.attributes?.name || '');

  let artistScore = 0.5;
  if (input.artist) {
    artistScore = diceSimilarity(
      input.artist,
      candidate.attributes?.artistName || ''
    );
  }

  const titleBoost = normalize(candidate.attributes?.name || '').includes(normalize(input.song)) ? 0.05 : 0;
  const score = Math.min(1, titleScore * 0.7 + artistScore * 0.3 + titleBoost);
  return score;
}

function base64url(bufferOrString) {
  const value = Buffer.isBuffer(bufferOrString)
    ? bufferOrString
    : Buffer.from(bufferOrString);
  return value
    .toString('base64')
    .replace(/\+/g, '-')
    .replace(/\//g, '_')
    .replace(/=+$/g, '');
}

async function loadPrivateKey() {
  const fromPath = process.env.APPLE_PRIVATE_KEY_PATH;
  const inline = process.env.APPLE_PRIVATE_KEY;

  if (fromPath) {
    return fs.readFile(path.resolve(process.cwd(), fromPath), 'utf8');
  }

  if (inline) {
    return inline.includes('\\n') ? inline.replace(/\\n/g, '\n') : inline;
  }

  throw new Error('Missing APPLE_PRIVATE_KEY_PATH or APPLE_PRIVATE_KEY');
}

async function createDeveloperToken() {
  const teamId = process.env.APPLE_TEAM_ID;
  const keyId = process.env.APPLE_KEY_ID;
  const privateKey = await loadPrivateKey();

  if (!teamId || !keyId) {
    throw new Error('Missing APPLE_TEAM_ID or APPLE_KEY_ID');
  }

  const now = Math.floor(Date.now() / 1000);
  const exp = now + 60 * 60 * 24 * 30;

  const header = { alg: 'ES256', kid: keyId, typ: 'JWT' };
  const payload = { iss: teamId, iat: now, exp };

  const encodedHeader = base64url(JSON.stringify(header));
  const encodedPayload = base64url(JSON.stringify(payload));
  const toSign = `${encodedHeader}.${encodedPayload}`;

  const signer = crypto.createSign('SHA256');
  signer.update(toSign);
  signer.end();
  const signature = signer.sign(privateKey);

  return `${toSign}.${base64url(signature)}`;
}

async function apiRequest(url, { method = 'GET', developerToken, userToken, body } = {}) {
  const headers = {
    Authorization: `Bearer ${developerToken}`
  };

  if (userToken) {
    headers['Music-User-Token'] = userToken;
  }

  let payload;
  if (body) {
    headers['Content-Type'] = 'application/json';
    payload = JSON.stringify(body);
  }

  const response = await fetch(url, { method, headers, body: payload });
  if (!response.ok) {
    const details = await response.text();
    throw new Error(`Apple Music API ${response.status}: ${details.slice(0, 500)}`);
  }

  if (response.status === 204) return null;
  return response.json();
}

async function searchSong({ storefront, developerToken, query, limit }) {
  const params = new URLSearchParams({
    term: query,
    types: 'songs',
    limit: String(limit)
  });

  const url = `https://api.music.apple.com/v1/catalog/${storefront}/search?${params.toString()}`;
  const json = await apiRequest(url, { developerToken });
  return json?.results?.songs?.data || [];
}

function csvEscape(value) {
  const text = String(value ?? '');
  if (/[",\n]/.test(text)) {
    return `"${text.replace(/"/g, '""')}"`;
  }
  return text;
}

function chunk(array, size) {
  const out = [];
  for (let i = 0; i < array.length; i += size) {
    out.push(array.slice(i, i + size));
  }
  return out;
}

async function createPlaylist({ developerToken, userToken, name }) {
  const url = 'https://api.music.apple.com/v1/me/library/playlists';
  const body = {
    attributes: {
      name,
      description: 'Imported by apple-music-batch-importer'
    }
  };

  const json = await apiRequest(url, {
    method: 'POST',
    developerToken,
    userToken,
    body
  });

  const playlistId = json?.data?.[0]?.id;
  if (!playlistId) {
    throw new Error('Playlist created but no playlist id returned.');
  }
  return playlistId;
}

async function addTracksToPlaylist({ developerToken, userToken, playlistId, songIds }) {
  const groups = chunk(songIds, 100);

  for (let i = 0; i < groups.length; i += 1) {
    const group = groups[i];
    const url = `https://api.music.apple.com/v1/me/library/playlists/${playlistId}/tracks`;
    const body = {
      data: group.map((id) => ({ id, type: 'songs' }))
    };

    await apiRequest(url, {
      method: 'POST',
      developerToken,
      userToken,
      body
    });

    console.log(`Added batch ${i + 1}/${groups.length} (${group.length} tracks)`);
  }
}

async function main() {
  await loadDotEnv();
  const args = parseArgs(process.argv);

  if (args.help) {
    printHelp();
    return;
  }

  if (!args.input) {
    throw new Error('Missing --input');
  }

  if (args.apply && !args.playlist) {
    throw new Error('When using --apply, provide --playlist <name>');
  }

  const storefront = args.storefront || process.env.APPLE_STOREFRONT || 'us';
  const userToken = process.env.APPLE_MUSIC_USER_TOKEN;

  if (!userToken) {
    throw new Error('Missing APPLE_MUSIC_USER_TOKEN');
  }

  await fs.mkdir(args.outputDir, { recursive: true });

  const csvText = await fs.readFile(args.input, 'utf8');
  const rows = parseCsv(csvText);

  if (!rows.length) {
    throw new Error('No song rows found in CSV.');
  }

  console.log(`Loaded ${rows.length} rows from ${args.input}`);
  console.log(`Storefront: ${storefront}`);

  const developerToken = await createDeveloperToken();

  const results = [];
  for (let index = 0; index < rows.length; index += 1) {
    const row = rows[index];
    const query = [row.song, row.artist, row.album].filter(Boolean).join(' ');

    const candidates = await searchSong({
      storefront,
      developerToken,
      query,
      limit: args.top
    });

    const ranked = candidates
      .map((candidate) => ({
        score: scoreCandidate(row, candidate),
        candidate
      }))
      .sort((a, b) => b.score - a.score);

    const best = ranked[0] || null;
    const accepted = !!best && best.score >= args.threshold;

    results.push({
      input: row,
      accepted,
      bestScore: best ? Number(best.score.toFixed(3)) : 0,
      match: best ? {
        id: best.candidate.id,
        title: best.candidate.attributes?.name || '',
        artist: best.candidate.attributes?.artistName || '',
        album: best.candidate.attributes?.albumName || ''
      } : null,
      alternatives: ranked.slice(0, 3).map((entry) => ({
        score: Number(entry.score.toFixed(3)),
        id: entry.candidate.id,
        title: entry.candidate.attributes?.name || '',
        artist: entry.candidate.attributes?.artistName || '',
        album: entry.candidate.attributes?.albumName || ''
      }))
    });

    const status = accepted ? 'MATCH' : 'REVIEW';
    const matchText = best
      ? `${best.candidate.attributes?.name} - ${best.candidate.attributes?.artistName} (${best.score.toFixed(2)})`
      : 'No candidates';
    console.log(`[${index + 1}/${rows.length}] ${status}: ${row.song} -> ${matchText}`);

    await new Promise((resolve) => setTimeout(resolve, 130));
  }

  const matched = results.filter((row) => row.accepted && row.match);
  const unmatched = results.filter((row) => !row.accepted);

  const timestamp = new Date().toISOString().replace(/[:.]/g, '-');
  const jsonPath = path.join(args.outputDir, `results-${timestamp}.json`);
  const matchedCsvPath = path.join(args.outputDir, `matched-${timestamp}.csv`);
  const unmatchedCsvPath = path.join(args.outputDir, `needs-review-${timestamp}.csv`);

  await fs.writeFile(jsonPath, JSON.stringify(results, null, 2), 'utf8');

  const matchedCsv = [
    'song,artist,album,matched_title,matched_artist,matched_album,apple_song_id,score',
    ...matched.map((row) => [
      row.input.song,
      row.input.artist,
      row.input.album,
      row.match.title,
      row.match.artist,
      row.match.album,
      row.match.id,
      row.bestScore
    ].map(csvEscape).join(','))
  ].join('\n');

  const unmatchedCsv = [
    'song,artist,album,best_candidate,best_candidate_artist,score',
    ...unmatched.map((row) => [
      row.input.song,
      row.input.artist,
      row.input.album,
      row.match?.title || '',
      row.match?.artist || '',
      row.bestScore
    ].map(csvEscape).join(','))
  ].join('\n');

  await Promise.all([
    fs.writeFile(matchedCsvPath, matchedCsv, 'utf8'),
    fs.writeFile(unmatchedCsvPath, unmatchedCsv, 'utf8')
  ]);

  console.log('\nSummary');
  console.log(`- Matched: ${matched.length}`);
  console.log(`- Needs review: ${unmatched.length}`);
  console.log(`- JSON report: ${jsonPath}`);
  console.log(`- Matched CSV: ${matchedCsvPath}`);
  console.log(`- Review CSV: ${unmatchedCsvPath}`);

  if (args.apply) {
    const ids = matched.map((row) => row.match.id);
    if (!ids.length) {
      throw new Error('No matched songs to add. Lower --threshold or review CSV first.');
    }

    console.log(`\nCreating playlist: ${args.playlist}`);
    const playlistId = await createPlaylist({
      developerToken,
      userToken,
      name: args.playlist
    });

    await addTracksToPlaylist({
      developerToken,
      userToken,
      playlistId,
      songIds: ids
    });

    console.log(`Done. Created playlist '${args.playlist}' with ${ids.length} songs.`);
    console.log(`Apple playlist id: ${playlistId}`);
  } else {
    console.log('\nDry run complete. Re-run with --apply --playlist "Your Name" to create playlist.');
  }
}

main().catch((error) => {
  console.error(`\nError: ${error.message}`);
  process.exitCode = 1;
});

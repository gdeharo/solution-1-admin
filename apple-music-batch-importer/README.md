# Apple Music Batch Importer (MVP)

Small Node CLI for importing a list of song names into an Apple Music playlist in batches.

## What it does

- Reads a CSV (`song`, optional `artist`, optional `album`)
- Searches Apple Music catalog for each row
- Auto-accepts strong matches (tunable threshold)
- Exports:
  - `matched-*.csv`
  - `needs-review-*.csv`
  - `results-*.json`
- Optionally creates a playlist and adds matched tracks

## Prerequisites

- macOS (works on MacBook Air)
- Node.js 18+
- Apple Music subscription on the account being authorized
- Apple Developer account (for MusicKit key + developer token)

## Setup

1. Open this directory:

```bash
cd /Users/gregoriodeharo/Documents/New\ project/apple-music-batch-importer
```

2. Copy env template:

```bash
cp .env.example .env
```

3. Fill `.env`:

- `APPLE_TEAM_ID`
- `APPLE_KEY_ID`
- `APPLE_PRIVATE_KEY_PATH` (path to your `.p8` key file)
- `APPLE_MUSIC_USER_TOKEN` (from token helper below)
- `APPLE_STOREFRONT` (`us` unless you need another storefront)

## Get Music User Token

1. Generate a short-lived developer token JWT:

```bash
node src/generate-dev-token.mjs
```

2. Copy the printed token.
3. Open:

```bash
open token-helper.html
```

4. Paste developer token and click **Authorize with Apple Music**.
5. Copy returned token into `.env` as `APPLE_MUSIC_USER_TOKEN`.

## Input CSV format

Example: `/Users/gregoriodeharo/Documents/New project/apple-music-batch-importer/examples/songs.csv`

```csv
song,artist,album
Levitating,Dua Lipa,
Bohemian Rhapsody,Queen,
```

## Run (dry run first)

```bash
node src/import-songs.mjs --input examples/songs.csv
```

Optional tuning:

```bash
node src/import-songs.mjs --input examples/songs.csv --threshold 0.58 --top 8
```

## Create playlist and import matches

```bash
node src/import-songs.mjs --input examples/songs.csv --apply --playlist "Daughter Import - Mar 2026"
```

## Notes

- Matching is fuzzy; always review `needs-review-*.csv`.
- API limits/authorization errors usually mean token issues.
- If your key path is outside this folder, use absolute path in `.env`.

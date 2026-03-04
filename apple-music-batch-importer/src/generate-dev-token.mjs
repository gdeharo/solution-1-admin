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
      const value = line.slice(eq + 1).trim();
      if (!(key in process.env)) process.env[key] = value;
    }
  } catch (error) {
    if (error?.code !== 'ENOENT') throw error;
  }
}

function base64url(input) {
  const buf = Buffer.isBuffer(input) ? input : Buffer.from(input);
  return buf.toString('base64').replace(/\+/g, '-').replace(/\//g, '_').replace(/=+$/g, '');
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

async function main() {
  await loadDotEnv();

  const teamId = process.env.APPLE_TEAM_ID;
  const keyId = process.env.APPLE_KEY_ID;
  if (!teamId || !keyId) {
    throw new Error('Missing APPLE_TEAM_ID or APPLE_KEY_ID');
  }

  const privateKey = await loadPrivateKey();

  const now = Math.floor(Date.now() / 1000);
  const exp = now + 60 * 60 * 24 * 30;

  const header = { alg: 'ES256', kid: keyId, typ: 'JWT' };
  const payload = { iss: teamId, iat: now, exp };
  const encodedHeader = base64url(JSON.stringify(header));
  const encodedPayload = base64url(JSON.stringify(payload));
  const body = `${encodedHeader}.${encodedPayload}`;

  const signer = crypto.createSign('SHA256');
  signer.update(body);
  signer.end();
  const signature = signer.sign(privateKey);

  console.log(`${body}.${base64url(signature)}`);
}

main().catch((error) => {
  console.error(`Error: ${error.message}`);
  process.exitCode = 1;
});

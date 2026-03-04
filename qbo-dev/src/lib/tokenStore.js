import fs from "node:fs/promises";
import path from "node:path";

const DATA_DIR = path.resolve(process.cwd(), "data");
const FILE_PATH = path.join(DATA_DIR, "qbo-connections.json");

async function ensureStore() {
  await fs.mkdir(DATA_DIR, { recursive: true });
  try {
    await fs.access(FILE_PATH);
  } catch {
    await fs.writeFile(FILE_PATH, JSON.stringify({}, null, 2), "utf8");
  }
}

async function readStore() {
  await ensureStore();
  const raw = await fs.readFile(FILE_PATH, "utf8");
  return JSON.parse(raw || "{}");
}

async function writeStore(data) {
  await fs.writeFile(FILE_PATH, JSON.stringify(data, null, 2), "utf8");
}

export async function saveConnection({ tenantId, realmId, accessToken, refreshToken, accessTokenExpiresAt, refreshTokenExpiresAt }) {
  const store = await readStore();
  store[tenantId] = {
    realmId,
    accessToken,
    refreshToken,
    accessTokenExpiresAt,
    refreshTokenExpiresAt,
    updatedAt: new Date().toISOString()
  };
  await writeStore(store);
}

export async function getConnection(tenantId) {
  const store = await readStore();
  return store[tenantId] ?? null;
}

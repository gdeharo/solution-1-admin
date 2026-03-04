import { getConnection, saveConnection } from "./tokenStore.js";

const INTUIT_TOKEN_URL = "https://oauth.platform.intuit.com/oauth2/v1/tokens/bearer";
function getQboBaseUrl() {
  const env = String(process.env.INTUIT_ENV ?? "sandbox").toLowerCase();
  if (env === "production") return "https://quickbooks.api.intuit.com/v3/company";
  return "https://sandbox-quickbooks.api.intuit.com/v3/company";
}
const REFRESH_SAFETY_SECONDS = 90;

function requireEnv(name) {
  const value = process.env[name];
  if (!value) throw new Error(`Missing env var: ${name}`);
  return value;
}

function buildBasicAuthHeader() {
  const clientId = requireEnv("INTUIT_CLIENT_ID");
  const clientSecret = requireEnv("INTUIT_CLIENT_SECRET");
  const encoded = Buffer.from(`${clientId}:${clientSecret}`).toString("base64");
  return `Basic ${encoded}`;
}

function nowPlusSeconds(seconds) {
  return new Date(Date.now() + seconds * 1000).toISOString();
}

function isExpiredOrNear(expiryIso, safetySeconds = REFRESH_SAFETY_SECONDS) {
  if (!expiryIso) return true;
  const expiresAt = new Date(expiryIso).getTime();
  const threshold = Date.now() + safetySeconds * 1000;
  return Number.isNaN(expiresAt) || expiresAt <= threshold;
}

async function refreshConnection(tenantId, connection) {
  if (!connection?.refreshToken) throw new Error("No refresh token saved for tenant");

  const body = new URLSearchParams({
    grant_type: "refresh_token",
    refresh_token: connection.refreshToken
  });

  const response = await fetch(INTUIT_TOKEN_URL, {
    method: "POST",
    headers: {
      Accept: "application/json",
      "Content-Type": "application/x-www-form-urlencoded",
      Authorization: buildBasicAuthHeader()
    },
    body
  });

  const token = await response.json();
  if (!response.ok) {
    throw new Error(`QBO token refresh failed: ${JSON.stringify(token)}`);
  }

  const accessToken = token.access_token ?? token.accessToken;
  const refreshToken = token.refresh_token ?? token.refreshToken;
  const expiresIn = Number(token.expires_in ?? 3600);
  const refreshExpiresIn = Number(token.x_refresh_token_expires_in ?? 0);

  const updated = {
    realmId: connection.realmId,
    accessToken,
    refreshToken,
    accessTokenExpiresAt: nowPlusSeconds(expiresIn),
    refreshTokenExpiresAt: refreshExpiresIn ? nowPlusSeconds(refreshExpiresIn) : null
  };

  await saveConnection({ tenantId, ...updated });
  return updated;
}

export async function getLiveConnection(tenantId = "local-dev") {
  const connection = await getConnection(tenantId);
  if (!connection?.realmId) throw new Error("No QuickBooks connection for tenant");

  if (isExpiredOrNear(connection.accessTokenExpiresAt)) {
    return refreshConnection(tenantId, connection);
  }

  return connection;
}

export async function qboApiRequest({
  tenantId = "local-dev",
  method = "GET",
  path,
  body,
  query
}) {
  let connection = await getLiveConnection(tenantId);
  const qboBaseUrl = getQboBaseUrl();

  const params = new URLSearchParams(query ?? {});
  if (!params.has("minorversion")) params.set("minorversion", "75");
  const url = `${qboBaseUrl}/${connection.realmId}${path}?${params.toString()}`;

  async function doRequest(accessToken) {
    const response = await fetch(url, {
      method,
      headers: {
        Accept: "application/json",
        "Content-Type": "application/json",
        Authorization: `Bearer ${accessToken}`
      },
      body: body ? JSON.stringify(body) : undefined
    });

    const text = await response.text();
    const parsed = text ? JSON.parse(text) : null;
    return { response, parsed };
  }

  let first = await doRequest(connection.accessToken);

  if (first.response.status === 401) {
    connection = await refreshConnection(tenantId, connection);
    first = await doRequest(connection.accessToken);
  }

  return first;
}

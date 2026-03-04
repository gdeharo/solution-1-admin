import crypto from "node:crypto";
import express from "express";
import { getConnection, saveConnection } from "../lib/tokenStore.js";

const INTUIT_AUTH_URL = "https://appcenter.intuit.com/connect/oauth2";
const INTUIT_TOKEN_URL = "https://oauth.platform.intuit.com/oauth2/v1/tokens/bearer";
const SCOPE = "com.intuit.quickbooks.accounting";

const router = express.Router();

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

router.get("/auth/intuit/status", async (_req, res) => {
  try {
    const connection = await getConnection("local-dev");
    if (!connection?.realmId) {
      return res.json({
        connected: false,
        tenantId: "local-dev",
        intuitEnv: String(process.env.INTUIT_ENV ?? "sandbox").toLowerCase()
      });
    }

    return res.json({
      connected: true,
      tenantId: "local-dev",
      intuitEnv: String(process.env.INTUIT_ENV ?? "sandbox").toLowerCase(),
      realmId: connection.realmId,
      accessTokenExpiresAt: connection.accessTokenExpiresAt,
      refreshTokenExpiresAt: connection.refreshTokenExpiresAt,
      updatedAt: connection.updatedAt
    });
  } catch (error) {
    return res.status(500).json({ error: error instanceof Error ? error.message : "Status failed" });
  }
});

router.get("/auth/intuit/connect", (req, res) => {
  const redirectUri = requireEnv("INTUIT_REDIRECT_URI");
  const clientId = requireEnv("INTUIT_CLIENT_ID");

  const state = crypto.randomUUID();
  req.session.intuitState = state;

  const params = new URLSearchParams({
    client_id: clientId,
    scope: SCOPE,
    redirect_uri: redirectUri,
    response_type: "code",
    access_type: "offline",
    state
  });

  return res.redirect(`${INTUIT_AUTH_URL}?${params.toString()}`);
});

router.get("/auth/intuit/callback", async (req, res) => {
  try {
    const code = String(req.query.code ?? "").trim();
    const realmId = String(req.query.realmId ?? "").trim();
    const state = String(req.query.state ?? "").trim();

    if (!code || !realmId) return res.status(400).json({ error: "Missing code or realmId" });
    if (!state || req.session.intuitState !== state) return res.status(400).json({ error: "Invalid state" });

    const body = new URLSearchParams({
      grant_type: "authorization_code",
      code,
      redirect_uri: requireEnv("INTUIT_REDIRECT_URI")
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
    if (!response.ok) return res.status(400).json(token);

    const accessToken = token.access_token ?? token.accessToken;
    const refreshToken = token.refresh_token ?? token.refreshToken;
    const expiresIn = Number(token.expires_in ?? 3600);
    const refreshExpiresIn = Number(token.x_refresh_token_expires_in ?? 0);

    await saveConnection({
      tenantId: "local-dev",
      realmId,
      accessToken,
      refreshToken,
      accessTokenExpiresAt: nowPlusSeconds(expiresIn),
      refreshTokenExpiresAt: refreshExpiresIn ? nowPlusSeconds(refreshExpiresIn) : null
    });

    req.session.intuitState = null;

    return res.json({
      connected: true,
      tenantId: "local-dev",
      realmId,
      accessTokenExpiresInSeconds: expiresIn,
      refreshTokenExpiresInSeconds: refreshExpiresIn
    });
  } catch (error) {
    return res.status(500).json({ error: error instanceof Error ? error.message : "Callback failed" });
  }
});

router.post("/auth/intuit/refresh", async (_req, res) => {
  try {
    const connection = await getConnection("local-dev");
    if (!connection?.refreshToken) return res.status(404).json({ error: "No saved refresh token" });

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
    if (!response.ok) return res.status(400).json(token);

    const accessToken = token.access_token ?? token.accessToken;
    const refreshToken = token.refresh_token ?? token.refreshToken;
    const expiresIn = Number(token.expires_in ?? 3600);
    const refreshExpiresIn = Number(token.x_refresh_token_expires_in ?? 0);

    await saveConnection({
      tenantId: "local-dev",
      realmId: connection.realmId,
      accessToken,
      refreshToken,
      accessTokenExpiresAt: nowPlusSeconds(expiresIn),
      refreshTokenExpiresAt: refreshExpiresIn ? nowPlusSeconds(refreshExpiresIn) : null
    });

    return res.json({
      refreshed: true,
      accessTokenExpiresInSeconds: expiresIn,
      refreshTokenExpiresInSeconds: refreshExpiresIn
    });
  } catch (error) {
    return res.status(500).json({ error: error instanceof Error ? error.message : "Refresh failed" });
  }
});

export default router;

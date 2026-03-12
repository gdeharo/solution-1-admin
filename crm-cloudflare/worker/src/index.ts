interface Env {
  CRM_DB: D1Database;
  CRM_FILES: R2Bucket;
  SESSION_TTL_HOURS: string;
  RESEND_API_KEY?: string;
  MAIL_FROM?: string;
  APP_BASE_URL?: string;
}

type UserRole = 'admin' | 'manager' | 'rep' | 'viewer';

type AuthedUser = {
  id: number;
  email: string;
  full_name: string;
  role: UserRole;
};

type Session = {
  id: string;
  user_id: number;
  expires_at: string;
};

const SECURITY_HEADERS: Record<string, string> = {
  'strict-transport-security': 'max-age=31536000; includeSubDomains; preload',
  'x-content-type-options': 'nosniff',
  'x-frame-options': 'DENY',
  'referrer-policy': 'strict-origin-when-cross-origin',
  'permissions-policy': 'camera=(), microphone=(), geolocation=(), payment=()',
  'content-security-policy': "default-src 'none'; frame-ancestors 'none'; base-uri 'none'; form-action 'none'"
};

function withSecurityHeaders(response: Response): Response {
  for (const [key, value] of Object.entries(SECURITY_HEADERS)) {
    if (!response.headers.has(key)) response.headers.set(key, value);
  }
  return response;
}

type RateBucket = { count: number; resetAt: number };
const AUTH_RATE_BUCKETS = new Map<string, RateBucket>();

function checkAuthRateLimit(request: Request, windowMs = 60_000, maxRequests = 20): boolean {
  const ip =
    request.headers.get('cf-connecting-ip') ||
    request.headers.get('x-forwarded-for')?.split(',')[0]?.trim() ||
    'unknown';
  const ua = request.headers.get('user-agent') || 'unknown';
  const path = new URL(request.url).pathname;
  const key = `${ip}|${ua.slice(0, 48)}|${path}`;
  const now = Date.now();
  const current = AUTH_RATE_BUCKETS.get(key);
  if (!current || now >= current.resetAt) {
    AUTH_RATE_BUCKETS.set(key, { count: 1, resetAt: now + windowMs });
    return true;
  }
  current.count += 1;
  if (current.count > maxRequests) return false;
  AUTH_RATE_BUCKETS.set(key, current);
  if (AUTH_RATE_BUCKETS.size > 10000) {
    for (const [k, v] of AUTH_RATE_BUCKETS.entries()) {
      if (now >= v.resetAt) AUTH_RATE_BUCKETS.delete(k);
    }
  }
  return true;
}

const json = (data: unknown, status = 200): Response =>
  withSecurityHeaders(
    new Response(JSON.stringify(data), {
      status,
      headers: {
        'content-type': 'application/json; charset=utf-8',
        'cache-control': 'no-store'
      }
    })
  );

const err = (message: string, status = 400): Response => json({ error: message }, status);

function withCors(response: Response): Response {
  response.headers.set('access-control-allow-origin', '*');
  return response;
}

const toBase64 = (bytes: Uint8Array): string => {
  let str = '';
  for (const b of bytes) str += String.fromCharCode(b);
  return btoa(str);
};

const fromBase64 = (value: string): Uint8Array => {
  const str = atob(value);
  const out = new Uint8Array(str.length);
  for (let i = 0; i < str.length; i += 1) out[i] = str.charCodeAt(i);
  return out;
};

const randomToken = (bytes = 32): string => {
  const arr = new Uint8Array(bytes);
  crypto.getRandomValues(arr);
  return toBase64(arr).replace(/\+/g, '-').replace(/\//g, '_').replace(/=+$/, '');
};

const randomPassword = (length = 12): string => {
  const alphabet = 'ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz23456789!@#$%';
  const arr = new Uint8Array(length);
  crypto.getRandomValues(arr);
  let out = '';
  for (let i = 0; i < length; i += 1) out += alphabet[arr[i] % alphabet.length];
  return out;
};

const isoAfterHours = (hours: number): string => new Date(Date.now() + hours * 60 * 60 * 1000).toISOString();
const getAppBaseUrl = (env: Env): string => (env.APP_BASE_URL || 'https://crm.rtf-cloud.com').replace(/\/+$/, '');
const getMailFrom = (env: Env): string => env.MAIL_FROM || 'noreply@mail.rtf-cloud.com';

async function sendEmail(env: Env, payload: { to: string; subject: string; text: string }): Promise<void> {
  if (!env.RESEND_API_KEY) throw new Error('RESEND_API_KEY is not configured');
  const response = await fetch('https://api.resend.com/emails', {
    method: 'POST',
    headers: {
      authorization: `Bearer ${env.RESEND_API_KEY}`,
      'content-type': 'application/json'
    },
    body: JSON.stringify({
      from: getMailFrom(env),
      to: [payload.to],
      subject: payload.subject,
      text: payload.text
    })
  });
  if (!response.ok) {
    const raw = await response.text();
    throw new Error(`Email send failed (${response.status}): ${raw}`);
  }
}

function buildInviteEmail(
  env: Env,
  adminName: string,
  recipientName: string,
  email: string,
  inviteToken: string
): { subject: string; text: string } {
  const inviteUrl = `${getAppBaseUrl(env)}?invite=${encodeURIComponent(inviteToken)}`;
  return {
    subject: `Invitation from ${adminName} to access Company CRM`,
    text: [
      `Hello ${recipientName || email},`,
      '',
      'You have been invited to access the Company CRM.',
      '',
      'Use the link below to set your password and sign in:',
      inviteUrl,
      '',
      `Your user ID is: ${email}`,
      '',
      'If you were not expecting this invitation, you can ignore this email.'
    ].join('\n')
  };
}

function buildPasswordResetEmail(env: Env, email: string, resetToken: string): { subject: string; text: string } {
  const resetUrl = `${getAppBaseUrl(env)}?reset=${encodeURIComponent(resetToken)}`;
  return {
    subject: 'Reset your Company CRM password',
    text: [
      'We received a request to reset your Company CRM password.',
      '',
      'Use the link below to choose a new password:',
      resetUrl,
      '',
      `Account: ${email}`,
      '',
      'If you did not request this reset, you can ignore this email.'
    ].join('\n')
  };
}

async function hashPassword(password: string, saltBase64?: string): Promise<{ hash: string; salt: string }> {
  const salt = saltBase64 ? fromBase64(saltBase64) : crypto.getRandomValues(new Uint8Array(16));
  const key = await crypto.subtle.importKey('raw', new TextEncoder().encode(password), 'PBKDF2', false, ['deriveBits']);
  const bits = await crypto.subtle.deriveBits(
    {
      name: 'PBKDF2',
      hash: 'SHA-256',
      salt,
      iterations: 100000
    },
    key,
    256
  );
  return {
    hash: toBase64(new Uint8Array(bits)),
    salt: toBase64(salt)
  };
}

async function verifyPassword(password: string, hash: string, salt: string): Promise<boolean> {
  const derived = await hashPassword(password, salt);
  return derived.hash === hash;
}

async function parseJson<T>(request: Request): Promise<T | null> {
  try {
    return (await request.json()) as T;
  } catch {
    return null;
  }
}

const getTokenFromRequest = (request: Request): string | null => {
  const header = request.headers.get('authorization');
  if (!header || !header.startsWith('Bearer ')) return null;
  return header.slice(7).trim() || null;
};

const getAuthToken = (request: Request): string | null => {
  const headerToken = getTokenFromRequest(request);
  if (headerToken) return headerToken;
  const queryToken = new URL(request.url).searchParams.get('token');
  return queryToken || null;
};

async function getAuthedUser(request: Request, env: Env): Promise<AuthedUser | null> {
  const token = getAuthToken(request);
  if (!token) return null;

  const session = await env.CRM_DB.prepare(
    `SELECT id, user_id, expires_at FROM sessions WHERE id = ?1`
  )
    .bind(token)
    .first<Session>();

  if (!session) return null;
  if (new Date(session.expires_at).getTime() < Date.now()) {
    await env.CRM_DB.prepare(`DELETE FROM sessions WHERE id = ?1`).bind(token).run();
    return null;
  }

  const user = await env.CRM_DB.prepare(
    `SELECT id, email, full_name, role FROM users WHERE id = ?1 AND is_active = 1`
  )
    .bind(session.user_id)
    .first<AuthedUser>();

  return user ?? null;
}

const canWrite = (role: UserRole): boolean => role === 'admin' || role === 'manager' || role === 'rep';
const canManageUsers = (role: UserRole): boolean => role === 'admin';
const canManageReps = (role: UserRole): boolean => role === 'admin' || role === 'manager';
const THEME_KEYS = ['bg', 'panel', 'ink', 'muted', 'line', 'accent', 'accentSoft', 'danger'] as const;
type ThemeKey = (typeof THEME_KEYS)[number];

function isHexColor(value: string): boolean {
  return /^#[0-9a-fA-F]{6}$/.test(value);
}

function deriveThemeFromAccent(accent: string): Record<ThemeKey, string> {
  const hex = accent.replace('#', '');
  const r = Number.parseInt(hex.slice(0, 2), 16);
  const g = Number.parseInt(hex.slice(2, 4), 16);
  const b = Number.parseInt(hex.slice(4, 6), 16);
  const tint = (amount: number): string => {
    const mix = (value: number): number => Math.round(value + (255 - value) * amount);
    return `#${[mix(r), mix(g), mix(b)].map((v) => v.toString(16).padStart(2, '0')).join('')}`;
  };
  return {
    bg: tint(0.9),
    panel: '#ffffff',
    ink: '#2b1b25',
    muted: '#6a4d5d',
    line: tint(0.72),
    accent,
    accentSoft: tint(0.82),
    danger: '#9b234f'
  };
}

async function ensureSegmentAndTypeExist(env: Env, segment?: string | null, customerType?: string | null): Promise<string | null> {
  if (segment && segment.trim()) {
    const segmentExists = await env.CRM_DB.prepare(`SELECT id FROM company_segments WHERE name = ?1`)
      .bind(segment.trim())
      .first();
    if (!segmentExists) return `Unknown segment: ${segment}`;
  }
  if (customerType && customerType.trim()) {
    const typeExists = await env.CRM_DB.prepare(`SELECT id FROM company_types WHERE name = ?1`)
      .bind(customerType.trim())
      .first();
    if (!typeExists) return `Unknown type: ${customerType}`;
  }
  return null;
}

async function syncRepRecordForUser(
  env: Env,
  input: {
    currentEmail: string;
    nextEmail: string;
    nextFullName: string;
    nextRole: UserRole;
    nextIsActive: boolean;
  }
): Promise<number | null> {
  const currentEmail = input.currentEmail.toLowerCase().trim();
  const nextEmail = input.nextEmail.toLowerCase().trim();
  const shouldExposeRep = input.nextRole === 'rep' && input.nextIsActive;

  if (!shouldExposeRep) {
    await env.CRM_DB.batch([
      env.CRM_DB.prepare(
        `UPDATE reps
         SET deleted_at = CURRENT_TIMESTAMP, updated_at = CURRENT_TIMESTAMP
         WHERE email IS NOT NULL AND lower(email) = lower(?1) AND deleted_at IS NULL`
      ).bind(currentEmail),
      env.CRM_DB.prepare(
        `UPDATE reps
         SET deleted_at = CURRENT_TIMESTAMP, updated_at = CURRENT_TIMESTAMP
         WHERE email IS NOT NULL AND lower(email) = lower(?1) AND deleted_at IS NULL`
      ).bind(nextEmail)
    ]);
    return null;
  }

  const existingRep = await env.CRM_DB.prepare(
    `SELECT id
     FROM reps
     WHERE email IS NOT NULL
       AND (lower(email) = lower(?1) OR lower(email) = lower(?2))
     ORDER BY CASE WHEN deleted_at IS NULL THEN 0 ELSE 1 END, id DESC
     LIMIT 1`
  )
    .bind(nextEmail, currentEmail)
    .first<{ id: number }>();

  if (existingRep?.id) {
    await env.CRM_DB.prepare(
      `UPDATE reps
       SET full_name = ?1, email = ?2, deleted_at = NULL, updated_at = CURRENT_TIMESTAMP
       WHERE id = ?3`
    )
      .bind(input.nextFullName, nextEmail, existingRep.id)
      .run();
    return existingRep.id;
  }

  const inserted = await env.CRM_DB.prepare(
    `INSERT INTO reps (full_name, company_name, is_independent, email, phone, segment, customer_type)
     VALUES (?1, NULL, 0, ?2, NULL, NULL, NULL)`
  )
    .bind(input.nextFullName, nextEmail)
    .run();
  return Number(inserted.meta.last_row_id);
}

function normalizedText(value: string | null | undefined): string {
  return String(value || '').trim();
}

function companyMissingAddressSql(alias: string): string {
  return `(
    trim(coalesce(${alias}.address, '')) = ''
    OR trim(coalesce(${alias}.city, '')) = ''
    OR trim(coalesce(${alias}.state, '')) = ''
    OR trim(coalesce(${alias}.zip, '')) = ''
  )`;
}

function splitCsvValues(value: unknown): string[] {
  if (Array.isArray(value)) return value.map((v) => normalizedText(String(v))).filter(Boolean);
  if (typeof value !== 'string') return [];
  return value
    .split(/[\n,]/g)
    .map((part) => normalizedText(part))
    .filter(Boolean);
}

function normalizeZip(value: string | null | undefined): string {
  return String(value || '')
    .trim()
    .toUpperCase()
    .replace(/[\s-]/g, '');
}

function parseZipEntries(value: unknown): Array<{ value: string; isExclusion: boolean }> {
  const out: Array<{ value: string; isExclusion: boolean }> = [];
  for (const raw of splitCsvValues(value)) {
    let next = raw.trim();
    let isExclusion = false;
    if (next.startsWith('-')) {
      isExclusion = true;
      next = next.slice(1).trim();
    }
    const rangeParts = next.split('..').map((part) => normalizeZip(part));
    if (rangeParts.length === 2) {
      const [start, end] = rangeParts;
      if (!start || !end) continue;
      if (start.length !== end.length) continue;
      if (start.length !== 3 && start.length !== 5) continue;
      const startNum = Number.parseInt(start, 10);
      const endNum = Number.parseInt(end, 10);
      if (!Number.isFinite(startNum) || !Number.isFinite(endNum) || endNum < startNum) continue;
      // Prevent accidental huge expansions from malformed ranges.
      if (endNum - startNum > 500) continue;
      for (let current = startNum; current <= endNum; current += 1) {
        out.push({ value: String(current).padStart(start.length, '0'), isExclusion });
      }
      continue;
    }
    const normalized = normalizeZip(next);
    if (!normalized) continue;
    out.push({ value: normalized, isExclusion });
  }
  return out;
}

function territoryRuleKey(input: {
  territoryType: string;
  state?: string | null;
  city?: string | null;
  zipPrefix?: string | null;
  zipExact?: string | null;
  segment?: string | null;
  customerType?: string | null;
  isExclusion?: boolean | number | null;
}): string {
  return [
    input.territoryType,
    normalizedText(input.state).toUpperCase(),
    normalizedText(input.city).toUpperCase(),
    normalizeZip(input.zipPrefix),
    normalizeZip(input.zipExact),
    normalizedText(input.segment),
    normalizedText(input.customerType),
    input.isExclusion ? '1' : '0'
  ].join('|');
}

function uniqueTrimmed(values: unknown[]): string[] {
  return Array.from(new Set(values.map((value) => normalizedText(String(value))).filter(Boolean)));
}

const US_ZIP3_RANGES_BY_STATE: Record<string, Array<[string, string]>> = {
  AL: [['350', '369']],
  AK: [['995', '999']],
  AZ: [['850', '865']],
  AR: [['716', '729'], ['755', '755']],
  CA: [['900', '966']],
  CO: [['800', '816']],
  CT: [['060', '069']],
  DC: [['200', '205']],
  DE: [['197', '199']],
  FL: [['320', '349']],
  GA: [['300', '319'], ['398', '399']],
  HI: [['967', '968']],
  IA: [['500', '528']],
  ID: [['832', '838']],
  IL: [['600', '629']],
  IN: [['460', '479']],
  KS: [['660', '679']],
  KY: [['400', '427']],
  LA: [['700', '714']],
  MA: [['010', '027'], ['055', '055']],
  MD: [['206', '219']],
  ME: [['039', '049']],
  MI: [['480', '499']],
  MN: [['550', '567']],
  MO: [['630', '658']],
  MS: [['386', '397']],
  MT: [['590', '599']],
  NC: [['269', '289']],
  ND: [['580', '588']],
  NE: [['680', '693']],
  NH: [['030', '039']],
  NJ: [['070', '089']],
  NM: [['870', '884']],
  NV: [['889', '898']],
  NY: [['005', '005'], ['063', '063'], ['090', '149']],
  OH: [['430', '459']],
  OK: [['730', '749']],
  OR: [['970', '979']],
  PA: [['150', '196']],
  RI: [['028', '029']],
  SC: [['290', '299']],
  SD: [['570', '577']],
  TN: [['370', '385']],
  TX: [['750', '799'], ['885', '885']],
  UT: [['840', '847']],
  VA: [['201', '201'], ['220', '246']],
  VT: [['050', '059']],
  WA: [['980', '994']],
  WI: [['530', '549']],
  WV: [['247', '268']],
  WY: [['820', '831']]
};

function zipTokenToZip3Range(value: string | null | undefined): [string, string] | null {
  const digits = normalizeZip(value);
  if (!digits) return null;
  if (digits.length === 5) {
    const zip3 = digits.slice(0, 3);
    return /^\d{3}$/.test(zip3) ? [zip3, zip3] : null;
  }
  if (digits.length === 3) {
    return /^\d{3}$/.test(digits) ? [digits, digits] : null;
  }
  return null;
}

function zipTokenMayOverlapState(value: string | null | undefined, stateCode: string | null | undefined): boolean {
  const code = normalizedText(stateCode).toUpperCase();
  const stateRanges = US_ZIP3_RANGES_BY_STATE[code];
  if (!stateRanges || stateRanges.length === 0) return false;
  const zip3Range = zipTokenToZip3Range(value);
  if (!zip3Range) return false;
  const [minZip3, maxZip3] = zip3Range;
  return stateRanges.some(([start, end]) => start <= maxZip3 && end >= minZip3);
}

function repTerritoryCompanyScopeClause(companyAlias: string, emailParamIndex: number): string {
  const includeClause = `EXISTS (
    SELECT 1
    FROM rep_territories t
    JOIN reps r ON r.id = t.rep_id
    WHERE r.deleted_at IS NULL
      AND r.email IS NOT NULL
      AND lower(r.email) = lower(?${emailParamIndex})
      AND t.is_exclusion = 0
      AND (
        (t.territory_type = 'state'
          AND upper(trim(coalesce(t.state, ''))) = upper(trim(coalesce(${companyAlias}.state, ''))))
        OR
        (t.territory_type = 'city_state'
          AND upper(trim(coalesce(t.state, ''))) = upper(trim(coalesce(${companyAlias}.state, '')))
          AND upper(trim(coalesce(t.city, ''))) = upper(trim(coalesce(${companyAlias}.city, ''))))
        OR
        (t.territory_type = 'zip_exact'
          AND replace(replace(upper(trim(coalesce(t.zip_exact, ''))), '-', ''), ' ', '') =
              replace(replace(upper(trim(coalesce(${companyAlias}.zip, ''))), '-', ''), ' ', ''))
        OR
        (t.territory_type = 'zip_prefix'
          AND trim(coalesce(t.zip_prefix, '')) <> ''
          AND replace(replace(upper(trim(coalesce(${companyAlias}.zip, ''))), '-', ''), ' ', '') LIKE
              (replace(replace(upper(trim(coalesce(t.zip_prefix, ''))), '-', ''), ' ', '') || '%'))
      )
      AND (t.segment IS NULL OR trim(t.segment) = '' OR t.segment = ${companyAlias}.segment)
      AND (t.customer_type IS NULL OR trim(t.customer_type) = '' OR t.customer_type = ${companyAlias}.customer_type)
  )`;
  const excludeClause = `NOT EXISTS (
    SELECT 1
    FROM rep_territories tx
    JOIN reps rx ON rx.id = tx.rep_id
    WHERE rx.deleted_at IS NULL
      AND rx.email IS NOT NULL
      AND lower(rx.email) = lower(?${emailParamIndex})
      AND tx.is_exclusion = 1
      AND tx.territory_type IN ('zip_prefix', 'zip_exact')
      AND (
        (tx.territory_type = 'zip_exact'
          AND replace(replace(upper(trim(coalesce(tx.zip_exact, ''))), '-', ''), ' ', '') =
              replace(replace(upper(trim(coalesce(${companyAlias}.zip, ''))), '-', ''), ' ', ''))
        OR
        (tx.territory_type = 'zip_prefix'
          AND trim(coalesce(tx.zip_prefix, '')) <> ''
          AND replace(replace(upper(trim(coalesce(${companyAlias}.zip, ''))), '-', ''), ' ', '') LIKE
              (replace(replace(upper(trim(coalesce(tx.zip_prefix, ''))), '-', ''), ' ', '') || '%'))
      )
      AND (tx.segment IS NULL OR trim(tx.segment) = '' OR tx.segment = ${companyAlias}.segment)
      AND (tx.customer_type IS NULL OR trim(tx.customer_type) = '' OR tx.customer_type = ${companyAlias}.customer_type)
  )`;
  return `(${includeClause} AND ${excludeClause})`;
}

function repTerritoryCompanyScopeClauseForRepId(companyAlias: string, repIdExpr: string): string {
  const includeClause = `EXISTS (
    SELECT 1
    FROM rep_territories t
    WHERE t.rep_id = ${repIdExpr}
      AND t.is_exclusion = 0
      AND (
        (t.territory_type = 'state'
          AND upper(trim(coalesce(t.state, ''))) = upper(trim(coalesce(${companyAlias}.state, ''))))
        OR
        (t.territory_type = 'city_state'
          AND upper(trim(coalesce(t.state, ''))) = upper(trim(coalesce(${companyAlias}.state, '')))
          AND upper(trim(coalesce(t.city, ''))) = upper(trim(coalesce(${companyAlias}.city, ''))))
        OR
        (t.territory_type = 'zip_exact'
          AND replace(replace(upper(trim(coalesce(t.zip_exact, ''))), '-', ''), ' ', '') =
              replace(replace(upper(trim(coalesce(${companyAlias}.zip, ''))), '-', ''), ' ', ''))
        OR
        (t.territory_type = 'zip_prefix'
          AND trim(coalesce(t.zip_prefix, '')) <> ''
          AND replace(replace(upper(trim(coalesce(${companyAlias}.zip, ''))), '-', ''), ' ', '') LIKE
              (replace(replace(upper(trim(coalesce(t.zip_prefix, ''))), '-', ''), ' ', '') || '%'))
      )
      AND (t.segment IS NULL OR trim(t.segment) = '' OR t.segment = ${companyAlias}.segment)
      AND (t.customer_type IS NULL OR trim(t.customer_type) = '' OR t.customer_type = ${companyAlias}.customer_type)
  )`;
  const excludeClause = `NOT EXISTS (
    SELECT 1
    FROM rep_territories tx
    WHERE tx.rep_id = ${repIdExpr}
      AND tx.is_exclusion = 1
      AND tx.territory_type IN ('zip_prefix', 'zip_exact')
      AND (
        (tx.territory_type = 'zip_exact'
          AND replace(replace(upper(trim(coalesce(tx.zip_exact, ''))), '-', ''), ' ', '') =
              replace(replace(upper(trim(coalesce(${companyAlias}.zip, ''))), '-', ''), ' ', ''))
        OR
        (tx.territory_type = 'zip_prefix'
          AND trim(coalesce(tx.zip_prefix, '')) <> ''
          AND replace(replace(upper(trim(coalesce(${companyAlias}.zip, ''))), '-', ''), ' ', '') LIKE
              (replace(replace(upper(trim(coalesce(tx.zip_prefix, ''))), '-', ''), ' ', '') || '%'))
      )
      AND (tx.segment IS NULL OR trim(tx.segment) = '' OR tx.segment = ${companyAlias}.segment)
      AND (tx.customer_type IS NULL OR trim(tx.customer_type) = '' OR tx.customer_type = ${companyAlias}.customer_type)
  )`;
  return `(${includeClause} AND ${excludeClause})`;
}

async function suggestedRepIdsForCompany(
  env: Env,
  data: { city?: string | null; state?: string | null; zip?: string | null; segment?: string | null; customerType?: string | null }
): Promise<number[]> {
  const city = normalizedText(data.city);
  const state = normalizedText(data.state).toUpperCase();
  const zip = normalizeZip(data.zip);
  const segment = normalizedText(data.segment);
  const customerType = normalizedText(data.customerType);
  if (!city && !state && !zip) return [];

  const rows = await env.CRM_DB.prepare(
    `SELECT DISTINCT r.id
     FROM rep_territories t
     JOIN reps r ON r.id = t.rep_id
     WHERE r.deleted_at IS NULL
       AND t.is_exclusion = 0
       AND (
         (t.territory_type = 'state'
           AND upper(trim(coalesce(t.state, ''))) = upper(trim(coalesce(?1, ''))))
         OR
         (t.territory_type = 'city_state'
           AND upper(trim(coalesce(t.state, ''))) = upper(trim(coalesce(?1, '')))
           AND upper(trim(coalesce(t.city, ''))) = upper(trim(coalesce(?2, ''))))
         OR
         (t.territory_type = 'zip_exact'
           AND replace(replace(upper(trim(coalesce(t.zip_exact, ''))), '-', ''), ' ', '') =
               replace(replace(upper(trim(coalesce(?3, ''))), '-', ''), ' ', ''))
         OR
         (t.territory_type = 'zip_prefix'
           AND trim(coalesce(t.zip_prefix, '')) <> ''
           AND replace(replace(upper(trim(coalesce(?3, ''))), '-', ''), ' ', '') LIKE
               (replace(replace(upper(trim(coalesce(t.zip_prefix, ''))), '-', ''), ' ', '') || '%'))
       )
       AND (t.segment IS NULL OR t.segment = ?4)
       AND (t.customer_type IS NULL OR t.customer_type = ?5)
       AND NOT EXISTS (
         SELECT 1
         FROM rep_territories tx
         WHERE tx.rep_id = t.rep_id
           AND tx.is_exclusion = 1
           AND tx.territory_type IN ('zip_prefix', 'zip_exact')
           AND (
             (tx.territory_type = 'zip_exact'
               AND replace(replace(upper(trim(coalesce(tx.zip_exact, ''))), '-', ''), ' ', '') =
                   replace(replace(upper(trim(coalesce(?3, ''))), '-', ''), ' ', ''))
             OR
             (tx.territory_type = 'zip_prefix'
               AND trim(coalesce(tx.zip_prefix, '')) <> ''
               AND replace(replace(upper(trim(coalesce(?3, ''))), '-', ''), ' ', '') LIKE
                   (replace(replace(upper(trim(coalesce(tx.zip_prefix, ''))), '-', ''), ' ', '') || '%'))
           )
           AND (tx.segment IS NULL OR tx.segment = ?4)
           AND (tx.customer_type IS NULL OR tx.customer_type = ?5)
       )
     ORDER BY r.id ASC`
  )
    .bind(state || null, city || null, zip || null, segment || null, customerType || null)
    .all<{ id: number }>();

  return (rows.results || []).map((row) => Number(row.id)).filter((id) => Number.isFinite(id) && id > 0);
}

async function deleteAttachmentsForEntity(env: Env, entityType: 'company' | 'customer' | 'interaction', entityId: number): Promise<number> {
  const rows = await env.CRM_DB.prepare(`SELECT id, file_key FROM attachments WHERE entity_type = ?1 AND entity_id = ?2`)
    .bind(entityType, entityId)
    .all<{ id: number; file_key: string }>();
  const attachments = rows.results || [];
  for (const attachment of attachments) {
    await env.CRM_FILES.delete(attachment.file_key);
  }
  await env.CRM_DB.prepare(`DELETE FROM attachments WHERE entity_type = ?1 AND entity_id = ?2`).bind(entityType, entityId).run();
  return attachments.length;
}

async function repCanAccessCompany(env: Env, user: AuthedUser, companyId: number): Promise<boolean> {
  const row = await env.CRM_DB.prepare(
    `SELECT c.id
     FROM companies c
     WHERE c.id = ?1
       AND c.deleted_at IS NULL
       AND ${repTerritoryCompanyScopeClause('c', 2)}`
  )
    .bind(companyId, user.email)
    .first<{ id: number }>();
  return !!row;
}

async function ensureRepCanAccessCompany(env: Env, user: AuthedUser, companyId: number): Promise<Response | null> {
  if (user.role !== 'rep') return null;
  if (!companyId) return err('company id is required');
  const allowed = await repCanAccessCompany(env, user, companyId);
  if (!allowed) return err('This company is outside your assigned territory.', 403);
  return null;
}

async function ensureRepCanAccessCustomer(env: Env, user: AuthedUser, customerId: number): Promise<Response | null> {
  if (user.role !== 'rep') return null;
  const row = await env.CRM_DB.prepare(`SELECT company_id FROM customers WHERE id = ?1 AND deleted_at IS NULL`)
    .bind(customerId)
    .first<{ company_id: number }>();
  if (!row) return err('Contact not found', 404);
  return ensureRepCanAccessCompany(env, user, row.company_id);
}

async function ensureRepCanAccessInteraction(env: Env, user: AuthedUser, interactionId: number): Promise<Response | null> {
  if (user.role !== 'rep') return null;
  const row = await env.CRM_DB.prepare(`SELECT company_id FROM interactions WHERE id = ?1 AND deleted_at IS NULL`)
    .bind(interactionId)
    .first<{ company_id: number }>();
  if (!row) return err('Interaction not found', 404);
  return ensureRepCanAccessCompany(env, user, row.company_id);
}

async function repCanCreateCompanyInTerritory(
  env: Env,
  user: AuthedUser,
  data: { city?: string; state?: string; zip?: string; segment?: string; customerType?: string }
): Promise<boolean> {
  const normalizedZip = normalizeZip(data.zip);
  const row = await env.CRM_DB.prepare(
    `SELECT 1 AS ok
     WHERE EXISTS (
       SELECT 1
       FROM rep_territories t
       JOIN reps r ON r.id = t.rep_id
       WHERE r.deleted_at IS NULL
         AND r.email IS NOT NULL
         AND lower(r.email) = lower(?1)
         AND t.is_exclusion = 0
         AND (
           (t.territory_type = 'state'
             AND upper(trim(coalesce(t.state, ''))) = upper(trim(coalesce(?2, ''))))
           OR
           (t.territory_type = 'city_state'
             AND upper(trim(coalesce(t.state, ''))) = upper(trim(coalesce(?2, '')))
             AND upper(trim(coalesce(t.city, ''))) = upper(trim(coalesce(?3, ''))))
           OR
           (t.territory_type = 'zip_exact'
             AND replace(replace(upper(trim(coalesce(t.zip_exact, ''))), '-', ''), ' ', '') =
                 replace(replace(upper(trim(coalesce(?4, ''))), '-', ''), ' ', ''))
           OR
           (t.territory_type = 'zip_prefix'
             AND trim(coalesce(t.zip_prefix, '')) <> ''
             AND replace(replace(upper(trim(coalesce(?4, ''))), '-', ''), ' ', '') LIKE
                 (replace(replace(upper(trim(coalesce(t.zip_prefix, ''))), '-', ''), ' ', '') || '%'))
         )
         AND (t.segment IS NULL OR trim(t.segment) = '' OR t.segment = ?5)
         AND (t.customer_type IS NULL OR trim(t.customer_type) = '' OR t.customer_type = ?6)
     )
     AND NOT EXISTS (
       SELECT 1
       FROM rep_territories tx
       JOIN reps rx ON rx.id = tx.rep_id
       WHERE rx.deleted_at IS NULL
         AND rx.email IS NOT NULL
         AND lower(rx.email) = lower(?1)
         AND tx.is_exclusion = 1
         AND tx.territory_type IN ('zip_prefix', 'zip_exact')
         AND (
           (tx.territory_type = 'zip_exact'
             AND replace(replace(upper(trim(coalesce(tx.zip_exact, ''))), '-', ''), ' ', '') =
                 replace(replace(upper(trim(coalesce(?4, ''))), '-', ''), ' ', ''))
           OR
           (tx.territory_type = 'zip_prefix'
             AND trim(coalesce(tx.zip_prefix, '')) <> ''
             AND replace(replace(upper(trim(coalesce(?4, ''))), '-', ''), ' ', '') LIKE
                 (replace(replace(upper(trim(coalesce(tx.zip_prefix, ''))), '-', ''), ' ', '') || '%'))
         )
         AND (tx.segment IS NULL OR trim(tx.segment) = '' OR tx.segment = ?5)
         AND (tx.customer_type IS NULL OR trim(tx.customer_type) = '' OR tx.customer_type = ?6)
     )`
  )
    .bind(user.email, data.state ?? null, data.city ?? null, normalizedZip || null, data.segment ?? null, data.customerType ?? null)
    .first<{ ok: number }>();
  return !!row;
}

async function audit(env: Env, user: AuthedUser | null, action: string, entityType: string, entityId: string, details?: unknown) {
  await env.CRM_DB.prepare(
    `INSERT INTO audit_log (actor_user_id, action, entity_type, entity_id, details_json) VALUES (?1, ?2, ?3, ?4, ?5)`
  )
    .bind(user?.id ?? null, action, entityType, entityId, details ? JSON.stringify(details) : null)
    .run();
}

function withAuth(handler: (request: Request, env: Env, user: AuthedUser, url: URL) => Promise<Response>) {
  return async (request: Request, env: Env, url: URL): Promise<Response> => {
    const user = await getAuthedUser(request, env);
    if (!user) return err('Unauthorized', 401);
    return handler(request, env, user, url);
  };
}

function withWriteAccess(handler: (request: Request, env: Env, user: AuthedUser, url: URL) => Promise<Response>) {
  return withAuth(async (request, env, user, url) => {
    if (!canWrite(user.role)) return err('Forbidden', 403);
    return handler(request, env, user, url);
  });
}

const routes: Array<{
  method: string;
  match: RegExp;
  handler: (request: Request, env: Env, url: URL, match: RegExpMatchArray) => Promise<Response>;
}> = [];

function addRoute(
  method: string,
  match: RegExp,
  handler: (request: Request, env: Env, url: URL, match: RegExpMatchArray) => Promise<Response>
) {
  routes.push({ method, match, handler });
}

addRoute('GET', /^\/api\/health$/, async () => json({ ok: true }));

addRoute('POST', /^\/api\/auth\/bootstrap$/, async (request, env) => {
  const existing = await env.CRM_DB.prepare(`SELECT COUNT(*) AS count FROM users`).first<{ count: number }>();
  if ((existing?.count ?? 0) > 0) return err('Bootstrap already completed', 409);

  const body = await parseJson<{ email: string; fullName: string; password: string }>(request);
  if (!body?.email || !body?.password || !body?.fullName) return err('email, fullName, and password are required');

  const pwd = await hashPassword(body.password);
  const result = await env.CRM_DB.prepare(
    `INSERT INTO users (email, full_name, role, password_hash, password_salt) VALUES (?1, ?2, 'admin', ?3, ?4)`
  )
    .bind(body.email.toLowerCase().trim(), body.fullName.trim(), pwd.hash, pwd.salt)
    .run();

  await audit(env, null, 'bootstrap_admin', 'user', String(result.meta.last_row_id), { email: body.email });
  return json({ success: true, userId: result.meta.last_row_id }, 201);
});

addRoute('POST', /^\/api\/auth\/login$/, async (request, env) => {
  const body = await parseJson<{ email: string; password: string }>(request);
  if (!body?.email || !body?.password) return err('email and password are required');

  const row = await env.CRM_DB.prepare(
    `SELECT id, email, full_name, role, password_hash, password_salt, is_active FROM users WHERE email = ?1`
  )
    .bind(body.email.toLowerCase().trim())
    .first<AuthedUser & { password_hash: string; password_salt: string; is_active: number }>();

  if (!row || row.is_active !== 1) return err('Invalid credentials', 401);
  const valid = await verifyPassword(body.password, row.password_hash, row.password_salt);
  if (!valid) return err('Invalid credentials', 401);

  const token = randomToken(32);
  const ttl = Number.parseInt(env.SESSION_TTL_HOURS, 10) || 24;
  await env.CRM_DB.prepare(`INSERT INTO sessions (id, user_id, expires_at) VALUES (?1, ?2, ?3)`)
    .bind(token, row.id, isoAfterHours(ttl))
    .run();

  await audit(env, { id: row.id, email: row.email, full_name: row.full_name, role: row.role }, 'login', 'session', token);
  return json({
    token,
    user: {
      id: row.id,
      email: row.email,
      fullName: row.full_name,
      role: row.role
    }
  });
});

addRoute('POST', /^\/api\/auth\/logout$/, async (request, env) => {
  const token = getTokenFromRequest(request);
  if (!token) return err('Unauthorized', 401);
  await env.CRM_DB.prepare(`DELETE FROM sessions WHERE id = ?1`).bind(token).run();
  return json({ success: true });
});

addRoute('GET', /^\/api\/auth\/invite\/([^/]+)$/, async (request, env) => {
  const match = request.url.match(/\/api\/auth\/invite\/([^/]+)$/);
  const token = decodeURIComponent(match?.[1] || '');
  if (!token) return err('token is required');
  const invite = await env.CRM_DB.prepare(
    `SELECT ui.id, ui.user_id, ui.expires_at, ui.used_at, u.email
     FROM user_invites ui
     JOIN users u ON u.id = ui.user_id
     WHERE ui.token = ?1`
  )
    .bind(token)
    .first<{ id: number; user_id: number; expires_at: string; used_at: string | null; email: string }>();
  if (!invite) return err('Invalid invite token', 404);
  if (invite.used_at) return err('Invite token already used', 409);
  if (new Date(invite.expires_at).getTime() < Date.now()) return err('Invite token expired', 410);
  return json({ email: invite.email });
});

addRoute('POST', /^\/api\/auth\/invite\/accept$/, async (request, env) => {
  const body = await parseJson<{ token: string; password: string }>(request);
  if (!body?.token || !body?.password) return err('token and password are required');
  if (String(body.password).length < 8) return err('Password must be at least 8 characters');

  const invite = await env.CRM_DB.prepare(
    `SELECT ui.id, ui.user_id, ui.expires_at, ui.used_at, u.email
     FROM user_invites ui
     JOIN users u ON u.id = ui.user_id
     WHERE ui.token = ?1`
  )
    .bind(body.token)
    .first<{ id: number; user_id: number; expires_at: string; used_at: string | null; email: string }>();

  if (!invite) return err('Invalid invite token', 404);
  if (invite.used_at) return err('Invite token already used', 409);
  if (new Date(invite.expires_at).getTime() < Date.now()) return err('Invite token expired', 410);

  const pwd = await hashPassword(body.password);
  await env.CRM_DB.batch([
    env.CRM_DB.prepare(
      `UPDATE users
       SET password_hash = ?1, password_salt = ?2, updated_at = CURRENT_TIMESTAMP
       WHERE id = ?3`
    ).bind(pwd.hash, pwd.salt, invite.user_id),
    env.CRM_DB.prepare(`UPDATE user_invites SET used_at = CURRENT_TIMESTAMP WHERE id = ?1`).bind(invite.id),
    env.CRM_DB.prepare(`DELETE FROM sessions WHERE user_id = ?1`).bind(invite.user_id)
  ]);

  await audit(env, null, 'accept_invite', 'user', String(invite.user_id), { email: invite.email });
  return json({ success: true });
});

addRoute('GET', /^\/api\/auth\/password-reset\/([^/]+)$/, async (request, env) => {
  const match = request.url.match(/\/api\/auth\/password-reset\/([^/]+)$/);
  const token = decodeURIComponent(match?.[1] || '');
  if (!token) return err('token is required');
  const reset = await env.CRM_DB.prepare(
    `SELECT pr.id, pr.user_id, pr.expires_at, pr.used_at, u.email
     FROM password_resets pr
     JOIN users u ON u.id = pr.user_id
     WHERE pr.token = ?1`
  )
    .bind(token)
    .first<{ id: number; user_id: number; expires_at: string; used_at: string | null; email: string }>();
  if (!reset) return err('Invalid reset token', 404);
  if (reset.used_at) return err('Reset token already used', 409);
  if (new Date(reset.expires_at).getTime() < Date.now()) return err('Reset token expired', 410);
  return json({ email: reset.email });
});

addRoute('POST', /^\/api\/auth\/password-reset\/request$/, async (request, env) => {
  const body = await parseJson<{ email: string }>(request);
  const email = body?.email?.toLowerCase().trim();
  if (!email) return err('email is required');

  const user = await env.CRM_DB.prepare(
    `SELECT id, email, is_active
     FROM users
     WHERE email = ?1`
  )
    .bind(email)
    .first<{ id: number; email: string; is_active: number }>();

  if (user && user.is_active === 1) {
    const token = randomToken(24);
    const expiresAt = isoAfterHours(1);
    await env.CRM_DB.batch([
      env.CRM_DB.prepare(`DELETE FROM password_resets WHERE user_id = ?1 AND used_at IS NULL`).bind(user.id),
      env.CRM_DB.prepare(
        `INSERT INTO password_resets (token, user_id, expires_at)
         VALUES (?1, ?2, ?3)`
      ).bind(token, user.id, expiresAt)
    ]);
    await sendEmail(env, {
      to: user.email,
      ...buildPasswordResetEmail(env, user.email, token)
    });
    await audit(env, null, 'request_password_reset', 'user', String(user.id), { email: user.email });
  }

  return json({
    success: true,
    message: 'If that email is active in the CRM, a password reset link has been sent.'
  });
});

addRoute('POST', /^\/api\/auth\/password-reset\/confirm$/, async (request, env) => {
  const body = await parseJson<{ token: string; password: string }>(request);
  if (!body?.token || !body?.password) return err('token and password are required');
  if (String(body.password).length < 8) return err('Password must be at least 8 characters');

  const reset = await env.CRM_DB.prepare(
    `SELECT pr.id, pr.user_id, pr.expires_at, pr.used_at, u.email
     FROM password_resets pr
     JOIN users u ON u.id = pr.user_id
     WHERE pr.token = ?1`
  )
    .bind(body.token)
    .first<{ id: number; user_id: number; expires_at: string; used_at: string | null; email: string }>();

  if (!reset) return err('Invalid reset token', 404);
  if (reset.used_at) return err('Reset token already used', 409);
  if (new Date(reset.expires_at).getTime() < Date.now()) return err('Reset token expired', 410);

  const pwd = await hashPassword(body.password);
  await env.CRM_DB.batch([
    env.CRM_DB.prepare(
      `UPDATE users
       SET password_hash = ?1, password_salt = ?2, updated_at = CURRENT_TIMESTAMP
       WHERE id = ?3`
    ).bind(pwd.hash, pwd.salt, reset.user_id),
    env.CRM_DB.prepare(`UPDATE password_resets SET used_at = CURRENT_TIMESTAMP WHERE id = ?1`).bind(reset.id),
    env.CRM_DB.prepare(`DELETE FROM sessions WHERE user_id = ?1`).bind(reset.user_id)
  ]);

  await audit(env, null, 'confirm_password_reset', 'user', String(reset.user_id), { email: reset.email });
  return json({ success: true });
});

addRoute('GET', /^\/api\/auth\/me$/, async (request, env) => {
  const user = await getAuthedUser(request, env);
  if (!user) return err('Unauthorized', 401);
  return json({ user: { id: user.id, email: user.email, fullName: user.full_name, role: user.role } });
});

addRoute(
  'GET',
  /^\/api\/lookups$/,
  withAuth(async (_request, env, user) => {
    const companyBinds: unknown[] = [];
    let companySql = `SELECT id, name FROM companies WHERE deleted_at IS NULL`;
    if (user.role === 'rep') {
      companySql += ` AND ${repTerritoryCompanyScopeClause('companies', 1)}`;
      companyBinds.push(user.email);
    }
    companySql += ` ORDER BY name ASC`;

    const [companies, reps, customers] = await Promise.all([
      companyBinds.length ? env.CRM_DB.prepare(companySql).bind(...companyBinds).all() : env.CRM_DB.prepare(companySql).all(),
      env.CRM_DB.prepare(`SELECT id, full_name FROM reps WHERE deleted_at IS NULL ORDER BY full_name ASC`).all(),
      (async () => {
        const customerBinds: unknown[] = [];
        let customerSql =
          `SELECT customers.id, customers.first_name, customers.last_name, companies.name AS company_name
           FROM customers
           JOIN companies ON companies.id = customers.company_id
           WHERE customers.deleted_at IS NULL`;
        if (user.role === 'rep') {
          customerSql += ` AND ${repTerritoryCompanyScopeClause('companies', 1)}`;
          customerBinds.push(user.email);
        }
        customerSql += ` ORDER BY customers.first_name, customers.last_name`;
        return customerBinds.length
          ? env.CRM_DB.prepare(customerSql).bind(...customerBinds).all()
          : env.CRM_DB.prepare(customerSql).all();
      })()
    ]);

    return json({
      companies: companies.results,
      reps: reps.results,
      customers: customers.results
    });
  }) as any
);

addRoute(
  'GET',
  /^\/api\/company-metadata$/,
  withAuth(async (_request, env) => {
    const [segments, types, interactionTypes] = await Promise.all([
      env.CRM_DB.prepare(`SELECT id, name FROM company_segments ORDER BY name ASC`).all(),
      env.CRM_DB.prepare(`SELECT id, name FROM company_types ORDER BY name ASC`).all(),
      env.CRM_DB.prepare(`SELECT id, name FROM interaction_types ORDER BY name ASC`).all()
    ]);
    return json({ segments: segments.results, types: types.results, interactionTypes: interactionTypes.results });
  }) as any
);

addRoute(
  'POST',
  /^\/api\/company-metadata\/segments$/,
  withAuth(async (request, env, user) => {
    if (!canManageReps(user.role)) return err('Forbidden', 403);
    const body = await parseJson<{ name: string }>(request);
    if (!body?.name?.trim()) return err('name is required');
    await env.CRM_DB.prepare(`INSERT OR IGNORE INTO company_segments (name) VALUES (?1)`).bind(body.name.trim()).run();
    await audit(env, user, 'create', 'company_segment', body.name.trim());
    return json({ success: true }, 201);
  }) as any
);

addRoute(
  'PATCH',
  /^\/api\/company-metadata\/segments\/(\d+)$/,
  withAuth(async (request, env, user) => {
    if (!canManageReps(user.role)) return err('Forbidden', 403);
    const match = request.url.match(/\/api\/company-metadata\/segments\/(\d+)$/);
    const segmentId = Number(match?.[1]);
    if (!segmentId) return err('segment id is required');
    const body = await parseJson<{ name: string }>(request);
    if (!body?.name?.trim()) return err('name is required');
    const current = await env.CRM_DB.prepare(`SELECT id, name FROM company_segments WHERE id = ?1`)
      .bind(segmentId)
      .first<{ id: number; name: string }>();
    if (!current) return err('Segment not found', 404);
    const nextName = body.name.trim();
    await env.CRM_DB.batch([
      env.CRM_DB.prepare(`UPDATE company_segments SET name = ?1 WHERE id = ?2`).bind(nextName, segmentId),
      env.CRM_DB.prepare(`UPDATE companies SET segment = ?1 WHERE segment = ?2`).bind(nextName, current.name),
      env.CRM_DB.prepare(`UPDATE reps SET segment = ?1 WHERE segment = ?2`).bind(nextName, current.name)
    ]);
    await audit(env, user, 'update', 'company_segment', String(segmentId), { from: current.name, to: nextName });
    return json({ success: true });
  }) as any
);

addRoute(
  'DELETE',
  /^\/api\/company-metadata\/segments\/(\d+)$/,
  withAuth(async (request, env, user) => {
    if (!canManageReps(user.role)) return err('Forbidden', 403);
    const match = request.url.match(/\/api\/company-metadata\/segments\/(\d+)$/);
    const segmentId = Number(match?.[1]);
    if (!segmentId) return err('segment id is required');
    const current = await env.CRM_DB.prepare(`SELECT id, name FROM company_segments WHERE id = ?1`)
      .bind(segmentId)
      .first<{ id: number; name: string }>();
    if (!current) return err('Segment not found', 404);
    await env.CRM_DB.batch([
      env.CRM_DB.prepare(`DELETE FROM company_segments WHERE id = ?1`).bind(segmentId),
      env.CRM_DB.prepare(`UPDATE companies SET segment = NULL WHERE segment = ?1`).bind(current.name),
      env.CRM_DB.prepare(`UPDATE reps SET segment = NULL WHERE segment = ?1`).bind(current.name),
      env.CRM_DB.prepare(`UPDATE rep_territories SET segment = NULL WHERE segment = ?1`).bind(current.name)
    ]);
    await audit(env, user, 'delete', 'company_segment', String(segmentId), { name: current.name });
    return json({ success: true });
  }) as any
);

addRoute(
  'POST',
  /^\/api\/company-metadata\/types$/,
  withAuth(async (request, env, user) => {
    if (!canManageReps(user.role)) return err('Forbidden', 403);
    const body = await parseJson<{ name: string }>(request);
    if (!body?.name?.trim()) return err('name is required');
    await env.CRM_DB.prepare(`INSERT OR IGNORE INTO company_types (name) VALUES (?1)`).bind(body.name.trim()).run();
    await audit(env, user, 'create', 'company_type', body.name.trim());
    return json({ success: true }, 201);
  }) as any
);

addRoute(
  'PATCH',
  /^\/api\/company-metadata\/types\/(\d+)$/,
  withAuth(async (request, env, user) => {
    if (!canManageReps(user.role)) return err('Forbidden', 403);
    const match = request.url.match(/\/api\/company-metadata\/types\/(\d+)$/);
    const typeId = Number(match?.[1]);
    if (!typeId) return err('type id is required');
    const body = await parseJson<{ name: string }>(request);
    if (!body?.name?.trim()) return err('name is required');
    const current = await env.CRM_DB.prepare(`SELECT id, name FROM company_types WHERE id = ?1`)
      .bind(typeId)
      .first<{ id: number; name: string }>();
    if (!current) return err('Type not found', 404);
    const nextName = body.name.trim();
    await env.CRM_DB.batch([
      env.CRM_DB.prepare(`UPDATE company_types SET name = ?1 WHERE id = ?2`).bind(nextName, typeId),
      env.CRM_DB.prepare(`UPDATE companies SET customer_type = ?1 WHERE customer_type = ?2`).bind(nextName, current.name),
      env.CRM_DB.prepare(`UPDATE reps SET customer_type = ?1 WHERE customer_type = ?2`).bind(nextName, current.name)
    ]);
    await audit(env, user, 'update', 'company_type', String(typeId), { from: current.name, to: nextName });
    return json({ success: true });
  }) as any
);

addRoute(
  'DELETE',
  /^\/api\/company-metadata\/types\/(\d+)$/,
  withAuth(async (request, env, user) => {
    if (!canManageReps(user.role)) return err('Forbidden', 403);
    const match = request.url.match(/\/api\/company-metadata\/types\/(\d+)$/);
    const typeId = Number(match?.[1]);
    if (!typeId) return err('type id is required');
    const current = await env.CRM_DB.prepare(`SELECT id, name FROM company_types WHERE id = ?1`)
      .bind(typeId)
      .first<{ id: number; name: string }>();
    if (!current) return err('Type not found', 404);
    await env.CRM_DB.batch([
      env.CRM_DB.prepare(`DELETE FROM company_types WHERE id = ?1`).bind(typeId),
      env.CRM_DB.prepare(`UPDATE companies SET customer_type = NULL WHERE customer_type = ?1`).bind(current.name),
      env.CRM_DB.prepare(`UPDATE reps SET customer_type = NULL WHERE customer_type = ?1`).bind(current.name),
      env.CRM_DB.prepare(`UPDATE rep_territories SET customer_type = NULL WHERE customer_type = ?1`).bind(current.name)
    ]);
    await audit(env, user, 'delete', 'company_type', String(typeId), { name: current.name });
    return json({ success: true });
  }) as any
);

addRoute(
  'POST',
  /^\/api\/interaction-types$/,
  withAuth(async (request, env, user) => {
    if (!canManageReps(user.role)) return err('Forbidden', 403);
    const body = await parseJson<{ name: string }>(request);
    if (!body?.name?.trim()) return err('name is required');
    await env.CRM_DB.prepare(`INSERT OR IGNORE INTO interaction_types (name) VALUES (?1)`).bind(body.name.trim()).run();
    await audit(env, user, 'create', 'interaction_type', body.name.trim());
    return json({ success: true }, 201);
  }) as any
);

addRoute(
  'PATCH',
  /^\/api\/interaction-types\/(\d+)$/,
  withAuth(async (request, env, user) => {
    if (!canManageReps(user.role)) return err('Forbidden', 403);
    const match = request.url.match(/\/api\/interaction-types\/(\d+)$/);
    const typeId = Number(match?.[1]);
    if (!typeId) return err('interaction type id is required');
    const body = await parseJson<{ name: string }>(request);
    if (!body?.name?.trim()) return err('name is required');
    const current = await env.CRM_DB.prepare(`SELECT id, name FROM interaction_types WHERE id = ?1`)
      .bind(typeId)
      .first<{ id: number; name: string }>();
    if (!current) return err('Interaction type not found', 404);
    const nextName = body.name.trim();
    await env.CRM_DB.batch([
      env.CRM_DB.prepare(`UPDATE interaction_types SET name = ?1 WHERE id = ?2`).bind(nextName, typeId),
      env.CRM_DB.prepare(`UPDATE interactions SET interaction_type = ?1 WHERE interaction_type = ?2`).bind(nextName, current.name)
    ]);
    await audit(env, user, 'update', 'interaction_type', String(typeId), { from: current.name, to: nextName });
    return json({ success: true });
  }) as any
);

addRoute(
  'GET',
  /^\/api\/settings\/theme$/,
  async (_request, env) => {
    const row = await env.CRM_DB.prepare(`SELECT value_json FROM app_settings WHERE key = 'theme'`).first<{ value_json: string }>();
    if (!row) return json({ theme: null });
    return json({ theme: JSON.parse(row.value_json) });
  }
);

addRoute(
  'PUT',
  /^\/api\/settings\/theme$/,
  withAuth(async (request, env, user) => {
    if (!canManageReps(user.role)) return err('Forbidden', 403);
    const body = await parseJson<Record<string, string>>(request);
    if (!body) return err('theme object is required');
    let normalized: Record<string, string> = {};
    if (body.accent && isHexColor(String(body.accent))) {
      normalized = deriveThemeFromAccent(String(body.accent));
    } else {
      for (const key of THEME_KEYS) {
        const value = String(body[key] || '');
        if (!isHexColor(value)) return err(`Invalid color for ${key}`);
        normalized[key] = value;
      }
    }
    await env.CRM_DB.prepare(
      `INSERT INTO app_settings (key, value_json, updated_by_user_id)
       VALUES ('theme', ?1, ?2)
       ON CONFLICT(key) DO UPDATE SET value_json = excluded.value_json, updated_by_user_id = excluded.updated_by_user_id, updated_at = CURRENT_TIMESTAMP`
    )
      .bind(JSON.stringify(normalized), user.id)
      .run();
    await audit(env, user, 'update', 'setting', 'theme', normalized);
    return json({ success: true });
  }) as any
);

addRoute(
  'GET',
  /^\/api\/companies$/,
  withAuth(async (_request, env, user, url) => {
    const page = Math.max(1, Number(url.searchParams.get('page') || 1));
    const pageSize = Math.min(100, Math.max(1, Number(url.searchParams.get('pageSize') || 25)));
    const sortBy = normalizedText(url.searchParams.get('sortBy')) || 'name';
    const sortDir = normalizedText(url.searchParams.get('sortDir')) === 'desc' ? 'desc' : 'asc';
    const q = normalizedText(url.searchParams.get('q'));
    const stateFilter = normalizedText(url.searchParams.get('state')).toUpperCase();
    const cityFilter = normalizedText(url.searchParams.get('city'));
    const repFilter = normalizedText(url.searchParams.get('rep'));
    const dueDays = Math.max(0, Number(url.searchParams.get('dueDays') || 0));
    const pendingOnly = normalizedText(url.searchParams.get('pendingOnly')) === '1';
    const offset = (page - 1) * pageSize;

    const whereParts: string[] = ['c.deleted_at IS NULL'];
    const binds: unknown[] = [];
    if (user.role === 'rep') {
      whereParts.push(repTerritoryCompanyScopeClause('c', binds.length + 1));
      binds.push(user.email);
    }
    if (q) {
      if (q === '!') {
        whereParts.push(companyMissingAddressSql('c'));
      } else if (/^[A-Za-z]{2}$/.test(q)) {
        whereParts.push(`upper(coalesce(c.state, '')) = ?${binds.length + 1}`);
        binds.push(q.toUpperCase());
      } else {
        const likeValue = `%${q.toLowerCase()}%`;
        whereParts.push(
          `(
            lower(coalesce(c.name, '')) LIKE ?${binds.length + 1}
            OR lower(coalesce(c.city, '')) LIKE ?${binds.length + 1}
            OR lower(coalesce(c.state, '')) LIKE ?${binds.length + 1}
            OR EXISTS (
              SELECT 1
              FROM reps rr
              WHERE rr.deleted_at IS NULL
                AND lower(coalesce(rr.full_name, '')) LIKE ?${binds.length + 1}
                AND (
                  EXISTS (SELECT 1 FROM company_reps cr WHERE cr.company_id = c.id AND cr.rep_id = rr.id)
                  OR ${repTerritoryCompanyScopeClauseForRepId('c', 'rr.id')}
                )
            )
          )`
        );
        binds.push(likeValue);
      }
    }
    if (stateFilter) {
      whereParts.push(`upper(coalesce(c.state, '')) = ?${binds.length + 1}`);
      binds.push(stateFilter);
    }
    if (cityFilter) {
      whereParts.push(`lower(coalesce(c.city, '')) = ?${binds.length + 1}`);
      binds.push(cityFilter.toLowerCase());
    }
    if (repFilter) {
      whereParts.push(
        `EXISTS (
          SELECT 1
          FROM reps rr
          WHERE rr.deleted_at IS NULL
            AND lower(coalesce(rr.full_name, '')) LIKE ?${binds.length + 1}
            AND (
              EXISTS (SELECT 1 FROM company_reps cr WHERE cr.company_id = c.id AND cr.rep_id = rr.id)
              OR ${repTerritoryCompanyScopeClauseForRepId('c', 'rr.id')}
            )
        )`
      );
      binds.push(`%${repFilter.toLowerCase()}%`);
    }
    if (dueDays > 0) {
      whereParts.push(
        `EXISTS (
          SELECT 1
          FROM interactions i
          WHERE i.company_id = c.id
            AND i.deleted_at IS NULL
            AND i.next_action_at IS NOT NULL
            AND datetime(i.next_action_at) <= datetime('now', '+${dueDays} days')
        )`
      );
    }
    if (pendingOnly) {
      whereParts.push(
        `NOT EXISTS (
          SELECT 1
          FROM interactions i
          WHERE i.company_id = c.id AND i.deleted_at IS NULL
        )`
      );
    }
    const whereClause = whereParts.join(' AND ');
    const sortKey = new Set(['name', 'city', 'state', 'next_action', 'last_interaction']).has(sortBy) ? sortBy : 'name';
    const textDirection = sortDir === 'desc' ? 'DESC' : 'ASC';
    const dateDirection = sortDir === 'desc' ? 'DESC' : 'ASC';
    const tieTextDirection = sortDir === 'desc' ? 'DESC' : 'ASC';
    const nextActionExpr = `(SELECT MIN(datetime(i.next_action_at))
                 FROM interactions i
                 WHERE i.company_id = c.id
                   AND i.deleted_at IS NULL
                   AND i.next_action_at IS NOT NULL)`;
    const lastInteractionExpr = `(SELECT MAX(datetime(coalesce(i.interaction_at, i.created_at)))
                   FROM interactions i
                   WHERE i.company_id = c.id
                     AND i.deleted_at IS NULL)`;
    const orderClause =
      sortKey === 'city'
        ? `lower(coalesce(c.city, '')) ${textDirection}, lower(coalesce(c.name, '')) ${tieTextDirection}`
        : sortKey === 'state'
          ? `lower(coalesce(c.state, '')) ${textDirection}, lower(coalesce(c.city, '')) ${textDirection}, lower(coalesce(c.name, '')) ${tieTextDirection}`
          : sortKey === 'next_action'
            ? `CASE WHEN ${nextActionExpr} IS NULL THEN 1 ELSE 0 END ASC, ${nextActionExpr} ${dateDirection}, lower(coalesce(c.name, '')) ${tieTextDirection}`
            : sortKey === 'last_interaction'
              ? `CASE WHEN ${lastInteractionExpr} IS NULL THEN 1 ELSE 0 END ASC, ${lastInteractionExpr} ${dateDirection}, lower(coalesce(c.name, '')) ${tieTextDirection}`
              : `lower(coalesce(c.name, '')) ${textDirection}`;

    const totalRow = await env.CRM_DB.prepare(`SELECT COUNT(*) AS c FROM companies c WHERE ${whereClause}`)
      .bind(...binds)
      .first<{ c: number }>();
    const total = Number(totalRow?.c || 0);

    const companies = await env.CRM_DB.prepare(
      `SELECT
         c.*,
         CASE WHEN ${companyMissingAddressSql('c')} THEN 1 ELSE 0 END AS has_incomplete_address,
         (SELECT COUNT(*) FROM customers cu WHERE cu.company_id = c.id AND cu.deleted_at IS NULL) AS customer_count,
         (SELECT COUNT(*) FROM company_reps cr WHERE cr.company_id = c.id) AS rep_count,
         (
           SELECT MIN(i.next_action_at)
           FROM interactions i
           WHERE i.company_id = c.id
             AND i.deleted_at IS NULL
             AND i.next_action_at IS NOT NULL
         ) AS next_action_at,
         (
           SELECT MAX(coalesce(i.interaction_at, i.created_at))
           FROM interactions i
           WHERE i.company_id = c.id
             AND i.deleted_at IS NULL
         ) AS last_interaction_at,
         (
           SELECT GROUP_CONCAT(name, ', ')
           FROM (
             SELECT DISTINCT rr.full_name AS name
             FROM reps rr
             WHERE rr.deleted_at IS NULL
               AND (
                 EXISTS (SELECT 1 FROM company_reps cr WHERE cr.company_id = c.id AND cr.rep_id = rr.id)
                 OR ${repTerritoryCompanyScopeClauseForRepId('c', 'rr.id')}
               )
             ORDER BY rr.full_name
           )
         ) AS rep_names
       FROM companies c
       WHERE ${whereClause}
       ORDER BY ${orderClause}
       LIMIT ?${binds.length + 1} OFFSET ?${binds.length + 2}`
    )
      .bind(...binds, pageSize, offset)
      .all();

    return json({ companies: companies.results, total, page, pageSize });
  }) as any
);

addRoute(
  'POST',
  /^\/api\/companies$/,
  withWriteAccess(async (request, env, user) => {
    const body = await parseJson<{
      name: string;
      address?: string;
      city?: string;
      state?: string;
      country?: string;
      zip?: string;
      mainPhone?: string;
      url?: string;
      segment?: string;
      customerType?: string;
      notes?: string;
      repIds?: number[];
    }>(request);

    if (!body?.name) return err('Company name is required');
    const metadataError = await ensureSegmentAndTypeExist(env, body.segment, body.customerType);
    if (metadataError) return err(metadataError);
    if (user.role === 'rep') {
      const inScope = await repCanCreateCompanyInTerritory(env, user, {
        city: body.city,
        state: body.state,
        zip: body.zip,
        segment: body.segment,
        customerType: body.customerType
      });
      if (!inScope) {
        return err('This company is outside your assigned territory (state/city/zip and segment/type).', 403);
      }
    }

    const result = await env.CRM_DB.prepare(
      `INSERT INTO companies (name, address, city, state, country, zip, main_phone, url, segment, customer_type, notes)
       VALUES (?1, ?2, ?3, ?4, ?5, ?6, ?7, ?8, ?9, ?10, ?11)`
    )
      .bind(
        body.name,
        body.address ?? null,
        body.city ?? null,
        body.state ?? null,
        body.country ?? 'US',
        body.zip ?? null,
        body.mainPhone ?? null,
        body.url ?? null,
        body.segment ?? null,
        body.customerType ?? null,
        body.notes ?? null
      )
      .run();

    const companyId = Number(result.meta.last_row_id);
    const autoRepIds = await suggestedRepIdsForCompany(env, {
      city: body.city ?? null,
      state: body.state ?? null,
      zip: body.zip ?? null,
      segment: body.segment ?? null,
      customerType: body.customerType ?? null
    });
    const explicitRepIds = Array.isArray(body.repIds) ? body.repIds.map((id) => Number(id)).filter((id) => Number.isFinite(id) && id > 0) : [];
    const repIdsToAssign = Array.from(new Set([...autoRepIds, ...explicitRepIds]));
    if (repIdsToAssign.length > 0) {
      for (const repId of repIdsToAssign) {
        await env.CRM_DB.prepare(`INSERT OR IGNORE INTO company_reps (company_id, rep_id) VALUES (?1, ?2)`).bind(companyId, repId).run();
      }
    }

    await audit(env, user, 'create', 'company', String(companyId), body);
    return json({ id: companyId }, 201);
  }) as any
);

addRoute(
  'POST',
  /^\/api\/companies\/(\d+)\/reps$/,
  withAuth(async (request, env, user, _url) => {
    if (!canManageReps(user.role)) return err('Forbidden', 403);
    const match = request.url.match(/\/api\/companies\/(\d+)\/reps$/);
    const companyId = Number(match?.[1]);
    const body = await parseJson<{ repIds: number[] }>(request);
    if (!Array.isArray(body?.repIds)) return err('repIds must be an array');
    const repAccessError = await ensureRepCanAccessCompany(env, user, companyId);
    if (repAccessError) return repAccessError;

    await env.CRM_DB.prepare(`DELETE FROM company_reps WHERE company_id = ?1`).bind(companyId).run();
    for (const repId of body.repIds) {
      await env.CRM_DB.prepare(`INSERT OR IGNORE INTO company_reps (company_id, rep_id) VALUES (?1, ?2)`).bind(companyId, repId).run();
    }

    await audit(env, user, 'set_reps', 'company', String(companyId), body);
    return json({ success: true });
  }) as any
);

addRoute(
  'GET',
  /^\/api\/companies\/(\d+)\/customers$/,
  withAuth(async (request, env, user) => {
    const match = request.url.match(/\/api\/companies\/(\d+)\/customers$/);
    const companyId = Number(match?.[1]);
    const repAccessError = await ensureRepCanAccessCompany(env, user, companyId);
    if (repAccessError) return repAccessError;
    const rows = await env.CRM_DB.prepare(
      `SELECT id, first_name, last_name, email, phone FROM customers WHERE company_id = ?1 AND deleted_at IS NULL ORDER BY first_name, last_name`
    )
      .bind(companyId)
      .all();
    return json({ customers: rows.results });
  }) as any
);

addRoute(
  'GET',
  /^\/api\/companies\/(\d+)$/,
  withAuth(async (request, env, user) => {
    const match = request.url.match(/\/api\/companies\/(\d+)$/);
    const companyId = Number(match?.[1]);
    if (!companyId) return err('company id is required');
    const repAccessError = await ensureRepCanAccessCompany(env, user, companyId);
    if (repAccessError) return repAccessError;

    const company = await env.CRM_DB.prepare(
      `SELECT
         c.*,
         CASE WHEN ${companyMissingAddressSql('c')} THEN 1 ELSE 0 END AS has_incomplete_address,
         (SELECT COUNT(*) FROM customers cu WHERE cu.company_id = c.id AND cu.deleted_at IS NULL) AS customer_count,
         (SELECT COUNT(*) FROM company_reps cr WHERE cr.company_id = c.id) AS rep_count
       FROM companies c
       WHERE c.id = ?1 AND c.deleted_at IS NULL`
    )
      .bind(companyId)
      .first();

    if (!company) return err('Company not found', 404);

    const explicitReps = await env.CRM_DB.prepare(
      `SELECT r.id, r.full_name
       FROM company_reps cr
       JOIN reps r ON r.id = cr.rep_id
       WHERE cr.company_id = ?1 AND r.deleted_at IS NULL
       ORDER BY r.full_name ASC`
    )
      .bind(companyId)
      .all<{ id: number; full_name: string }>();

    const suggestedRepIds = await suggestedRepIdsForCompany(env, {
      city: (company as any).city ?? null,
      state: (company as any).state ?? null,
      zip: (company as any).zip ?? null,
      segment: (company as any).segment ?? null,
      customerType: (company as any).customer_type ?? null
    });

    const assignedRepsMap = new Map<number, { id: number; full_name: string }>();
    for (const rep of explicitReps.results || []) {
      const repId = Number(rep.id);
      if (Number.isFinite(repId) && repId > 0) assignedRepsMap.set(repId, { id: repId, full_name: rep.full_name });
    }
    if (suggestedRepIds.length > 0) {
      const placeholders = suggestedRepIds.map((_id, idx) => `?${idx + 1}`).join(', ');
      const suggestedReps = await env.CRM_DB.prepare(
        `SELECT id, full_name
         FROM reps
         WHERE deleted_at IS NULL AND id IN (${placeholders})
         ORDER BY full_name ASC`
      )
        .bind(...suggestedRepIds)
        .all<{ id: number; full_name: string }>();
      for (const rep of suggestedReps.results || []) {
        const repId = Number(rep.id);
        if (Number.isFinite(repId) && repId > 0 && !assignedRepsMap.has(repId)) {
          assignedRepsMap.set(repId, { id: repId, full_name: rep.full_name });
        }
      }
    }
    const assignedReps = Array.from(assignedRepsMap.values()).sort((a, b) => a.full_name.localeCompare(b.full_name));

    return json({ company, assignedReps });
  }) as any
);

addRoute(
  'GET',
  /^\/api\/customers$/,
  withAuth(async (_request, env, user, url) => {
    const companyId = url.searchParams.get('companyId');
    if (companyId) {
      const repAccessError = await ensureRepCanAccessCompany(env, user, Number(companyId));
      if (repAccessError) return repAccessError;
      const rows = await env.CRM_DB.prepare(
        `SELECT cu.*, c.name AS company_name
         FROM customers cu
         JOIN companies c ON c.id = cu.company_id
         WHERE cu.deleted_at IS NULL AND cu.company_id = ?1
         ORDER BY cu.first_name, cu.last_name`
      )
        .bind(Number(companyId))
        .all();
      return json({ customers: rows.results });
    }

    const binds: unknown[] = [];
    let sql =
      `SELECT cu.*, c.name AS company_name
       FROM customers cu
       JOIN companies c ON c.id = cu.company_id
       WHERE cu.deleted_at IS NULL`;
    if (user.role === 'rep') {
      sql += ` AND ${repTerritoryCompanyScopeClause('c', 1)}`;
      binds.push(user.email);
    }
    sql += ` ORDER BY c.name, cu.first_name, cu.last_name`;
    const rows = binds.length ? await env.CRM_DB.prepare(sql).bind(...binds).all() : await env.CRM_DB.prepare(sql).all();
    return json({ customers: rows.results });
  }) as any
);

addRoute(
  'POST',
  /^\/api\/customers$/,
  withWriteAccess(async (request, env, user) => {
    const body = await parseJson<{
      companyId: number;
      firstName: string;
      lastName: string;
      email?: string;
      phone?: string;
      otherPhone?: string;
      photoKey?: string;
      notes?: string;
      repIds?: number[];
    }>(request);

    if (!body?.companyId || !body.firstName || !body.lastName) return err('companyId, firstName, and lastName are required');
    const repAccessError = await ensureRepCanAccessCompany(env, user, body.companyId);
    if (repAccessError) return repAccessError;

    const result = await env.CRM_DB.prepare(
      `INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes)
       VALUES (?1, ?2, ?3, ?4, ?5, ?6, ?7, ?8)`
    )
      .bind(
        body.companyId,
        body.firstName,
        body.lastName,
        body.email ?? null,
        body.phone ?? null,
        body.otherPhone ?? null,
        body.photoKey ?? null,
        body.notes ?? null
      )
      .run();

    const customerId = Number(result.meta.last_row_id);
    if (Array.isArray(body.repIds) && body.repIds.length > 0) {
      for (const repId of body.repIds) {
        await env.CRM_DB.prepare(`INSERT OR IGNORE INTO customer_reps (customer_id, rep_id) VALUES (?1, ?2)`).bind(customerId, repId).run();
      }
    }

    await audit(env, user, 'create', 'customer', String(customerId), body);
    return json({ id: customerId }, 201);
  }) as any
);

addRoute(
  'POST',
  /^\/api\/customers\/(\d+)\/reps$/,
  withAuth(async (request, env, user) => {
    if (!canManageReps(user.role)) return err('Forbidden', 403);
    const match = request.url.match(/\/api\/customers\/(\d+)\/reps$/);
    const customerId = Number(match?.[1]);
    const body = await parseJson<{ repIds: number[] }>(request);
    if (!Array.isArray(body?.repIds)) return err('repIds must be an array');
    const repAccessError = await ensureRepCanAccessCustomer(env, user, customerId);
    if (repAccessError) return repAccessError;

    await env.CRM_DB.prepare(`DELETE FROM customer_reps WHERE customer_id = ?1`).bind(customerId).run();
    for (const repId of body.repIds) {
      await env.CRM_DB.prepare(`INSERT OR IGNORE INTO customer_reps (customer_id, rep_id) VALUES (?1, ?2)`).bind(customerId, repId).run();
    }

    await audit(env, user, 'set_reps', 'customer', String(customerId), body);
    return json({ success: true });
  }) as any
);

addRoute(
  'GET',
  /^\/api\/customers\/(\d+)$/,
  withAuth(async (request, env, user) => {
    const match = request.url.match(/\/api\/customers\/(\d+)$/);
    const customerId = Number(match?.[1]);
    if (!customerId) return err('customer id is required');
    const repAccessError = await ensureRepCanAccessCustomer(env, user, customerId);
    if (repAccessError) return repAccessError;

    const customer = await env.CRM_DB.prepare(
      `SELECT cu.*, c.name AS company_name
       FROM customers cu
       JOIN companies c ON c.id = cu.company_id
       WHERE cu.id = ?1 AND cu.deleted_at IS NULL`
    )
      .bind(customerId)
      .first();
    if (!customer) return err('Contact not found', 404);

    return json({ customer });
  }) as any
);

addRoute(
  'GET',
  /^\/api\/reps$/,
  withAuth(async (_request, env) => {
    const rows = await env.CRM_DB.prepare(
      `SELECT * FROM reps WHERE deleted_at IS NULL ORDER BY full_name ASC`
    ).all();
    return json({ reps: rows.results });
  }) as any
);

addRoute(
  'GET',
  /^\/api\/reps\/with-assignments$/,
  withAuth(async (_request, env, user) => {
    if (!canManageReps(user.role)) return err('Forbidden', 403);
    const reps = await env.CRM_DB.prepare(
      `SELECT
         r.*,
         (
           SELECT u.id
           FROM users u
           WHERE lower(coalesce(u.email, '')) = lower(coalesce(r.email, ''))
           ORDER BY u.id DESC
           LIMIT 1
         ) AS user_id,
         (
           SELECT MAX(i.created_at)
           FROM interactions i
           JOIN users u ON u.id = i.created_by_user_id
           WHERE i.deleted_at IS NULL
             AND r.email IS NOT NULL
             AND lower(u.email) = lower(r.email)
         ) AS last_entry_at
       FROM reps r
       WHERE r.deleted_at IS NULL
       ORDER BY r.full_name ASC`
    ).all();
    const assignments = await env.CRM_DB.prepare(
      `SELECT cr.rep_id, c.id AS company_id, c.name AS company_name, c.city, c.state, c.zip
       FROM company_reps cr
       JOIN companies c ON c.id = cr.company_id
       WHERE c.deleted_at IS NULL
       ORDER BY cr.rep_id, c.name`
    ).all();
    const territories = await env.CRM_DB.prepare(
      `SELECT id, rep_id, territory_type, city, state, zip_prefix, zip_exact, segment, customer_type, is_exclusion
       FROM rep_territories
       ORDER BY rep_id, territory_type`
    ).all();
    return json({ reps: reps.results, assignments: assignments.results, territories: territories.results });
  }) as any
);

addRoute(
  'POST',
  /^\/api\/reps$/,
  withAuth(async (request, env, user) => {
    if (!canManageReps(user.role)) return err('Forbidden', 403);
    const body = await parseJson<{
      fullName: string;
      companyName?: string;
      isIndependent?: boolean;
      email?: string;
      phone?: string;
      segment?: string;
      customerType?: string;
    }>(request);

    if (!body?.fullName) return err('fullName is required');

    const result = await env.CRM_DB.prepare(
      `INSERT INTO reps (full_name, company_name, is_independent, email, phone, segment, customer_type)
       VALUES (?1, ?2, ?3, ?4, ?5, ?6, ?7)`
    )
      .bind(
        body.fullName,
        body.companyName ?? null,
        body.isIndependent ? 1 : 0,
        body.email ?? null,
        body.phone ?? null,
        body.segment ?? null,
        body.customerType ?? null
      )
      .run();

    await audit(env, user, 'create', 'rep', String(result.meta.last_row_id), body);
    return json({ id: result.meta.last_row_id }, 201);
  }) as any
);

addRoute(
  'GET',
  /^\/api\/interactions\/(\d+)$/,
  withAuth(async (request, env, user) => {
    const match = request.url.match(/\/api\/interactions\/(\d+)$/);
    const interactionId = Number(match?.[1]);
    if (!interactionId) return err('interaction id is required');
    const repAccessError = await ensureRepCanAccessInteraction(env, user, interactionId);
    if (repAccessError) return repAccessError;

    const interaction = await env.CRM_DB.prepare(
      `SELECT i.*, c.name AS company_name,
              (cu.first_name || ' ' || cu.last_name) AS customer_name,
              r.full_name AS rep_name,
              u.full_name AS created_by_name
       FROM interactions i
       JOIN companies c ON c.id = i.company_id
       LEFT JOIN customers cu ON cu.id = i.customer_id
       LEFT JOIN reps r ON r.id = i.rep_id
       JOIN users u ON u.id = i.created_by_user_id
       WHERE i.id = ?1 AND i.deleted_at IS NULL`
    )
      .bind(interactionId)
      .first();
    if (!interaction) return err('Interaction not found', 404);

    return json({ interaction });
  }) as any
);

addRoute(
  'GET',
  /^\/api\/interactions$/,
  withAuth(async (_request, env, user, url) => {
    const companyId = url.searchParams.get('companyId');
    const customerId = url.searchParams.get('customerId');
    if (user.role === 'rep' && companyId) {
      const repAccessError = await ensureRepCanAccessCompany(env, user, Number(companyId));
      if (repAccessError) return repAccessError;
    }
    if (user.role === 'rep' && customerId) {
      const repAccessError = await ensureRepCanAccessCustomer(env, user, Number(customerId));
      if (repAccessError) return repAccessError;
    }

    let sql =
      `SELECT i.*, c.name AS company_name,
              (cu.first_name || ' ' || cu.last_name) AS customer_name,
              r.full_name AS rep_name,
              u.full_name AS created_by_name
       FROM interactions i
       JOIN companies c ON c.id = i.company_id
       LEFT JOIN customers cu ON cu.id = i.customer_id
       LEFT JOIN reps r ON r.id = i.rep_id
       JOIN users u ON u.id = i.created_by_user_id
       WHERE i.deleted_at IS NULL`;

    const binds: unknown[] = [];
    if (companyId) {
      sql += ` AND i.company_id = ?${binds.length + 1}`;
      binds.push(Number(companyId));
    }
    if (customerId) {
      sql += ` AND i.customer_id = ?${binds.length + 1}`;
      binds.push(Number(customerId));
    }
    if (user.role === 'rep') {
      sql += ` AND ${repTerritoryCompanyScopeClause('c', binds.length + 1)}`;
      binds.push(user.email);
    }
    sql += ` ORDER BY coalesce(i.interaction_at, i.created_at) DESC, i.id DESC`;

    const stmt = env.CRM_DB.prepare(sql);
    const rows = binds.length > 0 ? await stmt.bind(...binds).all() : await stmt.all();

    return json({ interactions: rows.results });
  }) as any
);

addRoute(
  'POST',
  /^\/api\/interactions$/,
  withWriteAccess(async (request, env, user) => {
    const body = await parseJson<{
      companyId: number;
      customerId?: number;
      repId?: number;
      interactionType?: string;
      meetingNotes: string;
      interactionAt?: string;
      nextAction?: string;
      nextActionAt?: string;
      attachmentKeys?: string[];
    }>(request);

    if (!body?.companyId || !body?.meetingNotes) return err('companyId and meetingNotes are required');
    const repAccessError = await ensureRepCanAccessCompany(env, user, body.companyId);
    if (repAccessError) return repAccessError;

    const result = await env.CRM_DB.prepare(
      `INSERT INTO interactions (company_id, customer_id, rep_id, interaction_type, meeting_notes, interaction_at, next_action, next_action_at, created_by_user_id)
       VALUES (?1, ?2, ?3, ?4, ?5, ?6, ?7, ?8, ?9)`
    )
      .bind(
        body.companyId,
        body.customerId ?? null,
        body.repId ?? null,
        body.interactionType ?? null,
        body.meetingNotes,
        body.interactionAt ?? new Date().toISOString(),
        body.nextAction ?? null,
        body.nextActionAt ?? null,
        user.id
      )
      .run();

    const interactionId = Number(result.meta.last_row_id);

    if (Array.isArray(body.attachmentKeys) && body.attachmentKeys.length > 0) {
      for (const key of body.attachmentKeys) {
        await env.CRM_DB.prepare(
          `INSERT INTO attachments (entity_type, entity_id, file_key, file_name, created_by_user_id)
           VALUES ('interaction', ?1, ?2, ?3, ?4)`
        )
          .bind(interactionId, key, key.split('/').pop() ?? key, user.id)
          .run();
      }
    }

    await audit(env, user, 'create', 'interaction', String(interactionId), body);
    return json({ id: interactionId }, 201);
  }) as any
);

addRoute(
  'POST',
  /^\/api\/files\/upload$/,
  withWriteAccess(async (request, env, user) => {
    const form = await request.formData();
    const file = form.get('file');
    const entityType = String(form.get('entityType') || '').trim();
    const entityId = Number(form.get('entityId'));

    if (!(file instanceof File)) return err('file is required');
    if (!['company', 'customer', 'interaction'].includes(entityType)) return err('entityType must be company, customer, or interaction');
    if (!entityId) return err('entityId is required');
    if (user.role === 'rep') {
      if (entityType === 'company') {
        const repAccessError = await ensureRepCanAccessCompany(env, user, entityId);
        if (repAccessError) return repAccessError;
      }
      if (entityType === 'customer') {
        const repAccessError = await ensureRepCanAccessCustomer(env, user, entityId);
        if (repAccessError) return repAccessError;
      }
      if (entityType === 'interaction') {
        const repAccessError = await ensureRepCanAccessInteraction(env, user, entityId);
        if (repAccessError) return repAccessError;
      }
    }

    const key = `${entityType}/${entityId}/${Date.now()}-${randomToken(8)}-${file.name.replace(/[^a-zA-Z0-9._-]/g, '_')}`;

    await env.CRM_FILES.put(key, file.stream(), {
      httpMetadata: {
        contentType: file.type || 'application/octet-stream'
      }
    });

    const insert = await env.CRM_DB.prepare(
      `INSERT INTO attachments (entity_type, entity_id, file_key, file_name, mime_type, size_bytes, created_by_user_id)
       VALUES (?1, ?2, ?3, ?4, ?5, ?6, ?7)`
    )
      .bind(entityType, entityId, key, file.name, file.type || null, file.size, user.id)
      .run();

    await audit(env, user, 'upload', 'attachment', String(insert.meta.last_row_id), { entityType, entityId, key });
    return json({ id: insert.meta.last_row_id, key, fileName: file.name }, 201);
  }) as any
);

addRoute(
  'GET',
  /^\/api\/attachments$/,
  withAuth(async (_request, env, user, url) => {
    const entityType = url.searchParams.get('entityType');
    const entityId = Number(url.searchParams.get('entityId'));

    if (!entityType || !entityId) return err('entityType and entityId are required');
    if (user.role === 'rep') {
      if (entityType === 'company') {
        const repAccessError = await ensureRepCanAccessCompany(env, user, entityId);
        if (repAccessError) return repAccessError;
      }
      if (entityType === 'customer') {
        const repAccessError = await ensureRepCanAccessCustomer(env, user, entityId);
        if (repAccessError) return repAccessError;
      }
      if (entityType === 'interaction') {
        const repAccessError = await ensureRepCanAccessInteraction(env, user, entityId);
        if (repAccessError) return repAccessError;
      }
    }

    const rows = await env.CRM_DB.prepare(
      `SELECT id, entity_type, entity_id, file_key, file_name, mime_type, size_bytes, created_at
       FROM attachments
       WHERE entity_type = ?1 AND entity_id = ?2
       ORDER BY created_at DESC`
    )
      .bind(entityType, entityId)
      .all();

    return json({ attachments: rows.results });
  }) as any
);

addRoute(
  'DELETE',
  /^\/api\/attachments\/(\d+)$/,
  withWriteAccess(async (request, env, user) => {
    const match = request.url.match(/\/api\/attachments\/(\d+)$/);
    const attachmentId = Number(match?.[1]);
    if (!attachmentId) return err('attachment id is required');

    const attachment = await env.CRM_DB.prepare(
      `SELECT id, entity_type, entity_id, file_key FROM attachments WHERE id = ?1`
    )
      .bind(attachmentId)
      .first<{ id: number; entity_type: string; entity_id: number; file_key: string }>();

    if (!attachment) return err('Attachment not found', 404);
    if (user.role === 'rep') {
      if (attachment.entity_type === 'company') {
        const repAccessError = await ensureRepCanAccessCompany(env, user, attachment.entity_id);
        if (repAccessError) return repAccessError;
      }
      if (attachment.entity_type === 'customer') {
        const repAccessError = await ensureRepCanAccessCustomer(env, user, attachment.entity_id);
        if (repAccessError) return repAccessError;
      }
      if (attachment.entity_type === 'interaction') {
        const repAccessError = await ensureRepCanAccessInteraction(env, user, attachment.entity_id);
        if (repAccessError) return repAccessError;
      }
    }

    await env.CRM_FILES.delete(attachment.file_key);
    await env.CRM_DB.prepare(`DELETE FROM attachments WHERE id = ?1`).bind(attachmentId).run();
    await audit(env, user, 'delete', 'attachment', String(attachmentId), { fileKey: attachment.file_key });

    return json({ success: true });
  }) as any
);

addRoute(
  'GET',
  /^\/api\/files\/(.+)$/,
  withAuth(async (request, env, user) => {
    const path = new URL(request.url).pathname;
    const key = decodeURIComponent(path.replace('/api/files/', ''));
    if (user.role === 'rep') {
      const attachment = await env.CRM_DB.prepare(
        `SELECT entity_type, entity_id FROM attachments WHERE file_key = ?1 ORDER BY id DESC LIMIT 1`
      )
        .bind(key)
        .first<{ entity_type: string; entity_id: number }>();
      if (!attachment) return err('File not found', 404);
      if (attachment.entity_type === 'company') {
        const repAccessError = await ensureRepCanAccessCompany(env, user, attachment.entity_id);
        if (repAccessError) return repAccessError;
      }
      if (attachment.entity_type === 'customer') {
        const repAccessError = await ensureRepCanAccessCustomer(env, user, attachment.entity_id);
        if (repAccessError) return repAccessError;
      }
      if (attachment.entity_type === 'interaction') {
        const repAccessError = await ensureRepCanAccessInteraction(env, user, attachment.entity_id);
        if (repAccessError) return repAccessError;
      }
    }
    const object = await env.CRM_FILES.get(key);
    if (!object) return err('File not found', 404);

    const headers = new Headers();
    object.writeHttpMetadata(headers);
    headers.set('etag', object.httpEtag);
    headers.set('content-disposition', `inline; filename="${key.split('/').pop() || 'file'}"`);
    return new Response(object.body, { headers });
  }) as any
);

addRoute(
  'GET',
  /^\/api\/users$/,
  withAuth(async (_request, env, user) => {
    if (!canManageUsers(user.role)) return err('Forbidden', 403);
    const rows = await env.CRM_DB.prepare(
      `SELECT
         u.id,
         u.email,
         u.full_name,
         u.role,
         u.is_active,
         u.created_at,
         (
           SELECT MAX(a.created_at)
           FROM audit_log a
           WHERE a.actor_user_id = u.id AND a.action = 'login'
         ) AS last_login_at
       FROM users u
       ORDER BY u.created_at DESC`
    ).all();
    return json({ users: rows.results });
  }) as any
);

addRoute(
  'POST',
  /^\/api\/users$/,
  withAuth(async (request, env, user) => {
    if (!canManageUsers(user.role)) return err('Forbidden', 403);

    const body = await parseJson<{ email: string; fullName: string; role: UserRole; phone?: string; password?: string }>(request);
    if (!body?.email || !body?.fullName || !body?.role) {
      return err('email, fullName, and role are required');
    }
    if (!['admin', 'manager', 'rep', 'viewer'].includes(body.role)) return err('Invalid role');
    const normalizedEmail = body.email.toLowerCase().trim();

    const existingUser = await env.CRM_DB.prepare(
      `SELECT id, is_active, full_name, role
       FROM users
       WHERE email = ?1
       LIMIT 1`
    )
      .bind(normalizedEmail)
      .first<{ id: number; is_active: number; full_name: string; role: UserRole }>();
    if (existingUser) {
      return json(
        {
          error: existingUser.is_active ? 'A user with this email already exists.' : 'This email belongs to an inactive user.',
          code: existingUser.is_active ? 'USER_EXISTS_ACTIVE' : 'USER_EXISTS_INACTIVE',
          userId: existingUser.id,
          isActive: existingUser.is_active === 1,
          fullName: existingUser.full_name,
          role: existingUser.role
        },
        409
      );
    }

    const pwd = await hashPassword(body.password?.trim() || randomPassword(12));
    const result = await env.CRM_DB.prepare(
      `INSERT INTO users (email, full_name, role, password_hash, password_salt)
       VALUES (?1, ?2, ?3, ?4, ?5)`
    )
      .bind(normalizedEmail, body.fullName.trim(), body.role, pwd.hash, pwd.salt)
      .run();

    const inviteToken = randomToken(24);
    const inviteExpiresAt = isoAfterHours(24 * 7);
    await env.CRM_DB.prepare(
      `INSERT INTO user_invites (token, user_id, expires_at, created_by_user_id)
       VALUES (?1, ?2, ?3, ?4)`
    )
      .bind(inviteToken, result.meta.last_row_id, inviteExpiresAt, user.id)
      .run();

    let repId: number | null = null;
    if (body.role === 'rep') {
      const existingRep = await env.CRM_DB.prepare(
        `SELECT id
         FROM reps
         WHERE email IS NOT NULL AND lower(email) = lower(?1)
         ORDER BY id DESC
         LIMIT 1`
      )
        .bind(normalizedEmail)
        .first<{ id: number }>();
      if (existingRep?.id) {
        repId = existingRep.id;
        await env.CRM_DB.prepare(
          `UPDATE reps
           SET full_name = ?1, phone = ?2, deleted_at = NULL, updated_at = CURRENT_TIMESTAMP
           WHERE id = ?3`
        )
          .bind(body.fullName.trim(), normalizedText(body.phone) || null, repId)
          .run();
      } else {
        const repInsert = await env.CRM_DB.prepare(
          `INSERT INTO reps (full_name, company_name, is_independent, email, phone, segment, customer_type)
           VALUES (?1, NULL, 0, ?2, ?3, NULL, NULL)`
        )
          .bind(body.fullName.trim(), normalizedEmail, normalizedText(body.phone) || null)
          .run();
        repId = Number(repInsert.meta.last_row_id);
      }
    }

    let emailSent = true;
    let emailError: string | null = null;
    try {
      await sendEmail(env, {
        to: normalizedEmail,
        ...buildInviteEmail(env, user.full_name, body.fullName.trim(), normalizedEmail, inviteToken)
      });
    } catch (error) {
      emailSent = false;
      emailError = error instanceof Error ? error.message : 'Unable to send invitation email';
    }

    await audit(env, user, 'create', 'user', String(result.meta.last_row_id), {
      email: body.email,
      role: body.role,
      phone: normalizedText(body.phone) || null,
      repId,
      emailSent,
      emailError
    });
    return json(
      {
        id: result.meta.last_row_id,
        inviteExpiresAt,
        repId,
        emailSent,
        emailError
      },
      201
    );
  }) as any
);

addRoute(
  'GET',
  /^\/api\/company-reps$/,
  withAuth(async (_request, env, user) => {
    if (!canManageReps(user.role)) return err('Forbidden', 403);
    const rows = await env.CRM_DB.prepare(
      `SELECT cr.company_id, cr.rep_id, r.full_name AS rep_name
       FROM company_reps cr
       JOIN reps r ON r.id = cr.rep_id
       ORDER BY cr.company_id, r.full_name`
    ).all();

    return json({ companyReps: rows.results });
  }) as any
);

addRoute(
  'GET',
  /^\/api\/customer-reps$/,
  withAuth(async (_request, env, user) => {
    if (!canManageReps(user.role)) return err('Forbidden', 403);
    const rows = await env.CRM_DB.prepare(
      `SELECT cr.customer_id, cr.rep_id, r.full_name AS rep_name
       FROM customer_reps cr
       JOIN reps r ON r.id = cr.rep_id
       ORDER BY cr.customer_id, r.full_name`
    ).all();

    return json({ customerReps: rows.results });
  }) as any
);

addRoute(
  'GET',
  /^\/api\/rep-territories$/,
  withAuth(async (_request, env, user, url) => {
    if (!canManageReps(user.role)) return err('Forbidden', 403);
    const repId = Number(url.searchParams.get('repId'));
    if (!repId) return err('repId is required');
    const rows = await env.CRM_DB.prepare(
      `SELECT id, rep_id, territory_type, city, state, zip_prefix, zip_exact, segment, customer_type, is_exclusion, created_at
       FROM rep_territories
       WHERE rep_id = ?1
       ORDER BY created_at DESC`
    )
      .bind(repId)
      .all();
    return json({ territories: rows.results });
  }) as any
);

addRoute(
  'POST',
  /^\/api\/rep-territories$/,
  withAuth(async (request, env, user) => {
    if (!canManageReps(user.role)) return err('Forbidden', 403);
    const body = await parseJson<{
      repId: number;
      territoryType: 'state' | 'city_state' | 'zip_prefix' | 'zip_exact';
      state?: string;
      city?: string;
      zipPrefix?: string;
      zipExact?: string;
      states?: string[] | string;
      zipPrefixes?: string[] | string;
      zipExacts?: string[] | string;
      cityStates?: Array<{ city: string; state: string }> | string;
      segment?: string;
      customerType?: string;
      isExclusion?: boolean;
    }>(request);
    if (!body?.repId || !body.territoryType) return err('repId and territoryType are required');
    if (!['state', 'city_state', 'zip_prefix', 'zip_exact'].includes(body.territoryType)) return err('Invalid territoryType');
    const metadataError = await ensureSegmentAndTypeExist(env, body.segment, body.customerType);
    if (metadataError) return err(metadataError);

    const rows: Array<{ state?: string; city?: string; zipPrefix?: string; zipExact?: string; isExclusion: boolean }> = [];
    const defaultExclusion = !!body.isExclusion;
    if (body.territoryType === 'state') {
      const values = Array.from(new Set([...splitCsvValues(body.states), ...splitCsvValues(body.state)]));
      if (values.length === 0) return err('Provide at least one state');
      if (values.some((state) => state.startsWith('-'))) return err('State exclusions are not supported. Use zip exclusions with -prefix/-zip.');
      for (const state of values) rows.push({ state: state.toUpperCase(), isExclusion: defaultExclusion });
    }
    if (body.territoryType === 'zip_prefix') {
      const values = [...parseZipEntries(body.zipPrefixes), ...parseZipEntries(body.zipPrefix)];
      const deduped = Array.from(new Map(values.map((item) => [`${item.value}|${item.isExclusion ? 1 : 0}`, item])).values());
      if (deduped.length === 0) return err('Provide at least one zip prefix');
      for (const item of deduped) {
        const digits = item.value.replace(/\D/g, '');
        if (digits.length !== 3) {
          return err(`Invalid zip prefix: ${item.isExclusion ? '-' : ''}${item.value}. Use exactly 3 digits.`);
        }
        rows.push({ zipPrefix: digits, isExclusion: item.isExclusion || defaultExclusion });
      }
    }
    if (body.territoryType === 'zip_exact') {
      const values = [...parseZipEntries(body.zipExacts), ...parseZipEntries(body.zipExact)];
      const deduped = Array.from(new Map(values.map((item) => [`${item.value}|${item.isExclusion ? 1 : 0}`, item])).values());
      if (deduped.length === 0) return err('Provide at least one exact zip');
      for (const item of deduped) {
        const digits = item.value.replace(/\D/g, '');
        if (digits.length !== 5) {
          return err(`Invalid exact zip: ${item.isExclusion ? '-' : ''}${item.value}. Use exactly 5 digits.`);
        }
        rows.push({ zipExact: digits, isExclusion: item.isExclusion || defaultExclusion });
      }
    }
    if (body.territoryType === 'city_state') {
      const cityStates: Array<{ city: string; state: string }> = [];
      if (Array.isArray(body.cityStates)) {
        for (const item of body.cityStates) {
          const city = normalizedText(item?.city);
          const state = normalizedText(item?.state).toUpperCase();
          if (city && state) cityStates.push({ city, state });
        }
      } else if (typeof body.cityStates === 'string') {
        const entries = body.cityStates
          .split('\n')
          .map((line) => line.trim())
          .filter(Boolean);
        for (const entry of entries) {
          const parts = entry.split(',').map((part) => part.trim());
          if (parts.length < 2) continue;
          const state = parts.pop() || '';
          const city = parts.join(', ');
          if (city && state) cityStates.push({ city, state: state.toUpperCase() });
        }
      }
      const singleCity = normalizedText(body.city);
      const singleState = normalizedText(body.state).toUpperCase();
      if (singleCity && singleState) cityStates.push({ city: singleCity, state: singleState });
      if (cityStates.some((item) => item.state.startsWith('-'))) {
        return err('City/state exclusions are not supported. Use zip exclusions with -prefix/-zip.');
      }
      const deduped = Array.from(new Map(cityStates.map((item) => [`${item.city.toUpperCase()}|${item.state}`, item])).values());
      if (deduped.length === 0) return err('Provide at least one city and state');
      for (const item of deduped) rows.push({ city: item.city, state: item.state, isExclusion: defaultExclusion });
    }

    if (rows.length === 0) return err('No territory rows to create');
    const existingRows = await env.CRM_DB.prepare(
      `SELECT territory_type, state, city, zip_prefix, zip_exact, segment, customer_type, is_exclusion
       FROM rep_territories
       WHERE rep_id = ?1`
    )
      .bind(body.repId)
      .all<{
        territory_type: string;
        state: string | null;
        city: string | null;
        zip_prefix: string | null;
        zip_exact: string | null;
        segment: string | null;
        customer_type: string | null;
        is_exclusion: number;
      }>();

    const existingKeys = new Set(
      (existingRows.results || []).map((row) =>
        territoryRuleKey({
          territoryType: row.territory_type,
          state: row.state,
          city: row.city,
          zipPrefix: row.zip_prefix,
          zipExact: row.zip_exact,
          segment: row.segment,
          customerType: row.customer_type,
          isExclusion: row.is_exclusion
        })
      )
    );

    const newRows = rows.filter((row) => {
      const key = territoryRuleKey({
        territoryType: body.territoryType,
        state: row.state,
        city: row.city,
        zipPrefix: row.zipPrefix,
        zipExact: row.zipExact,
        segment: body.segment ?? null,
        customerType: body.customerType ?? null,
        isExclusion: row.isExclusion
      });
      if (existingKeys.has(key)) return false;
      existingKeys.add(key);
      return true;
    });

    if (newRows.length === 0) {
      return json({ created: 0, skipped: rows.length }, 200);
    }

    const insert = env.CRM_DB.prepare(
      `INSERT INTO rep_territories (rep_id, territory_type, state, city, zip_prefix, zip_exact, segment, customer_type, is_exclusion)
       VALUES (?1, ?2, ?3, ?4, ?5, ?6, ?7, ?8, ?9)`
    );
    const statements = newRows.map((row) =>
      insert.bind(
        body.repId,
        body.territoryType,
        row.state ?? null,
        row.city ?? null,
        row.zipPrefix ?? null,
        row.zipExact ?? null,
        body.segment ?? null,
        body.customerType ?? null,
        row.isExclusion ? 1 : 0
      )
    );
    await env.CRM_DB.batch(statements);
    await audit(env, user, 'create', 'rep_territory', String(body.repId), {
      ...body,
      createdRows: newRows.length,
      skippedRows: rows.length - newRows.length
    });
    return json({ created: newRows.length, skipped: rows.length - newRows.length }, 201);
  }) as any
);

addRoute(
  'POST',
  /^\/api\/rep-territories\/sync$/,
  withAuth(async (request, env, user) => {
    if (!canManageReps(user.role)) return err('Forbidden', 403);
    const body = await parseJson<{
      repId: number;
      segments: string[];
      customerTypes: string[];
      states?: string[];
      zipCodes?: string[] | string;
      clearAll?: boolean;
      replaceScope?: boolean;
      allowConflicts?: boolean;
    }>(request);
    if (!body?.repId) return err('repId is required');
    if (body.clearAll) {
      const deleteResult = await env.CRM_DB.prepare(`DELETE FROM rep_territories WHERE rep_id = ?1`).bind(body.repId).run();
      const removed = Number(deleteResult.meta.changes || 0);
      await audit(env, user, 'sync', 'rep_territory', String(body.repId), {
        clearAll: true,
        removedRows: removed
      });
      return json({ created: 0, removed, combos: 0, cleared: true });
    }
    const segments = uniqueTrimmed(Array.isArray(body.segments) ? body.segments : []);
    const customerTypes = uniqueTrimmed(Array.isArray(body.customerTypes) ? body.customerTypes : []);
    if (segments.length === 0 || customerTypes.length === 0) {
      return err('At least one segment and one type are required');
    }
    for (const segment of segments) {
      const metadataError = await ensureSegmentAndTypeExist(env, segment, null);
      if (metadataError) return err(metadataError);
    }
    for (const customerType of customerTypes) {
      const metadataError = await ensureSegmentAndTypeExist(env, null, customerType);
      if (metadataError) return err(metadataError);
    }

    const states = uniqueTrimmed(Array.isArray(body.states) ? body.states : []).map((state) => state.toUpperCase());
    const zipTokens = [...parseZipEntries(body.zipCodes)];
    const zipRows: Array<{ territoryType: 'zip_prefix' | 'zip_exact'; zipPrefix: string | null; zipExact: string | null; isExclusion: boolean }> = [];
    for (const token of zipTokens) {
      const digits = token.value.replace(/\D/g, '');
      if (![3, 5].includes(digits.length)) {
        return err(`Invalid zip token: ${token.isExclusion ? '-' : ''}${token.value}. Use 3 digits (ZIP3) or 5 digits (ZIP).`);
      }
      zipRows.push({
        territoryType: digits.length === 5 ? 'zip_exact' : 'zip_prefix',
        zipPrefix: digits.length === 5 ? null : digits,
        zipExact: digits.length === 5 ? digits : null,
        isExclusion: token.isExclusion
      });
    }

    const combos: Array<{ segment: string; customerType: string }> = [];
    for (const segment of segments) {
      for (const customerType of customerTypes) {
        combos.push({ segment, customerType });
      }
    }
    if (combos.length === 0) return err('No segment/type combinations selected');

    const includeRules: Array<
      | { territoryType: 'state'; state: string; segment: string; customerType: string }
      | { territoryType: 'zip_exact'; zipExact: string; segment: string; customerType: string }
      | { territoryType: 'zip_prefix'; zipPrefix: string; segment: string; customerType: string }
    > = [];
    for (const combo of combos) {
      for (const state of states) {
        includeRules.push({ territoryType: 'state', state, segment: combo.segment, customerType: combo.customerType });
      }
      for (const zipRow of zipRows) {
        if (zipRow.isExclusion) continue;
        if (zipRow.territoryType === 'zip_exact' && zipRow.zipExact) {
          includeRules.push({
            territoryType: 'zip_exact',
            zipExact: zipRow.zipExact,
            segment: combo.segment,
            customerType: combo.customerType
          });
        }
        if (zipRow.territoryType === 'zip_prefix' && zipRow.zipPrefix) {
          includeRules.push({
            territoryType: 'zip_prefix',
            zipPrefix: zipRow.zipPrefix,
            segment: combo.segment,
            customerType: combo.customerType
          });
        }
      }
    }

    const conflictMap = new Map<
      string,
      {
        repId: number;
        repName: string;
        territoryType: string;
        state: string | null;
        zipPrefix: string | null;
        zipExact: string | null;
        segment: string;
        customerType: string;
      }
    >();
    const addConflictRows = (
      rows: Array<{
        rep_id: number;
        rep_name: string;
        territory_type: string;
        state: string | null;
        zip_prefix: string | null;
        zip_exact: string | null;
        segment: string;
        customer_type: string;
      }>
    ) => {
      for (const row of rows || []) {
        const key = `${row.rep_id}|${row.territory_type}|${row.state || ''}|${row.zip_prefix || ''}|${row.zip_exact || ''}|${row.segment}|${row.customer_type}`;
        conflictMap.set(key, {
          repId: row.rep_id,
          repName: row.rep_name,
          territoryType: row.territory_type,
          state: row.state,
          zipPrefix: row.zip_prefix,
          zipExact: row.zip_exact,
          segment: row.segment,
          customerType: row.customer_type
        });
      }
    };
    for (const rule of includeRules) {
      if (rule.territoryType === 'state') {
        const stateRows = await env.CRM_DB.prepare(
          `SELECT t.rep_id, COALESCE(r.full_name, 'Rep #' || t.rep_id) AS rep_name, t.territory_type, t.state, t.zip_prefix, t.zip_exact,
                  t.segment, t.customer_type
           FROM rep_territories t
           LEFT JOIN reps r ON r.id = t.rep_id
           WHERE t.rep_id <> ?1
             AND t.is_exclusion = 0
             AND t.territory_type = 'state'
             AND t.segment = ?2
             AND t.customer_type = ?3
             AND upper(trim(coalesce(t.state, ''))) = upper(trim(?4))`
        )
          .bind(body.repId, rule.segment, rule.customerType, rule.state)
          .all<{
            rep_id: number;
            rep_name: string;
            territory_type: string;
            state: string | null;
            zip_prefix: string | null;
            zip_exact: string | null;
            segment: string;
            customer_type: string;
          }>();
        addConflictRows(stateRows.results || []);

        const zipRows = await env.CRM_DB.prepare(
          `SELECT t.rep_id, COALESCE(r.full_name, 'Rep #' || t.rep_id) AS rep_name, t.territory_type, t.state, t.zip_prefix, t.zip_exact,
                  t.segment, t.customer_type
           FROM rep_territories t
           LEFT JOIN reps r ON r.id = t.rep_id
           WHERE t.rep_id <> ?1
             AND t.is_exclusion = 0
             AND t.segment = ?2
             AND t.customer_type = ?3
             AND t.territory_type IN ('zip_exact', 'zip_prefix')`
        )
          .bind(body.repId, rule.segment, rule.customerType)
          .all<{
            rep_id: number;
            rep_name: string;
            territory_type: string;
            state: string | null;
            zip_prefix: string | null;
            zip_exact: string | null;
            segment: string;
            customer_type: string;
          }>();
        const overlaps = (zipRows.results || []).filter((row) =>
          zipTokenMayOverlapState(row.territory_type === 'zip_exact' ? row.zip_exact : row.zip_prefix, rule.state)
        );
        addConflictRows(overlaps);
      }
      if (rule.territoryType === 'zip_exact') {
        const zipRows = await env.CRM_DB.prepare(
          `SELECT t.rep_id, COALESCE(r.full_name, 'Rep #' || t.rep_id) AS rep_name, t.territory_type, t.state, t.zip_prefix, t.zip_exact,
                  t.segment, t.customer_type
           FROM rep_territories t
           LEFT JOIN reps r ON r.id = t.rep_id
           WHERE t.rep_id <> ?1
             AND t.is_exclusion = 0
             AND t.segment = ?2
             AND t.customer_type = ?3
             AND (
               (t.territory_type = 'zip_exact'
                 AND replace(replace(upper(trim(coalesce(t.zip_exact, ''))), '-', ''), ' ', '') =
                     replace(replace(upper(trim(?4)), '-', ''), ' ', ''))
               OR
               (t.territory_type = 'zip_prefix'
                 AND trim(coalesce(t.zip_prefix, '')) <> ''
                 AND replace(replace(upper(trim(?4)), '-', ''), ' ', '') LIKE
                     (replace(replace(upper(trim(coalesce(t.zip_prefix, ''))), '-', ''), ' ', '') || '%'))
             )`
        )
          .bind(body.repId, rule.segment, rule.customerType, rule.zipExact)
          .all<{
            rep_id: number;
            rep_name: string;
            territory_type: string;
            state: string | null;
            zip_prefix: string | null;
            zip_exact: string | null;
            segment: string;
            customer_type: string;
          }>();
        addConflictRows(zipRows.results || []);

        const stateRows = await env.CRM_DB.prepare(
          `SELECT t.rep_id, COALESCE(r.full_name, 'Rep #' || t.rep_id) AS rep_name, t.territory_type, t.state, t.zip_prefix, t.zip_exact,
                  t.segment, t.customer_type
           FROM rep_territories t
           LEFT JOIN reps r ON r.id = t.rep_id
           WHERE t.rep_id <> ?1
             AND t.is_exclusion = 0
             AND t.territory_type = 'state'
             AND t.segment = ?2
             AND t.customer_type = ?3`
        )
          .bind(body.repId, rule.segment, rule.customerType)
          .all<{
            rep_id: number;
            rep_name: string;
            territory_type: string;
            state: string | null;
            zip_prefix: string | null;
            zip_exact: string | null;
            segment: string;
            customer_type: string;
          }>();
        const overlaps = (stateRows.results || []).filter((row) => zipTokenMayOverlapState(rule.zipExact, row.state));
        addConflictRows(overlaps);
      }
      if (rule.territoryType === 'zip_prefix') {
        const zipRows = await env.CRM_DB.prepare(
          `SELECT t.rep_id, COALESCE(r.full_name, 'Rep #' || t.rep_id) AS rep_name, t.territory_type, t.state, t.zip_prefix, t.zip_exact,
                  t.segment, t.customer_type
           FROM rep_territories t
           LEFT JOIN reps r ON r.id = t.rep_id
           WHERE t.rep_id <> ?1
             AND t.is_exclusion = 0
             AND t.segment = ?2
             AND t.customer_type = ?3
             AND (
               (t.territory_type = 'zip_exact'
                 AND replace(replace(upper(trim(coalesce(t.zip_exact, ''))), '-', ''), ' ', '') LIKE
                     (replace(replace(upper(trim(?4)), '-', ''), ' ', '') || '%'))
               OR
               (t.territory_type = 'zip_prefix'
                 AND (
                   replace(replace(upper(trim(coalesce(t.zip_prefix, ''))), '-', ''), ' ', '') LIKE
                     (replace(replace(upper(trim(?4)), '-', ''), ' ', '') || '%')
                   OR
                   replace(replace(upper(trim(?4)), '-', ''), ' ', '') LIKE
                     (replace(replace(upper(trim(coalesce(t.zip_prefix, ''))), '-', ''), ' ', '') || '%')
                 ))
             )`
        )
          .bind(body.repId, rule.segment, rule.customerType, rule.zipPrefix)
          .all<{
            rep_id: number;
            rep_name: string;
            territory_type: string;
            state: string | null;
            zip_prefix: string | null;
            zip_exact: string | null;
            segment: string;
            customer_type: string;
          }>();
        addConflictRows(zipRows.results || []);

        const stateRows = await env.CRM_DB.prepare(
          `SELECT t.rep_id, COALESCE(r.full_name, 'Rep #' || t.rep_id) AS rep_name, t.territory_type, t.state, t.zip_prefix, t.zip_exact,
                  t.segment, t.customer_type
           FROM rep_territories t
           LEFT JOIN reps r ON r.id = t.rep_id
           WHERE t.rep_id <> ?1
             AND t.is_exclusion = 0
             AND t.territory_type = 'state'
             AND t.segment = ?2
             AND t.customer_type = ?3`
        )
          .bind(body.repId, rule.segment, rule.customerType)
          .all<{
            rep_id: number;
            rep_name: string;
            territory_type: string;
            state: string | null;
            zip_prefix: string | null;
            zip_exact: string | null;
            segment: string;
            customer_type: string;
          }>();
        const overlaps = (stateRows.results || []).filter((row) => zipTokenMayOverlapState(rule.zipPrefix, row.state));
        addConflictRows(overlaps);
      }
    }

    if (conflictMap.size > 0 && !body.allowConflicts) {
      return json(
        {
          error: 'Territory conflicts found with existing assignments.',
          conflicts: Array.from(conflictMap.values())
        },
        409
      );
    }

    const replaceScope = body.replaceScope !== false;
    let removed = 0;
    if (replaceScope) {
      const result = await env.CRM_DB.prepare(
        `DELETE FROM rep_territories
         WHERE rep_id = ?1
           AND territory_type IN ('state', 'zip_prefix', 'zip_exact')`
      )
        .bind(body.repId)
        .run();
      removed = Number(result.meta.changes || 0);
    }

    const existingRows = await env.CRM_DB.prepare(
      `SELECT territory_type, state, city, zip_prefix, zip_exact, segment, customer_type, is_exclusion
       FROM rep_territories
       WHERE rep_id = ?1`
    )
      .bind(body.repId)
      .all<{
        territory_type: string;
        state: string | null;
        city: string | null;
        zip_prefix: string | null;
        zip_exact: string | null;
        segment: string | null;
        customer_type: string | null;
        is_exclusion: number;
      }>();
    const existingKeys = new Set(
      (existingRows.results || []).map((row) =>
        territoryRuleKey({
          territoryType: row.territory_type,
          state: row.state,
          city: row.city,
          zipPrefix: row.zip_prefix,
          zipExact: row.zip_exact,
          segment: row.segment,
          customerType: row.customer_type,
          isExclusion: row.is_exclusion
        })
      )
    );

    const newRows: Array<{
      territoryType: 'state' | 'zip_prefix' | 'zip_exact';
      state?: string | null;
      zipPrefix?: string | null;
      zipExact?: string | null;
      segment: string;
      customerType: string;
      isExclusion: boolean;
    }> = [];
    for (const combo of combos) {
      for (const state of states) {
        const key = territoryRuleKey({
          territoryType: 'state',
          state,
          segment: combo.segment,
          customerType: combo.customerType,
          isExclusion: false
        });
        if (existingKeys.has(key)) continue;
        existingKeys.add(key);
        newRows.push({
          territoryType: 'state',
          state,
          segment: combo.segment,
          customerType: combo.customerType,
          isExclusion: false
        });
      }
      for (const zipRow of zipRows) {
        const key = territoryRuleKey({
          territoryType: zipRow.territoryType,
          zipPrefix: zipRow.zipPrefix,
          zipExact: zipRow.zipExact,
          segment: combo.segment,
          customerType: combo.customerType,
          isExclusion: zipRow.isExclusion
        });
        if (existingKeys.has(key)) continue;
        existingKeys.add(key);
        newRows.push({
          territoryType: zipRow.territoryType as 'zip_prefix' | 'zip_exact',
          zipPrefix: zipRow.zipPrefix,
          zipExact: zipRow.zipExact,
          segment: combo.segment,
          customerType: combo.customerType,
          isExclusion: zipRow.isExclusion
        });
      }
    }

    if (newRows.length > 0) {
      const insert = env.CRM_DB.prepare(
        `INSERT INTO rep_territories (rep_id, territory_type, state, city, zip_prefix, zip_exact, segment, customer_type, is_exclusion)
         VALUES (?1, ?2, ?3, NULL, ?4, ?5, ?6, ?7, ?8)`
      );
      await env.CRM_DB.batch(
        newRows.map((row) =>
          insert.bind(
            body.repId,
            row.territoryType,
            row.state ?? null,
            row.zipPrefix ?? null,
            row.zipExact ?? null,
            row.segment,
            row.customerType,
            row.isExclusion ? 1 : 0
          )
        )
      );
    }

    await audit(env, user, 'sync', 'rep_territory', String(body.repId), {
      segments,
      customerTypes,
      states,
      zipCodes: body.zipCodes,
      replaceScope,
      createdRows: newRows.length,
      removedRows: removed
    });
    return json({ created: newRows.length, removed, combos: combos.length });
  }) as any
);

addRoute(
  'DELETE',
  /^\/api\/rep-territories\/(\d+)$/,
  withAuth(async (request, env, user) => {
    if (!canManageReps(user.role)) return err('Forbidden', 403);
    const match = request.url.match(/\/api\/rep-territories\/(\d+)$/);
    const territoryId = Number(match?.[1]);
    if (!territoryId) return err('territory id is required');
    await env.CRM_DB.prepare(`DELETE FROM rep_territories WHERE id = ?1`).bind(territoryId).run();
    await audit(env, user, 'delete', 'rep_territory', String(territoryId));
    return json({ success: true });
  }) as any
);

addRoute(
  'GET',
  /^\/api\/reps\/suggest$/,
  withAuth(async (_request, env, _user, url) => {
    const city = normalizedText(url.searchParams.get('city'));
    const state = normalizedText(url.searchParams.get('state')).toUpperCase();
    const zip = normalizeZip(url.searchParams.get('zip') || '');
    const segment = normalizedText(url.searchParams.get('segment'));
    const customerType = normalizedText(url.searchParams.get('customerType'));
    const repIds = await suggestedRepIdsForCompany(env, { city, state, zip, segment, customerType });
    if (repIds.length === 0) return json({ suggestedReps: [] });
    const placeholders = repIds.map((_id, index) => `?${index + 1}`).join(', ');
    const reps = await env.CRM_DB.prepare(
      `SELECT id, full_name
       FROM reps
       WHERE deleted_at IS NULL AND id IN (${placeholders})
       ORDER BY full_name ASC`
    )
      .bind(...repIds)
      .all();
    return json({ suggestedReps: reps.results });
  }) as any
);

addRoute(
  'PUT',
  /^\/api\/companies\/(\d+)$/,
  withWriteAccess(async (request, env, user) => {
    const match = request.url.match(/\/api\/companies\/(\d+)$/);
    const companyId = Number(match?.[1]);
    const body = await parseJson<{
      name: string;
      address?: string;
      city?: string;
      state?: string;
      country?: string;
      zip?: string;
      mainPhone?: string;
      url?: string;
      segment?: string;
      customerType?: string;
      notes?: string;
    }>(request);
    if (!companyId || !body?.name) return err('company id and name are required');
    const repAccessError = await ensureRepCanAccessCompany(env, user, companyId);
    if (repAccessError) return repAccessError;
    const metadataError = await ensureSegmentAndTypeExist(env, body.segment, body.customerType);
    if (metadataError) return err(metadataError);

    await env.CRM_DB.prepare(
      `UPDATE companies
       SET name = ?1, address = ?2, city = ?3, state = ?4, country = ?5, zip = ?6, main_phone = ?7, url = ?8,
           segment = ?9, customer_type = ?10, notes = ?11, updated_at = CURRENT_TIMESTAMP
       WHERE id = ?12 AND deleted_at IS NULL`
    )
      .bind(
        body.name,
        body.address ?? null,
        body.city ?? null,
        body.state ?? null,
        body.country ?? 'US',
        body.zip ?? null,
        body.mainPhone ?? null,
        body.url ?? null,
        body.segment ?? null,
        body.customerType ?? null,
        body.notes ?? null,
        companyId
      )
      .run();

    await audit(env, user, 'update', 'company', String(companyId), body);
    return json({ success: true });
  }) as any
);

addRoute(
  'DELETE',
  /^\/api\/companies\/(\d+)$/,
  withAuth(async (request, env, user) => {
    if (!canManageReps(user.role)) return err('Forbidden', 403);
    const match = request.url.match(/\/api\/companies\/(\d+)$/);
    const companyId = Number(match?.[1]);
    if (!companyId) return err('company id is required');
    const repAccessError = await ensureRepCanAccessCompany(env, user, companyId);
    if (repAccessError) return repAccessError;
    const deletedAttachmentCount = await deleteAttachmentsForEntity(env, 'company', companyId);
    await env.CRM_DB.prepare(`UPDATE companies SET deleted_at = CURRENT_TIMESTAMP, updated_at = CURRENT_TIMESTAMP WHERE id = ?1`).bind(companyId).run();
    await audit(env, user, 'delete', 'company', String(companyId), { deletedAttachmentCount });
    return json({ success: true });
  }) as any
);

addRoute(
  'PUT',
  /^\/api\/customers\/(\d+)$/,
  withWriteAccess(async (request, env, user) => {
    const match = request.url.match(/\/api\/customers\/(\d+)$/);
    const customerId = Number(match?.[1]);
    const body = await parseJson<{
      companyId: number;
      firstName: string;
      lastName: string;
      email?: string;
      phone?: string;
      otherPhone?: string;
      notes?: string;
      photoKey?: string;
    }>(request);
    if (!customerId || !body?.companyId || !body.firstName || !body.lastName) {
      return err('customer id, companyId, firstName, and lastName are required');
    }
    const repAccessError = await ensureRepCanAccessCustomer(env, user, customerId);
    if (repAccessError) return repAccessError;
    const repTargetAccessError = await ensureRepCanAccessCompany(env, user, body.companyId);
    if (repTargetAccessError) return repTargetAccessError;

    await env.CRM_DB.prepare(
      `UPDATE customers
       SET company_id = ?1, first_name = ?2, last_name = ?3, email = ?4, phone = ?5, other_phone = ?6, notes = ?7, photo_key = ?8, updated_at = CURRENT_TIMESTAMP
       WHERE id = ?9 AND deleted_at IS NULL`
    )
      .bind(
        body.companyId,
        body.firstName,
        body.lastName,
        body.email ?? null,
        body.phone ?? null,
        body.otherPhone ?? null,
        body.notes ?? null,
        body.photoKey ?? null,
        customerId
      )
      .run();

    await audit(env, user, 'update', 'customer', String(customerId), body);
    return json({ success: true });
  }) as any
);

addRoute(
  'DELETE',
  /^\/api\/customers\/(\d+)$/,
  withWriteAccess(async (request, env, user) => {
    const match = request.url.match(/\/api\/customers\/(\d+)$/);
    const customerId = Number(match?.[1]);
    if (!customerId) return err('customer id is required');
    const repAccessError = await ensureRepCanAccessCustomer(env, user, customerId);
    if (repAccessError) return repAccessError;
    const deletedAttachmentCount = await deleteAttachmentsForEntity(env, 'customer', customerId);
    await env.CRM_DB.prepare(`UPDATE customers SET deleted_at = CURRENT_TIMESTAMP, updated_at = CURRENT_TIMESTAMP WHERE id = ?1`).bind(customerId).run();
    await audit(env, user, 'delete', 'customer', String(customerId), { deletedAttachmentCount });
    return json({ success: true });
  }) as any
);

addRoute(
  'PUT',
  /^\/api\/reps\/(\d+)$/,
  withAuth(async (request, env, user) => {
    if (!canManageReps(user.role)) return err('Forbidden', 403);
    const match = request.url.match(/\/api\/reps\/(\d+)$/);
    const repId = Number(match?.[1]);
    const body = await parseJson<{
      fullName: string;
      companyName?: string;
      isIndependent?: boolean;
      email?: string;
      phone?: string;
      segment?: string;
      customerType?: string;
    }>(request);
    if (!repId || !body?.fullName) return err('rep id and fullName are required');

    await env.CRM_DB.prepare(
      `UPDATE reps
       SET full_name = ?1, company_name = ?2, is_independent = ?3, email = ?4, phone = ?5, segment = ?6, customer_type = ?7, updated_at = CURRENT_TIMESTAMP
       WHERE id = ?8 AND deleted_at IS NULL`
    )
      .bind(
        body.fullName,
        body.companyName ?? null,
        body.isIndependent ? 1 : 0,
        body.email ?? null,
        body.phone ?? null,
        body.segment ?? null,
        body.customerType ?? null,
        repId
      )
      .run();

    await audit(env, user, 'update', 'rep', String(repId), body);
    return json({ success: true });
  }) as any
);

addRoute(
  'DELETE',
  /^\/api\/reps\/(\d+)$/,
  withAuth(async (request, env, user) => {
    if (!canManageReps(user.role)) return err('Forbidden', 403);
    const match = request.url.match(/\/api\/reps\/(\d+)$/);
    const repId = Number(match?.[1]);
    if (!repId) return err('rep id is required');
    await env.CRM_DB.prepare(`UPDATE reps SET deleted_at = CURRENT_TIMESTAMP, updated_at = CURRENT_TIMESTAMP WHERE id = ?1`).bind(repId).run();
    await audit(env, user, 'delete', 'rep', String(repId));
    return json({ success: true });
  }) as any
);

addRoute(
  'PUT',
  /^\/api\/interactions\/(\d+)$/,
  withWriteAccess(async (request, env, user) => {
    const match = request.url.match(/\/api\/interactions\/(\d+)$/);
    const interactionId = Number(match?.[1]);
    const body = await parseJson<{
      companyId: number;
      customerId?: number;
      repId?: number;
      interactionType?: string;
      meetingNotes: string;
      interactionAt?: string;
      nextAction?: string;
      nextActionAt?: string;
    }>(request);
    if (!interactionId || !body?.companyId || !body.meetingNotes) {
      return err('interaction id, companyId, and meetingNotes are required');
    }
    const repAccessError = await ensureRepCanAccessInteraction(env, user, interactionId);
    if (repAccessError) return repAccessError;
    const repTargetAccessError = await ensureRepCanAccessCompany(env, user, body.companyId);
    if (repTargetAccessError) return repTargetAccessError;

    await env.CRM_DB.prepare(
      `UPDATE interactions
       SET company_id = ?1, customer_id = ?2, rep_id = ?3, interaction_type = ?4, meeting_notes = ?5, interaction_at = ?6, next_action = ?7, next_action_at = ?8, updated_at = CURRENT_TIMESTAMP
       WHERE id = ?9 AND deleted_at IS NULL`
    )
      .bind(
        body.companyId,
        body.customerId ?? null,
        body.repId ?? null,
        body.interactionType ?? null,
        body.meetingNotes,
        body.interactionAt ?? null,
        body.nextAction ?? null,
        body.nextActionAt ?? null,
        interactionId
      )
      .run();

    await audit(env, user, 'update', 'interaction', String(interactionId), body);
    return json({ success: true });
  }) as any
);

addRoute(
  'DELETE',
  /^\/api\/interactions\/(\d+)$/,
  withWriteAccess(async (request, env, user) => {
    const match = request.url.match(/\/api\/interactions\/(\d+)$/);
    const interactionId = Number(match?.[1]);
    if (!interactionId) return err('interaction id is required');
    const repAccessError = await ensureRepCanAccessInteraction(env, user, interactionId);
    if (repAccessError) return repAccessError;
    const deletedAttachmentCount = await deleteAttachmentsForEntity(env, 'interaction', interactionId);
    await env.CRM_DB.prepare(`UPDATE interactions SET deleted_at = CURRENT_TIMESTAMP, updated_at = CURRENT_TIMESTAMP WHERE id = ?1`).bind(interactionId).run();
    await audit(env, user, 'delete', 'interaction', String(interactionId), { deletedAttachmentCount });
    return json({ success: true });
  }) as any
);

addRoute(
  'PATCH',
  /^\/api\/users\/(\d+)$/,
  withAuth(async (request, env, user) => {
    if (!canManageUsers(user.role)) return err('Forbidden', 403);
    const match = request.url.match(/\/api\/users\/(\d+)$/);
    const userId = Number(match?.[1]);
    const body = await parseJson<{ role?: UserRole; isActive?: boolean; fullName?: string; email?: string }>(request);
    if (!userId) return err('user id is required');
    if (!body || (body.role === undefined && body.isActive === undefined && body.fullName === undefined && body.email === undefined)) {
      return err('No changes provided');
    }
    if (body.role && !['admin', 'manager', 'rep', 'viewer'].includes(body.role)) return err('Invalid role');

    const current = await env.CRM_DB.prepare(`SELECT id, role, is_active, full_name, email FROM users WHERE id = ?1`)
      .bind(userId)
      .first<{ id: number; role: UserRole; is_active: number; full_name: string; email: string }>();
    if (!current) return err('User not found', 404);

    const nextRole = body.role ?? current.role;
    const nextIsActive = body.isActive === undefined ? current.is_active : body.isActive ? 1 : 0;
    const nextEmail = body.email?.toLowerCase().trim() || current.email;
    const nextFullName = body.fullName?.trim() || current.full_name;

    if (nextEmail !== current.email) {
      const existing = await env.CRM_DB.prepare(`SELECT id FROM users WHERE email = ?1 AND id <> ?2`)
        .bind(nextEmail, userId)
        .first();
      if (existing) return err('Email already in use', 409);
    }

    if (current.role === 'admin' && current.is_active === 1 && (nextRole !== 'admin' || nextIsActive !== 1)) {
      const admins = await env.CRM_DB.prepare(
        `SELECT COUNT(*) AS c FROM users WHERE role = 'admin' AND is_active = 1 AND id <> ?1`
      )
        .bind(userId)
        .first<{ c: number }>();
      if (!admins || admins.c < 1) return err('At least one active admin must remain', 409);
    }

    await env.CRM_DB.prepare(
      `UPDATE users
       SET role = ?1, is_active = ?2, full_name = ?3, email = ?4, updated_at = CURRENT_TIMESTAMP
       WHERE id = ?5`
    )
      .bind(nextRole, nextIsActive, nextFullName, nextEmail, userId)
      .run();

    const repId = await syncRepRecordForUser(env, {
      currentEmail: current.email,
      nextEmail,
      nextFullName,
      nextRole,
      nextIsActive: nextIsActive === 1
    });

    await audit(env, user, 'update', 'user', String(userId), { ...body, repId });
    return json({ success: true });
  }) as any
);

addRoute(
  'DELETE',
  /^\/api\/users\/(\d+)$/,
  withAuth(async (request, env, user) => {
    if (!canManageUsers(user.role)) return err('Forbidden', 403);
    const match = request.url.match(/\/api\/users\/(\d+)$/);
    const userId = Number(match?.[1]);
    if (!userId) return err('user id is required');
    if (userId === user.id) return err('You cannot delete your own account', 409);

    const current = await env.CRM_DB.prepare(`SELECT id, role, is_active, email FROM users WHERE id = ?1`)
      .bind(userId)
      .first<{ id: number; role: UserRole; is_active: number; email: string }>();
    if (!current) return err('User not found', 404);

    if (current.role === 'admin' && current.is_active === 1) {
      const admins = await env.CRM_DB.prepare(
        `SELECT COUNT(*) AS c FROM users WHERE role = 'admin' AND is_active = 1 AND id <> ?1`
      )
        .bind(userId)
        .first<{ c: number }>();
      if (!admins || admins.c < 1) return err('At least one active admin must remain', 409);
    }

    await env.CRM_DB.batch([
      env.CRM_DB.prepare(`UPDATE users SET is_active = 0, updated_at = CURRENT_TIMESTAMP WHERE id = ?1`).bind(userId),
      env.CRM_DB.prepare(`DELETE FROM sessions WHERE user_id = ?1`).bind(userId)
    ]);
    await syncRepRecordForUser(env, {
      currentEmail: current.email,
      nextEmail: current.email,
      nextFullName: '',
      nextRole: current.role,
      nextIsActive: false
    });
    await audit(env, user, 'delete', 'user', String(userId));
    return json({ success: true });
  }) as any
);

addRoute(
  'POST',
  /^\/api\/users\/(\d+)\/resend-invite$/,
  withAuth(async (request, env, user) => {
    if (!canManageUsers(user.role)) return err('Forbidden', 403);
    const match = request.url.match(/\/api\/users\/(\d+)\/resend-invite$/);
    const userId = Number(match?.[1]);
    if (!userId) return err('user id is required');

    const target = await env.CRM_DB.prepare(`SELECT id, email, full_name FROM users WHERE id = ?1`)
      .bind(userId)
      .first<{ id: number; email: string; full_name: string }>();
    if (!target) return err('User not found', 404);

    const pwd = await hashPassword(randomPassword(12));
    const inviteToken = randomToken(24);
    const inviteExpiresAt = isoAfterHours(24 * 7);

    await env.CRM_DB.batch([
      env.CRM_DB.prepare(
        `UPDATE users
         SET password_hash = ?1, password_salt = ?2, is_active = 1, updated_at = CURRENT_TIMESTAMP
         WHERE id = ?3`
      ).bind(pwd.hash, pwd.salt, userId),
      env.CRM_DB.prepare(`DELETE FROM sessions WHERE user_id = ?1`).bind(userId),
      env.CRM_DB.prepare(
        `INSERT INTO user_invites (token, user_id, expires_at, created_by_user_id)
         VALUES (?1, ?2, ?3, ?4)`
      ).bind(inviteToken, userId, inviteExpiresAt, user.id)
    ]);

    let emailSent = true;
    let emailError: string | null = null;
    try {
      await sendEmail(env, {
        to: target.email,
        ...buildInviteEmail(env, user.full_name, target.full_name, target.email, inviteToken)
      });
    } catch (error) {
      emailSent = false;
      emailError = error instanceof Error ? error.message : 'Unable to send invitation email';
    }
    await audit(env, user, 'resend_invite', 'user', String(userId), { email: target.email, emailSent, emailError });
    return json({ inviteExpiresAt, email: target.email, fullName: target.full_name, emailSent, emailError });
  }) as any
);

addRoute(
  'GET',
  /^\/api\/audit-log$/,
  withAuth(async (_request, env, user, url) => {
    if (!canManageReps(user.role)) return err('Forbidden', 403);
    const days = Math.max(1, Number(url.searchParams.get('days') || 14));
    const limit = Math.min(200, Math.max(1, Number(url.searchParams.get('limit') || 50)));
    const sinceIso = new Date(Date.now() - days * 86400000).toISOString();
    const rows = await env.CRM_DB.prepare(
      `SELECT
         a.id,
         a.created_at,
         a.action,
         a.entity_type,
         a.entity_id,
         a.details_json,
         u.full_name AS actor_name,
         u.email AS actor_email
       FROM audit_log a
       LEFT JOIN users u ON u.id = a.actor_user_id
       WHERE a.created_at >= ?1
       ORDER BY a.created_at DESC
       LIMIT ?2`
    )
      .bind(sinceIso, limit)
      .all();
    return json({ days, limit, entries: rows.results });
  }) as any
);

addRoute(
  'GET',
  /^\/api\/reports\/rep-activity$/,
  withAuth(async (_request, env, user, url) => {
    if (!canWrite(user.role)) return err('Forbidden', 403);
    const days = Number(url.searchParams.get('days') || 30);
    const sinceIso = new Date(Date.now() - Math.max(days, 1) * 86400000).toISOString();
    const binds: unknown[] = [sinceIso];
    let sql =
      `SELECT
         COALESCE(r.full_name, 'Unassigned') AS rep_name,
         COUNT(i.id) AS interaction_count,
         MAX(i.created_at) AS last_interaction_at
       FROM interactions i
       JOIN companies c ON c.id = i.company_id
       LEFT JOIN reps r ON r.id = i.rep_id
       WHERE i.deleted_at IS NULL
         AND c.deleted_at IS NULL
         AND i.created_at >= ?1`;
    if (user.role === 'rep') {
      sql += ` AND i.created_by_user_id = ?2 AND ${repTerritoryCompanyScopeClause('c', 3)}`;
      binds.push(user.id, user.email);
    }
    sql += ` GROUP BY rep_name ORDER BY interaction_count DESC, rep_name ASC`;
    const rows = await env.CRM_DB.prepare(sql).bind(...binds).all();
    return json({ days, repActivity: rows.results });
  }) as any
);

addRoute(
  'GET',
  /^\/api\/reports\/(weekly-activity|activity)$/,
  withAuth(async (_request, env, user, url) => {
    if (!canWrite(user.role)) return err('Forbidden', 403);
    const startDateRaw = normalizedText(url.searchParams.get('startDate'));
    const endDateRaw = normalizedText(url.searchParams.get('endDate'));
    const segment = normalizedText(url.searchParams.get('segment'));
    const customerType = normalizedText(url.searchParams.get('customerType'));
    const repIdFilter = Number(url.searchParams.get('repId') || 0);
    const isoDate = (d: Date): string => d.toISOString().slice(0, 10);
    const parseYmd = (value: string): Date | null => {
      if (!/^\d{4}-\d{2}-\d{2}$/.test(value)) return null;
      const parsed = new Date(`${value}T12:00:00.000Z`);
      if (Number.isNaN(parsed.getTime())) return null;
      return new Date(Date.UTC(parsed.getUTCFullYear(), parsed.getUTCMonth(), parsed.getUTCDate()));
    };
    const fallbackEnd = new Date();
    const fallbackStart = new Date(fallbackEnd);
    fallbackStart.setUTCDate(fallbackEnd.getUTCDate() - 7);
    const startDate = startDateRaw ? parseYmd(startDateRaw) : fallbackStart;
    const endDate = endDateRaw ? parseYmd(endDateRaw) : fallbackEnd;
    if (!startDate) return err('Invalid startDate');
    if (!endDate) return err('Invalid endDate');
    const startIso = isoDate(startDate);
    const endIso = isoDate(endDate);
    if (startIso > endIso) return err('startDate must be on or before endDate');

    let reps: Array<{ id: number; full_name: string; email: string | null }> = [];
    if (user.role === 'rep') {
      reps = (
        await env.CRM_DB.prepare(
          `SELECT id, full_name, email
           FROM reps
           WHERE deleted_at IS NULL
             AND email IS NOT NULL
             AND lower(email) = lower(?1)
           ORDER BY full_name ASC`
        )
          .bind(user.email)
          .all<{ id: number; full_name: string; email: string | null }>()
      ).results || [];
    } else {
      const binds: unknown[] = [];
      let sql = `SELECT id, full_name, email FROM reps WHERE deleted_at IS NULL`;
      if (repIdFilter > 0) {
        sql += ` AND id = ?${binds.length + 1}`;
        binds.push(repIdFilter);
      }
      sql += ` ORDER BY full_name ASC`;
      reps = (await env.CRM_DB.prepare(sql).bind(...binds).all<{ id: number; full_name: string; email: string | null }>()).results || [];
    }

    const reportReps: Array<{
      repId: number;
      repName: string;
      lastWeekInteractions: Array<{ date: string; companyName: string; contacts: string; notes: string }>;
      upcomingFollowUps: Array<{ date: string; companyName: string; contacts: string; nextAction: string }>;
    }> = [];

    for (const rep of reps) {
      if (!rep.email) continue;
      const baseFilters = `AND (?4 = '' OR c.segment = ?4) AND (?5 = '' OR c.customer_type = ?5)`;
      const territoryScope = repTerritoryCompanyScopeClauseForRepId('c', '?6');

      const lastWeek = await env.CRM_DB.prepare(
        `SELECT
           date(coalesce(i.interaction_at, i.created_at)) AS interaction_date,
           c.name AS company_name,
           COALESCE((
             SELECT GROUP_CONCAT(name, ', ')
             FROM (
               SELECT DISTINCT trim(coalesce(cu.first_name, '') || ' ' || coalesce(cu.last_name, '')) AS name
               FROM customers cu
               WHERE cu.company_id = c.id
                 AND cu.deleted_at IS NULL
                 AND trim(coalesce(cu.first_name, '') || ' ' || coalesce(cu.last_name, '')) <> ''
               ORDER BY name
             )
           ), '-') AS contacts,
           i.meeting_notes
         FROM interactions i
         JOIN companies c ON c.id = i.company_id
         JOIN users u ON u.id = i.created_by_user_id
         WHERE i.deleted_at IS NULL
           AND c.deleted_at IS NULL
           AND lower(u.email) = lower(?1)
           AND date(coalesce(i.interaction_at, i.created_at)) >= date(?2)
           AND date(coalesce(i.interaction_at, i.created_at)) <= date(?3)
           ${baseFilters}
           AND ${territoryScope}
         ORDER BY date(coalesce(i.interaction_at, i.created_at)) ASC, c.name ASC`
      )
        .bind(rep.email, startIso, endIso, segment, customerType, rep.id)
        .all<{
          interaction_date: string;
          company_name: string;
          contacts: string;
          meeting_notes: string | null;
        }>();

      const upcoming = await env.CRM_DB.prepare(
        `SELECT
           date(i.next_action_at) AS next_date,
           c.name AS company_name,
           COALESCE((
             SELECT GROUP_CONCAT(name, ', ')
             FROM (
               SELECT DISTINCT trim(coalesce(cu.first_name, '') || ' ' || coalesce(cu.last_name, '')) AS name
               FROM customers cu
               WHERE cu.company_id = c.id
                 AND cu.deleted_at IS NULL
                 AND trim(coalesce(cu.first_name, '') || ' ' || coalesce(cu.last_name, '')) <> ''
               ORDER BY name
             )
           ), '-') AS contacts,
           i.next_action
         FROM interactions i
         JOIN companies c ON c.id = i.company_id
         WHERE i.deleted_at IS NULL
           AND c.deleted_at IS NULL
           AND i.next_action_at IS NOT NULL
           AND date(i.next_action_at) >= date(?1)
           AND date(i.next_action_at) <= date(?2)
           AND (?3 = '' OR c.segment = ?3)
           AND (?4 = '' OR c.customer_type = ?4)
           AND ${repTerritoryCompanyScopeClauseForRepId('c', '?5')}
           AND date(i.next_action_at) = (
             SELECT MIN(date(ix.next_action_at))
             FROM interactions ix
             WHERE ix.company_id = c.id
               AND ix.deleted_at IS NULL
               AND ix.next_action_at IS NOT NULL
               AND date(ix.next_action_at) >= date(?1)
               AND date(ix.next_action_at) <= date(?2)
           )
         GROUP BY c.id, next_date
         ORDER BY next_date ASC, c.name ASC`
      )
        .bind(startIso, endIso, segment, customerType, rep.id)
        .all<{
          next_date: string;
          company_name: string;
          contacts: string;
          next_action: string | null;
        }>();

      reportReps.push({
        repId: rep.id,
        repName: rep.full_name,
        lastWeekInteractions: (lastWeek.results || []).map((row) => ({
          date: row.interaction_date,
          companyName: row.company_name,
          contacts: row.contacts,
          notes: row.meeting_notes || ''
        })),
        upcomingFollowUps: (upcoming.results || []).map((row) => ({
          date: row.next_date,
          companyName: row.company_name,
          contacts: row.contacts,
          nextAction: row.next_action || ''
        }))
      });
    }

    return json({
      // New shape
      startDate: startIso,
      endDate: endIso,
      // Backward compatibility for older Pages bundles still expecting weekly fields
      referenceFriday: endIso,
      previousWeek: { start: startIso, end: endIso },
      currentWeek: { start: startIso, end: endIso },
      reps: reportReps
    });
  }) as any
);

addRoute(
  'GET',
  /^\/api\/reports\/follow-ups$/,
  withAuth(async (_request, env, user, url) => {
    if (!canWrite(user.role)) return err('Forbidden', 403);
    const days = Number(url.searchParams.get('days') || 14);
    const now = new Date();
    const until = new Date(now.getTime() + Math.max(days, 1) * 86400000).toISOString();
    const binds: unknown[] = [now.toISOString(), until];
    let sql =
      `SELECT
         i.id,
         c.name AS company_name,
         (cu.first_name || ' ' || cu.last_name) AS customer_name,
         i.next_action,
         i.next_action_at,
         r.full_name AS rep_name
       FROM interactions i
       JOIN companies c ON c.id = i.company_id
       LEFT JOIN customers cu ON cu.id = i.customer_id
       LEFT JOIN reps r ON r.id = i.rep_id
       WHERE i.deleted_at IS NULL
         AND c.deleted_at IS NULL
         AND i.next_action_at IS NOT NULL
         AND i.next_action_at >= ?1
         AND i.next_action_at <= ?2`;
    if (user.role === 'rep') {
      sql += ` AND i.created_by_user_id = ?3 AND ${repTerritoryCompanyScopeClause('c', 4)}`;
      binds.push(user.id, user.email);
    }
    sql += ` ORDER BY i.next_action_at ASC`;
    const rows = await env.CRM_DB.prepare(sql).bind(...binds).all();
    return json({ days, followUps: rows.results });
  }) as any
);

addRoute(
  'GET',
  /^\/api\/reports\/company-engagement$/,
  withAuth(async (_request, env, user, url) => {
    if (!canWrite(user.role)) return err('Forbidden', 403);
    const days = Number(url.searchParams.get('days') || 90);
    const sinceIso = new Date(Date.now() - Math.max(days, 1) * 86400000).toISOString();
    const binds: unknown[] = [sinceIso];
    let sql =
      `SELECT
         c.id,
         c.name AS company_name,
         COUNT(i.id) AS interactions,
         MAX(coalesce(i.interaction_at, i.created_at)) AS last_interaction_at
       FROM companies c
       LEFT JOIN interactions i ON i.company_id = c.id AND i.deleted_at IS NULL AND coalesce(i.interaction_at, i.created_at) >= ?1
       WHERE c.deleted_at IS NULL`;
    if (user.role === 'rep') {
      sql += ` AND ${repTerritoryCompanyScopeClause('c', 2)}`;
      binds.push(user.email);
    }
    sql += ` GROUP BY c.id, c.name ORDER BY interactions DESC, c.name ASC`;
    const rows = await env.CRM_DB.prepare(sql).bind(...binds).all();
    return json({ days, companyEngagement: rows.results });
  }) as any
);

addRoute(
  'GET',
  /^\/api\/feedback$/,
  withAuth(async (_request, env, _user, url) => {
    const includeResolved = normalizedText(url.searchParams.get('includeResolved')) === '1';
    const dateFilter = normalizedText(url.searchParams.get('date'));
    const userId = Number(url.searchParams.get('userId') || 0);
    const whereParts = ['1 = 1'];
    const binds: unknown[] = [];
    if (!includeResolved) {
      whereParts.push(`f.is_resolved = 0`);
    }
    if (dateFilter) {
      whereParts.push(`date(f.feedback_at) = date(?${binds.length + 1})`);
      binds.push(dateFilter);
    }
    if (userId > 0) {
      whereParts.push(`f.user_id = ?${binds.length + 1}`);
      binds.push(userId);
    }

    const entries = await env.CRM_DB.prepare(
      `SELECT f.id, f.user_id, f.user_name, f.feedback_at, f.message, f.is_resolved, f.resolved_at, f.created_at
       FROM feedback_items f
       WHERE ${whereParts.join(' AND ')}
       ORDER BY datetime(f.feedback_at) DESC, f.id DESC`
    )
      .bind(...binds)
      .all();

    const users = await env.CRM_DB.prepare(
      `SELECT id, full_name
       FROM users
       WHERE is_active = 1
       ORDER BY full_name ASC`
    ).all();

    return json({ entries: entries.results, users: users.results });
  }) as any
);

addRoute(
  'POST',
  /^\/api\/feedback$/,
  withAuth(async (request, env, user) => {
    const body = await parseJson<{ feedbackAt?: string; message?: string; isResolved?: boolean }>(request);
    if (!body?.message?.trim()) return err('message is required');
    const feedbackAt = normalizedText(body.feedbackAt) || new Date().toISOString();
    const result = await env.CRM_DB.prepare(
      `INSERT INTO feedback_items (user_id, user_name, feedback_at, message, is_resolved, resolved_at)
       VALUES (?1, ?2, ?3, ?4, ?5, ?6)`
    )
      .bind(user.id, user.full_name, feedbackAt, body.message.trim(), body.isResolved ? 1 : 0, body.isResolved ? new Date().toISOString() : null)
      .run();
    await audit(env, user, 'create', 'feedback', String(result.meta.last_row_id), body);
    return json({ id: result.meta.last_row_id }, 201);
  }) as any
);

addRoute(
  'PATCH',
  /^\/api\/feedback\/(\d+)$/,
  withAuth(async (request, env, user) => {
    const match = request.url.match(/\/api\/feedback\/(\d+)$/);
    const feedbackId = Number(match?.[1]);
    if (!feedbackId) return err('feedback id is required');
    const body = await parseJson<{ isResolved?: boolean }>(request);
    if (typeof body?.isResolved !== 'boolean') return err('isResolved is required');
    await env.CRM_DB.prepare(
      `UPDATE feedback_items
       SET is_resolved = ?1, resolved_at = ?2, updated_at = CURRENT_TIMESTAMP
       WHERE id = ?3`
    )
      .bind(body.isResolved ? 1 : 0, body.isResolved ? new Date().toISOString() : null, feedbackId)
      .run();
    await audit(env, user, 'update', 'feedback', String(feedbackId), body);
    return json({ success: true });
  }) as any
);

export default {
  async fetch(request: Request, env: Env): Promise<Response> {
    try {
      const url = new URL(request.url);
      if (!url.pathname.startsWith('/api/')) return withCors(err('Not found', 404));
      if (
        request.method === 'POST' &&
        /^\/api\/auth\/(login|bootstrap|invite\/accept|password-reset\/request|password-reset\/confirm)$/.test(url.pathname) &&
        !checkAuthRateLimit(request)
      ) {
        return withCors(err('Too many requests. Please wait and try again.', 429));
      }

      if (request.method === 'OPTIONS') {
        return withCors(
          withSecurityHeaders(
          new Response(null, {
            status: 204,
            headers: {
              'access-control-allow-methods': 'GET,POST,PUT,DELETE,OPTIONS',
              'access-control-allow-headers': 'content-type,authorization'
            }
          })
        ));
      }

      for (const route of routes) {
        if (route.method !== request.method) continue;
        const match = url.pathname.match(route.match);
        if (!match) continue;
        const response = await route.handler(request, env, url, match);
        return withCors(withSecurityHeaders(response));
      }

      return withCors(err('Not found', 404));
    } catch (error) {
      const msg = error instanceof Error ? error.message : 'Unexpected error';
      return withCors(err(msg, 500));
    }
  }
};

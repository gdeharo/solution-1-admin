interface Env {
  CRM_DB: D1Database;
  CRM_FILES: R2Bucket;
  SESSION_TTL_HOURS: string;
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

const json = (data: unknown, status = 200): Response =>
  new Response(JSON.stringify(data), {
    status,
    headers: {
      'content-type': 'application/json; charset=utf-8',
      'cache-control': 'no-store'
    }
  });

const err = (message: string, status = 400): Response => json({ error: message }, status);

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

function normalizedText(value: string | null | undefined): string {
  return String(value || '').trim();
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
  withAuth(async (_request, env, user) => {
    const binds: unknown[] = [];
    let sql =
      `SELECT
         c.*, 
         (SELECT COUNT(*) FROM customers cu WHERE cu.company_id = c.id AND cu.deleted_at IS NULL) AS customer_count,
         (SELECT COUNT(*) FROM company_reps cr WHERE cr.company_id = c.id) AS rep_count
       FROM companies c
       WHERE c.deleted_at IS NULL`;
    if (user.role === 'rep') {
      sql += ` AND ${repTerritoryCompanyScopeClause('c', 1)}`;
      binds.push(user.email);
    }
    sql += ` ORDER BY c.name ASC`;
    const companies = binds.length ? await env.CRM_DB.prepare(sql).bind(...binds).all() : await env.CRM_DB.prepare(sql).all();
    return json({ companies: companies.results });
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
    if (Array.isArray(body.repIds) && body.repIds.length > 0) {
      for (const repId of body.repIds) {
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
  withWriteAccess(async (request, env, user, _url) => {
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
         (SELECT COUNT(*) FROM customers cu WHERE cu.company_id = c.id AND cu.deleted_at IS NULL) AS customer_count,
         (SELECT COUNT(*) FROM company_reps cr WHERE cr.company_id = c.id) AS rep_count
       FROM companies c
       WHERE c.id = ?1 AND c.deleted_at IS NULL`
    )
      .bind(companyId)
      .first();

    if (!company) return err('Company not found', 404);

    const reps = await env.CRM_DB.prepare(
      `SELECT r.id, r.full_name
       FROM company_reps cr
       JOIN reps r ON r.id = cr.rep_id
       WHERE cr.company_id = ?1 AND r.deleted_at IS NULL
       ORDER BY r.full_name ASC`
    )
      .bind(companyId)
      .all();

    return json({ company, assignedReps: reps.results });
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
  withWriteAccess(async (request, env, user) => {
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
  withWriteAccess(async (request, env, user) => {
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
    sql += ` ORDER BY i.created_at DESC`;

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
      nextAction?: string;
      nextActionAt?: string;
      attachmentKeys?: string[];
    }>(request);

    if (!body?.companyId || !body?.meetingNotes) return err('companyId and meetingNotes are required');
    const repAccessError = await ensureRepCanAccessCompany(env, user, body.companyId);
    if (repAccessError) return repAccessError;

    const result = await env.CRM_DB.prepare(
      `INSERT INTO interactions (company_id, customer_id, rep_id, interaction_type, meeting_notes, next_action, next_action_at, created_by_user_id)
       VALUES (?1, ?2, ?3, ?4, ?5, ?6, ?7, ?8)`
    )
      .bind(
        body.companyId,
        body.customerId ?? null,
        body.repId ?? null,
        body.interactionType ?? null,
        body.meetingNotes,
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

    const body = await parseJson<{ email: string; fullName: string; role: UserRole; password?: string }>(request);
    if (!body?.email || !body?.fullName || !body?.role) {
      return err('email, fullName, and role are required');
    }
    if (!['admin', 'manager', 'rep', 'viewer'].includes(body.role)) return err('Invalid role');

    const temporaryPassword = body.password?.trim() || randomPassword(12);
    const pwd = await hashPassword(temporaryPassword);
    const result = await env.CRM_DB.prepare(
      `INSERT INTO users (email, full_name, role, password_hash, password_salt)
       VALUES (?1, ?2, ?3, ?4, ?5)`
    )
      .bind(body.email.toLowerCase().trim(), body.fullName.trim(), body.role, pwd.hash, pwd.salt)
      .run();

    const inviteToken = randomToken(24);
    const inviteExpiresAt = isoAfterHours(24 * 7);
    await env.CRM_DB.prepare(
      `INSERT INTO user_invites (token, user_id, expires_at, created_by_user_id)
       VALUES (?1, ?2, ?3, ?4)`
    )
      .bind(inviteToken, result.meta.last_row_id, inviteExpiresAt, user.id)
      .run();

    await audit(env, user, 'create', 'user', String(result.meta.last_row_id), { email: body.email, role: body.role });
    return json(
      {
        id: result.meta.last_row_id,
        temporaryPassword,
        inviteToken,
        inviteExpiresAt
      },
      201
    );
  }) as any
);

addRoute(
  'GET',
  /^\/api\/company-reps$/,
  withAuth(async (_request, env) => {
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
  withAuth(async (_request, env) => {
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
        if (![1, 2, 3].includes(digits.length)) {
          return err(`Invalid zip prefix: ${item.isExclusion ? '-' : ''}${item.value}. Use 1-3 digits.`);
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
      replaceScope?: boolean;
    }>(request);
    if (!body?.repId) return err('repId is required');
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
      if (![1, 2, 3, 5].includes(digits.length)) {
        return err(`Invalid zip token: ${token.isExclusion ? '-' : ''}${token.value}. Use 1-3 digits prefix or 5 digits exact.`);
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

    const replaceScope = body.replaceScope !== false;
    let removed = 0;
    if (replaceScope) {
      for (const combo of combos) {
        const result = await env.CRM_DB.prepare(
          `DELETE FROM rep_territories
           WHERE rep_id = ?1
             AND segment = ?2
             AND customer_type = ?3
             AND territory_type IN ('state', 'zip_prefix', 'zip_exact')`
        )
          .bind(body.repId, combo.segment, combo.customerType)
          .run();
        removed += Number(result.meta.changes || 0);
      }
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
    const city = (url.searchParams.get('city') || '').trim();
    const state = (url.searchParams.get('state') || '').trim();
    const zip = normalizeZip(url.searchParams.get('zip') || '');
    const segment = (url.searchParams.get('segment') || '').trim();
    const customerType = (url.searchParams.get('customerType') || '').trim();

    if (!city && !state && !zip) return err('Provide city, state, or zip');

    const rows = await env.CRM_DB.prepare(
      `SELECT DISTINCT r.id, r.full_name
       FROM rep_territories t
       JOIN reps r ON r.id = t.rep_id
       WHERE r.deleted_at IS NULL
         AND t.is_exclusion = 0
         AND (
           (t.territory_type = 'state' AND t.state = ?1)
           OR (t.territory_type = 'city_state' AND t.state = ?1 AND t.city = ?2)
           OR (t.territory_type = 'zip_exact' AND t.zip_exact = ?3)
           OR (t.territory_type = 'zip_prefix' AND ?3 LIKE (t.zip_prefix || '%'))
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
               (tx.territory_type = 'zip_exact' AND tx.zip_exact = ?3)
               OR (tx.territory_type = 'zip_prefix' AND ?3 LIKE (tx.zip_prefix || '%'))
             )
             AND (tx.segment IS NULL OR tx.segment = ?4)
             AND (tx.customer_type IS NULL OR tx.customer_type = ?5)
         )
       ORDER BY r.full_name ASC`
    )
      .bind(state || null, city || null, zip || null, segment || null, customerType || null)
      .all();

    return json({ suggestedReps: rows.results });
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
  withWriteAccess(async (request, env, user) => {
    const match = request.url.match(/\/api\/companies\/(\d+)$/);
    const companyId = Number(match?.[1]);
    if (!companyId) return err('company id is required');
    const repAccessError = await ensureRepCanAccessCompany(env, user, companyId);
    if (repAccessError) return repAccessError;
    await env.CRM_DB.prepare(`UPDATE companies SET deleted_at = CURRENT_TIMESTAMP, updated_at = CURRENT_TIMESTAMP WHERE id = ?1`).bind(companyId).run();
    await audit(env, user, 'delete', 'company', String(companyId));
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
    await env.CRM_DB.prepare(`UPDATE customers SET deleted_at = CURRENT_TIMESTAMP, updated_at = CURRENT_TIMESTAMP WHERE id = ?1`).bind(customerId).run();
    await audit(env, user, 'delete', 'customer', String(customerId));
    return json({ success: true });
  }) as any
);

addRoute(
  'PUT',
  /^\/api\/reps\/(\d+)$/,
  withWriteAccess(async (request, env, user) => {
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
  withWriteAccess(async (request, env, user) => {
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
       SET company_id = ?1, customer_id = ?2, rep_id = ?3, interaction_type = ?4, meeting_notes = ?5, next_action = ?6, next_action_at = ?7, updated_at = CURRENT_TIMESTAMP
       WHERE id = ?8 AND deleted_at IS NULL`
    )
      .bind(
        body.companyId,
        body.customerId ?? null,
        body.repId ?? null,
        body.interactionType ?? null,
        body.meetingNotes,
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
    await env.CRM_DB.prepare(`UPDATE interactions SET deleted_at = CURRENT_TIMESTAMP, updated_at = CURRENT_TIMESTAMP WHERE id = ?1`).bind(interactionId).run();
    await audit(env, user, 'delete', 'interaction', String(interactionId));
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

    await audit(env, user, 'update', 'user', String(userId), body);
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

    const current = await env.CRM_DB.prepare(`SELECT id, role, is_active FROM users WHERE id = ?1`)
      .bind(userId)
      .first<{ id: number; role: UserRole; is_active: number }>();
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

    const temporaryPassword = randomPassword(12);
    const pwd = await hashPassword(temporaryPassword);
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

    await audit(env, user, 'resend_invite', 'user', String(userId), { email: target.email });
    return json({ temporaryPassword, inviteToken, inviteExpiresAt, email: target.email, fullName: target.full_name });
  }) as any
);

addRoute(
  'GET',
  /^\/api\/reports\/rep-activity$/,
  withAuth(async (_request, env, _user, url) => {
    const days = Number(url.searchParams.get('days') || 30);
    const sinceIso = new Date(Date.now() - Math.max(days, 1) * 86400000).toISOString();
    const rows = await env.CRM_DB.prepare(
      `SELECT
         COALESCE(r.full_name, 'Unassigned') AS rep_name,
         COUNT(i.id) AS interaction_count,
         MAX(i.created_at) AS last_interaction_at
       FROM interactions i
       LEFT JOIN reps r ON r.id = i.rep_id
       WHERE i.deleted_at IS NULL AND i.created_at >= ?1
       GROUP BY rep_name
       ORDER BY interaction_count DESC, rep_name ASC`
    )
      .bind(sinceIso)
      .all();
    return json({ days, repActivity: rows.results });
  }) as any
);

addRoute(
  'GET',
  /^\/api\/reports\/follow-ups$/,
  withAuth(async (_request, env, _user, url) => {
    const days = Number(url.searchParams.get('days') || 14);
    const now = new Date();
    const until = new Date(now.getTime() + Math.max(days, 1) * 86400000).toISOString();
    const rows = await env.CRM_DB.prepare(
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
         AND i.next_action_at IS NOT NULL
         AND i.next_action_at >= ?1
         AND i.next_action_at <= ?2
       ORDER BY i.next_action_at ASC`
    )
      .bind(now.toISOString(), until)
      .all();
    return json({ days, followUps: rows.results });
  }) as any
);

addRoute(
  'GET',
  /^\/api\/reports\/company-engagement$/,
  withAuth(async (_request, env, _user, url) => {
    const days = Number(url.searchParams.get('days') || 90);
    const sinceIso = new Date(Date.now() - Math.max(days, 1) * 86400000).toISOString();
    const rows = await env.CRM_DB.prepare(
      `SELECT
         c.id,
         c.name AS company_name,
         COUNT(i.id) AS interactions,
         MAX(i.created_at) AS last_interaction_at
       FROM companies c
       LEFT JOIN interactions i ON i.company_id = c.id AND i.deleted_at IS NULL AND i.created_at >= ?1
       WHERE c.deleted_at IS NULL
       GROUP BY c.id, c.name
       ORDER BY interactions DESC, c.name ASC`
    )
      .bind(sinceIso)
      .all();
    return json({ days, companyEngagement: rows.results });
  }) as any
);

export default {
  async fetch(request: Request, env: Env): Promise<Response> {
    try {
      const url = new URL(request.url);
      if (!url.pathname.startsWith('/api/')) return err('Not found', 404);

      if (request.method === 'OPTIONS') {
        return new Response(null, {
          status: 204,
          headers: {
            'access-control-allow-origin': '*',
            'access-control-allow-methods': 'GET,POST,PUT,DELETE,OPTIONS',
            'access-control-allow-headers': 'content-type,authorization'
          }
        });
      }

      for (const route of routes) {
        if (route.method !== request.method) continue;
        const match = url.pathname.match(route.match);
        if (!match) continue;
        const response = await route.handler(request, env, url, match);
        response.headers.set('access-control-allow-origin', '*');
        return response;
      }

      return err('Not found', 404);
    } catch (error) {
      const msg = error instanceof Error ? error.message : 'Unexpected error';
      return err(msg, 500);
    }
  }
};

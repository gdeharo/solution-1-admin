let googleTokenCache = {
  accessToken: null,
  expiresAtMs: 0,
};
const WORKER_BUILD = "2026-02-20-hardening-v1";
let spreadsheetMetaCache = {
  meta: null,
  loadedAtMs: 0,
};
let catalogDataCache = {
  barRows: null,
  kmcRows: null,
  chainTypeRows: null,
  loadedAtMs: 0,
};
let catalogHeaderRepairCache = {
  lastCheckAtMs: 0,
};

const TAB_BAR_LENGTHS = "Chainsaw Bar Lengths-Grid view";
const TAB_KMC_CHAINS = "KMC Chains-Grid view";
const TAB_CHAIN_TYPES = "Chain Types-Grid view";
const TAB_LOOKUP_VALUES = "Lookup Values";
const DEFAULT_LOG_TAB = "Search Log";
const HUB_ADMIN_PANEL_ID = "kmc-chain-finder-admin";
const LOOKUP_HEADERS = ["Field", "Value", "Active", "Sort Order", "Group"];
const HUB_SESSION_TTL_MS = 1000 * 60 * 60 * 24 * 30;
const CHAIN_TYPE_LOOKUP_FIELDS = new Set([
  "Gauge",
  "Pitch",
  "Chisel Style",
  "ANSI Low Kickback",
  "Profile Class",
  "Kerf Type",
  "Sequence Type",
]);
const BAR_LENGTH_LOOKUP_FIELDS = new Set(["Chainsaw Brand", "Chainsaw Model", "Bar Length"]);
const CHAIN_TYPE_GAUGE_CODE_MAP = new Map([
  ['.043"', "A"],
  ['.050"', "B"],
  ['.058"', "C"],
  ['.063"', "D"],
  ['.05"', "B"],
]);
const CHAIN_TYPE_PITCH_CODE_MAP = new Map([
  ['1/4"', "A"],
  ['3/8"', "B"],
  ['3/8" lp', "C"],
  ['.325"', "D"],
]);
const SHEET_ENTITY_CONFIG = {
  "chain-types": {
    tab: TAB_CHAIN_TYPES,
    headers: [
      "Chain Type",
      "Gauge",
      "Pitch",
      "Chisel Style",
      "ANSI Low Kickback",
      "Profile Class",
      "Kerf Type",
      "Sequence Type",
    ],
  },
  "kmc-chains": {
    tab: TAB_KMC_CHAINS,
    headers: [
      "Gauge",
      "Pitch",
      "Chisel Style",
      "ANSI Low Kickback",
      "Profile Class",
      "Kerf Type",
      "Sequence Type",
      "Links",
      "Part Reference",
      "UPC",
      "URL",
    ],
  },
  "bar-lengths": {
    tab: TAB_BAR_LENGTHS,
    headers: [
      "Chainsaw Brand",
      "Chainsaw Model",
      "Chain Type Code",
      "Gauge",
      "Pitch",
      "Bar Length",
      "Drive Links",
      "Name",
      "KMC Chain URL",
    ],
  },
};

export default {
  async fetch(request, env) {
    try {
      const url = new URL(request.url);
      const path = url.pathname;

      if (request.method === "OPTIONS") {
        return cors(new Response(null, { status: 204 }));
      }

      if (path === "/health") {
        return json({ ok: true, build: WORKER_BUILD });
      }

      if (path === "/catalog/config" && request.method === "GET") {
        const settings = await getSettingsMap(env);
        return json({
          form_title: settings.form_title || "KMC Chainsaw Chain Finder",
          accent_color: settings.accent_color || "rgb(20, 111, 248)",
          button_label: settings.button_label || "Find Chains",
          card_tint_percent: settings.card_tint_percent || "20",
          no_result_message:
            settings.no_result_message ||
            "we don't offer this chainsaw chain at the moment, please check again in the future",
          chain_brand_fallback: settings.chain_brand_fallback || "KMC",
        });
      }

      // Google Sheets-backed catalog endpoints
      if (path === "/catalog/brands" && request.method === "GET") {
        const { barRows } = await getCatalogSheetData(env);
        const brands = uniqueSorted(
          barRows.map((r) => r["Chainsaw Brand"]).filter(Boolean)
        );
        return json({ brands });
      }

      if (path === "/catalog/models" && request.method === "GET") {
        const { barRows } = await getCatalogSheetData(env);
        const brand = (url.searchParams.get("brand") || "").trim();
        if (!brand) return json({ error: "Missing required param: brand" }, 400);

        const models = uniqueSorted(
          barRows
            .filter((r) => eqNorm(r["Chainsaw Brand"], brand))
            .map((r) => r["Chainsaw Model"])
            .filter(Boolean)
        );

        return json({ brand, models });
      }

      if (path === "/catalog/bar-lengths" && request.method === "GET") {
        const { barRows } = await getCatalogSheetData(env);
        const brand = (url.searchParams.get("brand") || "").trim();
        const model = (url.searchParams.get("model") || "").trim();
        if (!brand || !model) {
          return json({ error: "Missing required params: brand, model" }, 400);
        }

        const lengths = uniqueSortedByNumericPrefix(
          barRows
            .filter((r) => eqNorm(r["Chainsaw Brand"], brand) && eqNorm(r["Chainsaw Model"], model))
            .map((r) => r["Bar Length"])
            .filter(Boolean)
        );

        return json({ brand, model, bar_lengths: lengths });
      }

      if (path === "/catalog/results" && request.method === "GET") {
        const { barRows, kmcRows, chainTypeRows } = await getCatalogSheetData(env);
        const brand = (url.searchParams.get("brand") || "").trim();
        const model = (url.searchParams.get("model") || "").trim();
        const barLength = (url.searchParams.get("barLength") || "").trim();
        const shouldLog = (url.searchParams.get("log") || "1") !== "0";

        if (!brand || !model || !barLength) {
          return json({ error: "Missing required params: brand, model, barLength" }, 400);
        }

        const chainTypeMap = buildChainTypeMap(chainTypeRows);
        const settings = await getSettingsMap(env);
        const chainBrandFallback = settings.chain_brand_fallback || "KMC";

        const matchingBarRows = barRows.filter(
          (r) =>
            eqNorm(r["Chainsaw Brand"], brand) &&
            eqNorm(r["Chainsaw Model"], model) &&
            eqNorm(r["Bar Length"], barLength)
        );

        const pathKeys = [];
        for (const row of matchingBarRows) {
          const chainTypeCode = toStr(row["Chain Type Code"]);
          const pitch = toStr(row.Pitch);
          const gauge = toStr(row.Gauge);
          const driveLinks = toStr(row["Drive Links"]);
          if (!pitch || !gauge || !driveLinks) continue;
          pathKeys.push({ chainTypeCode, pitch, gauge, driveLinks });
        }

        const uniqueKeys = dedupePathKeys(pathKeys);
        const results = [];

        for (const key of uniqueKeys) {
          for (const kmc of kmcRows) {
            if (!eqNorm(kmc.Pitch, key.pitch)) continue;
            if (!eqNorm(kmc.Gauge, key.gauge)) continue;
            if (!sameDriveLinks(kmc["Links"], key.driveLinks)) continue;
            const chainTypeInfo = chainTypeMap.get(norm(kmc["Chain Type"])) || {};
            const pitch = toStr(kmc.Pitch || chainTypeInfo.pitch);
            const gauge = toStr(kmc.Gauge || chainTypeInfo.gauge);
            const chiselStyle = toStr(kmc["Chisel Style"] || chainTypeInfo.chisel_style);
            const ansiLowKickback = toStr(kmc["ANSI Low Kickback"] || chainTypeInfo.ansi_low_kickback);
            const profileClass = toStr(kmc["Profile Class"] || chainTypeInfo.profile_class);
            const kerfType = toStr(kmc["Kerf Type"] || chainTypeInfo.kerf_type);
            const sequenceType = toStr(kmc["Sequence Type"] || chainTypeInfo.sequence_type);
            const chainModel =
              pitch && gauge
                ? `Pitch ${pitch} / Gauge ${gauge}`
                : pitch
                  ? `Pitch ${pitch}`
                  : gauge
                    ? `Gauge ${gauge}`
                    : "";

            results.push({
              chain_brand: toStr(kmc["Chain Brand"]) || toStr(kmc.Brand) || chainBrandFallback,
              chain_model: chainModel,
              chain_type: toStr(kmc["Chain Type"]),
              pitch,
              gauge,
              chisel_style: chiselStyle,
              ansi_low_kickback: ansiLowKickback,
              profile_class: profileClass,
              kerf_type: kerfType,
              sequence_type: sequenceType,
              links: toStr(kmc["Links"]),
              part_reference: toStr(kmc["Part Reference"]),
              upc: toStr(kmc["UPC"]),
              url: toStr(kmc["URL"]),
            });
          }
        }

        const uniqueResults = dedupeByKey(results, (r) => `${r.part_reference}|${r.pitch}|${r.gauge}|${r.links}|${r.url}`);

        const payload = {
          query: { brand, model, bar_length: barLength },
          match_keys: uniqueKeys,
          result_count: uniqueResults.length,
          chains: uniqueResults,
        };

        if (shouldLog) {
          await appendSearchLog(env, {
            brand,
            model,
            barLength,
            matchKeys: uniqueKeys,
            chains: uniqueResults,
            userAgent: request.headers.get("user-agent") || "",
            clientIp: request.headers.get("cf-connecting-ip") || "",
          });
          payload.logged = true;
        }

        return json(payload);
      }

      // Explicit logging endpoint (optional if frontend wants manual logging)
      if (path === "/log-search" && request.method === "POST") {
        const body = await parseJson(request);
        const brand = toStr(body.brand);
        const model = toStr(body.model);
        const barLength = toStr(body.barLength);
        const matchKeys = Array.isArray(body.matchKeys) ? body.matchKeys : [];
        const chains = Array.isArray(body.chains) ? body.chains : [];

        if (!brand || !model || !barLength) {
          return json({ error: "log-search requires brand, model, barLength" }, 400);
        }

        await appendSearchLog(env, {
          brand,
          model,
          barLength,
          matchKeys,
          chains,
          userAgent: request.headers.get("user-agent") || "",
          clientIp: request.headers.get("cf-connecting-ip") || "",
        });

        return json({ ok: true });
      }

      if (path.startsWith("/hub")) {
        const route = path.split("/").filter(Boolean);

        if (route.length === 3 && route[0] === "hub" && route[1] === "auth" && route[2] === "bootstrap" && request.method === "POST") {
          const body = await parseJson(request);
          const username = toStr(body.username).trim();
          const password = toStr(body.password);
          if (!username || !password) return json({ error: "username and password are required" }, 400);
          const out = await hubBootstrapOwner(env, username, password);
          return json(out);
        }

        if (route.length === 3 && route[0] === "hub" && route[1] === "auth" && route[2] === "login" && request.method === "POST") {
          const body = await parseJson(request);
          const username = toStr(body.username).trim();
          const password = toStr(body.password);
          if (!username || !password) return json({ error: "username and password are required" }, 400);
          const out = await hubLogin(env, username, password);
          return json(out);
        }

        if (route.length === 3 && route[0] === "hub" && route[1] === "auth" && route[2] === "logout" && request.method === "POST") {
          const session = await requireHubSession(request, env);
          if (!session.ok) return session.error;
          await hubDeleteSession(env, session.token);
          return json({ ok: true });
        }

        if (route.length === 2 && route[0] === "hub" && route[1] === "me" && request.method === "GET") {
          const session = await requireHubSession(request, env);
          if (!session.ok) return session.error;
          return json({ user: session.user });
        }

        if (route.length === 2 && route[0] === "hub" && route[1] === "users" && request.method === "GET") {
          const session = await requireHubOwnerSession(request, env);
          if (!session.ok) return session.error;
          const users = await hubListUsers(env);
          return json({ users });
        }

        if (route.length === 4 && route[0] === "hub" && route[1] === "panels" && route[3] === "users" && request.method === "GET") {
          const session = await requireHubSession(request, env);
          if (!session.ok) return session.error;
          const panelId = decodeURIComponent(route[2]);
          if (!canManagePanel(session.user, panelId)) return json({ error: "Forbidden" }, 403);
          const users = await hubListUsersForPanel(env, panelId);
          return json({ panel_id: panelId, users });
        }

        if (route.length === 4 && route[0] === "hub" && route[1] === "panels" && route[3] === "users" && request.method === "POST") {
          const session = await requireHubSession(request, env);
          if (!session.ok) return session.error;
          const panelId = decodeURIComponent(route[2]);
          if (!canManagePanel(session.user, panelId)) return json({ error: "Forbidden" }, 403);
          const body = await parseJson(request);
          const username = toStr(body.username).trim();
          const password = toStr(body.password);
          const panelRole = normalizeHubPanelRole(body.panel_role || "viewer");
          if (!username || !password) return json({ error: "username and password are required" }, 400);
          const user = await hubCreateUserForPanel(env, { username, password, panelId, panelRole });
          return json({ ok: true, user });
        }

        if (
          route.length === 6 &&
          route[0] === "hub" &&
          route[1] === "panels" &&
          route[3] === "users" &&
          route[5] === "panel-role" &&
          request.method === "POST"
        ) {
          const session = await requireHubSession(request, env);
          if (!session.ok) return session.error;
          const panelId = decodeURIComponent(route[2]);
          if (!canManagePanel(session.user, panelId)) return json({ error: "Forbidden" }, 403);
          const username = decodeURIComponent(route[4]);
          const body = await parseJson(request);
          const panelRole = normalizeHubPanelRole(body.panel_role);
          await hubSetPanelRoleForPanelManager(env, username, panelId, panelRole);
          return json({ ok: true });
        }

        if (route.length === 2 && route[0] === "hub" && route[1] === "users" && request.method === "POST") {
          const session = await requireHubOwnerSession(request, env);
          if (!session.ok) return session.error;
          const body = await parseJson(request);
          const username = toStr(body.username).trim();
          const password = toStr(body.password);
          const globalRole = normalizeHubGlobalRole(body.global_role);
          if (!username || !password) return json({ error: "username and password are required" }, 400);
          const panelRoles = sanitizePanelRoles(body.panel_roles || {});
          const user = await hubCreateUser(env, { username, password, globalRole, panelRoles });
          return json({ ok: true, user });
        }

        if (route.length === 4 && route[0] === "hub" && route[1] === "users" && route[3] === "password" && request.method === "POST") {
          const session = await requireHubOwnerSession(request, env);
          if (!session.ok) return session.error;
          const username = decodeURIComponent(route[2]);
          const body = await parseJson(request);
          const password = toStr(body.password);
          if (!password) return json({ error: "password is required" }, 400);
          await hubSetPassword(env, username, password);
          return json({ ok: true });
        }

        if (route.length === 4 && route[0] === "hub" && route[1] === "users" && route[3] === "role" && request.method === "POST") {
          const session = await requireHubOwnerSession(request, env);
          if (!session.ok) return session.error;
          const username = decodeURIComponent(route[2]);
          const body = await parseJson(request);
          const globalRole = normalizeHubGlobalRole(body.global_role);
          await hubSetGlobalRole(env, username, globalRole, session.user.username);
          return json({ ok: true });
        }

        if (route.length === 4 && route[0] === "hub" && route[1] === "users" && route[3] === "panel-role" && request.method === "POST") {
          const session = await requireHubOwnerSession(request, env);
          if (!session.ok) return session.error;
          const username = decodeURIComponent(route[2]);
          const body = await parseJson(request);
          const panelId = toStr(body.panel_id).trim();
          const panelRole = normalizeHubPanelRole(body.panel_role);
          if (!panelId) return json({ error: "panel_id is required" }, 400);
          await hubSetPanelRole(env, username, panelId, panelRole);
          return json({ ok: true });
        }

        if (route.length === 3 && route[0] === "hub" && route[1] === "users" && request.method === "DELETE") {
          const session = await requireHubOwnerSession(request, env);
          if (!session.ok) return session.error;
          const username = decodeURIComponent(route[2]);
          await hubDeleteUser(env, username, session.user.username);
          return json({ ok: true });
        }

        return json({ error: "Unknown hub route" }, 404);
      }

      // Existing D1-backed admin and selector endpoints (kept for backwards compatibility)
      if (path.startsWith("/admin")) {
        const authError = await validateAdmin(request, env);
        if (authError) return authError;

        const route = path.split("/").filter(Boolean);

        if (route.length === 2 && route[0] === "admin" && route[1] === "settings" && request.method === "GET") {
          const settings = await getSettingsMap(env);
          return json({ settings });
        }

        if (route.length === 2 && route[0] === "admin" && route[1] === "settings" && request.method === "POST") {
          const body = await parseJson(request);
          const input = body && body.settings && typeof body.settings === "object" ? body.settings : {};
          await upsertSettings(env, input);
          return json({ ok: true });
        }

        if (route.length === 2 && route[0] === "admin" && route[1] === "lookups" && request.method === "GET") {
          const field = toStr(url.searchParams.get("field")).trim();
          const group = toStr(url.searchParams.get("group")).trim();
          const includeInactive = toStr(url.searchParams.get("includeInactive")) === "1";
          const lookups = await getLookupValues(env, { field, group, includeInactive });
          return json({ lookups });
        }

        if (route.length === 2 && route[0] === "admin" && route[1] === "lookups" && request.method === "POST") {
          const body = await parseJson(request);
          const field = toStr(body.field).trim();
          const value = toStr(body.value).trim();
          const group = normalizeLookupGroup(body.group || "");
          const active = body.active === 0 || body.active === "0" ? "0" : "1";
          const sortOrder = Number(body.sort_order || 0);

          if (!field || !value) {
            return json({ error: "lookups requires field and value" }, 400);
          }

          const rowNumber = await upsertLookupValue(env, {
            field,
            value,
            group,
            active,
            sortOrder,
          });

          return json({ ok: true, row_number: rowNumber });
        }

        if (
          route.length === 3 &&
          route[0] === "admin" &&
          route[1] === "migrate" &&
          route[2] === "chain-type-codes" &&
          (request.method === "GET" || request.method === "POST")
        ) {
          let dryRun = true;
          let maxUpdates = 0;
          if (request.method === "POST") {
            const body = await parseJson(request);
            dryRun = body && body.dryRun === false ? false : true;
            maxUpdates = Number(body.maxUpdates || 0);
          } else {
            dryRun = toStr(url.searchParams.get("dryRun") || "1") !== "0";
            maxUpdates = Number(url.searchParams.get("maxUpdates") || 0);
          }
          const result = await migrateChainTypeCodes(env, { dryRun, maxUpdates });
          return json(result);
        }

        if (route.length === 3 && route[0] === "admin" && route[1] === "gsheet" && request.method === "GET") {
          const entity = route[2];
          const cfg = SHEET_ENTITY_CONFIG[entity];
          if (!cfg) return json({ error: "Unknown sheet entity" }, 404);

          // Read-only admin view should not mutate sheet headers.
          const rows = await loadEntityRowsWithoutHeaderRepair(env, entity);
          return json({ entity, tab: cfg.tab, headers: cfg.headers, rows });
        }

        if (route.length === 3 && route[0] === "admin" && route[1] === "gsheet" && request.method === "POST") {
          const entity = route[2];
          const cfg = SHEET_ENTITY_CONFIG[entity];
          if (!cfg) return json({ error: "Unknown sheet entity" }, 404);

          const body = await parseJson(request);
          const row = body && body.row && typeof body.row === "object" ? body.row : body;
          if (!row || typeof row !== "object") {
            return json({ error: "Missing row payload" }, 400);
          }
          const rowNumber = body && body.rowNumber ? Number(body.rowNumber) : Number(row.__row || 0);

          if (entity === "chain-types") {
            await enforceChainTypeUniqueness(env, row, rowNumber || null);
          }
          if (entity === "kmc-chains") {
            await enforceKmcChainUniqueness(env, row, rowNumber || null);
          }

          const updatedRow = await upsertSheetEntityRow(env, cfg, row, rowNumber || null);
          return json({ ok: true, row_number: updatedRow });
        }

        if (route.length === 3 && route[0] === "admin" && route[1] === "gsheet" && request.method === "DELETE") {
          const entity = route[2];
          const cfg = SHEET_ENTITY_CONFIG[entity];
          if (!cfg) return json({ error: "Unknown sheet entity" }, 404);
          const rowNumber = Number(url.searchParams.get("rowNumber") || 0);
          if (!Number.isInteger(rowNumber) || rowNumber < 2) {
            return json({ error: "Missing or invalid rowNumber query parameter" }, 400);
          }
          await deleteSheetRow(env, cfg.tab, rowNumber);
          return json({ ok: true, row_number: rowNumber });
        }

        if (route.length === 2 && route[0] === "admin" && route[1] === "options" && request.method === "GET") {
          const step = (url.searchParams.get("step") || "").toUpperCase();
          let sql = "SELECT id, step, label, sort_order, is_active FROM options";
          let stmt;
          if (step && ["A", "B", "C", "D"].includes(step)) {
            sql += " WHERE step = ?";
            stmt = env.DB.prepare(sql + " ORDER BY step, sort_order, label").bind(step);
          } else {
            stmt = env.DB.prepare(sql + " ORDER BY step, sort_order, label");
          }
          const result = await stmt.all();
          return json({ options: result.results || [] });
        }

        if (route.length === 2 && route[0] === "admin" && route[1] === "products" && request.method === "GET") {
          const result = await env.DB.prepare(
            "SELECT id, sku, name, description, url, image_url, is_active FROM products ORDER BY name"
          ).all();
          return json({ products: result.results || [] });
        }

        if (route.length === 2 && route[0] === "admin" && route[1] === "rules" && request.method === "GET") {
          const result = await env.DB.prepare(
            `SELECT r.id, r.option_a_id, r.option_b_id, r.option_c_id, r.option_d_id, r.product_id, r.is_active,
                    p.name AS product_name
             FROM product_rules r
             LEFT JOIN products p ON p.id = r.product_id
             ORDER BY r.id DESC`
          ).all();
          return json({ rules: result.results || [] });
        }

        if (route.length === 2 && route[0] === "admin" && route[1] === "options" && request.method === "POST") {
          const body = await parseJson(request);
          if (!body.id || !body.step || !body.label) {
            return json({ error: "options requires id, step, label" }, 400);
          }
          const step = String(body.step).toUpperCase();
          if (!["A", "B", "C", "D"].includes(step)) {
            return json({ error: "step must be A, B, C, or D" }, 400);
          }

          await env.DB.prepare(
            `INSERT INTO options (id, step, label, sort_order, is_active)
             VALUES (?, ?, ?, ?, ?)
             ON CONFLICT(id) DO UPDATE SET
               step = excluded.step,
               label = excluded.label,
               sort_order = excluded.sort_order,
               is_active = excluded.is_active`
          )
            .bind(
              String(body.id),
              step,
              String(body.label),
              Number(body.sort_order || 0),
              body.is_active === 0 ? 0 : 1
            )
            .run();

          return json({ ok: true });
        }

        if (route.length === 2 && route[0] === "admin" && route[1] === "products" && request.method === "POST") {
          const body = await parseJson(request);
          if (!body.id || !body.name) {
            return json({ error: "products requires id and name" }, 400);
          }

          await env.DB.prepare(
            `INSERT INTO products (id, sku, name, description, url, image_url, is_active)
             VALUES (?, ?, ?, ?, ?, ?, ?)
             ON CONFLICT(id) DO UPDATE SET
               sku = excluded.sku,
               name = excluded.name,
               description = excluded.description,
               url = excluded.url,
               image_url = excluded.image_url,
               is_active = excluded.is_active`
          )
            .bind(
              String(body.id),
              body.sku ? String(body.sku) : null,
              String(body.name),
              body.description ? String(body.description) : null,
              body.url ? String(body.url) : null,
              body.image_url ? String(body.image_url) : null,
              body.is_active === 0 ? 0 : 1
            )
            .run();

          return json({ ok: true });
        }

        if (route.length === 2 && route[0] === "admin" && route[1] === "rules" && request.method === "POST") {
          const body = await parseJson(request);
          if (!body.option_a_id || !body.option_b_id || !body.option_c_id || !body.option_d_id || !body.product_id) {
            return json({ error: "rules requires option_a_id, option_b_id, option_c_id, option_d_id, product_id" }, 400);
          }

          if (body.id) {
            await env.DB.prepare(
              `UPDATE product_rules
               SET option_a_id = ?, option_b_id = ?, option_c_id = ?, option_d_id = ?, product_id = ?, is_active = ?
               WHERE id = ?`
            )
              .bind(
                String(body.option_a_id),
                String(body.option_b_id),
                String(body.option_c_id),
                String(body.option_d_id),
                String(body.product_id),
                body.is_active === 0 ? 0 : 1,
                Number(body.id)
              )
              .run();
          } else {
            await env.DB.prepare(
              `INSERT INTO product_rules (option_a_id, option_b_id, option_c_id, option_d_id, product_id, is_active)
               VALUES (?, ?, ?, ?, ?, ?)`
            )
              .bind(
                String(body.option_a_id),
                String(body.option_b_id),
                String(body.option_c_id),
                String(body.option_d_id),
                String(body.product_id),
                body.is_active === 0 ? 0 : 1
              )
              .run();
          }

          return json({ ok: true });
        }

        if (route.length === 3 && route[0] === "admin" && route[1] === "options" && request.method === "DELETE") {
          const id = route[2];
          await env.DB.prepare("DELETE FROM options WHERE id = ?").bind(id).run();
          return json({ ok: true });
        }

        if (route.length === 3 && route[0] === "admin" && route[1] === "products" && request.method === "DELETE") {
          const id = route[2];
          await env.DB.prepare("DELETE FROM products WHERE id = ?").bind(id).run();
          return json({ ok: true });
        }

        if (route.length === 3 && route[0] === "admin" && route[1] === "rules" && request.method === "DELETE") {
          const id = Number(route[2]);
          await env.DB.prepare("DELETE FROM product_rules WHERE id = ?").bind(id).run();
          return json({ ok: true });
        }

        return json({ error: "Unknown admin route" }, 404);
      }

      if (path === "/options" && request.method === "GET") {
        const step = (url.searchParams.get("step") || "").toUpperCase();
        const a = url.searchParams.get("a");
        const b = url.searchParams.get("b");
        const c = url.searchParams.get("c");

        if (!["A", "B", "C", "D"].includes(step)) {
          return json({ error: "Invalid step. Use A, B, C, or D." }, 400);
        }

        let sql = "";
        let binds = [];

        if (step === "A") {
          sql = `
            SELECT id, label, sort_order
            FROM options
            WHERE step = 'A' AND is_active = 1
            ORDER BY sort_order, label
          `;
        } else if (step === "B") {
          if (!a) return json({ error: "Missing required param: a" }, 400);
          sql = `
            SELECT DISTINCT o.id, o.label, o.sort_order
            FROM product_rules r
            JOIN options o ON o.id = r.option_b_id
            WHERE r.is_active = 1 AND o.is_active = 1
              AND r.option_a_id = ?
              AND o.step = 'B'
            ORDER BY o.sort_order, o.label
          `;
          binds = [a];
        } else if (step === "C") {
          if (!a || !b) return json({ error: "Missing required params: a, b" }, 400);
          sql = `
            SELECT DISTINCT o.id, o.label, o.sort_order
            FROM product_rules r
            JOIN options o ON o.id = r.option_c_id
            WHERE r.is_active = 1 AND o.is_active = 1
              AND r.option_a_id = ?
              AND r.option_b_id = ?
              AND o.step = 'C'
            ORDER BY o.sort_order, o.label
          `;
          binds = [a, b];
        } else if (step === "D") {
          if (!a || !b || !c) return json({ error: "Missing required params: a, b, c" }, 400);
          sql = `
            SELECT DISTINCT o.id, o.label, o.sort_order
            FROM product_rules r
            JOIN options o ON o.id = r.option_d_id
            WHERE r.is_active = 1 AND o.is_active = 1
              AND r.option_a_id = ?
              AND r.option_b_id = ?
              AND r.option_c_id = ?
              AND o.step = 'D'
            ORDER BY o.sort_order, o.label
          `;
          binds = [a, b, c];
        }

        const result = await env.DB.prepare(sql).bind(...binds).all();
        return json({ step, options: result.results || [] });
      }

      if (path === "/results" && request.method === "GET") {
        const a = url.searchParams.get("a");
        const b = url.searchParams.get("b");
        const c = url.searchParams.get("c");
        const d = url.searchParams.get("d");

        if (!a || !b || !c || !d) {
          return json({ error: "Missing required params: a, b, c, d" }, 400);
        }

        const sql = `
          SELECT p.id, p.sku, p.name, p.description, p.url, p.image_url
          FROM product_rules r
          JOIN products p ON p.id = r.product_id
          WHERE r.is_active = 1 AND p.is_active = 1
            AND r.option_a_id = ?
            AND r.option_b_id = ?
            AND r.option_c_id = ?
            AND r.option_d_id = ?
          ORDER BY p.name
        `;

        const result = await env.DB.prepare(sql).bind(a, b, c, d).all();
        return json({ products: result.results || [] });
      }

      return json({ error: "Not found" }, 404);
    } catch (err) {
      const message = err && err.message ? String(err.message) : String(err);
      const low = message.toLowerCase();
      const isUserError =
        low.includes("duplicate ") ||
        low.includes("header mismatch") ||
        low.includes("missing required") ||
        low.includes("invalid ") ||
        low.includes("user not found") ||
        low.includes("already exists") ||
        low.includes("cannot remove") ||
        low.includes("at least one owner") ||
        low.includes("last owner") ||
        low.includes("hub already initialized") ||
        low.includes("hub not initialized");

      if (isUserError) {
        return json({ error: message }, 400);
      }

      return json({ error: "Server error", details: String(err) }, 500);
    }
  },
};

async function validateAdmin(request, env) {
  const adminToken = toStr(env.ADMIN_TOKEN);
  const providedAdminToken = toStr(request.headers.get("x-admin-token"));
  if (adminToken && providedAdminToken && providedAdminToken === adminToken) {
    return null;
  }

  const hubSession = await requireHubSession(request, env);
  if (!hubSession.ok) {
    return json({ error: "Unauthorized" }, 401);
  }

  const globalRole = normalizeHubGlobalRole(hubSession.user.global_role);
  if (globalRole === "owner") return null;

  const panelRole = getUserPanelRole(hubSession.user, HUB_ADMIN_PANEL_ID);
  const roleWeight = { none: 0, viewer: 1, editor: 2, manager: 3 };
  const requiredWeight = request.method === "GET" ? 1 : 2;
  if ((roleWeight[panelRole] || 0) < requiredWeight) {
    return json({ error: "Forbidden" }, 403);
  }
  return null;
}

async function parseJson(request) {
  const text = await request.text();
  if (!text) return {};
  return JSON.parse(text);
}

async function appendSearchLog(env, data) {
  const now = new Date().toISOString();
  const tab = env.SEARCH_LOG_TAB || DEFAULT_LOG_TAB;

  await ensureLogHeader(env, tab);

  const row = [
    now,
    data.brand || "",
    data.model || "",
    data.barLength || "",
    (data.matchKeys || []).map((k) => `${toStr(k.pitch)}/${toStr(k.gauge)}:${toStr(k.driveLinks)}`).join(" | "),
    (data.matchKeys || []).map((k) => `${toStr(k.pitch)}/${toStr(k.gauge)}`).filter(Boolean).join(","),
    (data.matchKeys || []).map((k) => toStr(k.driveLinks)).filter(Boolean).join(","),
    Array.isArray(data.chains) ? String(data.chains.length) : "0",
    Array.isArray(data.chains)
      ? data.chains.map((c) => toStr(c.part_reference)).filter(Boolean).join(",")
      : "",
    Array.isArray(data.chains)
      ? data.chains.map((c) => toStr(c.url)).filter(Boolean).join(",")
      : "",
    data.clientIp || "",
    data.userAgent || "",
  ];

  const range = `'${escapeSheetTab(tab)}'!A:L`;
  const path = `/values/${encodeURIComponent(range)}:append?valueInputOption=RAW&insertDataOption=INSERT_ROWS`;
  await googleSheetsRequest(env, "POST", path, { values: [row] });
}

async function ensureLogHeader(env, tab) {
  const checkRange = `'${escapeSheetTab(tab)}'!A1:L1`;
  let existing;
  try {
    existing = await googleSheetsRequest(env, "GET", `/values/${encodeURIComponent(checkRange)}`);
  } catch (err) {
    if (String(err).includes("Unable to parse range")) {
      await createSheetIfMissing(env, tab);
      existing = await googleSheetsRequest(env, "GET", `/values/${encodeURIComponent(checkRange)}`);
    } else {
      throw err;
    }
  }
  const hasHeader = Array.isArray(existing.values) && existing.values.length > 0 && existing.values[0].length > 0;
  if (hasHeader) return;

  const header = [
    "Timestamp",
    "Brand",
    "Model",
    "Bar Length",
    "Match Keys",
    "Chain Type Codes",
    "Drive Links",
    "Match Count",
    "Matched Part References",
    "Matched URLs",
    "Client IP",
    "User Agent",
  ];

  await googleSheetsRequest(
    env,
    "PUT",
    `/values/${encodeURIComponent(checkRange)}?valueInputOption=RAW`,
    { values: [header] }
  );
}

async function createSheetIfMissing(env, tabName) {
  const body = {
    requests: [
      {
        addSheet: {
          properties: {
            title: tabName,
          },
        },
      },
    ],
  };

  try {
    await googleSheetsRequest(env, "POST", ":batchUpdate", body);
  } catch (err) {
    const msg = String(err);
    // If another request created it first, ignore and continue.
    if (!msg.includes("already exists")) {
      throw err;
    }
  }
}

async function ensureSettingsTable(env) {
  if (!env.DB) throw new Error("Missing DB binding for settings");
  await env.DB.prepare(
    `CREATE TABLE IF NOT EXISTS app_settings (
      key TEXT PRIMARY KEY,
      value TEXT NOT NULL
    )`
  ).run();
}

async function getSettingsMap(env) {
  await ensureSettingsTable(env);
  const result = await env.DB.prepare("SELECT key, value FROM app_settings").all();
  const out = {};
  for (const row of result.results || []) {
    out[row.key] = row.value;
  }
  return out;
}

async function upsertSettings(env, input) {
  await ensureSettingsTable(env);
  const allowed = new Set([
    "form_title",
    "accent_color",
    "button_label",
    "card_tint_percent",
    "no_result_message",
    "chain_brand_fallback",
  ]);

  for (const [key, value] of Object.entries(input || {})) {
    if (!allowed.has(key)) continue;
    await env.DB.prepare(
      `INSERT INTO app_settings (key, value)
       VALUES (?, ?)
       ON CONFLICT(key) DO UPDATE SET value = excluded.value`
    ).bind(key, toStr(value)).run();
  }
}

async function ensureHubTables(env) {
  if (!env.DB) throw new Error("Missing DB binding for hub auth");
  await env.DB.prepare(
    `CREATE TABLE IF NOT EXISTS hub_users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      username TEXT NOT NULL,
      username_norm TEXT NOT NULL UNIQUE,
      password_hash TEXT NOT NULL,
      global_role TEXT NOT NULL DEFAULT 'viewer',
      panel_roles_json TEXT NOT NULL DEFAULT '{}',
      is_active INTEGER NOT NULL DEFAULT 1,
      created_at INTEGER NOT NULL,
      updated_at INTEGER NOT NULL
    )`
  ).run();
  await env.DB.prepare(
    `CREATE TABLE IF NOT EXISTS hub_sessions (
      token TEXT PRIMARY KEY,
      username_norm TEXT NOT NULL,
      expires_at INTEGER NOT NULL,
      created_at INTEGER NOT NULL
    )`
  ).run();
  await env.DB.prepare(`CREATE INDEX IF NOT EXISTS idx_hub_sessions_expires_at ON hub_sessions (expires_at)`).run();
}

async function hubBootstrapOwner(env, username, password) {
  await ensureHubTables(env);
  const now = Date.now();
  const existing = await env.DB.prepare("SELECT COUNT(*) AS c FROM hub_users").first();
  if (Number(existing && existing.c) > 0) {
    return { ok: false, error: "Hub already initialized" };
  }
  const passwordHash = await hubHashPassword(env, password);
  await env.DB.prepare(
    `INSERT INTO hub_users (username, username_norm, password_hash, global_role, panel_roles_json, is_active, created_at, updated_at)
     VALUES (?, ?, ?, 'owner', '{}', 1, ?, ?)`
  ).bind(username, hubNormUsername(username), passwordHash, now, now).run();
  const user = await hubGetUserByUsername(env, username);
  const token = await hubCreateSession(env, user.username_norm);
  return { ok: true, session_token: token, user: hubPublicUser(user) };
}

async function hubLogin(env, username, password) {
  await ensureHubTables(env);
  const count = await env.DB.prepare("SELECT COUNT(*) AS c FROM hub_users").first();
  if (Number(count && count.c) === 0) {
    return { ok: false, error: "Hub not initialized. Use bootstrap first." };
  }
  const user = await hubGetUserByUsername(env, username);
  if (!user || Number(user.is_active || 0) !== 1) {
    return { ok: false, error: "Invalid credentials" };
  }
  const hash = await hubHashPassword(env, password);
  if (hash !== toStr(user.password_hash)) {
    return { ok: false, error: "Invalid credentials" };
  }
  const token = await hubCreateSession(env, user.username_norm);
  return { ok: true, session_token: token, user: hubPublicUser(user) };
}

async function hubCreateSession(env, usernameNorm) {
  await ensureHubTables(env);
  const token = randomHex(32);
  const now = Date.now();
  const expiresAt = now + HUB_SESSION_TTL_MS;
  await env.DB.prepare(`DELETE FROM hub_sessions WHERE expires_at < ?`).bind(now).run();
  await env.DB.prepare(
    `INSERT INTO hub_sessions (token, username_norm, expires_at, created_at)
     VALUES (?, ?, ?, ?)`
  ).bind(token, usernameNorm, expiresAt, now).run();
  return token;
}

async function hubDeleteSession(env, token) {
  await ensureHubTables(env);
  await env.DB.prepare(`DELETE FROM hub_sessions WHERE token = ?`).bind(token).run();
}

async function requireHubSession(request, env) {
  await ensureHubTables(env);
  const token = getHubSessionToken(request);
  if (!token) return { ok: false, error: json({ error: "Unauthorized" }, 401) };
  const now = Date.now();
  const session = await env.DB.prepare(
    `SELECT s.token, s.username_norm, s.expires_at,
            u.username, u.username_norm AS user_norm, u.global_role, u.panel_roles_json, u.is_active
     FROM hub_sessions s
     JOIN hub_users u ON u.username_norm = s.username_norm
     WHERE s.token = ?`
  ).bind(token).first();
  if (!session) return { ok: false, error: json({ error: "Unauthorized" }, 401) };
  if (Number(session.expires_at || 0) < now || Number(session.is_active || 0) !== 1) {
    await hubDeleteSession(env, token);
    return { ok: false, error: json({ error: "Session expired" }, 401) };
  }
  return {
    ok: true,
    token,
    user: {
      username: toStr(session.username),
      username_norm: toStr(session.user_norm),
      global_role: normalizeHubGlobalRole(session.global_role),
      panel_roles: parsePanelRoles(session.panel_roles_json),
    },
  };
}

async function requireHubOwnerSession(request, env) {
  const session = await requireHubSession(request, env);
  if (!session.ok) return session;
  if (normalizeHubGlobalRole(session.user.global_role) !== "owner") {
    return { ok: false, error: json({ error: "Forbidden" }, 403) };
  }
  return session;
}

function getHubSessionToken(request) {
  const fromHeader = toStr(request.headers.get("x-hub-session")).trim();
  if (fromHeader) return fromHeader;
  const auth = toStr(request.headers.get("authorization")).trim();
  if (auth.toLowerCase().startsWith("bearer ")) return auth.slice(7).trim();
  return "";
}

async function hubGetUserByUsername(env, username) {
  await ensureHubTables(env);
  return env.DB.prepare(
    `SELECT username, username_norm, password_hash, global_role, panel_roles_json, is_active
     FROM hub_users
     WHERE username_norm = ?`
  ).bind(hubNormUsername(username)).first();
}

async function hubListUsers(env) {
  await ensureHubTables(env);
  const result = await env.DB.prepare(
    `SELECT username, username_norm, global_role, panel_roles_json, is_active, created_at, updated_at
     FROM hub_users
     ORDER BY username COLLATE NOCASE`
  ).all();
  return (result.results || []).map((u) => hubPublicUser(u));
}

async function hubCreateUser(env, input) {
  await ensureHubTables(env);
  const username = toStr(input.username).trim();
  const usernameNorm = hubNormUsername(username);
  const existing = await env.DB.prepare(`SELECT username_norm FROM hub_users WHERE username_norm = ?`).bind(usernameNorm).first();
  if (existing) throw new Error("User already exists");
  const now = Date.now();
  await env.DB.prepare(
    `INSERT INTO hub_users (username, username_norm, password_hash, global_role, panel_roles_json, is_active, created_at, updated_at)
     VALUES (?, ?, ?, ?, ?, 1, ?, ?)`
  ).bind(
    username,
    usernameNorm,
    await hubHashPassword(env, input.password),
    normalizeHubGlobalRole(input.globalRole),
    JSON.stringify(sanitizePanelRoles(input.panelRoles || {})),
    now,
    now
  ).run();
  const created = await hubGetUserByUsername(env, username);
  return hubPublicUser(created);
}

async function hubCreateUserForPanel(env, input) {
  await ensureHubTables(env);
  const username = toStr(input.username).trim();
  const usernameNorm = hubNormUsername(username);
  const existing = await env.DB.prepare(`SELECT username_norm FROM hub_users WHERE username_norm = ?`).bind(usernameNorm).first();
  if (existing) throw new Error("User already exists");
  const now = Date.now();
  const panelId = toStr(input.panelId).trim();
  const panelRole = normalizeHubPanelRole(input.panelRole);
  const panelRoles = {};
  if (panelId) panelRoles[panelId] = panelRole;
  await env.DB.prepare(
    `INSERT INTO hub_users (username, username_norm, password_hash, global_role, panel_roles_json, is_active, created_at, updated_at)
     VALUES (?, ?, ?, 'viewer', ?, 1, ?, ?)`
  ).bind(
    username,
    usernameNorm,
    await hubHashPassword(env, input.password),
    JSON.stringify(sanitizePanelRoles(panelRoles)),
    now,
    now
  ).run();
  const created = await hubGetUserByUsername(env, username);
  return hubPublicUser(created);
}

async function hubSetPassword(env, username, password) {
  await ensureHubTables(env);
  const user = await hubGetUserByUsername(env, username);
  if (!user) throw new Error("User not found");
  const now = Date.now();
  const result = await env.DB.prepare(
    `UPDATE hub_users
     SET password_hash = ?, updated_at = ?
     WHERE username_norm = ?`
  ).bind(await hubHashPassword(env, password), now, hubNormUsername(username)).run();
  if (!result.success) throw new Error("Unable to update password");
}

async function hubSetGlobalRole(env, username, globalRole, actingUsername) {
  await ensureHubTables(env);
  const target = await hubGetUserByUsername(env, username);
  if (!target) throw new Error("User not found");
  const currentRole = normalizeHubGlobalRole(target.global_role);
  const nextRole = normalizeHubGlobalRole(globalRole);
  if (currentRole === "owner" && nextRole !== "owner") {
    const owners = await env.DB.prepare(`SELECT COUNT(*) AS c FROM hub_users WHERE global_role = 'owner' AND is_active = 1`).first();
    if (Number(owners && owners.c) <= 1) throw new Error("At least one owner must remain");
  }
  const now = Date.now();
  await env.DB.prepare(
    `UPDATE hub_users
     SET global_role = ?, updated_at = ?
     WHERE username_norm = ?`
  ).bind(nextRole, now, hubNormUsername(username)).run();
  if (hubNormUsername(username) === hubNormUsername(actingUsername) && nextRole !== "owner") {
    // no-op; caller may still continue, but they will lose owner permissions on next request.
  }
}

async function hubSetPanelRole(env, username, panelId, panelRole) {
  await ensureHubTables(env);
  const user = await hubGetUserByUsername(env, username);
  if (!user) throw new Error("User not found");
  if (normalizeHubGlobalRole(user.global_role) === "owner") return;
  const roles = parsePanelRoles(user.panel_roles_json);
  roles[toStr(panelId).trim()] = normalizeHubPanelRole(panelRole);
  const now = Date.now();
  await env.DB.prepare(
    `UPDATE hub_users
     SET panel_roles_json = ?, updated_at = ?
     WHERE username_norm = ?`
  ).bind(JSON.stringify(sanitizePanelRoles(roles)), now, hubNormUsername(username)).run();
}

async function hubSetPanelRoleForPanelManager(env, username, panelId, panelRole) {
  await ensureHubTables(env);
  const user = await hubGetUserByUsername(env, username);
  if (!user) throw new Error("User not found");
  if (normalizeHubGlobalRole(user.global_role) === "owner") return;
  const roles = parsePanelRoles(user.panel_roles_json);
  roles[toStr(panelId).trim()] = normalizeHubPanelRole(panelRole);
  const now = Date.now();
  await env.DB.prepare(
    `UPDATE hub_users
     SET panel_roles_json = ?, updated_at = ?
     WHERE username_norm = ?`
  ).bind(JSON.stringify(sanitizePanelRoles(roles)), now, hubNormUsername(username)).run();
}

async function hubListUsersForPanel(env, panelId) {
  const pid = toStr(panelId).trim();
  const users = await hubListUsers(env);
  return users
    .filter((u) => normalizeHubGlobalRole(u.global_role) !== "owner")
    .filter((u) => normalizeHubPanelRole((u.panel_roles || {})[pid]) !== "none");
}

async function hubDeleteUser(env, username, actingUsername) {
  await ensureHubTables(env);
  const usernameNorm = hubNormUsername(username);
  if (usernameNorm === hubNormUsername(actingUsername)) throw new Error("Cannot remove current signed-in user");
  const target = await hubGetUserByUsername(env, username);
  if (!target) throw new Error("User not found");
  if (normalizeHubGlobalRole(target.global_role) === "owner") {
    const owners = await env.DB.prepare(`SELECT COUNT(*) AS c FROM hub_users WHERE global_role = 'owner' AND is_active = 1`).first();
    if (Number(owners && owners.c) <= 1) throw new Error("Cannot remove last owner");
  }
  await env.DB.prepare(`DELETE FROM hub_users WHERE username_norm = ?`).bind(usernameNorm).run();
  await env.DB.prepare(`DELETE FROM hub_sessions WHERE username_norm = ?`).bind(usernameNorm).run();
}

function hubPublicUser(row) {
  return {
    username: toStr(row.username),
    username_norm: toStr(row.username_norm || hubNormUsername(row.username)),
    global_role: normalizeHubGlobalRole(row.global_role),
    panel_roles: sanitizePanelRoles(parsePanelRoles(row.panel_roles_json)),
    is_active: Number(row.is_active || 0) === 1 ? 1 : 0,
  };
}

function hubNormUsername(value) {
  return toStr(value).trim().toLowerCase();
}

async function hubHashPassword(env, password) {
  const pepper = toStr(env.HUB_PASSWORD_PEPPER || "");
  const data = new TextEncoder().encode(`${pepper}:${toStr(password)}`);
  const digest = await crypto.subtle.digest("SHA-256", data);
  return [...new Uint8Array(digest)].map((b) => b.toString(16).padStart(2, "0")).join("");
}

function parsePanelRoles(value) {
  try {
    const parsed = typeof value === "string" ? JSON.parse(value || "{}") : value;
    if (!parsed || typeof parsed !== "object" || Array.isArray(parsed)) return {};
    return parsed;
  } catch {
    return {};
  }
}

function sanitizePanelRoles(input) {
  const out = {};
  const source = input && typeof input === "object" ? input : {};
  for (const [k, v] of Object.entries(source)) {
    const key = toStr(k).trim();
    if (!key) continue;
    out[key] = normalizeHubPanelRole(v);
  }
  return out;
}

function normalizeHubGlobalRole(value) {
  const role = toStr(value).trim().toLowerCase();
  if (role === "owner" || role === "editor") return role;
  return "viewer";
}

function normalizeHubPanelRole(value) {
  const role = toStr(value).trim().toLowerCase();
  if (role === "manager" || role === "editor" || role === "viewer") return role;
  return "none";
}

function getUserPanelRole(user, panelId) {
  if (!user) return "none";
  if (normalizeHubGlobalRole(user.global_role) === "owner") return "manager";
  const roles = sanitizePanelRoles(user.panel_roles || {});
  return normalizeHubPanelRole(roles[toStr(panelId).trim()]);
}

function canManagePanel(user, panelId) {
  return getUserPanelRole(user, panelId) === "manager";
}

function randomHex(numBytes) {
  const bytes = new Uint8Array(numBytes);
  crypto.getRandomValues(bytes);
  return [...bytes].map((b) => b.toString(16).padStart(2, "0")).join("");
}

async function upsertSheetEntityRow(env, cfg, row, rowNumber) {
  await validateHeaderRow(env, cfg.tab, cfg.headers);
  return upsertSheetEntityRowNoHeaderCheck(env, cfg, row, rowNumber);
}

async function upsertSheetEntityRowNoHeaderCheck(env, cfg, row, rowNumber) {
  const values = cfg.headers.map((h) => toStr(row[h]));
  const endCol = columnToLetter(cfg.headers.length);

  if (rowNumber && Number.isInteger(rowNumber) && rowNumber >= 2) {
    const range = `'${escapeSheetTab(cfg.tab)}'!A${rowNumber}:${endCol}${rowNumber}`;
    await googleSheetsRequest(
      env,
      "PUT",
      `/values/${encodeURIComponent(range)}?valueInputOption=RAW`,
      { values: [values] }
    );
    return rowNumber;
  }

  const appendRange = `'${escapeSheetTab(cfg.tab)}'!A:${endCol}`;
  const result = await googleSheetsRequest(
    env,
    "POST",
    `/values/${encodeURIComponent(appendRange)}:append?valueInputOption=RAW&insertDataOption=INSERT_ROWS`,
    { values: [values] }
  );
  const updatedRange = toStr(result && result.updates && result.updates.updatedRange);
  return parseRowNumberFromRange(updatedRange);
}

async function validateHeaderRow(env, tab, headers) {
  const endCol = columnToLetter(headers.length);
  const range = `'${escapeSheetTab(tab)}'!A1:${endCol}1`;
  const existing = await googleSheetsRequest(env, "GET", `/values/${encodeURIComponent(range)}`);
  const actual = Array.isArray(existing.values) && existing.values[0] ? existing.values[0] : [];
  const expected = headers.map((h) => toStr(h));

  let mismatch = false;
  for (let i = 0; i < expected.length; i++) {
    if (toStr(actual[i]) !== expected[i]) {
      mismatch = true;
      break;
    }
  }
  if (!mismatch) return;

  await googleSheetsRequest(
    env,
    "PUT",
    `/values/${encodeURIComponent(range)}?valueInputOption=RAW`,
    { values: [expected] }
  );
}

async function validateManagedSheetHeaders(env) {
  const checks = Object.values(SHEET_ENTITY_CONFIG).map((cfg) => validateHeaderRow(env, cfg.tab, cfg.headers));
  await Promise.all(checks);
}

async function loadEntityRowsWithHeaderRepair(env, entity) {
  const cfg = SHEET_ENTITY_CONFIG[entity];
  if (!cfg) throw new Error("Unknown sheet entity");
  await validateHeaderRow(env, cfg.tab, cfg.headers);
  return getSheetRows(env, cfg.tab, { includeRowNumber: true });
}

async function loadEntityRowsWithoutHeaderRepair(env, entity) {
  const cfg = SHEET_ENTITY_CONFIG[entity];
  if (!cfg) throw new Error("Unknown sheet entity");
  return getSheetRows(env, cfg.tab, { includeRowNumber: true });
}

async function maybeRepairHeadersForCatalog(env) {
  // Keep automatic header repair, but throttle checks to avoid repeated writes.
  const now = Date.now();
  if (catalogHeaderRepairCache.lastCheckAtMs && catalogHeaderRepairCache.lastCheckAtMs + 120_000 > now) {
    return;
  }
  await validateManagedSheetHeaders(env);
  catalogHeaderRepairCache.lastCheckAtMs = now;
}

async function getCatalogSheetData(env) {
  const now = Date.now();
  if (
    catalogDataCache.barRows &&
    catalogDataCache.kmcRows &&
    catalogDataCache.chainTypeRows &&
    catalogDataCache.loadedAtMs + 30_000 > now
  ) {
    return {
      barRows: catalogDataCache.barRows,
      kmcRows: catalogDataCache.kmcRows,
      chainTypeRows: catalogDataCache.chainTypeRows,
    };
  }

  await maybeRepairHeadersForCatalog(env);
  const [barRows, kmcRows, chainTypeRows] = await Promise.all([
    getSheetRows(env, TAB_BAR_LENGTHS),
    getSheetRows(env, TAB_KMC_CHAINS),
    getSheetRows(env, TAB_CHAIN_TYPES),
  ]);

  catalogDataCache = {
    barRows,
    kmcRows,
    chainTypeRows,
    loadedAtMs: now,
  };

  return { barRows, kmcRows, chainTypeRows };
}

async function getLookupValues(env, opts = {}) {
  await ensureLookupSheetReady(env);
  await ensureLookupGroupsAssigned(env);
  const rows = await getSheetRows(env, TAB_LOOKUP_VALUES, { includeRowNumber: true });
  const fieldFilter = norm(opts.field || "");
  const groupFilter = normalizeLookupGroup(opts.group || "");
  const includeInactive = Boolean(opts.includeInactive);

  const filtered = rows.filter((row) => {
    const rowField = toStr(row.Field).trim();
    const rowValue = toStr(row.Value).trim();
    if (!rowField || !rowValue) return false;
    if (fieldFilter && norm(rowField) !== fieldFilter) return false;
    const rowGroup = normalizeLookupGroup(row.Group || "");
    if (groupFilter && rowGroup !== groupFilter) return false;
    const isActive = toStr(row.Active || "1").trim() !== "0";
    if (!includeInactive && !isActive) return false;
    return true;
  });

  filtered.sort((a, b) => {
    const ag = toStr(a.Group).localeCompare(toStr(b.Group), undefined, { sensitivity: "base" });
    if (ag !== 0) return ag;
    const af = toStr(a.Field).localeCompare(toStr(b.Field), undefined, { sensitivity: "base" });
    if (af !== 0) return af;
    const as = Number(a["Sort Order"] || 0);
    const bs = Number(b["Sort Order"] || 0);
    if (as !== bs) return as - bs;
    return toStr(a.Value).localeCompare(toStr(b.Value), undefined, { sensitivity: "base" });
  });

  return filtered.map((row) => ({
    field: toStr(row.Field),
    value: toStr(row.Value),
    active: toStr(row.Active || "1") !== "0" ? 1 : 0,
    sort_order: Number(row["Sort Order"] || 0),
    group: normalizeLookupGroup(row.Group || ""),
    __row: Number(row.__row || 0),
  }));
}

async function upsertLookupValue(env, input) {
  const cfg = {
    tab: TAB_LOOKUP_VALUES,
    headers: LOOKUP_HEADERS,
  };
  await ensureLookupSheetReady(env);
  const rows = await getSheetRows(env, cfg.tab, { includeRowNumber: true });

  const field = toStr(input.field).trim();
  const value = toStr(input.value).trim();
  const group = normalizeLookupGroup(input.group || "");
  const active = toStr(input.active || "1") === "0" ? "0" : "1";
  const sortOrder = Number(input.sortOrder || 0);

  let existingRowNumber = null;
  for (const row of rows) {
    if (
      norm(row.Field) === norm(field) &&
      norm(row.Value) === norm(value) &&
      normalizeLookupGroup(row.Group || "") === group
    ) {
      existingRowNumber = Number(row.__row || 0);
      break;
    }
  }

  return upsertSheetEntityRow(
    env,
    cfg,
    {
      Field: field,
      Value: value,
      Active: active,
      "Sort Order": String(sortOrder),
      Group: group,
    },
    existingRowNumber
  );
}

async function ensureLookupSheetReady(env) {
  try {
    await validateHeaderRow(env, TAB_LOOKUP_VALUES, LOOKUP_HEADERS);
  } catch (err) {
    if (String(err).includes("Unable to parse range")) {
      await createSheetIfMissing(env, TAB_LOOKUP_VALUES);
      await validateHeaderRow(env, TAB_LOOKUP_VALUES, LOOKUP_HEADERS);
      return;
    }
    throw err;
  }
}

async function ensureLookupGroupsAssigned(env) {
  const cfg = {
    tab: TAB_LOOKUP_VALUES,
    headers: LOOKUP_HEADERS,
  };
  const rows = await getSheetRows(env, TAB_LOOKUP_VALUES, { includeRowNumber: true });
  for (const row of rows) {
    const currentGroup = normalizeLookupGroup(row.Group || "");
    if (currentGroup) continue;
    const inferredGroup = inferLookupGroupFromField(toStr(row.Field));
    if (!inferredGroup) continue;
    const rowNumber = Number(row.__row || 0);
    if (!rowNumber) continue;
    await upsertSheetEntityRow(
      env,
      cfg,
      {
        Field: toStr(row.Field),
        Value: toStr(row.Value),
        Active: toStr(row.Active || "1"),
        "Sort Order": toStr(row["Sort Order"] || "0"),
        Group: inferredGroup,
      },
      rowNumber
    );
  }
}

async function migrateChainTypeCodes(env, opts = {}) {
  const dryRun = opts && opts.dryRun !== false;
  const maxUpdates = Math.max(0, Number(opts.maxUpdates || 0));
  const chainCfg = SHEET_ENTITY_CONFIG["chain-types"];
  const kmcCfg = SHEET_ENTITY_CONFIG["kmc-chains"];
  const barCfg = SHEET_ENTITY_CONFIG["bar-lengths"];

  const chainRows = await loadEntityRowsWithHeaderRepair(env, "chain-types");
  const kmcRows = await loadEntityRowsWithHeaderRepair(env, "kmc-chains");
  const barRows = await loadEntityRowsWithHeaderRepair(env, "bar-lengths");

  const sortedChainRows = [...chainRows].sort((a, b) => Number(a.__row || 0) - Number(b.__row || 0));
  const seqByPrefix = new Map();
  const oldToNewCode = new Map();
  const issues = [];
  const chainUpdates = [];

  for (const row of sortedChainRows) {
    const gauge = toStr(row.Gauge).trim();
    const pitch = toStr(row.Pitch).trim();
    const gaugeCode = getGaugeCode(gauge);
    const pitchCode = getPitchCode(pitch);
    const oldCodeRaw = toStr(row["Chain Type"]).trim();
    const oldCode = norm(oldCodeRaw);

    if (!gaugeCode || !pitchCode) {
      issues.push({
        tab: chainCfg.tab,
        row: Number(row.__row || 0),
        old_code: oldCodeRaw,
        gauge,
        pitch,
        reason: "Unsupported gauge/pitch for code mapping",
      });
      continue;
    }

    const prefix = `${gaugeCode}${pitchCode}`;
    const nextNum = (seqByPrefix.get(prefix) || 0) + 1;
    seqByPrefix.set(prefix, nextNum);
    const newCode = `${prefix}${String(nextNum).padStart(2, "0")}`;

    if (oldCode) {
      const existingMap = oldToNewCode.get(oldCode);
      if (existingMap && existingMap !== newCode) {
        issues.push({
          tab: chainCfg.tab,
          row: Number(row.__row || 0),
          old_code: oldCodeRaw,
          new_code: newCode,
          reason: `Ambiguous old code mapping (already mapped to ${existingMap})`,
        });
      } else {
        oldToNewCode.set(oldCode, newCode);
      }
    }

    if (oldCodeRaw !== newCode) {
      const updated = {};
      for (const h of chainCfg.headers) {
        updated[h] = toStr(row[h]);
      }
      updated["Chain Type"] = newCode;
      chainUpdates.push({
        rowNumber: Number(row.__row || 0),
        oldCode: oldCodeRaw,
        newCode,
        row: updated,
      });
    }
  }

  const kmcUpdates = [];
  for (const row of kmcRows) {
    const oldCodeRaw = toStr(row["Chain Type"]).trim();
    const mapped = oldToNewCode.get(norm(oldCodeRaw));
    if (!mapped || oldCodeRaw === mapped) continue;
    const updated = {};
    for (const h of kmcCfg.headers) {
      updated[h] = toStr(row[h]);
    }
    updated["Chain Type"] = mapped;
    const links = toStr(updated.Links).trim();
    updated["Type+Links"] = links ? `${mapped}-${links}` : mapped;
    kmcUpdates.push({
      rowNumber: Number(row.__row || 0),
      oldCode: oldCodeRaw,
      newCode: mapped,
      row: updated,
    });
  }

  const barUpdates = [];
  for (const row of barRows) {
    const oldCodeRaw = toStr(row["Chain Type Code"]).trim();
    const mapped = oldToNewCode.get(norm(oldCodeRaw));
    if (!mapped || oldCodeRaw === mapped) continue;
    const updated = {};
    for (const h of barCfg.headers) {
      updated[h] = toStr(row[h]);
    }
    updated["Chain Type Code"] = mapped;
    barUpdates.push({
      rowNumber: Number(row.__row || 0),
      oldCode: oldCodeRaw,
      newCode: mapped,
      row: updated,
    });
  }

  let appliedChain = 0;
  let appliedKmc = 0;
  let appliedBar = 0;
  const plan = [
    { cfg: chainCfg, list: chainUpdates, applied: "chain" },
    { cfg: kmcCfg, list: kmcUpdates, applied: "kmc" },
    { cfg: barCfg, list: barUpdates, applied: "bar" },
  ];
  if (!dryRun) {
    await validateHeaderRow(env, chainCfg.tab, chainCfg.headers);
    await validateHeaderRow(env, kmcCfg.tab, kmcCfg.headers);
    await validateHeaderRow(env, barCfg.tab, barCfg.headers);

    let remainingBudget = maxUpdates > 0 ? maxUpdates : Number.MAX_SAFE_INTEGER;
    for (const step of plan) {
      for (const u of step.list) {
        if (remainingBudget <= 0) break;
        await upsertSheetEntityRowNoHeaderCheck(env, step.cfg, u.row, u.rowNumber);
        remainingBudget--;
        if (step.applied === "chain") appliedChain++;
        if (step.applied === "kmc") appliedKmc++;
        if (step.applied === "bar") appliedBar++;
      }
      if (remainingBudget <= 0) break;
    }
  }

  return {
    ok: true,
    dryRun,
    maxUpdates,
    counts: {
      chain_types_updates: chainUpdates.length,
      kmc_chains_updates: kmcUpdates.length,
      bar_lengths_updates: barUpdates.length,
      issues: issues.length,
    },
    applied: {
      chain_types: appliedChain,
      kmc_chains: appliedKmc,
      bar_lengths: appliedBar,
      total: appliedChain + appliedKmc + appliedBar,
    },
    remaining: {
      chain_types: Math.max(0, chainUpdates.length - appliedChain),
      kmc_chains: Math.max(0, kmcUpdates.length - appliedKmc),
      bar_lengths: Math.max(0, barUpdates.length - appliedBar),
      total:
        Math.max(0, chainUpdates.length - appliedChain) +
        Math.max(0, kmcUpdates.length - appliedKmc) +
        Math.max(0, barUpdates.length - appliedBar),
    },
    samples: {
      chain_types: chainUpdates.slice(0, 15).map((u) => ({ row: u.rowNumber, old: u.oldCode, new: u.newCode })),
      kmc_chains: kmcUpdates.slice(0, 15).map((u) => ({ row: u.rowNumber, old: u.oldCode, new: u.newCode })),
      bar_lengths: barUpdates.slice(0, 15).map((u) => ({ row: u.rowNumber, old: u.oldCode, new: u.newCode })),
      issues: issues.slice(0, 25),
    },
  };
}

async function deleteSheetRow(env, tabName, rowNumber) {
  const sheetId = await getSheetIdByName(env, tabName);
  const body = {
    requests: [
      {
        deleteDimension: {
          range: {
            sheetId,
            dimension: "ROWS",
            startIndex: rowNumber - 1,
            endIndex: rowNumber,
          },
        },
      },
    ],
  };
  await googleSheetsRequest(env, "POST", ":batchUpdate", body);
}

async function getSheetIdByName(env, tabName) {
  const meta = await getSpreadsheetMeta(env);
  const sheets = meta.sheets || [];
  for (const sheet of sheets) {
    const p = sheet.properties || {};
    if (p.title === tabName) return p.sheetId;
  }
  throw new Error(`Sheet not found: ${tabName}`);
}

async function getSpreadsheetMeta(env) {
  const now = Date.now();
  if (spreadsheetMetaCache.meta && spreadsheetMetaCache.loadedAtMs + 60_000 > now) {
    return spreadsheetMetaCache.meta;
  }
  const meta = await googleSheetsRequest(env, "GET", "");
  spreadsheetMetaCache.meta = meta;
  spreadsheetMetaCache.loadedAtMs = now;
  return meta;
}

function parseRowNumberFromRange(a1Range) {
  const m = toStr(a1Range).match(/!(?:[A-Z]+)(\d+)/);
  return m ? Number(m[1]) : null;
}

function columnToLetter(columnNumber) {
  let n = Number(columnNumber);
  let col = "";
  while (n > 0) {
    const rem = (n - 1) % 26;
    col = String.fromCharCode(65 + rem) + col;
    n = Math.floor((n - 1) / 26);
  }
  return col || "A";
}

async function enforceChainTypeUniqueness(env, row, rowNumber) {
  const rows = await getSheetRows(env, TAB_CHAIN_TYPES, { includeRowNumber: true });
  const incomingSig = chainTypeSignature(row);
  if (!incomingSig) return;

  for (const existing of rows) {
    const existingRowNumber = Number(existing.__row || 0);
    if (rowNumber && existingRowNumber === rowNumber) continue;

    if (chainTypeSignature(existing) === incomingSig) {
      const existingCode = toStr(existing["Chain Type"]);
      throw new Error(
        `Duplicate chain type variables detected (existing code: ${existingCode || "unknown"}). ` +
        "This combination already exists; use Edit instead of creating a new chain type code."
      );
    }
  }
}

function chainTypeSignature(row) {
  const fields = [
    "Gauge",
    "Pitch",
    "Chisel Style",
    "ANSI Low Kickback",
    "Profile Class",
    "Kerf Type",
    "Sequence Type",
  ];
  return fields.map((f) => norm(row && row[f])).join("|");
}

async function enforceKmcChainUniqueness(env, row, rowNumber) {
  const rows = await getSheetRows(env, TAB_KMC_CHAINS, { includeRowNumber: true });
  const requiredFields = [
    "Gauge",
    "Pitch",
    "Chisel Style",
    "ANSI Low Kickback",
    "Profile Class",
    "Kerf Type",
    "Sequence Type",
    "Links",
    "Part Reference",
    "UPC",
    "URL",
  ];
  const missing = requiredFields.filter((f) => !toStr(row && row[f]).trim());
  if (missing.length) {
    throw new Error(`Missing required fields: ${missing.join(", ")}`);
  }
  const incomingPartRef = norm(row && row["Part Reference"]);
  const incomingUpc = normalizeUpc(row && row.UPC);
  const incomingSig = kmcChainRowSignature(row);

  if (incomingUpc && !isValidUpcA(incomingUpc)) {
    throw new Error("Invalid UPC code. Please enter a valid 12-digit UPC-A.");
  }

  for (const existing of rows) {
    const existingRowNumber = Number(existing.__row || 0);
    if (rowNumber && existingRowNumber === rowNumber) continue;

    if (incomingSig && incomingSig === kmcChainRowSignature(existing)) {
      throw new Error("Duplicate KMC chain row detected. This exact chain entry already exists.");
    }

    if (incomingPartRef && incomingPartRef === norm(existing["Part Reference"])) {
      throw new Error("Duplicate Part Reference detected. Part Reference must be unique.");
    }

    if (incomingUpc && incomingUpc === normalizeUpc(existing.UPC)) {
      throw new Error("Duplicate UPC detected. UPC must be unique.");
    }
  }
}

function kmcChainRowSignature(row) {
  const fields = [
    "Gauge",
    "Pitch",
    "Chisel Style",
    "ANSI Low Kickback",
    "Profile Class",
    "Kerf Type",
    "Sequence Type",
    "Links",
    "Part Reference",
    "UPC",
    "URL",
  ];
  return fields.map((f) => norm(row && row[f])).join("|");
}

function normalizeUpc(value) {
  return toStr(value).replace(/\D/g, "");
}

function normalizeLookupGroup(value) {
  return toStr(value).trim().toLowerCase();
}

function getGaugeCode(gaugeValue) {
  const key = normalizeGaugeForCode(gaugeValue);
  return CHAIN_TYPE_GAUGE_CODE_MAP.get(key) || "";
}

function getPitchCode(pitchValue) {
  const key = normalizePitchForCode(pitchValue);
  return CHAIN_TYPE_PITCH_CODE_MAP.get(key) || "";
}

function normalizeGaugeForCode(value) {
  let v = toStr(value).trim().toLowerCase();
  v = v.replace(/\s+/g, "");
  if (v === '0.043"') return '.043"';
  if (v === '0.050"') return '.050"';
  if (v === '0.05"') return '.05"';
  if (v === '0.058"') return '.058"';
  if (v === '0.063"') return '.063"';
  return v;
}

function normalizePitchForCode(value) {
  let v = toStr(value).trim().toLowerCase();
  v = v.replace(/\s+/g, " ");
  v = v.replace(/\s*lp$/i, ' lp');
  if (v === '0.325"') return '.325"';
  return v;
}

function inferLookupGroupFromField(field) {
  const f = toStr(field).trim();
  if (!f) return "";
  if (CHAIN_TYPE_LOOKUP_FIELDS.has(f)) return "chain-types";
  if (BAR_LENGTH_LOOKUP_FIELDS.has(f)) return "bar-lengths";
  return "";
}

function isValidUpcA(upcDigits) {
  const digits = toStr(upcDigits).replace(/\D/g, "");
  if (digits.length !== 12) return false;
  let oddSum = 0;
  let evenSum = 0;
  for (let i = 0; i < 11; i++) {
    const n = Number(digits[i]);
    if (!Number.isFinite(n)) return false;
    if (i % 2 === 0) oddSum += n;
    else evenSum += n;
  }
  const check = (10 - ((oddSum * 3 + evenSum) % 10)) % 10;
  return check === Number(digits[11]);
}

async function getSheetRows(env, tabName, opts = {}) {
  const range = `'${escapeSheetTab(tabName)}'!A1:ZZ`;
  const data = await googleSheetsRequest(env, "GET", `/values/${encodeURIComponent(range)}`);
  const rows = Array.isArray(data.values) ? data.values : [];
  if (rows.length === 0) return [];

  const headers = rows[0].map((h) => toStr(h).trim());
  const out = [];

  for (let i = 1; i < rows.length; i++) {
    const row = rows[i];
    const obj = {};
    for (let j = 0; j < headers.length; j++) {
      if (!headers[j]) continue;
      obj[headers[j]] = toStr(row[j]);
    }
    const nonEmpty = Object.values(obj).some((v) => toStr(v).trim().length > 0);
    if (!nonEmpty) continue;
    if (opts.includeRowNumber) obj.__row = i + 1;
    out.push(obj);
  }

  return out;
}

async function googleSheetsRequest(env, method, path, body) {
  assertGoogleConfig(env);
  const token = await getGoogleAccessToken(env);
  const base = `https://sheets.googleapis.com/v4/spreadsheets/${env.GOOGLE_SHEET_ID}`;
  const url = `${base}${path}`;

  const headers = {
    Authorization: `Bearer ${token}`,
  };

  const init = {
    method,
    headers,
  };

  if (body !== undefined) {
    headers["Content-Type"] = "application/json";
    init.body = JSON.stringify(body);
  }

  const res = await fetch(url, init);
  const text = await res.text();
  const jsonBody = text ? safeJsonParse(text) : {};

  if (!res.ok) {
    throw new Error(`Google Sheets API ${res.status}: ${text}`);
  }

  return jsonBody;
}

async function getGoogleAccessToken(env) {
  const now = Date.now();
  if (googleTokenCache.accessToken && googleTokenCache.expiresAtMs - 60_000 > now) {
    return googleTokenCache.accessToken;
  }

  assertGoogleConfig(env);
  const sa = safeJsonParse(env.GOOGLE_SERVICE_ACCOUNT_JSON);
  if (!sa || !sa.client_email || !sa.private_key) {
    throw new Error("Invalid GOOGLE_SERVICE_ACCOUNT_JSON");
  }

  const jwt = await createServiceAccountJwt(sa.client_email, sa.private_key, [
    "https://www.googleapis.com/auth/spreadsheets",
    "https://www.googleapis.com/auth/drive",
  ]);

  const body = new URLSearchParams({
    grant_type: "urn:ietf:params:oauth:grant-type:jwt-bearer",
    assertion: jwt,
  });

  const res = await fetch("https://oauth2.googleapis.com/token", {
    method: "POST",
    headers: {
      "Content-Type": "application/x-www-form-urlencoded",
    },
    body,
  });

  const tokenJson = await res.json();
  if (!res.ok || !tokenJson.access_token) {
    throw new Error(`Google token error: ${JSON.stringify(tokenJson)}`);
  }

  googleTokenCache.accessToken = tokenJson.access_token;
  googleTokenCache.expiresAtMs = now + Number(tokenJson.expires_in || 3600) * 1000;
  return googleTokenCache.accessToken;
}

async function createServiceAccountJwt(clientEmail, privateKeyPem, scopes) {
  const nowSec = Math.floor(Date.now() / 1000);
  const header = { alg: "RS256", typ: "JWT" };
  const claim = {
    iss: clientEmail,
    scope: scopes.join(" "),
    aud: "https://oauth2.googleapis.com/token",
    exp: nowSec + 3600,
    iat: nowSec,
  };

  const enc = new TextEncoder();
  const headerB64 = base64UrlEncode(enc.encode(JSON.stringify(header)));
  const claimB64 = base64UrlEncode(enc.encode(JSON.stringify(claim)));
  const signingInput = `${headerB64}.${claimB64}`;

  const keyData = pemToArrayBuffer(privateKeyPem);
  const cryptoKey = await crypto.subtle.importKey(
    "pkcs8",
    keyData,
    {
      name: "RSASSA-PKCS1-v1_5",
      hash: "SHA-256",
    },
    false,
    ["sign"]
  );

  const sig = await crypto.subtle.sign("RSASSA-PKCS1-v1_5", cryptoKey, enc.encode(signingInput));
  const sigB64 = base64UrlEncode(new Uint8Array(sig));
  return `${signingInput}.${sigB64}`;
}

function pemToArrayBuffer(pem) {
  const clean = pem
    .replace("-----BEGIN PRIVATE KEY-----", "")
    .replace("-----END PRIVATE KEY-----", "")
    .replace(/\s+/g, "");

  const binary = atob(clean);
  const bytes = new Uint8Array(binary.length);
  for (let i = 0; i < binary.length; i++) {
    bytes[i] = binary.charCodeAt(i);
  }
  return bytes.buffer;
}

function base64UrlEncode(data) {
  let bytes;
  if (data instanceof Uint8Array) {
    bytes = data;
  } else if (data instanceof ArrayBuffer) {
    bytes = new Uint8Array(data);
  } else {
    bytes = new Uint8Array(data);
  }

  let binary = "";
  for (let i = 0; i < bytes.length; i++) {
    binary += String.fromCharCode(bytes[i]);
  }

  return btoa(binary).replace(/\+/g, "-").replace(/\//g, "_").replace(/=+$/g, "");
}

function assertGoogleConfig(env) {
  if (!env.GOOGLE_SHEET_ID) {
    throw new Error("Missing GOOGLE_SHEET_ID env var");
  }
  if (!env.GOOGLE_SERVICE_ACCOUNT_JSON) {
    throw new Error("Missing GOOGLE_SERVICE_ACCOUNT_JSON env var");
  }
}

function dedupePathKeys(keys) {
  return dedupeByKey(keys, (k) => `${norm(k.pitch)}|${norm(k.gauge)}|${norm(k.driveLinks)}`);
}

function buildChainTypeMap(rows) {
  const map = new Map();
  for (const row of rows || []) {
    const code = norm(row["Chain Type"]);
    if (!code) continue;
    map.set(code, {
      pitch: row.Pitch,
      gauge: row.Gauge,
      chisel_style: row["Chisel Style"],
      ansi_low_kickback: row["ANSI Low Kickback"],
      profile_class: row["Profile Class"],
      kerf_type: row["Kerf Type"],
      sequence_type: row["Sequence Type"],
    });
  }
  return map;
}

function dedupeByKey(arr, keyFn) {
  const seen = new Set();
  const out = [];
  for (const item of arr) {
    const key = keyFn(item);
    if (seen.has(key)) continue;
    seen.add(key);
    out.push(item);
  }
  return out;
}

function uniqueSorted(values) {
  return Array.from(new Set(values.map((v) => toStr(v).trim()).filter(Boolean))).sort((a, b) =>
    a.localeCompare(b, undefined, { sensitivity: "base" })
  );
}

function uniqueSortedByNumericPrefix(values) {
  const unique = Array.from(new Set(values.map((v) => toStr(v).trim()).filter(Boolean)));
  unique.sort((a, b) => {
    const na = numericPrefix(a);
    const nb = numericPrefix(b);
    if (na !== null && nb !== null && na !== nb) return na - nb;
    if (na !== null && nb === null) return -1;
    if (na === null && nb !== null) return 1;
    return a.localeCompare(b, undefined, { sensitivity: "base" });
  });
  return unique;
}

function numericPrefix(input) {
  const m = toStr(input).match(/^\s*(\d+(?:\.\d+)?)/);
  return m ? Number(m[1]) : null;
}

function toStr(v) {
  if (v === null || v === undefined) return "";
  return String(v);
}

function norm(v) {
  return toStr(v).trim().toLowerCase();
}

function eqNorm(a, b) {
  return norm(a) === norm(b);
}

function sameDriveLinks(a, b) {
  const na = normalizeDriveLinks(a);
  const nb = normalizeDriveLinks(b);
  if (na && nb) return na === nb;
  return eqNorm(a, b);
}

function normalizeDriveLinks(value) {
  const raw = toStr(value).trim();
  if (!raw) return "";

  const numeric = raw.match(/-?\d+(?:\.\d+)?/);
  if (numeric) {
    const n = Number(numeric[0]);
    if (Number.isFinite(n)) return Number.isInteger(n) ? String(n) : String(n);
  }

  return norm(raw);
}

function escapeSheetTab(name) {
  return toStr(name).replace(/'/g, "''");
}

function safeJsonParse(text) {
  try {
    return JSON.parse(text);
  } catch {
    return null;
  }
}

function json(data, status = 200) {
  return cors(
    new Response(JSON.stringify(data), {
      status,
      headers: { "Content-Type": "application/json" },
    })
  );
}

function cors(response) {
  response.headers.set("Access-Control-Allow-Origin", "*");
  response.headers.set("Access-Control-Allow-Methods", "GET, POST, DELETE, OPTIONS");
  response.headers.set("Access-Control-Allow-Headers", "Content-Type, x-admin-token, x-hub-session, Authorization");
  return response;
}

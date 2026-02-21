# Cloudflare CRM (Workers + Pages + D1 + R2)

A web CRM scaffold with:
- Company-first UX (A-Z list + search)
- Company records with location fields (`city`, `state`, `zip`) and multi-rep assignment
- Customer contacts linked to companies
- Employee/sales rep directory
- Interaction tracking (notes, next actions)
- Collapsible company detail sections (company info, contacts, interactions)
- Manager/admin rep territory rules by city/state/zip
- Attachment uploads (documents/photos) stored in R2
- Login + session-based auth + role management in D1

## Project layout

- `worker/`: API running on Cloudflare Workers
- `worker/migrations/`: D1 schema migrations
- `pages/`: static frontend for Cloudflare Pages

## 1) Create Cloudflare resources

1. Create D1 database: `crm-db`
2. Create R2 bucket: `crm-files`
3. Update `worker/wrangler.toml` with your `database_id`

## 2) Worker setup

```bash
cd /Users/gregoriodeharo/Documents/New\ project/crm-cloudflare/worker
npm install
npx wrangler d1 migrations apply CRM_DB --local
npx wrangler d1 migrations apply CRM_DB --remote
npx wrangler deploy
```

## 3) Pages setup

Deploy `/Users/gregoriodeharo/Documents/New project/crm-cloudflare/pages` as a Pages project.

Recommended production routing:
- Host Pages on your main domain
- Route `/api/*` to this Worker so frontend + API share origin

If you host API on a separate domain, define before `app.js`:

```html
<script>
  window.CRM_API_BASE = "https://your-worker-domain.workers.dev";
</script>
```

## 4) First login

1. Open the app.
2. Use **Initial Admin Setup** once.
3. Log in with that admin user.
4. Use company list search to open company detail pages.
5. Managers/admins can open **Manage Reps** to define territory rules.

## Roles

- `admin`: full access (includes user management)
- `manager`: CRM data write access
- `rep`: CRM data write access
- `viewer`: read-only

## Notes

- File contents live in R2, metadata lives in D1 `attachments`.
- Core tables include soft-delete columns (`deleted_at`) for future lifecycle policies.
- If you pull new backend changes, re-run migrations:
  - `npx wrangler d1 migrations apply CRM_DB --local`
  - `npx wrangler d1 migrations apply CRM_DB --remote`

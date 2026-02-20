# Cloudflare CRM (Workers + Pages + D1 + R2)

A web CRM scaffold with:
- Company records and multi-rep assignment
- Customer contacts linked to companies
- Employee/sales rep directory
- Interaction tracking (notes, next actions)
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
4. Create additional users and roles in **User and Role Management**.

## Roles

- `admin`: full access (includes user management)
- `manager`: CRM data write access
- `rep`: CRM data write access
- `viewer`: read-only

## Notes

- File contents live in R2, metadata lives in D1 `attachments`.
- Core tables include soft-delete columns (`deleted_at`) for future lifecycle policies.
- Reporting can be added later from D1 (interactions by rep, company activity, follow-up due reports).

# CRM Backup/Restore Runbook

## Scope
- Worker: `crm-api`
- Database: `CRM_DB` (D1)
- Files: `CRM_FILES` (R2)

## Preconditions
- Logged in to correct Cloudflare account: `npx wrangler whoami`
- Correct project dir: `cd crm-cloudflare/worker`
- Keep backups in a private location.

## D1 Backup
1. Create a timestamped backup directory.
2. Export schema/data from remote D1.

```bash
cd "/Users/gregoriodeharo/Documents/New project/crm-cloudflare/worker"
mkdir -p ../backups
TS=$(date +"%Y%m%d-%H%M%S")

# Preferred if supported by your Wrangler version
npx wrangler d1 export CRM_DB --remote --output "../backups/crm-db-$TS.sql"
```

If your Wrangler version does not support `d1 export`, use Cloudflare Dashboard D1 export for `crm-db` and store the SQL file under `crm-cloudflare/backups/`.

## R2 Backup
Use the Cloudflare Dashboard for bucket export/sync, or your approved internal object-storage sync tooling.

Minimum requirement:
- Record backup timestamp.
- Record object count.
- Record total bytes.

## Restore to Test/Staging First
Never restore directly to production first.

1. Create a fresh D1 database.
2. Point a staging worker binding to that DB.
3. Apply schema/data import.

```bash
# Example import command (adjust DB binding/name)
npx wrangler d1 execute CRM_DB --remote --file ../backups/crm-db-YYYYMMDD-HHMMSS.sql
```

4. Validate:
- login works
- company list loads
- contact detail loads
- interaction create/update works
- admin panel and territories load

## Production Restore (Only if validated)
1. Confirm maintenance window.
2. Announce read-only/downtime period.
3. Apply restore file to production DB.
4. Validate critical paths.
5. Close incident with timestamp and operator notes.

## Post-Backup Verification Checklist
- SQL backup file exists and is non-empty.
- Backup file checksum recorded.
- R2 backup evidence captured.
- Restore test completed in staging at least once.

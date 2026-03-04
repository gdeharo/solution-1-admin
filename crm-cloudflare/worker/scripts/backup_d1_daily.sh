#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

BACKUP_DIR="${ROOT_DIR}/backups"
STAMP="$(date +"%Y-%m-%d_%H-%M-%S")"
OUT_FILE="${BACKUP_DIR}/crm-db-${STAMP}.sql"

mkdir -p "$BACKUP_DIR"

echo "Creating D1 backup: ${OUT_FILE}"
npx wrangler d1 export CRM_DB --remote --output "${OUT_FILE}"

echo "Backup complete: ${OUT_FILE}"

# Retain only the latest 30 backups.
ls -1t "${BACKUP_DIR}"/crm-db-*.sql 2>/dev/null | tail -n +31 | xargs -r rm -f

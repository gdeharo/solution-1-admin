#!/usr/bin/env bash
set -euo pipefail

# New domains
NEW_ADMIN_DOMAIN="chain.rft-cloud.com"
NEW_API_DOMAIN="api.rtf-cloud.com"

# Domains/hosts to replace
OLD_API_HOSTS=(
  "product-selector-api.gdeharo.workers.dev"
  "product-selector-api\\.gdeharo\\.workers\\.dev"
)

OLD_ADMIN_HOSTS=(
  "solution-1-admin.pages.dev"
  "solution-1-admin\\.pages\\.dev"
)

# File list (only update files that exist)
CANDIDATES=(
  "index.html"
  "chain-finder-settings/index.html"
  "chainsaw-chain-finder/index.html"
  "embed-snippets/index.html"
  "product-selector-api/index.html"
  "product-selector-api/chain-finder-settings.html"
  "product-selector-api/chain-finder-settings/index.html"
  "product-selector-api/chainsaw-chain-finder/index.html"
  "product-selector-api/embed-snippets/index.html"
)

FILES=()
for f in "${CANDIDATES[@]}"; do
  [[ -f "$f" ]] && FILES+=("$f")
done

if [[ ${#FILES[@]} -eq 0 ]]; then
  echo "No target files found."
  exit 1
fi

echo "Updating files:"
printf ' - %s\n' "${FILES[@]}"

# Replace API URLs
for f in "${FILES[@]}"; do
  perl -0777 -i -pe "s#https://product-selector-api\\.gdeharo\\.workers\\.dev#https://${NEW_API_DOMAIN}#g" "$f"
  perl -0777 -i -pe "s#product-selector-api\\.gdeharo\\.workers\\.dev#${NEW_API_DOMAIN}#g" "$f"

  # Replace admin URL references if any
  perl -0777 -i -pe "s#https://solution-1-admin\\.pages\\.dev#https://${NEW_ADMIN_DOMAIN}#g" "$f"
  perl -0777 -i -pe "s#solution-1-admin\\.pages\\.dev#${NEW_ADMIN_DOMAIN}#g" "$f"
done

echo
echo "Done. Quick verification:"
grep -RInE "gdeharo\\.workers\\.dev|solution-1-admin\\.pages\\.dev" "${FILES[@]}" || true
grep -RInE "${NEW_API_DOMAIN}|${NEW_ADMIN_DOMAIN}" "${FILES[@]}" | head -n 40 || true

#!/usr/bin/env bash
# web_lookup.sh <ip_or_domain>
set -o errexit
set -o pipefail
set -o nounset

source "$(dirname "$0")/helper.sh"

if [ $# -lt 1 ]; then
  echo "Usage: $0 <ip_or_domain>"
  exit 2
fi

TARGET="$1"
OUTDIR="results/web_lookup_${TARGET}_$(date +%Y%m%d%H%M%S)"
mkdir -p "$OUTDIR" logs

LOGFILE="logs/web_lookup.log"
echo "$(date --iso-8601=seconds) | web_lookup.sh | INFO | Querying threat intel for ${TARGET}" >> "${LOGFILE}"

# Example: AbuseIPDB (requires ABUSEIPDB_KEY env var)
if [ -n "${ABUSEIPDB_KEY:-}" ]; then
  curl -s -G "https://api.abuseipdb.com/api/v2/check" \
    --data-urlencode "ipAddress=${TARGET}" \
    -H "Key: ${ABUSEIPDB_KEY}" -H "Accept: application/json" \
    > "${OUTDIR}/abuseipdb.json" || true
else
  echo "$(date --iso-8601=seconds) | web_lookup.sh | WARN | ABUSEIPDB_KEY not set" >> "${LOGFILE}"
fi

echo "$(date --iso-8601=seconds) | web_lookup.sh | INFO | Lookup complete for ${TARGET}" >> "${LOGFILE}"
echo "${OUTDIR}"

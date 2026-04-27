#!/usr/bin/env bash
# recon.sh <target> [output_dir]
set -o errexit
set -o pipefail
set -o nounset

source "$(dirname "$0")/helper.sh"

if [ $# -lt 1 ]; then
  echo "Usage: $0 <target> [output_dir]"
  exit 2
fi

TARGET="$1"
OUTDIR="${2:-results/recon_${TARGET}_$(date +%Y%m%d%H%M%S)}"
mkdir -p "$OUTDIR" logs results

LOGFILE="logs/recon.log"
echo "$(date --iso-8601=seconds) | recon.sh | INFO | Starting recon for ${TARGET}" >> "${LOGFILE}"

# DNS
dig +short "$TARGET" > "${OUTDIR}/dns.txt" 2>/dev/null || true

# WHOIS
if command -v whois >/dev/null 2>&1; then
  whois "$TARGET" > "${OUTDIR}/whois.txt" 2>/dev/null || true
fi

# HTTP headers
if command -v curl >/dev/null 2>&1; then
  curl -sI "http://${TARGET}" > "${OUTDIR}/http_headers.txt" || true
fi

# nmap (if available)
if command -v nmap >/dev/null 2>&1; then
  nmap -sV -Pn "$TARGET" -oN "${OUTDIR}/nmap.txt" || true
else
  echo "$(date --iso-8601=seconds) | recon.sh | WARN | nmap not installed" >> "${LOGFILE}"
fi

echo "$(date --iso-8601=seconds) | recon.sh | INFO | Recon complete for ${TARGET}" >> "${LOGFILE}"
echo "${OUTDIR}"

set -o errexit
set -o pipefail
set -o nounset

LOGFILE="logs/bash_helper.log"

log() {
  local level="$1"; shift
  local msg="$*"
  echo "$(date --iso-8601=seconds) | helper.sh | ${level} | ${msg}" >> "${LOGFILE}"
}

retry() {
  local -r -i max_attempts="${1}"; shift
  local -r cmd="${*}"
  local -i attempt=1
  local -i delay=2
  until $cmd; do
    if (( attempt == max_attempts )); then
      log "ERROR" "Command failed after ${attempt} attempts: ${cmd}"
      return 1
    fi
    log "WARN" "Attempt ${attempt} failed. Retrying in ${delay}s..."
    sleep $delay
    attempt=$(( attempt + 1 ))
    delay=$(( delay * 2 ))
  done
  return 0
}

#!/usr/bin/env bash
set -euo pipefail

# Source the logging library (supports --file-name flag)
source "$(dirname "$0")/log.sh" --file-name "generate-password.log"

MIN_LENGTH=8

usage() {
  echo "Usage: $0 <password_length> [<number_of_passwords>]"
  exit 1
}

# -------------------------------------------------------------------------
# Validate input
# -------------------------------------------------------------------------
if [ "$#" -lt 1 ]; then
  log "ERROR: Missing required argument <password_length>"
  usage
fi

LENGTH="$1"
COUNT="${2:-1}"

if ! [[ "$LENGTH" =~ ^[0-9]+$ ]]; then
  log "ERROR: Password length must be numeric (got '$LENGTH')"
  exit 1
fi

if [ "$LENGTH" -lt "$MIN_LENGTH" ]; then
  log "ERROR: Password length must be at least $MIN_LENGTH"
  exit 1
fi

log "INFO: Generating $COUNT password(s) of length $LENGTH"

# -------------------------------------------------------------------------
# Safe, escaped character set
# -------------------------------------------------------------------------
# Important:
# - ']' must come first if used.
# - '-' must be either first or last or escaped to avoid range expansion.
# - Avoid unescaped backslashes.
# -------------------------------------------------------------------------
CHARSET=']A-Za-z0-9!@#$%^&*()_+=?'

# -------------------------------------------------------------------------
# Generate passwords
# -------------------------------------------------------------------------
for i in $(seq 1 "$COUNT"); do
  LC_ALL=C tr -dc "$CHARSET" < /dev/urandom | head -c "$LENGTH" || true
  echo
done

log "INFO: Done generating password(s)"

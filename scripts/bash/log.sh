#!/usr/bin/env bash
set -euo pipefail

USER_HOME="${SUDO_USER:+/home/$SUDO_USER}"
USER_HOME="${USER_HOME:-$HOME}"

# Default log filename (basename of the calling script)
DEFAULT_LOGFILE="$(basename "${BASH_SOURCE[1]}").log"

# Parse flags
LOG_NAME="$DEFAULT_LOGFILE"
while [[ $# -gt 0 ]]; do
  case "$1" in
    --file-name)
      if [[ -n "${2-}" ]]; then
        LOG_NAME="$2"
        shift 2
      else
        echo "Error: --file-name requires an argument" >&2
        exit 1
      fi
      ;;
    --) shift; break ;;
    *) break ;;
  esac
done

LOG_DIR="$USER_HOME/Projects/System-Critical-Services/.logs"
LOG_FILE="$LOG_DIR/$LOG_NAME"

mkdir -p "$LOG_DIR"

log() {
  local msg="$1"
  echo -e "[$(date '+%Y-%m-%d %H:%M:%S')] $msg" | tee -a "$LOG_FILE"
}

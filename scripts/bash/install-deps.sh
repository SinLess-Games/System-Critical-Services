#!/usr/bin/env bash
set -euo pipefail

# ------------------------------------------------------------------------------
# Environment setup
# ------------------------------------------------------------------------------
source "$(dirname "$0")/log.sh"

log "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
log "🛠️  Starting dependency installation for System-Critical-Services"
log "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# ------------------------------------------------------------------------------
# 1. Update repositories
# ------------------------------------------------------------------------------
log "🔧 Updating apt repositories..."
sudo apt-get update -y | tee -a "$LOG_FILE"

# ------------------------------------------------------------------------------
# 2. Install Docker safely (handle containerd conflict)
# ------------------------------------------------------------------------------
log "🐋 Checking Docker installation..."
if ! command -v docker &>/dev/null; then
  log "Installing Docker and Compose plugin..."
  sudo apt-get install -y ca-certificates curl gnupg lsb-release | tee -a "$LOG_FILE"
  sudo install -m 0755 -d /etc/apt/keyrings
  if [ ! -f /etc/apt/keyrings/docker.gpg ]; then
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor \
      -o /etc/apt/keyrings/docker.gpg
  fi
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
    https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" |
    sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
  sudo apt-get update -y | tee -a "$LOG_FILE"

  if dpkg -l | grep -q containerd.io; then
    log "Removing conflicting package containerd.io..."
    sudo apt-get remove -y containerd.io | tee -a "$LOG_FILE"
  fi

  sudo apt-get install -y docker-ce docker-ce-cli containerd docker-compose-plugin | tee -a "$LOG_FILE"
  sudo usermod -aG docker "${SUDO_USER:-$USER}" || true
  log "✅ Docker installed successfully."
else
  log "Docker already installed — skipping."
fi

# ------------------------------------------------------------------------------
# 3. Install Homebrew (skip if root)
# ------------------------------------------------------------------------------
log "🍺 Checking Homebrew..."
if ! command -v brew &>/dev/null; then
  if [ "$(id -u)" -eq 0 ]; then
    log "⚠️  Running as root — skipping Homebrew (cannot install as root)."
  else
    log "Installing Homebrew (Linuxbrew)..."
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> "$USER_HOME/.bashrc"
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    log "✅ Homebrew installed successfully."
  fi
else
  log "Homebrew already installed — skipping."
fi

# ------------------------------------------------------------------------------
# 4. Install SOPS & age
# ------------------------------------------------------------------------------
log "🔐 Checking SOPS and age..."
if ! command -v sops &>/dev/null; then
  if command -v brew &>/dev/null; then
    log "Installing SOPS and age via Homebrew..."
    brew install sops age | tee -a "$LOG_FILE"
  else
    log "Installing SOPS and age via apt..."
    sudo apt-get install -y sops age | tee -a "$LOG_FILE"
  fi
else
  log "SOPS and age already installed — skipping."
fi

# ------------------------------------------------------------------------------
# 5. Python venv for templating tools (jinja2-cli + PyYAML)
# ------------------------------------------------------------------------------
log "🐍 Ensuring Python3 and modules..."
cd "$USER_HOME"

# Create venv if missing
if [ ! -d "$USER_HOME/.venv" ]; then
  python3 -m venv "$USER_HOME/.venv"
fi

# Activate venv and install without --user
source "$USER_HOME/.venv/bin/activate"
unset PIP_USER  # prevent "--user" installs inside venv
pip install --upgrade pip >/dev/null 2>&1
pip install jinja2-cli PyYAML >/dev/null 2>&1
deactivate

log "✅ Python virtual environment ready at $USER_HOME/.venv"


# ------------------------------------------------------------------------------
# 6. Secrets setup
# ------------------------------------------------------------------------------
log "🗝️ Setting up secrets directory..."
cd "$OLDPWD"
mkdir -p secrets
if [ ! -f secrets/env.sops.yaml ]; then
  cp secrets/env.sops.example.yaml secrets/env.sops.yaml
  export SOPS_AGE_KEY_FILE="${SOPS_AGE_KEY_FILE:-$USER_HOME/.age.key}"
  if [ -f "$SOPS_AGE_KEY_FILE" ]; then
    log "Encrypting secrets/env.sops.yaml with age key..."
    sops --encrypt --in-place secrets/env.sops.yaml
    log "✅ Secrets encrypted successfully."
  else
    log "⚠️  Age key not found at $SOPS_AGE_KEY_FILE — skipping encryption."
  fi
else
  log "Encrypted secrets file already exists — skipping."
fi

# ------------------------------------------------------------------------------
# 7. Summary
# ------------------------------------------------------------------------------
log "🎉 Dependencies installation completed successfully!"
log "📜 Log saved to: $LOG_FILE"
log "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

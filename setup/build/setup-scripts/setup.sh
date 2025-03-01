#!/bin/bash

# Logging functions
log_info() {
    echo -e "\033[0;32m[INFO]\033[0m $1"
}

log_warning() {
    echo -e "\033[0;33m[WARNING]\033[0m $1"
}

log_error() {
    echo -e "\033[0;31m[ERROR]\033[0m $1"
}

# Ensure script is run as root
if [ "$EUID" -ne 0 ]; then
    log_error "This script must be run as root. Exiting."
    exit 1
fi

log_info "Starting setup process..."

# Update and install necessary packages
log_info "Updating package lists and installing required dependencies..."
apt-get update && apt-get install -y \
    curl \
    wget \
    gnupg \
    lsb-release \
    ca-certificates \
    software-properties-common \
    unzip \
    git \
    nano \
    vim \
    jq \
    sudo

log_info "Setup completed successfully."

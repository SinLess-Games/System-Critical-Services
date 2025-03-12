#!/bin/bash
# setup/build/setup-scripts/setup.sh

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

# Update package lists and install required dependencies
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
    sudo \
    docker-compose

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    log_error "Docker is not installed. Please install Docker first."
    exit 1
fi

# Define directories containing docker-compose files
compose_dirs=(
    "management/gitlab"
    "management/homepage"
    "management/watchtower"
    "networking/cloudflared"
    "networking/powerdns"
    "networking/proxmox-lb"
    "networking/unifi"
    "networking/wireguard"
    "observability/grafana"
    "observability/influx-db"
)

# Loop through each directory and bring up the Docker Compose stack
for dir in "${compose_dirs[@]}"; do
    if [ -f "$dir/docker-compose.yaml" ]; then
        log_info "Processing docker-compose in $dir..."
        if [ -f "$dir/.env" ]; then
            log_info "Using environment file $dir/.env"
            docker-compose -f "$dir/docker-compose.yaml" --env-file "$dir/.env" up -d
        else
            log_warning "No .env file found in $dir, proceeding without --env-file"
            docker-compose -f "$dir/docker-compose.yaml" up -d
        fi
    else
        log_warning "No docker-compose.yaml found in $dir, skipping..."
    fi
done

log_info "Setup process completed successfully."

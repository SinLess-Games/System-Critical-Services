#!/bin/bash
# setup/build/setup-scripts/setup.sh

############################################
# Logging functions
############################################
log_info() {
    echo -e "\033[0;32m[INFO]\033[0m $1"
}

log_warning() {
    echo -e "\033[0;33m[WARNING]\033[0m $1"
}

log_error() {
    echo -e "\033[0;31m[ERROR]\033[0m $1"
}

############################################
# Ensure script is run as root
############################################
# if [ "$EUID" -ne 0 ]; then
#     log_error "This script must be run as root. Exiting."
#     exit 1
# fi

log_info "Starting setup process..."

############################################
# Update package lists and install dependencies
############################################
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

############################################
# Check Docker installation
############################################
if ! command -v docker &> /dev/null; then
    log_error "Docker is not installed. Please install Docker first."
    exit 1
fi

############################################
# Directories containing docker-compose files
############################################
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

############################################
# Function: create_cert_packages
# Generate self-signed CA and server certs in each directory
############################################
create_cert_packages() {
    for dir in "${compose_dirs[@]}"; do
        app_name=$(basename "$dir")
        log_warning "App: $app_name"
        sleep 20
        cert_dir="./$dir/certs"

        log_info "Creating certificates for $app_name in $cert_dir"
        mkdir -p "$cert_dir"

        # Generate CA key and certificate
        openssl req -new -x509 -days 3650 -nodes \
            -subj "/CN=${app_name}-CA" \
            -keyout "$cert_dir/ca-key.pem" \
            -out "$cert_dir/ca.pem"

        # Generate server key and CSR
        openssl req -newkey rsa:2048 -nodes -keyout "$cert_dir/server-key.pem" \
            -subj "/CN=$app_name" \
            -out "$cert_dir/server-req.pem"

        # Sign the server certificate with the CA
        openssl x509 -req -in "$cert_dir/server-req.pem" \
            -CA "$cert_dir/ca.pem" -CAkey "$cert_dir/ca-key.pem" -CAcreateserial \
            -out "$cert_dir/server-cert.pem" -days 3650

        # Set secure permissions
        chmod 600 "$cert_dir/server-key.pem"
        chmod 644 "$cert_dir/server-cert.pem" "$cert_dir/ca.pem"

        log_info "Certificates created in $cert_dir"
    done
}

############################################
# Generate certificates
############################################
create_cert_packages

############################################
# Bring up Docker Compose stacks
############################################
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

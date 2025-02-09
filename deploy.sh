#!/bin/bash

# Utility functions
RED='\033[0;31m'
GREEN='\033[0;32m'
RESET='\033[0m'
BOLD='\033[1m'

Log_info() {
    echo -e "${GREEN}${BOLD}[INFO]${RESET} $1"
}

Log_error() {
    echo -e "${RED}${BOLD}[ERROR]${RESET} $1"
}


# Deploy Portainer
Log_info "Deploying Portainer..."
try {
    docker stack deploy -c portainer/docker-compose.yaml Portainer
} catch {
    Log_error "Failed to deploy Portainer"
}

# Deploy Unifi network controller
Log_info "Deploying Unifi network controller..."
try {
    cd unifi
    docker compose up -d
    cd ..
} catch {
    Log_error "Failed to deploy Unifi network controller"
}

# Deploy Homepage
Log_info "Deploying Homepage..."
try {
    cd homepage
    docker compose up -d
    cd ..
} catch {
    Log_error "Failed to deploy Homepage"
}

# Deploy SinLess Games Website
Log_info "Deploying SinLess Games Website..."
try {
    cd sinlessgamesllc
    docker stack deploy -c sinlessgamesllc/docker-compose.yaml SinLess-Games-Website
} catch {
    Log_error "Failed to deploy SinLess Games Website"
}

# Deploy cAdvisor
Log_info "Deploying cAdvisor..."
try {
    docker stack deploy -c cAdvisor/docker-compose.yaml cAdvisor
} catch {
    Log_error "Failed to deploy cAdvisor"
}
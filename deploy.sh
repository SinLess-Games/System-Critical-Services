#!/bin/bash

# ANSI color codes for logging output
RED='\033[0;31m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
RESET='\033[0m'
BOLD='\033[1m'

# Function to log informational messages
Log_info() {
    echo -e "${GREEN}${BOLD}[INFO]${RESET} $1"
}

# Function to log error messages
Log_error() {
    echo -e "${RED}${BOLD}[ERROR]${RESET} $1"
}

# Function to log warning messages
Log_warning() {
    echo -e "${ORANGE}${BOLD}[WARNING]${RESET} $1"
}

# Load environment variables from .env file if it exists, otherwise load from .env.example
if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
    Log_info "Loaded environment variables from .env file."
elif [ -f .env.example ]; then
    export $(grep -v '^#' .env.example | xargs)
    Log_warning "No .env file found. Loaded default values from .env.example."
else
    Log_error "No .env or .env.example file found. Using default environment variables."
fi

# Function to deploy a Docker stack
# Arguments:
#   $1 - Stack name
#   $2 - Docker Compose file path

deploy_stack() {
    local stack_name=$1
    local compose_file=$2
    
    Log_info "Deploying ${stack_name}..."
    
    # Check if the stack already exists
    docker stack ls | grep -q ${stack_name}
    if [ $? -eq 0 ]; then
        Log_info "${stack_name} stack already exists. Skipping deployment."
    else
        # Deploy the stack
        docker stack deploy -c ${compose_file} ${stack_name}
        if [ $? -eq 0 ]; then
            Log_info "${stack_name} stack deployed successfully."
        else
            Log_error "Failed to deploy ${stack_name} stack."
        fi
    fi
}

# Function to deploy a service using docker-compose
# Arguments:
#   $1 - Service name
#   $2 - Docker Compose file path

deploy_compose() {
    local service_name=$1
    local compose_file=$2
    
    Log_info "Deploying ${service_name} using docker-compose..."
    
    # Start the service using docker-compose
    docker-compose -f ${compose_file} up -d
    if [ $? -eq 0 ]; then
        Log_info "${service_name} deployed successfully."
    else
        Log_error "Failed to deploy ${service_name}."
    fi
}

##--------------------------------------------------------------------##
##                   DEPLOY SERVICES AND STACKS                       ##
##--------------------------------------------------------------------##
##                                                                    ##
## Ensure the compose filepaths are correct before running the script ##
##                                                                    ##
##--------------------------------------------------------------------##

# ----------------------------------------------------------------------
# Management Services
# ----------------------------------------------------------------------

#
# Deploy Portainer
deploy_stack "Portainer" "management/portainer/docker-compose.yaml"

#
# Deploy Watchtower
deploy_stack "Watchtower" "management/watchtower/docker-compose.yaml"

#
# Deploy Homepage
deploy_compose "Homepage" "management/homepage/docker-compose.yaml"

# ----------------------------------------------------------------------
# Application Services
# ----------------------------------------------------------------------

#
# Deploy SinLess Games website
deploy_compose "SinLess Games" "applications/sinlessgamesllc/docker-compose.yaml"

# ----------------------------------------------------------------------
# Networking Services
# ----------------------------------------------------------------------

#
# Deploy CloudflareD
deploy_stack "CloudflareD" "networking/cloudflared/docker-compose.yaml"

#
# Deploy Unifi
deploy_compose "Unifi Network Controller" "networking/unifi/docker-compose.yaml"

# ----------------------------------------------------------------------
# Observability Services
# ----------------------------------------------------------------------
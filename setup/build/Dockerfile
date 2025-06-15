# Debian 12 base image (updated to a secure patch level)
FROM debian:12-slim

# Set environment variables to avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Update system and install essential dependencies, then clean up APT cache
RUN apt-get update && apt-get install -y \
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
    bash-completion \
    jq \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Add a non-root user 'deployer' with sudo privileges for better security
RUN useradd -m -s /bin/bash deployer && \
    echo "deployer ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Set working directory
WORKDIR /setup

# Copy setup scripts and configurations into the container
COPY setup-scripts /setup

# Ensure that all setup scripts are executable
RUN chmod +x /setup/*.sh

# Default command - adjust as needed for your use-case
CMD ["sudo", "-u", "deployer", "/setup/setup.sh"]

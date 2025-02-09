# Debian 11 base image
FROM debian:11

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Update system and install essential dependencies
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

# Add a non-root user for security purposes
RUN useradd -m -s /bin/bash deployer && echo "deployer ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Set working directory
WORKDIR /setup

# Copy setup scripts or configurations (if needed)
COPY setup-scripts/ /setup/

# Set execute permissions on setup scripts
RUN chmod +x /setup/*.sh

# Default command (adjust as needed)
CMD ["/bin/bash"]
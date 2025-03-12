# Networking Services

This directory contains the configuration files and Docker Compose setups for our networking infrastructure. These services form the backbone of our network management and connectivity, and they include the following components:

- **Cloudflared**  
  Provides secure tunneling using Cloudflare Tunnel. The configuration includes environment variables for the tunnel token and Docker Compose settings to run the Cloudflare Tunnel container with automatic update support via Watchtower.

- **PowerDNS**  
  Manages local and public DNS resolution. PowerDNS is used in conjunction with PowerDNS-Admin to provide a web interface for DNS management. Configuration files include NGINX settings for the admin panel and environment variables for database and API keys.

- **Proxmox Load Balancer (proxmox-lb)**  
  Uses NGINX as a load balancer to distribute traffic across multiple Proxmox VE nodes. The NGINX configuration defines an upstream group with multiple Proxmox backends and handles proxy settings to forward HTTPS requests.

- **Unifi**  
  Hosts the Unifi Network Controller for managing network devices. The Docker Compose file for Unifi also sets up MongoDB as the backend database. Environment variables are provided for database access and Unifi-specific settings.

- **WireGuard**  
  Provides VPN connectivity to securely access the internal network. The WireGuard configuration includes settings for user IDs, time zone, VPN subnet, allowed IPs, and port mapping. This service uses the LinuxServer.io WireGuard image with the necessary capabilities added (NET_ADMIN and SYS_MODULE).

## Networks

The Docker Compose files for these services assume two external networks:

- **frontend**  
- **backend**

These networks are used to segregate and control traffic flow between different layers of the infrastructure.

## Deployment

Each service is containerized and deployed using Docker Compose. The configurations include health checks, logging with Loki, and restart policies to ensure high availability and resilience. Environment variables are defined in separate `.env` or `.env.example` files to keep sensitive information secure and to allow easy configuration adjustments.

## Additional Notes

- **Environment Variables:**  
  Check the provided `.env.example` files in each service directory for sample configurations. Make sure to update these values to match your environment.

- **Persistent Data:**  
  Volumes are mapped to local directories (e.g., `./.data/<service>`) to persist configuration and database data across container restarts.

- **High Availability & Security:**  
  Services are configured with health checks and resource constraints to provide high availability and secure operation. External tools like KeepaliveD, Nebula Sync, and Watchtower further enhance the overall robustness of the infrastructure.

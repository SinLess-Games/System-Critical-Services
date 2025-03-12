# DNS Architecture and Configuration

This document outlines the planned DNS setup for our infrastructure. The solution is designed to provide secure, highly available, and full‐visibility DNS resolution for both local and public domains while integrating advanced features such as ad blocking, DNS over HTTPS/TLS, and automated security management.

## Overview

Our DNS solution combines several technologies to achieve the following goals:

- **Ad Blocking:** Block unwanted advertisements.
- **Wildcard Domains:** Support wildcard domains for local subdomains (e.g., `*.local.sinlessgamesllc.com` or `*.local.helixaibot.com`).
- **Local DNS Resolution:** Resolve local domain requests to internal IP addresses.
- **Public DNS Resolution:** Provide DNS resolution for public domains.
- **DNS over HTTPS (DoH) & DNS over TLS (DoT):** Secure DNS queries from eavesdropping.
- **High Availability:** Ensure continuous DNS service with redundancy.
- **Security:** Use secure protocols and practices across all DNS components.
- **Metrics & Monitoring:** Gain full visibility into network traffic and DNS performance.
- **Automated Security Management:** Automatically handle updates and security patches.
- **Centralized Management:** DNS records will be managed using Terraform for reproducibility and version control.

## Components

The following components will be used in our DNS setup:

- **PowerDNS:**  
  - Routes requests for local domains.
  - Handles local DNS resolution.
  
- **Pihole:**  
  - Three instances provide ad blocking.
  - Two of the Pihole servers are paired with KeepaliveD for high availability.
  - Configurations are synchronized across instances using [Nebula Sync](https://github.com/lovelaze/nebula-sync).

- **Unbound:**  
  - Performs recursive DNS resolution.
  
- **Cloudflare DNS:**  
  - Serves as the upstream resolver for public DNS queries.
  
- **Docker Compose:**  
  - Containerizes all DNS components.
  
- **KeepaliveD:**  
  - Provides high availability for Pihole instances.
  
- **Nebula Sync:**  
  - Synchronizes configurations across Pihole servers.
  
- **Terraform:**  
  - Manages DNS records for both public and local domains.

## Network Topology

Below is an overview of the existing networks and VLAN assignments. The third octet in the IP address generally represents the VLAN ID:

| Name              | VLAN | Router    | CIDR             |
| ----------------- | ---- | --------- | ---------------- |
| Default           | 1    | USG-Pro-4 | 192.168.1.0/24   |
| Guest             | 2    | USG-Pro-4 | 192.168.2.0/24   |
| SinLess Games LLC | 10   | USG-Pro-4 | 192.168.5.0/24   |
| Home              | 20   | USG-Pro-4 | 192.168.20.0/24  |
| IoT               | 30   | USG-Pro-4 | 192.168.30.0/24  |

## Request Flow and Resolution

1. **Client Request:**  
   The client sends a DNS query.

2. **PowerDNS:**  
   - Receives the request and checks if the query is for a local domain.
   - Routes local domains (e.g., `local.sinlessgamesllc.com` and `local.helixaibot.com`) to internal resources.
   - Forwards queries for ad blocking to Pihole.

3. **Pihole:**  
   - Blocks any requests that match ad domains.
   - Forwards clean queries to Unbound.

4. **Unbound:**  
   - Resolves the query by performing recursive DNS lookups.
   - For public DNS queries (e.g., for `sinlessgamesllc.com` or `helixaibot.com`), Unbound forwards the request to Cloudflare DNS.

5. **Cloudflare DNS:**  
   - Handles public DNS resolution and returns the answer.

## Domain Routing

- **Local Domains (Managed by PowerDNS):**
  - `local.sinlessgamesllc.com`
  - `local.helixaibot.com`

- **Public Domains (Managed by Cloudflare DNS):**
  - `sinlessgamesllc.com`
  - `helixaibot.com`

DNS records for all domains will be managed using Terraform.

## Summary

The proposed DNS solution ensures a secure, resilient, and fully visible DNS infrastructure by integrating PowerDNS for local routing, Pihole for ad blocking, Unbound for recursive resolution, and Cloudflare for public DNS. Containerization (using Docker Compose) and high availability (using KeepaliveD and Nebula Sync) further enhance the robustness of this setup.
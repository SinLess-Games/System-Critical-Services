lets discuss how i will set up my dns, I need the following:
- Ad Blocking
- Wildcard domains e.g.*.local.sinlessgamesllc.com or *.local.helixaibot.com
- Local DNS resolution
- Public DNS resolution
- DNS over HTTPS
- DNS over TLS
- High availability
- Secure
- Uses Cloudflare DNS for public domains
- Uses PowerDNS for local domains
- Uses pihole for ad blocking
- Uses Docker compose for containerization
- Uses KeepaliveD for high availability
- Uses Nebula Sync for configuration sync
- Uses Unbound for DNS resolution
- Full visability into all network traffic
- Metrics and Monitoring
- Automated Security Management

These are my curent networks and vlans in my network. I use the third octet to represent the vlan id in most cases.

| Name              | VLAN | Router    | CIDR            |
| ----------------- | ---- | --------- | --------------- |
| Default           | 1    | USG-Pro-4 | 192.168.1.0/24  |
| Guest             | 2    | USG-Pro-4 | 192.168.2.0/24  |
| SinLess Games LLC | 10   | USG-Pro-4 | 192.168.5.0/24  |
| Home              | 20   | USG-Pro-4 | 192.168.20.0/24 |
| IoT               | 30   | USG-Pro-4 | 192.168.30.0/24 |
| Harvester Cluster | 40   | USG-Pro-4 | 192.168.40.0/24 |
| Kubernetes        | 300  | USG-Pro-4 | 10.0.0.0/24     |
	
---

I am going to use 3 Pihole instances, KeepaliveD to pair 2 of the pihole servers and [Nebula Sync](https://github.com/lovelaze/nebula-sync) to sync the configurations of the pihole servers, Unbound, cloudflare, PowerDNS

I want the request flow to work like this
- client sends request to PowerDNS
- PowerDNS forwards the request to pihole for add blocking or it will resolve the local domains to the proper location like a server or ip address
- pihole forwards the request to unbound
- unbound forwards the request to cloudflare

PowerDNS will route my local domains of:
- local.sinlessgamesllc.com
- local.helixaibot.com

cloudflare will route my public domains of:
- sinlessgamesllc.com
- helixaibot.com

DNS records will be managed by terraform
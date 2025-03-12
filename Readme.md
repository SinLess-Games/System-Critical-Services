# System Critical Services

This repository contains the configuration and management of critical services for the infrastructure of Sinless Games LLC. These services include authentication, database management, caching, and other essential components. The goal is to ensure high availability, scalability, and security of the critical services that support the organization’s systems.

| Port  | Service                                    | Protocol  |
|-------|--------------------------------------------|-----------|
| 1900  | Unifi Network Controller                   | UDP       |
| 3000  | Homepage                                   | TCP       |
| 3100  | Grafana Loki                               | TCP       |
| 3200  | Grafana Tempo                              | TCP       |
| 3306  | MySQL                                      | TCP       |
| 3478  | Unifi Network Controller                   | UDP       |
| 4040  | Grafana Pyroscope                          | TCP       |
| 4317  | otelcol                                    | TCP       |
| 4318  | otelcol                                    | TCP       |
| 5300  | PDNS Recursor                              | TCP/UDP   |
| 5353  | dnsdist                                    | TCP/UDP   |
| 5514  | Unifi Network Controller                   | UDP       |
| 5672  | RabbitMQ                                   | TCP       |
| 6379  | Redis                                      | TCP       |
| 6789  | Unifi Network Controller                   | TCP       |
| 7443  | PDNS Admin Panel (HTTPS)                   | TCP       |
| 8000  | (Service not specified)                    | TCP       |
| 8080  | Unifi Network Controller                   | TCP       |
| 8081  | PDNS Admin Panel (HTTP)                    | TCP       |
| 8082  | Traefik Dashboard                          | TCP       |
| 8086  | InfluxDB                                   | TCP       |
| 8443  | Unifi Network Controller                   | TCP       |
| 8843  | Unifi Network Controller                   | TCP       |
| 8880  | Unifi Network Controller                   | TCP       |
| 8888  | otelcol                                    | TCP       |
| 9009  | Grafana Mimir                              | TCP       |
| 9090  | Prometheus                                 | TCP       |
| 9093  | Alertmanager                               | TCP       |
| 9094  | alertmanager-discord-notifier              | TCP       |
| 9100  | Node Exporter                              | TCP       |
| 9104  | MySQL Exporter                             | TCP       |
| 51820 | WireGuard VPN                              | UDP       |


## Services Overview

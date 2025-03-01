# System Critical Services

This repository contains the configuration and management of critical services for the infrastructure of Sinless Games LLC. These services include authentication, database management, caching, and other essential components. The goal is to ensure high availability, scalability, and security of the critical services that support the organization’s systems.


## Ports

This is a list of ports that is used and exposed 


| Ports  | Service                          | Protocol |
|--------|----------------------------------|----------|
| 1900   | Unifi Network Controller         | UDP      |
| 3000   | Homepage                         | TCP      |
| 3100   | Grafana Loki                     | TCP      |
| 3200   | Grafana Tempo                    | TCP      |
| 3478   | Unifi Network Controller         | UDP      |
| 4317   | otelcol                          | TCP      |
| 4318   | otelcol                          | TCP      |
| 5514   | Unifi Network Controller         | UDP      |
| 6789   | Unifi Network Controller         | TCP      |
| 8000   | Portainer                        | TCP      |
| 8080   | Unifi Network Controller         | TCP      |
| 8086   | InfluxDB                         | TCP      |
| 8443   | Unifi Network Controller         | TCP      |
| 8843   | Unifi Network Controller         | TCP      |
| 8880   | Unifi Network Controller         | TCP      |
| 8888   | otelcol                          | TCP      |
| 9000   | Portainer                        | TCP      |
| 9001   | Portainer Agent                  | TCP      |
| 9009   | Grafana Mimir                    | TCP      |
| 9090   | Prometheus                       | TCP      |
| 9093   | Alertmanager                     | TCP      |
| 9094   | alertmanager-discord-notifier    | TCP      |
| 9100   | Node Exporter                    | TCP      |
| 9101   | cAdvisor                         | TCP      |
| 9443   | Portainer                        | TCP      |
| 10001  | Unifi Network Controller         | UDP      |
| 51820  | Wireguard                        | UDP      |


## Services Overview

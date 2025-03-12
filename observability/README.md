# Observability

This directory contains the configuration files for our observability stack, including Prometheus rules, Grafana dashboards, Alertmanager configurations, and other related components.

## Overview

Our observability setup is designed to provide full visibility into system and application performance. It includes:

- **Grafana Dashboards**: For visualizing metrics, logs, traces, and alerts.
- **Prometheus Rules and Configurations**: Alerting rules to monitor container performance, database metrics, node health, and more.
- **Alertmanager Configuration**: To route alerts to notification services such as Discord.
- **Additional Tools**: Configurations for Loki (log aggregation), Tempo (distributed tracing), and others.

## Prometheus Rules and Configurations

Many of our Prometheus rules and configurations are derived from and modified based on the excellent work available at [Awesome Prometheus Alerts](https://samber.github.io/awesome-prometheus-alerts). These rules help us monitor critical metrics across various services and infrastructure components.

### Key Components

- **Rule Files**:  
  - Located in `observability/grafana/configs/prometheus/rules/`
  - Define alerts for container health, database performance, node metrics, and more.
- **Global Prometheus Configuration**:  
  - Found in `observability/grafana/configs/prometheus/prometheus.yaml`
  - Sets global scrape intervals, evaluation intervals, and other settings.
- **Alertmanager Configuration**:  
  - Located in `observability/grafana/configs/alertmanager.yaml`
  - Routes alerts based on defined criteria (e.g., alertname) and sends notifications to services like Discord.

## Deployment

Our observability stack is deployed using Docker Compose. The main compose file is located at `observability/grafana/docker-compose.yaml` and it defines the following services:

- **Grafana**: For dashboard visualization.
- **Prometheus**: For scraping and alerting.
- **Alertmanager**: For handling alert routing.
- **Additional Services**: Loki, Tempo, Node Exporter, cAdvisor, etc.

## Customization

- **Alerts**:  
  - Modify or add new Prometheus alerting rules by editing the JSON/YAML files in the rules directory.
- **Dashboards**:  
  - Customize Grafana dashboards by editing the JSON files located in `observability/grafana/dashboards/`.
- **Configurations**:  
  - Adjust settings in the provided configuration files for Prometheus, Alertmanager, Loki, Tempo, and other services.
- **Environment Variables**:  
  - Many configurations are parameterized via environment variables defined in `.env` files.

## References

- [Awesome Prometheus Alerts](https://samber.github.io/awesome-prometheus-alerts)
- [Prometheus Documentation](https://prometheus.io/docs/introduction/overview/)
- [Grafana Documentation](https://grafana.com/docs/)
- [Alertmanager Documentation](https://prometheus.io/docs/alerting/latest/alertmanager/)

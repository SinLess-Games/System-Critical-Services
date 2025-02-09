FROM fluent/fluentd:v1.16.3-1.0

# Install fluentd plugins
# - fluent-plugin-record-reformer: for record transformation
# - fluent-plugin-grafana-loki: for App logs
# - fluent-plugin-elasticsearch: for Infra logs
# - fluent-plugin-prometheus: for monitoring
# - fluent-plugin-influxdb-v2: for syslog input
RUN fluent-gem install fluent-plugin-record-reformer && \
    fluent-gem install fluent-plugin-grafana-loki && \
    fluent-gem install fluent-plugin-elasticsearch && \
    fluent-gem install fluent-plugin-prometheus


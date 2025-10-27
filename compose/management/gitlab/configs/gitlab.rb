## External URL (Traefik terminates TLS)
external_url "http://gitlab:8080"

## Postgres (external service)
gitlab_rails['db_adapter'] = 'postgresql'
gitlab_rails['db_encoding'] = 'unicode'
gitlab_rails['db_host'] = 'postgres'
gitlab_rails['db_port'] = 5432
gitlab_rails['db_username'] = ENV['GITLAB_DB_USER'] || 'gitlab'
gitlab_rails['db_password'] = ENV['GITLAB_DB_PASSWORD']
gitlab_rails['db_database'] = ENV['GITLAB_DB_NAME'] || 'gitlabhq_production'
gitlab_rails['db_pool'] = 20

## Redis (required for queues/cache)
gitlab_rails['redis_host'] = 'redis'
gitlab_rails['redis_port'] = 6379

## Time zone
gitlab_rails['time_zone'] = 'America/Denver'

## SMTP (optional) – configure if you need email
# gitlab_rails['smtp_enable'] = true
# gitlab_rails['smtp_address'] = 'smtp.example.com'
# gitlab_rails['smtp_port'] = 587
# gitlab_rails['smtp_user_name'] = ENV['SMTP_USERNAME']
# gitlab_rails['smtp_password'] = ENV['SMTP_PASSWORD']
# gitlab_rails['smtp_domain'] = 'example.com'
# gitlab_rails['smtp_authentication'] = 'login'
# gitlab_rails['smtp_enable_starttls_auto'] = true
# gitlab_rails['gitlab_email_from'] = 'gitlab@example.com'

## Registry (optionally expose via Traefik at registry.${ROOT_DOMAIN})
registry_external_url 'http://gitlab:5050'
registry['enable'] = true
registry_nginx['enable'] = false
gitlab_rails['registry_enabled'] = true
gitlab_rails['registry_host'] = "registry.#{ENV['ROOT_DOMAIN']}" if ENV['ROOT_DOMAIN']
gitlab_rails['registry_api_url'] = "http://gitlab:5050"
gitlab_rails['registry_key_path'] = "/var/opt/gitlab/gitlab-rails/etc/gitlab-registry.key"

## Pages (off by default)
pages_external_url nil

## Disable bundled nginx TLS since Traefik fronts it
letsencrypt['enable'] = false
nginx['enable'] = true
nginx['listen_port'] = 8080
nginx['listen_https'] = false

## Prometheus exporters inside Omnibus (optional)
prometheus_monitoring['enable'] = true

## Backup (optional)
gitlab_rails['backup_path'] = "/var/opt/gitlab/backups"
gitlab_rails['backup_keep_time'] = 604800  # 7 days

external_url 'https://gitlab-prod-1.srv-prod-1.home.clcreative.de'

# SSH port
gitlab_rails['gitlab_shell_ssh_port'] = 2424

# Letsencrypt
letsencrypt['enable'] = false

# Nginx
nginx['listen_port'] = 80
nginx['listen_https'] = false
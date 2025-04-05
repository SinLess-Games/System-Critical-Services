CREATE DATABASE IF NOT EXISTS oncall_hobby;
CREATE DATABASE IF NOT EXISTS grafana;

/**
  * Create users
  * 
  * - grafana
  * - dashboard
  * - oncall
  */
CREATE USER 'grafana'@'%' IDENTIFIED BY 'grafana_password';
CREATE USER 'dashboard'@'%' IDENTIFIED BY 'dashboard_password';
CREATE USER 'oncall'@'%' IDENTIFIED BY 'oncall_password';
CREATE USER 'exporter'@'%' IDENTIFIED BY 'exporter_password';
CREATE USER 'sinless777'@'%' IDENTIFIED BY 'shellshocker93';


/**
  * Give grafana all perms on grafana
  */
GRANT ALL PRIVILEGES ON grafana.* TO 'grafana'@'%';
GRANT PROCESS, REPLICATION CLIENT, SELECT ON *.* TO 'exporter'@'%';
GRANT ALL PRIVILEGES ON *.* TO 'sinless777'@'%';

/**
  * Give oncall all perms on oncall_hobby
  */
GRANT ALL PRIVILEGES ON oncall_hobby.* TO 'oncall'@'%';

/**
  * Give dashboard read-only access to all databases
  */
GRANT SELECT ON *.* TO 'dashboard'@'%';

/**
  * Apply changes
  */
FLUSH PRIVILEGES;

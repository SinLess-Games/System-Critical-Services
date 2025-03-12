# Management

This directory contains the infrastructure management configurations for our critical services. It includes Docker Compose files and related configuration files for deploying and managing key applications such as GitLab, Homepage, and Watchtower.

## Directory Structure

- **gitlab/**  
  Contains the Docker Compose file for deploying GitLab along with its dependencies:
  - **postgres:** PostgreSQL database for GitLab.
  - **redis:** Redis instance used by GitLab.
  - **gitlab:** GitLab CE application.
  - **gitlab-runner:** GitLab Runner for CI/CD jobs.

- **homepage/**  
  Contains configuration files and a Docker Compose file for the Homepage application:
  - **config/bookmarks.yaml:** Bookmark configuration for quick access to important sites.
  - **config/services.yaml:** Service configurations for monitoring, infrastructure, networking, etc.
  - **config/settings.yaml:** Global settings for the Homepage.
  - **config/widgets.yaml:** Widget configurations for displaying metrics and additional data.
  - **docker-compose.yaml:** Deployment configuration for the Homepage service.

- **watchtower/**  
  Contains the Docker Compose file for deploying Watchtower:
  - **watchtower:** Automatically monitors and updates running containers.

## Prerequisites

- Docker and Docker Compose must be installed on your host machine.
- External networks named `frontend` and `backend` must already exist (as these services are attached to these external networks).

## Running the Services

### GitLab

1. Navigate to the `management/gitlab/` directory.
2. Start the GitLab stack with:
   ```bash
   docker-compose up -d --build
   ```
3. Ensure your environment variables (such as `GITLAB_EXTERNAL_URL`, `GITLAB_DB_USER`, etc.) are set, either via a `.env` file or your shell.

### Homepage

1. Navigate to the `management/homepage/` directory.
2. Deploy the Homepage service:
   ```bash
   docker-compose up -d
   ```
3. The service will be exposed on port 3000.

### Watchtower

1. Navigate to the `management/watchtower/` directory.
2. Deploy Watchtower with:
   ```bash
   docker-compose up -d --build
   ```
3. Watchtower will monitor your containers and update them as needed.

## Environment Variables

Each service uses environment variables defined in `.env` files. An example for Watchtower is provided in `.env.example`. Copy these files to `.env` and update the values as required.

## Logging & Monitoring

- **Logging:** Containers are configured to send logs to a Loki instance. Check your Loki server settings if you need to adjust logging parameters.
- **Monitoring:** Health checks are configured for all services. Customize the health check commands if needed.

## Security & High Availability

- Sensitive credentials are provided via environment variables. Make sure to secure these values and do not commit them to public repositories.
- High availability is achieved through the use of multiple service replicas, KeepaliveD, and configuration sync via Nebula Sync (for certain services).

## Additional Resources

- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [GitLab Omnibus Documentation](https://docs.gitlab.com/omnibus/)
- [Homepage Documentation](https://gethomepage.dev/)
- [Watchtower Documentation](https://containrrr.dev/watchtower/)


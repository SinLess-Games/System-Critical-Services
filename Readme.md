# System Critical Services

This repository contains the configuration and management of critical services for the infrastructure of Sinless Games LLC. These services include authentication, database management, caching, and other essential components. The goal is to ensure high availability, scalability, and security of the critical services that support the organization’s systems.

## Services Overview

### Authentik

Authentik is an open-source identity provider (IdP) that provides authentication services. It integrates with multiple applications and services to manage user authentication and authorization. The Authentik stack consists of the following components:

- **authentik-server**: The main service for handling authentication requests.
- **authentik-proxy**: A proxy service that communicates with the authentik-server to provide authentication features to other services.
- **authentik-worker**: A worker service that performs background tasks for the authentik-server.
- **postgres**: The database service used by Authentik to store user data and configurations.
- **redis**: The caching service used by Authentik to improve performance.

### Traefik

Traefik is a modern HTTP reverse proxy and load balancer that makes deploying microservices easy. It integrates with Docker and Kubernetes to automatically configure routes for services based on their labels.

### Watchtower

Watchtower is a tool for automatically updating Docker containers when new images are available. It ensures that all containers are running the latest versions of their respective images.

## Setup and Configuration

### Prerequisites

- Docker and Docker Compose
- Access to an SMTP server for email services (optional)
- Redis and PostgreSQL services are required for Authentik to function

### Configuration

The configuration of each service is managed through environment variables. These variables should be set in your `.env` file or in the Docker Compose configuration.

Key environment variables include:

- `POSTGRES_USER`, `POSTGRES_PASSWORD`, `POSTGRES_DB`: PostgreSQL credentials for Authentik
- `AUTHENTIK_SECRET_KEY`: A secret key used by Authentik for encryption
- `AUTHENTIK_COOKIE_DOMAIN`: The domain used for Authentik cookies
- `DOMAIN`: The domain name for the services
- `AUTHENTIK_SINLESS_OPUTPOST_TOKEN`: Token for Authentik proxy authentication

### Running the Services

To start the services, use Docker Compose:

```bash
docker-compose up -d
```

This will start the following services:

- `authentik-server`
- `authentik-proxy`
- `authentik-worker`
- `postgres`
- `redis`

You can check the status of the containers using:

```bash
docker-compose ps
```

### Traefik Routing

The `authentik-server` service is exposed via Traefik. The routing configuration includes both HTTP and HTTPS entry points:

- HTTP: `http://authentik.${DOMAIN}`
- HTTPS: `https://authentik.${DOMAIN}`

Traefik will automatically handle the SSL certificate management and routing based on the provided domain.

### Updating Services

To update the services, you can pull the latest images and restart the containers:

```bash
docker-compose pull
docker-compose up -d
```

### Logs

Logs for each service can be accessed using Docker logs:

```bash
docker logs <container_name>
```

For example, to view the logs of the `authentik-server`:

```bash
docker logs authentik-server
```

### Health Checks

Each service has configured health checks to ensure proper operation. These can be monitored through Docker Compose or using monitoring tools like Prometheus.

## Security Considerations

- Ensure that all environment variables containing sensitive information (e.g., passwords, tokens) are kept secure and not exposed in public repositories.
- Use a reverse proxy (e.g., Traefik) with HTTPS to secure communication between services.
- Rotate secrets and API keys periodically to minimize the risk of compromise.

## Contributing

Contributions to this repository are welcome. Please fork the repository, create a branch, and submit a pull request with your changes.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

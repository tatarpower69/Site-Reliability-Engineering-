# Microservices Platform (SRE & DevOps)

Secure and monitored microservices architecture deployed on AWS.

## Features
- **5 Microservices**: Auth, User, Product, Order, Chat (FastAPI).
- **Reverse Proxy**: Nginx acting as an API Gateway (Port 80).
- **Security**: Closed public ports, SSL-ready, and secrets management via `.env`.
- **Monitoring**: Full observability stack with Prometheus & Grafana.
- **Reliability**: Automated Docker health checks and self-healing (auto-restart).
- **IaC**: Infrastructure provisioning via Terraform.

## Project Structure
- `/auth-service`, `/user-service`, etc. - Application source code.
- `/frontend` - Static UI and Nginx configuration.
- `/monitoring` - Prometheus scrape configs and Grafana dashboards.
- `/terraform` - AWS infrastructure scripts.
- `/scripts` - Incident simulation and maintenance tools.

## Quick Start
1. Configure `.env` from `.env.example`.
2. Run `docker-compose up -d`.
3. Validate configuration: `./validate_config.ps1`.

## Monitoring
- **Prometheus**: http://localhost:9090
- **Grafana**: http://localhost:3000 (Admin password in .env)

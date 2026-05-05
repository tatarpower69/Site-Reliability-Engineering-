# Microservices-System


## Overview
This project demonstrates a complete DevOps/SRE workflow, including:
- **Microservices Architecture**: 5 independent services (Auth, User, Product, Order, Chat).
- **Containerization**: All services packaged with Docker.
- **Orchestration**: Managed via Docker Compose.
- **Infrastructure as Code**: AWS infrastructure provisioned using Terraform.
- **Monitoring & Observability**: Prometheus metrics collection and Grafana visualization.
- **Incident Management**: Simulation of a production-level failure in the Order Service and structured postmortem analysis.

## Technology Stack
- **Backend**: Python (FastAPI)
- **Frontend**: JavaScript / HTML (Served via Nginx)
- **Database**: PostgreSQL
- **Monitoring**: Prometheus & Grafana
- **Infrastructure**: Terraform (AWS)
- **Deployment**: Docker & Docker Compose

## Project Structure
- `auth-service/`, `user-service/`, `product-service/`, `order-service/`, `chat-service/`: Microservices source code and Dockerfiles.
- `frontend/`: Nginx configuration and static frontend files.
- `monitoring/`: Prometheus configuration.
- `terraform/`: IaC files (main.tf, variables.tf, outputs.tf, terraform.tfvars).
- `docker-compose.yml`: Orchestration file for the entire system.

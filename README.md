# SRE Automation & Capacity Planning Project

Secure and monitored microservices system with automated recovery and capacity analysis.

## Features

### 1. Automation & Reliability
- **Automated Deployment**: Fully orchestrated with Docker Compose.
- **Self-Healing**: Health checks and restart policies for all services.
- **Infrastructure as Code**: AWS environment provisioned via Terraform.
- **Reverse Proxy**: Secure API Gateway using Nginx (Port 80).

### 2. Observability & Alerting
- **Full Monitoring**: Prometheus & Grafana stack.
- **Visual Dashboards**: Real-time system health visualization.
- **Custom Alerts**: High CPU, Service Downtime, and Error Rate alerts.

### 3. Capacity Planning
- **Load Testing**: `load_test.py` script for system stress testing.
- **Metrics**: Real-time tracking of RPS, Latency, and Resource usage.

## Quick Start

1. **Configure Environment**:
   ```powershell
   # Create .env from .env.example and run validation
   ./validate_config.ps1
   ```

2. **Deploy System**:
   ```bash
   docker-compose up -d
   ```

3. **Monitoring Access**:
   - **Grafana**: [http://localhost:3000/d/microservices-overview/microservices-overview](http://localhost:3000/d/microservices-overview/microservices-overview)
   - **Prometheus**: [http://localhost:9090](http://localhost:9090)

4. **Run Load Test**:
   ```bash
   python load_test.py
   ```

## Infrastructure
The cloud environment is hosted on AWS. Access the control plane at:
**[http://3.223.248.196](http://3.223.248.196)**

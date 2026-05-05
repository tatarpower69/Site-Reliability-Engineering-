# SRE Automation & Capacity Planning Project

This repository contains a containerized microservices system enhanced with SRE principles, automated troubleshooting, and capacity planning analysis.

## Features

### 1. Automation (Assignment 6)
- **Automated Deployment**: Orchestrated with Docker Compose and provisioned via Terraform on AWS.
- **Self-Healing**: Health checks and restart policies for all services.
- **Configuration Validation**: `validate_config.sh` script to ensure environment correctness before deployment.
- **Log-Based Troubleshooting**: `troubleshoot.sh` script for automated root cause analysis.

### 2. Observability & Alerting
- **Full Monitoring**: Prometheus & Grafana stack.
- **DB Insights**: Integrated `postgres-exporter` for database health metrics.
- **Custom Alerts**: 7+ alerting rules (ServiceDown, HighCPU, DBFailure, etc.).

### 3. Capacity Planning
- **Load Simulation**: `load_test.py` for stress testing the system.
- **Metrics Analysis**: Documented resource consumption and scaling strategies.

### 4. Infrastructure as Code (Assignment 5)
- **Professional Terraform**: VPC, Subnets, Internet Gateway, and Automated Key Management.

## Quick Start

1. **Validate Configuration**:
   ```bash
   sh validate_config.sh
   ```

2. **Deploy Locally**:
   ```bash
   docker-compose up -d
   ```

3. **Analyze Logs**:
   ```bash
   sh troubleshoot.sh
   ```

4. **Run Load Test**:
   ```bash
   python load_test.py 20 60
   ```

## Infrastructure

The cloud environment is provisioned in AWS `us-east-1` using Terraform. See the `terraform/` directory for details.

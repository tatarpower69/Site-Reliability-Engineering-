#!/bin/bash

echo "=================================================="
echo "SRE CONFIGURATION & ENVIRONMENT VALIDATOR"
echo "=================================================="

# 1. Check for .env file
echo -n "[1/5] Checking for .env file... "
if [ ! -f .env ]; then
    echo "ERROR: .env file not found"
    exit 1
fi
echo "OK"

# Source the .env file to check variables
source .env

# 2. Detailed Environment Validation (like your friend's script)
echo "[2/5] Validating environment variables..."

CHECK_VARS=("POSTGRES_USER" "POSTGRES_PASSWORD" "POSTGRES_DB")
for VAR in "${CHECK_VARS[@]}"; do
    if [ -z "${!VAR}" ]; then
        echo "ERROR: $VAR is not set in .env"
        exit 1
    else
        echo "  - $VAR: OK"
    fi
done

# 3. Check required ports
echo "[3/5] Checking required system ports..."
PORTS=(8001 8002 8003 8004 8005 3000 9090 80)
for PORT in "${PORTS[@]}"; do
    if netstat -tuln | grep -q ":$PORT "; then
        echo "  WARNING: Port $PORT is already in use."
    else
        echo "  Port $PORT: AVAILABLE"
    fi
done

# 4. Validating docker-compose.yml syntax
echo -n "[4/5] Validating docker-compose.yml syntax... "
docker-compose config -q > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "VALID"
else
    echo "INVALID YAML"
    exit 1
fi

# 5. Verifying Monitoring Config
echo -n "[5/5] Verifying Prometheus Alert Rules... "
if [ -f monitoring/alert.rules.yml ]; then
    echo "FOUND"
else
    echo "MISSING"
    exit 1
fi

echo "=================================================="
echo "Validation Complete. System is READY."
echo "=================================================="

#!/bin/bash

echo "sre configuration & environment validator"

# 1. check .env file
echo -n "[1/5] checking for .env file "
if [ ! -f .env ]; then
    echo "ERROR: .env file not found"
    exit 1
fi
echo "OK"

source .env

# 2. env validation
echo "[2/5] validating environment var.."

CHECK_VARS=("POSTGRES_USER" "POSTGRES_PASSWORD" "POSTGRES_DB")
for VAR in "${CHECK_VARS[@]}"; do
    if [ -z "${!VAR}" ]; then
        echo "ERROR: $VAR is not set in .env"
        exit 1
    else
        echo "  - $VAR: OK"
    fi
done

# 3. check req ports
echo "[3/5] checking req system ports..."
PORTS=(8001 8002 8003 8004 8005 3000 9090 80)
for PORT in "${PORTS[@]}"; do
    if netstat -tuln | grep -q ":$PORT "; then
        echo "  WARNING: Port $PORT is already in use."
    else
        echo "  Port $PORT: AVAILABLE"
    fi
done

# 4. validate docker-compose.yml
echo -n "[4/5] validating docker-compose.yml syntax... "
docker-compose config -q > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "VALID"
else
    echo "INVALID YAML"
    exit 1
fi

# ver monitoring 
echo -n "[5/5] verifying Prometheus Alert Rules... "
if [ -f monitoring/alert.rules.yml ]; then
    echo "found"
else
    echo "missing"
    exit 1
fi

echo "validation complete. system is ready."


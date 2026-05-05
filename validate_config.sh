#!/bin/bash


echo "=================================================="
echo "SRE CONFIGURATION VALIDATOR"
echo "=================================================="

echo -n "[1/4] Checking for .env file... "
if [ -f .env ]; then
    echo "OK"
else
    echo "MISSING"
    echo "POSTGRES_USER=user" > .env
    echo "POSTGRES_PASSWORD=password" >> .env
    echo "POSTGRES_DB=microservices" >> .env
    echo "CREATED default .env template."
fi

echo "[2/4] Checking required ports..."
PORTS=(8001 8002 8003 8004 8005 3000 9090 80)
for PORT in "${PORTS[@]}"; do
    if netstat -tuln | grep -q ":$PORT "; then
        echo "WARNING: Port $PORT is already in use. Deployment might fail."
    else
        echo "Port $PORT is AVAILABLE."
    fi
done

echo -n "[3/4] Validating docker-compose.yml syntax... "
docker compose config > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "VALID"
else
    echo "INVALID YAML"
    exit 1
fi

echo -n "[4/4] Verifying Prometheus Alert Rules... "
if [ -f monitoring/alert.rules.yml ]; then
    echo "FOUND"
else
    echo "MISSING"
fi

echo "=================================================="
echo "Validation Complete. Ready for Deployment."
echo "=================================================="

#!/bin/bash

echo "=================================================="
echo "SRE AUTOMATED LOG INSPECTOR"
echo "=================================================="

echo "[1/3] Checking for Database Connection Failures..."
docker compose logs | grep -i "DATABASE_CONNECTION_FAILURE" && echo "FAILED: Database issues found!" || echo "PASSED: No DB errors found."

echo "[2/3] Checking for Service Restart Loops..."
RESTARTS=$(docker compose ps | grep -c "restarting")
if [ $RESTARTS -gt 0 ]; then
    echo "FAILED: $RESTARTS services are in a restart loop!"
else
    echo "PASSED: All services are stable."
fi

echo "[3/3] Checking for Critical HTTP 500 Errors..."
docker compose logs | grep -i "500" && echo "WARNING: High error rate detected!" || echo "PASSED: No 500 errors found."

echo "=================================================="
echo "Troubleshooting Complete."

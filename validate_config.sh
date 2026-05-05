#!/bin/bash
# Pre-deployment Configuration Validation Script
# Assignment 6 - Automation in SRE

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

ERRORS=0
WARNINGS=0

echo "======================================"
echo "  Pre-Deployment Validation Script"
echo "  $(date)"
echo "======================================"

# Function to check env variable
check_env() {
    local var_name=$1
    local required=$2
    local value=${!var_name}
    
    if [ -z "$value" ]; then
        if [ "$required" = "true" ]; then
            echo -e "${RED}[ERROR]${NC} Required variable $var_name is not set"
            ERRORS=$((ERRORS+1))
        else
            echo -e "${YELLOW}[WARN]${NC}  Optional variable $var_name is not set (using default)"
            WARNINGS=$((WARNINGS+1))
        fi
    else
        echo -e "${GREEN}[OK]${NC}    $var_name is set"
    fi
}

echo ""
echo "--- Checking Environment Variables ---"
# Load .env if exists
if [ -f ".env" ]; then
    # Use a more robust way to export .env for bash
    export $(grep -v '^#' .env | xargs)
    echo -e "${GREEN}[OK]${NC}    .env file found and loaded"
else
    echo -e "${YELLOW}[WARN]${NC}  No .env file found, using system environment"
fi

check_env "POSTGRES_USER" "false"
check_env "POSTGRES_PASSWORD" "false"
check_env "POSTGRES_DB" "false"
check_env "GRAFANA_PASSWORD" "false"

echo ""
echo "--- Checking Docker ---"
if command -v docker &> /dev/null; then
    echo -e "${GREEN}[OK]${NC}    Docker is installed: $(docker --version)"
else
    echo -e "${RED}[ERROR]${NC} Docker is not installed"
    ERRORS=$((ERRORS+1))
fi

if command -v docker-compose &> /dev/null || docker compose version &> /dev/null 2>&1; then
    echo -e "${GREEN}[OK]${NC}    Docker Compose is available"
else
    echo -e "${RED}[ERROR]${NC} Docker Compose is not available"
else
    echo -e "${RED}[ERROR]${NC} Docker Compose is not available"
    ERRORS=$((ERRORS+1))
fi

echo ""
echo "--- Checking Required Files ---"
for file in "docker-compose.yml" "monitoring/prometheus.yml" "monitoring/alert.rules.yml"; do
    if [ -f "$file" ]; then
        echo -e "${GREEN}[OK]${NC}    $file exists"
    else
        echo -e "${RED}[ERROR]${NC} $file is missing"
        ERRORS=$((ERRORS+1))
    fi
done

echo ""
echo "--- Validating Docker Compose ---"
if docker-compose config > /dev/null 2>&1; then
    echo -e "${GREEN}[OK]${NC}    docker-compose.yml is valid"
else
    echo -e "${RED}[ERROR]${NC} docker-compose.yml has syntax errors"
    ERRORS=$((ERRORS+1))
fi

echo ""
echo "======================================"
echo "  Validation Summary"
echo "======================================"
echo -e "Errors:   ${RED}$ERRORS${NC}"
echo -e "Warnings: ${YELLOW}$WARNINGS${NC}"

if [ $ERRORS -gt 0 ]; then
    echo -e "${RED}DEPLOYMENT BLOCKED - Fix errors before deploying${NC}"
    exit 1
else
    echo -e "${GREEN}VALIDATION PASSED - Ready to deploy${NC}"
    exit 0
fi

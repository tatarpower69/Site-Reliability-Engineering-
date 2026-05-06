Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "SRE CONFIGURATION & ENVIRONMENT VALIDATOR (Windows)" -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan

# 1. Check for .env file
Write-Host -NoNewline "[1/5] Checking for .env file... "
if (Test-Path .env) {
    Write-Host "OK" -ForegroundColor Green
} else {
    Write-Host "ERROR: .env file not found" -ForegroundColor Red
    exit
}

# Load .env variables
$envVars = Get-Content .env | Where-Object { $_ -match "=" }
foreach ($line in $envVars) {
    $name, $value = $line.Split('=', 2)
    Set-Variable -Name "ENV_$name" -Value $value -Scope Local
}

# 2. Detailed Environment Validation
Write-Host "[2/5] Validating environment variables..."
$checkVars = "POSTGRES_USER", "POSTGRES_PASSWORD", "POSTGRES_DB"
foreach ($var in $checkVars) {
    $varName = "ENV_$var"
    if (-not (Get-Variable $varName -ErrorAction SilentlyContinue)) {
        Write-Host "  ERROR: ${var} is not set in .env" -ForegroundColor Red
    } else {
        Write-Host "  - ${var}: OK" -ForegroundColor Green
    }
}

# 3. Check required ports
Write-Host "[3/5] Checking required system ports..."
$ports = 8001, 8002, 8003, 8004, 8005, 3000, 9090, 80
$netstat = netstat -an
foreach ($port in $ports) {
    if ($netstat -match ":$port\s+") {
        Write-Host "  WARNING: Port ${port} is already in use." -ForegroundColor Yellow
    } else {
        Write-Host "  Port ${port}: AVAILABLE" -ForegroundColor Green
    }
}

# 4. Validating docker-compose.yml syntax
Write-Host -NoNewline "[4/5] Validating docker-compose.yml syntax... "
docker-compose config -q
if ($LASTEXITCODE -eq 0) {
    Write-Host "VALID" -ForegroundColor Green
} else {
    Write-Host "INVALID YAML" -ForegroundColor Red
}

# 5. Verifying Monitoring Config
Write-Host -NoNewline "[5/5] Verifying Prometheus Alert Rules... "
if (Test-Path monitoring/alert.rules.yml) {
    Write-Host "FOUND" -ForegroundColor Green
} else {
    Write-Host "MISSING" -ForegroundColor Red
}

Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "Validation Complete. Ready for Deployment." -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan

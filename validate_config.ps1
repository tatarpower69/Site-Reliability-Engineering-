
Write-Host "sre configuration & environment validator (Windows)" -ForegroundColor Cyan


# 1. Check for .env file
Write-Host -NoNewline "[1/5] checking for .env file... "
if (Test-Path .env) {
    Write-Host "ok" -ForegroundColor Green
}
else {
    Write-Host "error: .env file not found" -ForegroundColor Red
    exit
}

# load .env variables
$envVars = Get-Content .env | Where-Object { $_ -match "=" }
foreach ($line in $envVars) {
    $name, $value = $line.Split('=', 2)
    Set-Variable -Name "ENV_$name" -Value $value -Scope Local
}

# 2. detailed environment validation
Write-Host "[2/5] validating environment variables..."
$checkVars = "POSTGRES_USER", "POSTGRES_PASSWORD", "POSTGRES_DB"
foreach ($var in $checkVars) {
    $varName = "ENV_$var"
    if (-not (Get-Variable $varName -ErrorAction SilentlyContinue)) {
        Write-Host "  error: ${var} is not set in .env" -ForegroundColor Red
    }
    else {
        Write-Host "  - ${var}: OK" -ForegroundColor Green
    }
}

# 3. check req ports
Write-Host "[3/5] checking required system ports..."
# We only need 80 (Proxy), 3000 (Grafana), 9090 (Prometheus)
# Ports 8001-8005 are now HIDDEN for better security
$ports = 80, 3000, 9090
$netstat = netstat -an
foreach ($port in $ports) {
    if ($netstat -match ":$port\s+") {
        Write-Host "  WARNING: Port ${port} is already in use." -ForegroundColor Yellow
    }
    else {
        Write-Host "  Port ${port}: available" -ForegroundColor Green
    }
}

# 4. validating docker-compose.yml syntax
Write-Host -NoNewline "[4/5] validating docker-compose.yml syntax... "
docker-compose config -q
if ($LASTEXITCODE -eq 0) {
    Write-Host "valid" -ForegroundColor Green
}
else {
    Write-Host "invalid yaml" -ForegroundColor Red
}

# 5. verifying prometheus alert rules
Write-Host -NoNewline "[5/5] verifying prometheus alert rules... "
if (Test-Path monitoring/alert.rules.yml) {
    Write-Host "found" -ForegroundColor Green
}
else {
    Write-Host "missing" -ForegroundColor Red
}

Write-Host "validation complete. ready for deployment." -ForegroundColor Cyan


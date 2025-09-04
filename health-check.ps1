# Health Check Script for FastAPI Application

param(
    [string]$BaseUrl = "http://localhost"
)

Write-Host "FastAPI Application Health Check" -ForegroundColor Cyan
Write-Host "=================================" -ForegroundColor Cyan
Write-Host ""

# Function to test endpoint
function Test-Endpoint {
    param($Url, $Name)
    
    try {
        $response = Invoke-RestMethod -Uri $Url -Method Get -TimeoutSec 10
        Write-Host "✓ $Name" -ForegroundColor Green
        return $true
    } catch {
        Write-Host "✗ $Name - Error: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

# Test endpoints
$frontendOk = Test-Endpoint "$BaseUrl" "Frontend"
$healthOk = Test-Endpoint "$BaseUrl/api/health" "Backend Health"
$apiOk = Test-Endpoint "$BaseUrl/api/users" "API Endpoint"

Write-Host ""

if ($frontendOk -and $healthOk -and $apiOk) {
    Write-Host "🎉 All services are healthy!" -ForegroundColor Green
    exit 0
} else {
    Write-Host "⚠️  Some services are not responding" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Troubleshooting steps:" -ForegroundColor Yellow
    Write-Host "1. Check if containers are running: docker-compose ps"
    Write-Host "2. View logs: docker-compose logs"
    Write-Host "3. Restart services: docker-compose restart"
    exit 1
}

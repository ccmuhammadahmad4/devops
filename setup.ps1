# FastAPI Application Setup Script for PowerShell
# Run this with: .\setup.ps1

Write-Host "==========================================="
Write-Host "    FastAPI Application Setup Script"
Write-Host "==========================================="
Write-Host ""

# Check if Docker is installed
try {
    $dockerVersion = docker --version
    Write-Host "✓ Docker is installed: $dockerVersion" -ForegroundColor Green
} catch {
    Write-Host "✗ ERROR: Docker is not installed or not in PATH" -ForegroundColor Red
    Write-Host "Please install Docker Desktop first:" -ForegroundColor Yellow
    Write-Host "https://docs.docker.com/desktop/install/windows-install/" -ForegroundColor Yellow
    Read-Host "Press any key to exit"
    exit 1
}

Write-Host ""
Write-Host "Building and starting containers..." -ForegroundColor Yellow

# Build and start containers
try {
    docker-compose up --build -d
    Write-Host "✓ Containers started successfully!" -ForegroundColor Green
} catch {
    Write-Host "✗ ERROR: Failed to start containers" -ForegroundColor Red
    Read-Host "Press any key to exit"
    exit 1
}

Write-Host ""
Write-Host "==========================================="
Write-Host "    Application Started Successfully!"
Write-Host "==========================================="
Write-Host ""
Write-Host "🌐 Frontend:        http://localhost" -ForegroundColor Cyan
Write-Host "🔌 Backend API:     http://localhost/api" -ForegroundColor Cyan
Write-Host "📚 API Docs:        http://localhost/api/docs" -ForegroundColor Cyan
Write-Host "💓 Health Check:    http://localhost/api/health" -ForegroundColor Cyan
Write-Host ""
Write-Host "Useful commands:" -ForegroundColor Yellow
Write-Host "  Stop:        docker-compose down"
Write-Host "  View logs:   docker-compose logs -f"
Write-Host "  Rebuild:     docker-compose up --build"
Write-Host ""

# Ask if user wants to open browser
$openBrowser = Read-Host "Open browser? (y/n)"
if ($openBrowser -eq 'y' -or $openBrowser -eq 'Y' -or $openBrowser -eq '') {
    Start-Process "http://localhost"
}

# Ask if user wants to view logs
$viewLogs = Read-Host "View application logs? (y/n)"
if ($viewLogs -eq 'y' -or $viewLogs -eq 'Y') {
    Write-Host ""
    Write-Host "Showing logs (Press Ctrl+C to exit)..." -ForegroundColor Yellow
    docker-compose logs -f
}

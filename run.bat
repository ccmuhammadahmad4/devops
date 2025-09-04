@echo off
echo ===========================================
echo     FastAPI Application Setup Script
echo ===========================================
echo.

REM Check if Docker is installed
docker --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Docker is not installed or not in PATH
    echo Please install Docker Desktop first
    echo https://docs.docker.com/desktop/install/windows-install/
    pause
    exit /b 1
)

echo Docker is installed. Starting application...
echo.

REM Build and start the containers
echo Building and starting containers...
docker-compose up --build -d

if %errorlevel% neq 0 (
    echo ERROR: Failed to start containers
    pause
    exit /b 1
)

echo.
echo ===========================================
echo     Application Started Successfully!
echo ===========================================
echo.
echo Frontend:        http://localhost
echo Backend API:     http://localhost/api
echo API Docs:        http://localhost/api/docs
echo Health Check:    http://localhost/api/health
echo.
echo To stop the application, run: docker-compose down
echo To view logs, run: docker-compose logs -f
echo.
echo Opening browser...
start http://localhost

echo.
echo Press any key to view logs (Ctrl+C to exit logs)...
pause >nul
docker-compose logs -f

@echo off
echo ===========================================
echo     FastAPI Application - Stop Script
echo ===========================================
echo.

echo Stopping containers...
docker-compose down

if %errorlevel% neq 0 (
    echo ERROR: Failed to stop containers
    pause
    exit /b 1
)

echo.
echo Application stopped successfully!
echo.
echo To clean up everything (containers, images, volumes):
echo   docker-compose down -v --rmi all
echo.
pause

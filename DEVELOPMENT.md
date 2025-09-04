# Local Development Setup

## Prerequisites

- Python 3.11+
- Docker Desktop
- Node.js (optional, for frontend tooling)

## Quick Start

### 1. Backend Development

```powershell
# Navigate to backend directory
cd backend

# Create virtual environment
python -m venv venv

# Activate virtual environment
.\venv\Scripts\Activate.ps1

# Install dependencies
pip install -r requirements.txt

# Run the FastAPI server
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

Backend will be available at:
- API: http://localhost:8000
- Documentation: http://localhost:8000/docs

### 2. Frontend Development

Simply open `frontend/index.html` in your browser or use a local server:

```powershell
# Using Python's built-in server
cd frontend
python -m http.server 3000
```

Frontend will be available at: http://localhost:3000

### 3. Docker Development

```powershell
# Build and run all services
docker-compose up --build

# Run in background
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down
```

Application will be available at:
- Frontend: http://localhost
- Backend API: http://localhost/api
- API Docs: http://localhost/api/docs

## Development Commands

### Backend Commands

```powershell
# Install new package
pip install package-name
pip freeze > requirements.txt

# Run tests (when added)
pytest

# Format code
black .
isort .

# Type checking
mypy .
```

### Docker Commands

```powershell
# Rebuild specific service
docker-compose build backend

# View container logs
docker-compose logs backend

# Execute command in container
docker-compose exec backend bash

# Remove all containers and volumes
docker-compose down -v --rmi all
```

## Environment Variables

Copy `.env.example` to `.env` and update the values:

```powershell
copy .env.example .env
```

## Troubleshooting

### Common Issues

1. **Port already in use**
   ```powershell
   # Find process using port
   netstat -ano | findstr :8000
   
   # Kill process
   taskkill /PID <process_id> /F
   ```

2. **Docker issues**
   ```powershell
   # Reset Docker
   docker system prune -a
   
   # Restart Docker Desktop
   ```

3. **Python environment issues**
   ```powershell
   # Remove and recreate virtual environment
   Remove-Item -Recurse -Force venv
   python -m venv venv
   .\venv\Scripts\Activate.ps1
   pip install -r requirements.txt
   ```

## VS Code Setup

Recommended extensions:
- Python
- Docker
- REST Client
- Auto Rename Tag
- Prettier
- GitLens

### VS Code Settings

Create `.vscode/settings.json`:

```json
{
    "python.defaultInterpreterPath": "./backend/venv/Scripts/python.exe",
    "python.formatting.provider": "black",
    "python.linting.enabled": true,
    "python.linting.pylintEnabled": false,
    "python.linting.flake8Enabled": true,
    "editor.formatOnSave": true,
    "docker.showStartPage": false
}
```

# FastAPI + Frontend Project

A simple, clean project with FastAPI backend and HTML/CSS/JavaScript frontend, ready for Azure DevOps CI/CD deployment.

## Project Structure

```
fastapi-nginx/
├── backend/                # FastAPI backend
│   ├── app/
│   │   ├── __init__.py
│   │   ├── main.py        # FastAPI application
│   │   ├── models.py      # Data models
│   │   └── routes.py      # API routes
│   ├── requirements.txt   # Python dependencies
│   └── Dockerfile        # Backend Docker configuration
├── frontend/              # HTML/CSS/JavaScript frontend
│   ├── index.html        # Main page
│   ├── css/
│   │   └── style.css     # Styles
│   ├── js/
│   │   └── app.js        # JavaScript logic
│   └── Dockerfile        # Frontend Docker configuration
├── nginx/                 # Nginx configuration
│   ├── nginx.conf        # Nginx configuration
│   └── Dockerfile        # Nginx Docker configuration
├── docker-compose.yml     # Multi-service setup
├── azure-pipelines.yml    # Azure DevOps CI/CD pipeline
├── .gitignore            # Git ignore file
└── README.md             # This file
```

## Features

- **Backend**: FastAPI with RESTful APIs
- **Frontend**: Responsive HTML/CSS/JavaScript
- **Database**: In-memory storage (easily upgradable to PostgreSQL)
- **Containerization**: Docker support for all services
- **Reverse Proxy**: Nginx for production deployment
- **CI/CD**: Azure DevOps pipeline configuration

## Quick Start

### Local Development

1. **Backend Setup**:
   ```bash
   cd backend
   pip install -r requirements.txt
   uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
   ```

2. **Frontend**: Open `frontend/index.html` in your browser

### Docker Setup

```bash
docker-compose up --build
```

Access the application at:
- Frontend: http://localhost
- Backend API: http://localhost/api
- API Documentation: http://localhost/api/docs

## API Endpoints

- `GET /api/health` - Health check
- `GET /api/users` - Get all users
- `POST /api/users` - Create a new user
- `GET /api/users/{user_id}` - Get user by ID
- `PUT /api/users/{user_id}` - Update user
- `DELETE /api/users/{user_id}` - Delete user

## Azure Deployment

This project is configured for Azure Container Instances deployment through Azure DevOps:

1. Create Azure DevOps project
2. Connect to this repository
3. Run the pipeline defined in `azure-pipelines.yml`
4. The pipeline will build, test, and deploy to Azure

## Environment Variables

- `DATABASE_URL`: Database connection string (for production)
- `CORS_ORIGINS`: Allowed CORS origins
- `DEBUG`: Enable debug mode (development only)

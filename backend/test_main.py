import pytest
from fastapi.testclient import TestClient
from app.main import app

client = TestClient(app)

def test_root():
    """Test root endpoint and push"""
    response = client.get("/")
    assert response.status_code == 200
    data = response.json()
    assert "message" in data
    assert data["status"] == "running"

def test_health_check():
    """Test health check endpoint"""
    response = client.get("/api/health")
    assert response.status_code == 200
    data = response.json()
    assert data["status"] == "healthy"
    assert "timestamp" in data

def test_get_users_empty():
    """Test get users when no users exist"""
    response = client.get("/api/users")
    assert response.status_code == 200
    assert response.json() == []

def test_create_user():
    """Test creating a new user"""
    user_data = {
        "name": "Test User",
        "email": "test@example.com"
    }
    response = client.post("/api/users", json=user_data)
    assert response.status_code == 200
    data = response.json()
    assert data["name"] == user_data["name"]
    assert data["email"] == user_data["email"]
    assert "id" in data
    assert "created_at" in data

def test_create_user_duplicate_email():
    """Test creating user with duplicate email"""
    user_data = {
        "name": "Test User",
        "email": "test@example.com"
    }
    # Create first user
    client.post("/api/users", json=user_data)
    
    # Try to create second user with same email
    response = client.post("/api/users", json=user_data)
    assert response.status_code == 400
    assert "Email already registered" in response.json()["detail"]

def test_get_user_by_id():
    """Test getting user by ID"""
    # Create a user first
    user_data = {
        "name": "Test User 2",
        "email": "test2@example.com"
    }
    create_response = client.post("/api/users", json=user_data)
    user_id = create_response.json()["id"]
    
    # Get the user
    response = client.get(f"/api/users/{user_id}")
    assert response.status_code == 200
    data = response.json()
    assert data["id"] == user_id
    assert data["name"] == user_data["name"]

def test_get_user_not_found():
    """Test getting non-existent user"""
    response = client.get("/api/users/9999")
    assert response.status_code == 404
    assert "User not found" in response.json()["detail"]

def test_update_user():
    """Test updating user"""
    # Create a user first
    user_data = {
        "name": "Test User 3",
        "email": "test3@example.com"
    }
    create_response = client.post("/api/users", json=user_data)
    user_id = create_response.json()["id"]
    
    # Update the user
    update_data = {
        "name": "Updated User",
        "email": "updated@example.com"
    }
    response = client.put(f"/api/users/{user_id}", json=update_data)
    assert response.status_code == 200
    data = response.json()
    assert data["name"] == update_data["name"]
    assert data["email"] == update_data["email"]

def test_delete_user():
    """Test deleting user"""
    # Create a user first
    user_data = {
        "name": "Test User 4",
        "email": "test4@example.com"
    }
    create_response = client.post("/api/users", json=user_data)
    user_id = create_response.json()["id"]
    
    # Delete the user
    response = client.delete(f"/api/users/{user_id}")
    assert response.status_code == 200
    assert "User deleted successfully" in response.json()["message"]
    
    # Verify user is deleted
    get_response = client.get(f"/api/users/{user_id}")
    assert get_response.status_code == 404

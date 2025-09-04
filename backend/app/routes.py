from fastapi import APIRouter, HTTPException
from typing import List
from datetime import datetime
from app.models import User, UserCreate, UserUpdate, HealthResponse

router = APIRouter()

# In-memory storage (replace with database in production)
users_db = []
next_id = 1

@router.get("/health", response_model=HealthResponse)
async def health_check():
    """Health check endpoint"""
    return HealthResponse(
        status="healthy",
        message="API is running successfully",
        timestamp=datetime.now()
    )

@router.get("/users", response_model=List[User])
async def get_users():
    """Get all users"""
    return users_db

@router.post("/users", response_model=User)
async def create_user(user: UserCreate):
    """Create a new user"""
    global next_id
    
    # Check if email already exists
    for existing_user in users_db:
        if existing_user.email == user.email:
            raise HTTPException(status_code=400, detail="Email already registered")
    
    new_user = User(
        id=next_id,
        name=user.name,
        email=user.email,
        created_at=datetime.now()
    )
    users_db.append(new_user)
    next_id += 1
    return new_user

@router.get("/users/{user_id}", response_model=User)
async def get_user(user_id: int):
    """Get user by ID"""
    for user in users_db:
        if user.id == user_id:
            return user
    raise HTTPException(status_code=404, detail="User not found")

@router.put("/users/{user_id}", response_model=User)
async def update_user(user_id: int, user_update: UserUpdate):
    """Update user"""
    for i, user in enumerate(users_db):
        if user.id == user_id:
            if user_update.name is not None:
                user.name = user_update.name
            if user_update.email is not None:
                # Check if new email already exists
                for other_user in users_db:
                    if other_user.id != user_id and other_user.email == user_update.email:
                        raise HTTPException(status_code=400, detail="Email already registered")
                user.email = user_update.email
            users_db[i] = user
            return user
    raise HTTPException(status_code=404, detail="User not found")

@router.delete("/users/{user_id}")
async def delete_user(user_id: int):
    """Delete user"""
    for i, user in enumerate(users_db):
        if user.id == user_id:
            del users_db[i]
            return {"message": "User deleted successfully"}
    raise HTTPException(status_code=404, detail="User not found")

// API Configuration
const API_BASE_URL = window.location.origin + '/api';

// DOM Elements
const userForm = document.getElementById('userForm');
const usersContainer = document.getElementById('usersContainer');
const loading = document.getElementById('loading');
const statusIndicator = document.getElementById('statusIndicator');
const statusText = document.getElementById('statusText');
const statusDot = statusIndicator.querySelector('.status-dot');
const toast = document.getElementById('toast');

// Application State
let users = [];

// Initialize Application
document.addEventListener('DOMContentLoaded', function() {
    checkAPIHealth();
    loadUsers();
    setupEventListeners();
});

// Event Listeners
function setupEventListeners() {
    userForm.addEventListener('submit', handleUserSubmit);
}

// API Health Check
async function checkAPIHealth() {
    try {
        statusText.textContent = 'Checking API...';
        statusDot.className = 'status-dot checking';
        
        const response = await fetch(`${API_BASE_URL}/health`);
        
        if (response.ok) {
            const health = await response.json();
            statusText.textContent = `API is ${health.status}`;
            statusDot.className = 'status-dot healthy';
        } else {
            throw new Error('API health check failed');
        }
    } catch (error) {
        console.error('API health check failed:', error);
        statusText.textContent = 'API is offline';
        statusDot.className = 'status-dot';
    }
}

// Load Users
async function loadUsers() {
    try {
        loading.style.display = 'block';
        
        const response = await fetch(`${API_BASE_URL}/users`);
        
        if (response.ok) {
            users = await response.json();
            renderUsers();
        } else {
            throw new Error('Failed to load users');
        }
    } catch (error) {
        console.error('Error loading users:', error);
        showToast('Failed to load users', 'error');
        usersContainer.innerHTML = '<div class="no-users">Failed to load users</div>';
    } finally {
        loading.style.display = 'none';
    }
}

// Render Users
function renderUsers() {
    if (users.length === 0) {
        usersContainer.innerHTML = '<div class="no-users">No users found. Add some users to get started!</div>';
        return;
    }

    const usersHTML = users.map(user => `
        <div class="user-card" data-user-id="${user.id}">
            <div class="user-info">
                <h3>${escapeHtml(user.name)}</h3>
                <p><strong>Email:</strong> ${escapeHtml(user.email)}</p>
                <small><strong>Created:</strong> ${formatDate(user.created_at)}</small>
            </div>
            <div class="user-actions">
                <button class="btn btn-edit" onclick="editUser(${user.id})">Edit</button>
                <button class="btn btn-danger" onclick="deleteUser(${user.id})">Delete</button>
            </div>
        </div>
    `).join('');

    usersContainer.innerHTML = usersHTML;
}

// Handle User Form Submit
async function handleUserSubmit(event) {
    event.preventDefault();
    
    const formData = new FormData(userForm);
    const userData = {
        name: formData.get('name').trim(),
        email: formData.get('email').trim()
    };

    // Basic validation
    if (!userData.name || !userData.email) {
        showToast('Please fill in all fields', 'error');
        return;
    }

    try {
        const response = await fetch(`${API_BASE_URL}/users`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(userData)
        });

        if (response.ok) {
            const newUser = await response.json();
            users.push(newUser);
            renderUsers();
            userForm.reset();
            showToast('User added successfully!', 'success');
        } else {
            const error = await response.json();
            throw new Error(error.detail || 'Failed to add user');
        }
    } catch (error) {
        console.error('Error adding user:', error);
        showToast(error.message, 'error');
    }
}

// Edit User
async function editUser(userId) {
    const user = users.find(u => u.id === userId);
    if (!user) return;

    const newName = prompt('Enter new name:', user.name);
    if (newName === null) return; // User cancelled

    const newEmail = prompt('Enter new email:', user.email);
    if (newEmail === null) return; // User cancelled

    if (!newName.trim() || !newEmail.trim()) {
        showToast('Name and email cannot be empty', 'error');
        return;
    }

    try {
        const response = await fetch(`${API_BASE_URL}/users/${userId}`, {
            method: 'PUT',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                name: newName.trim(),
                email: newEmail.trim()
            })
        });

        if (response.ok) {
            const updatedUser = await response.json();
            const userIndex = users.findIndex(u => u.id === userId);
            users[userIndex] = updatedUser;
            renderUsers();
            showToast('User updated successfully!', 'success');
        } else {
            const error = await response.json();
            throw new Error(error.detail || 'Failed to update user');
        }
    } catch (error) {
        console.error('Error updating user:', error);
        showToast(error.message, 'error');
    }
}

// Delete User
async function deleteUser(userId) {
    const user = users.find(u => u.id === userId);
    if (!user) return;

    if (!confirm(`Are you sure you want to delete ${user.name}?`)) {
        return;
    }

    try {
        const response = await fetch(`${API_BASE_URL}/users/${userId}`, {
            method: 'DELETE'
        });

        if (response.ok) {
            users = users.filter(u => u.id !== userId);
            renderUsers();
            showToast('User deleted successfully!', 'success');
        } else {
            const error = await response.json();
            throw new Error(error.detail || 'Failed to delete user');
        }
    } catch (error) {
        console.error('Error deleting user:', error);
        showToast(error.message, 'error');
    }
}

// Show Toast Message
function showToast(message, type = 'success') {
    toast.textContent = message;
    toast.className = `toast ${type}`;
    toast.classList.add('show');

    setTimeout(() => {
        toast.classList.remove('show');
    }, 3000);
}

// Utility Functions
function escapeHtml(text) {
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
}

function formatDate(dateString) {
    if (!dateString) return 'N/A';
    
    try {
        const date = new Date(dateString);
        return date.toLocaleDateString('en-US', {
            year: 'numeric',
            month: 'short',
            day: 'numeric',
            hour: '2-digit',
            minute: '2-digit'
        });
    } catch (error) {
        return 'Invalid Date';
    }
}

// Auto-refresh users every 30 seconds
setInterval(() => {
    checkAPIHealth();
    loadUsers();
}, 30000);

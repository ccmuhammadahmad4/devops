# Azure DevOps Deployment Guide

## Azure mein Application Access karne ke liye Setup

### 1. **Azure Service Connection Setup**

Azure DevOps mein access karne ke liye pehle yeh service connections banane hain:

#### a) Azure Subscription Service Connection:
1. Azure DevOps project mein jao
2. **Project Settings** → **Service connections**
3. **New service connection** → **Azure Resource Manager**
4. **Service principal (automatic)** select karo
5. Name: `azure-subscription`
6. Resource group: **All resource groups** ya specific select karo

#### b) Container Registry Service Connection (Optional):
1. **New service connection** → **Docker Registry**
2. Registry type: **Azure Container Registry**
3. Connection name: `acr-connection`

### 2. **Pipeline Environment Setup**

1. Azure DevOps mein **Environments** section mein jao
2. **New environment** create karo
3. Name: `production`
4. Resource: **None** (for now)

### 3. **Azure Resources Required**

Pipeline automatically yeh resources banayega:

```bash
# Resource Group
Resource Group: fastapi-rg
Location: East US

# Azure Container Registry (ACR)
Name: fastapiacr{BuildId}
SKU: Basic

# Azure Container Instances (ACI)
Backend: fastapi-backend
Frontend: fastapi-frontend
```

### 4. **Pipeline Variables (Optional)**

Azure DevOps mein pipeline variables set kar sakte hain:

| Variable | Default Value | Description |
|----------|---------------|-------------|
| `resourceGroupName` | `fastapi-rg` | Azure resource group name |
| `location` | `East US` | Azure region |
| `containerRegistry` | `fastapiacr$(Build.BuildId)` | ACR name |

### 5. **Manual Azure Setup (Alternative)**

Agar manual setup karna hai:

```bash
# Azure CLI commands
az login
az group create --name fastapi-rg --location "East US"
az acr create --resource-group fastapi-rg --name fastapiacr001 --sku Basic --admin-enabled true
```

## Pipeline Run karne ke baad Access URLs

Pipeline successfully run hone ke baad yeh URLs milenge:

### 🌐 **Public Access URLs**
- **Frontend**: `http://{FRONTEND_IP}`
- **Backend API**: `http://{BACKEND_IP}:8000`
- **API Documentation**: `http://{BACKEND_IP}:8000/docs`

### 🔍 **Azure Portal mein Check karna**

1. [Azure Portal](https://portal.azure.com) mein login karo
2. **Resource Groups** → `fastapi-rg`
3. Container instances dekho:
   - `fastapi-backend` - Backend API
   - `fastapi-frontend` - Frontend + Nginx
4. IP addresses copy karo

### 📊 **Pipeline Output**

Pipeline ke last step mein yeh information display hogi:

```
================================
🚀 DEPLOYMENT SUCCESSFUL!
================================
Frontend URL: http://20.XXX.XXX.XXX
Backend API: http://20.XXX.XXX.XXX:8000
API Docs: http://20.XXX.XXX.XXX:8000/docs
================================
```

## Troubleshooting

### Common Issues:

1. **Service Connection Error**:
   - Azure subscription service connection properly configure karo
   - Permissions check karo

2. **ACR Access Error**:
   - Admin user enabled hai ya nahi check karo
   - Credentials properly set hain ya nahi

3. **Container Instance Creation Failed**:
   - Resource limits check karo
   - Region availability check karo

### Commands for Debugging:

```bash
# Check Azure resources
az group list --output table
az acr list --output table
az container list --output table

# Get container logs
az container logs --resource-group fastapi-rg --name fastapi-backend
az container logs --resource-group fastapi-rg --name fastapi-frontend
```

## Cost Management

Azure Container Instances charging:
- **vCPU**: ~$0.0012 per vCPU/second
- **Memory**: ~$0.00017 per GB/second
- **Basic setup**: ~$5-10 per month

Container stop karne ke liye:
```bash
az container stop --resource-group fastapi-rg --name fastapi-backend
az container stop --resource-group fastapi-rg --name fastapi-frontend
```

## Next Steps

1. Custom domain setup
2. HTTPS/SSL certificates
3. Azure Application Gateway for load balancing
4. Azure Database integration
5. Monitoring with Application Insights

---

**Important**: Service connection setup karna zaroori hai pipeline run karne se pehle!

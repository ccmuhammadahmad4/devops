# Azure DevOps CI/CD Deployment Guide

This guide will help you set up complete CI/CD pipeline for your FastAPI application on Azure.

## Prerequisites

1. Azure Subscription
2. Azure DevOps Organization
3. Azure Container Registry (ACR)
4. Azure Resource Group

## Step 1: Azure Resources Setup

### Create Azure Container Registry

```bash
# Login to Azure
az login

# Create resource group
az group create --name fastapi-rg --location "East US"

# Create Azure Container Registry
az acr create --resource-group fastapi-rg --name fastapiregistry --sku Basic --admin-enabled true

# Get ACR credentials
az acr credential show --name fastapiregistry
```

### Create Azure App Service (Alternative to Container Instances)

```bash
# Create App Service Plan
az appservice plan create --name fastapi-plan --resource-group fastapi-rg --sku B1 --is-linux

# Create Web App
az webapp create --resource-group fastapi-rg --plan fastapi-plan --name fastapi-webapp --deployment-container-image-name fastapiregistry.azurecr.io/fastapi-app:latest
```

## Step 2: Azure DevOps Project Setup

### Create New Project

1. Go to https://dev.azure.com
2. Create new project: "FastAPI-Application"
3. Choose Git version control

### Service Connections

Create the following service connections in Project Settings:

#### Azure Resource Manager Connection
- Connection name: `azure-subscription`
- Subscription: Your Azure subscription
- Resource group: `fastapi-rg`

#### Docker Registry Connection
- Connection name: `acr-service-connection`
- Registry URL: `fastapiregistry.azurecr.io`
- Username: ACR admin username
- Password: ACR admin password

## Step 3: Pipeline Configuration

### Update Pipeline Variables

In `azure-pipelines.yml`, update these variables:

```yaml
variables:
  dockerRegistryServiceConnection: 'acr-service-connection'
  imageRepository: 'fastapi-app'
  containerRegistry: 'fastapiregistry.azurecr.io'
  azureSubscription: 'azure-subscription'
  appName: 'fastapi-webapp'
  resourceGroupName: 'fastapi-rg'
```

### Repository Setup

1. Push your code to Azure DevOps repository:

```bash
git remote add origin https://dev.azure.com/yourorg/FastAPI-Application/_git/FastAPI-Application
git branch -M main
git push -u origin main
```

## Step 4: Create Pipeline

### Method 1: Using Azure DevOps UI

1. Go to Pipelines → Create Pipeline
2. Choose "Azure Repos Git"
3. Select your repository
4. Choose "Existing Azure Pipelines YAML file"
5. Select `/azure-pipelines.yml`
6. Review and run

### Method 2: Using Azure CLI

```bash
# Create pipeline
az pipelines create --name "FastAPI-CI-CD" --description "FastAPI Application CI/CD" --repository https://dev.azure.com/yourorg/FastAPI-Application/_git/FastAPI-Application --branch main --yml-path azure-pipelines.yml
```

## Step 5: Environment Setup

### Create Environment

1. Go to Pipelines → Environments
2. Create new environment: "production"
3. Add approval checks if needed

### Variable Groups (Optional)

Create variable group for sensitive data:

1. Go to Pipelines → Library
2. Create variable group: "production-vars"
3. Add variables:
   - `DATABASE_URL`
   - `SECRET_KEY`
   - `CORS_ORIGINS`

## Step 6: Monitoring and Logging

### Application Insights

```bash
# Create Application Insights
az monitor app-insights component create --app fastapi-insights --location "East US" --resource-group fastapi-rg --application-type web
```

### Log Analytics

```bash
# Create Log Analytics workspace
az monitor log-analytics workspace create --workspace-name fastapi-logs --resource-group fastapi-rg --location "East US"
```

## Step 7: Security Best Practices

### Key Vault Integration

```bash
# Create Key Vault
az keyvault create --name fastapi-keyvault --resource-group fastapi-rg --location "East US"

# Add secrets
az keyvault secret set --vault-name fastapi-keyvault --name "database-url" --value "your-database-connection-string"
az keyvault secret set --vault-name fastapi-keyvault --name "secret-key" --value "your-secret-key"
```

### Update Pipeline for Key Vault

Add to your pipeline:

```yaml
- task: AzureKeyVault@2
  inputs:
    azureSubscription: $(azureSubscription)
    KeyVaultName: 'fastapi-keyvault'
    SecretsFilter: '*'
    RunAsPreJob: true
```

## Step 8: Custom Domain and SSL

### Configure Custom Domain

```bash
# Add custom domain
az webapp config hostname add --webapp-name fastapi-webapp --resource-group fastapi-rg --hostname yourdomain.com

# Enable SSL
az webapp config ssl bind --certificate-thumbprint <thumbprint> --ssl-type SNI --name fastapi-webapp --resource-group fastapi-rg
```

## Step 9: Scaling Configuration

### Auto-scaling Rules

```bash
# Create auto-scale setting
az monitor autoscale create --resource-group fastapi-rg --resource fastapi-webapp --resource-type Microsoft.Web/serverFarms --name fastapi-autoscale --min-count 1 --max-count 5 --count 2

# Add scale-out rule
az monitor autoscale rule create --resource-group fastapi-rg --autoscale-name fastapi-autoscale --condition "Percentage CPU > 70 avg 5m" --scale out 1
```

## Step 10: Backup and Disaster Recovery

### Database Backup (if using Azure SQL)

```bash
# Create SQL Database
az sql server create --name fastapi-sql-server --resource-group fastapi-rg --location "East US" --admin-user sqladmin --admin-password YourPassword123!

az sql db create --resource-group fastapi-rg --server fastapi-sql-server --name fastapi-db --service-objective Basic
```

## Troubleshooting

### Common Issues

1. **Registry Authentication Failed**
   - Verify ACR service connection
   - Check ACR admin credentials

2. **Deployment Failed**
   - Check resource group permissions
   - Verify App Service configuration

3. **Pipeline Fails**
   - Check service connection permissions
   - Verify Azure subscription access

### Useful Commands

```bash
# Check deployment status
az webapp deployment list --name fastapi-webapp --resource-group fastapi-rg

# View container logs
az webapp log tail --name fastapi-webapp --resource-group fastapi-rg

# Restart app
az webapp restart --name fastapi-webapp --resource-group fastapi-rg
```

## Monitoring URLs

After deployment, monitor these URLs:

- Application: `https://fastapi-webapp.azurewebsites.net`
- Health Check: `https://fastapi-webapp.azurewebsites.net/api/health`
- API Docs: `https://fastapi-webapp.azurewebsites.net/api/docs`
- Container Registry: `https://fastapiregistry.azurecr.io`

## Cost Optimization

1. Use Azure Cost Management to monitor spending
2. Set up budget alerts
3. Use B1 App Service Plan for development
4. Scale down during off-hours
5. Use Azure Reserved Instances for production

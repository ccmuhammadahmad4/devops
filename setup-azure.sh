#!/bin/bash

# Quick Azure Setup Script for FastAPI Deployment

echo "🚀 Setting up Azure resources for FastAPI deployment..."

# Variables
RESOURCE_GROUP="fastapi-rg"
LOCATION="East US"
ACR_NAME="fastapiacr$(date +%s)"
APP_ENV_NAME="fastapi-env"

echo "Creating resource group: $RESOURCE_GROUP"
az group create --name $RESOURCE_GROUP --location "$LOCATION"

echo "Creating Azure Container Registry: $ACR_NAME"
az acr create --resource-group $RESOURCE_GROUP --name $ACR_NAME --sku Basic --admin-enabled true

echo "Creating Container Apps Environment: $APP_ENV_NAME"
az containerapp env create --name $APP_ENV_NAME --resource-group $RESOURCE_GROUP --location "$LOCATION"

echo "✅ Azure resources created successfully!"
echo ""
echo "📋 Resource Information:"
echo "Resource Group: $RESOURCE_GROUP"
echo "Container Registry: $ACR_NAME"
echo "Container Apps Environment: $APP_ENV_NAME"
echo ""
echo "🔧 Next steps:"
echo "1. Update azure-pipelines.yml with these resource names"
echo "2. Create Azure service connection in Azure DevOps"
echo "3. Run the pipeline to deploy"

# Quick Azure Setup Script for FastAPI Deployment

Write-Host "🚀 Setting up Azure resources for FastAPI deployment..." -ForegroundColor Green

# Variables
$RESOURCE_GROUP = "fastapi-rg"
$LOCATION = "East US"
$ACR_NAME = "fastapiacr$(Get-Date -Format 'yyyyMMddHHmm')"
$APP_ENV_NAME = "fastapi-env"

Write-Host "Creating resource group: $RESOURCE_GROUP" -ForegroundColor Yellow
az group create --name $RESOURCE_GROUP --location $LOCATION

Write-Host "Creating Azure Container Registry: $ACR_NAME" -ForegroundColor Yellow
az acr create --resource-group $RESOURCE_GROUP --name $ACR_NAME --sku Basic --admin-enabled true

Write-Host "Creating Container Apps Environment: $APP_ENV_NAME" -ForegroundColor Yellow
az containerapp env create --name $APP_ENV_NAME --resource-group $RESOURCE_GROUP --location $LOCATION

Write-Host "✅ Azure resources created successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "📋 Resource Information:" -ForegroundColor Cyan
Write-Host "Resource Group: $RESOURCE_GROUP"
Write-Host "Container Registry: $ACR_NAME"
Write-Host "Container Apps Environment: $APP_ENV_NAME"
Write-Host ""
Write-Host "🔧 Next steps:" -ForegroundColor Cyan
Write-Host "1. Update azure-pipelines.yml with these resource names"
Write-Host "2. Create Azure service connection in Azure DevOps"
Write-Host "3. Run the pipeline to deploy"

# Save variables to file for reference
@"
# Azure Resource Variables - Generated $(Get-Date)
RESOURCE_GROUP=$RESOURCE_GROUP
CONTAINER_REGISTRY=$ACR_NAME
APP_ENV_NAME=$APP_ENV_NAME
LOCATION=$LOCATION
"@ | Out-File -FilePath "azure-resources.txt" -Encoding UTF8

Write-Host ""
Write-Host "📄 Resource details saved to azure-resources.txt" -ForegroundColor Green

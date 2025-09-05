# Alternative: Azure Container Apps Deployment

## Add this stage to your azure-pipelines.yml instead of the complex ACI deployment

```yaml
- stage: DeployContainerApps
  displayName: Deploy to Azure Container Apps
  dependsOn: Build
  condition: succeeded()
  jobs:
  - deployment: DeployToContainerApps
    displayName: Deploy to Azure Container Apps
    pool:
      name: 'muhammad-ahmad'
      demands:
        - Agent.Name -equals ahmad
    environment: 'production'
    strategy:
      runOnce:
        deploy:
          steps:
          # Download artifacts
          - download: current
            artifact: backend-image
          - download: current
            artifact: frontend-image
          
          # Azure Container Apps deployment (simpler)
          - task: AzureCLI@2
            displayName: 'Deploy to Container Apps'
            inputs:
              azureSubscription: 'azure-subscription'
              scriptType: 'batch'
              scriptLocation: 'inlineScript'
              inlineScript: |
                echo Creating Container Apps Environment...
                az containerapp env create --name fastapi-env --resource-group $(resourceGroupName) --location "$(location)"
                
                echo Deploying backend container app...
                az containerapp create --name fastapi-backend-app --resource-group $(resourceGroupName) --environment fastapi-env --image $(containerRegistry).azurecr.io/$(imageRepository)-backend:$(Build.BuildId) --target-port 8000 --ingress external --query "properties.configuration.ingress.fqdn"
                
                echo Deploying frontend container app...
                az containerapp create --name fastapi-frontend-app --resource-group $(resourceGroupName) --environment fastapi-env --image $(containerRegistry).azurecr.io/$(imageRepository)-frontend:$(Build.BuildId) --target-port 80 --ingress external --query "properties.configuration.ingress.fqdn"
```

## Benefits of Container Apps:
- Automatic HTTPS
- Better scaling
- More cost-effective
- Easier management

# Prerequisites

- Visual Studio Code
- .NET 6 SDK
- Bicep extension (recommended)
- Docker Desktop
- Azure CLI
- Azure Subscription

# Deploy solution to Azure

## Create a new resource group

```
az group create -n acasample -l northeurope
```

## Create a new Azure Container Registry (ACR)

```
az acr create -g acasample \
              -n acasamplepb1 \
              --sku Basic \
              --admin-enabled true \
```

## Push sample app to registry

### Login to ACR

```
az acr login -n acasamplepb1
```

### Build image and push to ACR

```
cd app/app
docker build --push . -t acasamplepb1.azurecr.io/acamanagedidentities -f Dockerfile
```

## Deploy Bicep

```
az deployment group create -g acasample \
                           -n acasample-deployment \
                           --template-file ./infra/solution.bicep \
                           -p name=acasample \
                              mySecretValue=42 \
                              registryName=acasamplepb1 \
                              registryResourceGroupName=acasample \
                              containerImage=acasamplepb1.azurecr.io/acamanagedidentities:latest
```

## Cleanup

### Remove resource group

```
az group delete --name acasample
```

### Purge KeyVault

```
az keyvault purge -n acasample
```
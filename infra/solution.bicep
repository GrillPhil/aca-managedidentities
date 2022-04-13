param name string
param location string = resourceGroup().location
param mySecretName string = 'mySecret'
param mySecretValue string
param registryName string
param registryResourceGroupName string
param containerImage string

module keyVault 'keyvault.bicep' = {
  name: 'keyVault-deployment'
  params: {
    name: name
    location: location
    secrets: [
      {
        name: mySecretName
        value: mySecretValue
      }
    ]
  }
}

module containerEnv 'container-env.bicep' = {
  name: 'containerEnv-deployment'
  params: {
    name: name
    location: location
  }
}

module containerApp 'container-app.bicep' = {
  name: 'containerApp-deployment'
  params: {
    name: name
    location: location
    envId: containerEnv.outputs.id
    registryName: registryName
    registryResourceGroupName: registryResourceGroupName
    containerImage: containerImage
    containerPort: 80
    useExternalIngress: true
    appSettings: [
      {
        name: 'keyVaultName'
        value: keyVault.outputs.keyVaultName
      }
      {
        name: 'secretName'
        value: mySecretName
      }
    ]
  }
}

module rbacContainerApp2KeyVault 'rbac-keyvault.bicep' = {
  name: 'rbac-containerApp-2-keyVault-deployment'
  params: {
    keyVaultName: keyVault.outputs.keyVaultName
    serviceName: name
    servicePrincipalId: containerApp.outputs.principalId
  }
}

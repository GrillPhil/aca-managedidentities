param name string
param location string = resourceGroup().location
param secrets array = []

resource keyVault 'Microsoft.KeyVault/vaults@2021-06-01-preview' = {
  name: name
  location: location
  properties: {
    enabledForTemplateDeployment: true
    enableRbacAuthorization: true
    tenantId: subscription().tenantId
    sku: {
      family: 'A'
      name: 'standard'
    }
  }
  resource secret 'secrets' = [for s in secrets: {
    name: s.name
    properties: {
      value: s.value
    }
  }]
}

output keyVaultName string = keyVault.name

param keyVaultName string
param serviceName string
param servicePrincipalId string 
param roleId string = '4633458b-17de-408a-b874-0445c86b69e6' // Secret User by default

resource keyVault 'Microsoft.KeyVault/vaults@2021-06-01-preview' existing = {
  name: keyVaultName
}

resource keyVaultRoleAssignment 'Microsoft.Authorization/roleAssignments@2020-08-01-preview' = {
  name: guid(subscription().subscriptionId, serviceName)
  scope: keyVault
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleId)
    principalId: servicePrincipalId
    principalType: 'ServicePrincipal'
  }
}


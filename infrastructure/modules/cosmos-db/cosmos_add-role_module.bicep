targetScope = 'resourceGroup'

@description('Cosmos DB のリソース名')
param cosmosDbName string

@description('マネージドIDのリソース名')
@minLength(3)
@maxLength(128)
param userAssignedIdentityName string

@description('マネージドIDに付与するロールID')
param roleDefinitionId string = '5bd9cd88-fe45-4216-938b-f97437e15450'

var roleAssignmentName = guid(userAssignedIdentityName,roleDefinitionId, resourceGroup().id)

resource existingCosmosDb 'Microsoft.DocumentDB/databaseAccounts@2024-05-15' existing =  {
  name: cosmosDbName
}

resource existingUserAssignedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' existing = {
  name: userAssignedIdentityName
}

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: roleAssignmentName
  scope: existingCosmosDb
  properties: {
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', roleDefinitionId)
    principalId: existingUserAssignedIdentity.properties.principalId
    principalType: 'ServicePrincipal'
  }
}

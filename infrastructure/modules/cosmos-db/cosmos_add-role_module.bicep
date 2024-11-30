targetScope = 'resourceGroup'

@description('Cosmos DB のリソース名')
param cosmosDbName string

@description('マネージドIDのリソース名')
@minLength(3)
@maxLength(128)
param userAssignedIdentityName string

@description('マネージドIDに付与するロールID')
param roleDefinitionId string = 'b24988ac-6180-42a0-ab88-20f7382dd24c'

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
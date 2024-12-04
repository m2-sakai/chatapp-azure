targetScope = 'resourceGroup'

@description('WebPubSub のリソース名')
param webPubSubName string

@description('マネージドIDのリソース名')
@minLength(3)
@maxLength(128)
param userAssignedIdentityName string

@description('マネージドIDに付与するロールID')
param roleDefinitionId string = '12cf5a90-567b-43ae-8102-96cf46c7d9b4'

var roleAssignmentName = guid(userAssignedIdentityName,roleDefinitionId, resourceGroup().id)

resource existingWebPubSub 'Microsoft.SignalRService/WebPubSub@2024-04-01-preview' existing = {
  name: webPubSubName
}

resource existingUserAssignedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' existing = {
  name: userAssignedIdentityName
}

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: roleAssignmentName
  scope: existingWebPubSub
  properties: {
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', roleDefinitionId)
    principalId: existingUserAssignedIdentity.properties.principalId
    principalType: 'ServicePrincipal'
  }
}

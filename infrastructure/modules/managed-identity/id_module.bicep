targetScope = 'resourceGroup'

@description('場所')
param location string = resourceGroup().location

@description('タグ名')
param tag object = {}

@description('マネージドIDのリソース名')
@minLength(3)
@maxLength(128)
param userAssignedIdentityName string

resource userAssignedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: userAssignedIdentityName
  location: location
  tags: tag
}

output userAssignedIdentityId string = userAssignedIdentity.id
output userAssignedIdentityClientId string = userAssignedIdentity.properties.clientId
output userAssignedIdentityPrincipalId string = userAssignedIdentity.properties.principalId


targetScope = 'resourceGroup'

/*** param: 共通 ***/
@description('場所')
param location string = resourceGroup().location

@description('タグ名')
param tag object = {}

/*** param: User Assigned Managed Id ***/
@description('マネージドIDのリソース名')
@minLength(3)
@maxLength(128)
param userAssignedIdentityName string

/*** resource/module: User Assigned Managed Id ***/
module idModule '../../modules/managed-identity/id_module.bicep' = {
  name: '${userAssignedIdentityName}_Deployment'
  params: {
    location: location
    tag: tag
    userAssignedIdentityName: userAssignedIdentityName
  }
  dependsOn: []
}

output userAssignedIdentityId string = idModule.outputs.userAssignedIdentityId
output userAssignedIdentityClientId string = idModule.outputs.userAssignedIdentityClientId
output userAssignedIdentityPrincipalId string = idModule.outputs.userAssignedIdentityPrincipalId

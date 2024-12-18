targetScope = 'resourceGroup'

/*** param: 共通 ***/
@description('場所')
param location string = resourceGroup().location

@description('タグ名')
param tag object = {}

/*** param: Cosmos DB ***/
@description('Cosmos DB のリソース名')
param cosmosDbName string

/*** param: Private Endpoint ***/
@description('プライベートエンドポイントのリソース名')
@minLength(2)
@maxLength(64)
param privateEndpointName string

@description('接続する必要があるリモートリソースから取得したグループのID')
param privateLinkServiceGroupIds array

@description('リモートリソースへの接続の状態に関する読み取り専用情報のコレクション')
param privateLinkServiceConnectionState object = {
  status: 'Approved'
  actionsRequired: 'None'
}

@description('プライベートIPを静的に割り当てるか')
param assignStaticPrivateIP bool = false

@description('プライベートIPを静的に割り当てる場合のIPアドレス情報')
param privateIPAddressInfo object = {}

@description('仮想ネットワークのリソース名')
param virtualNetworkName string

@description('プライベートエンドポイントのための仮想ネットワークのサブネット名')
@minLength(1)
@maxLength(80)
param privateEndpointSubnetName string

@description('プライベートDNSゾーンのリソース情報')
param privateDnsZoneName string

/*** param: Role Assignment ***/
@description('マネージドIDのリソース名')
@minLength(3)
@maxLength(128)
param userAssignedIdentityName string

@description('マネージドIDに付与するロールID')
param roleDefinitionId string = '00000000-0000-0000-0000-000000000002'

/*** resource/module: Cosmos DB ***/
module cosmosModule '../../modules/cosmos-db/cosmos_module.bicep' = {
  name: '${cosmosDbName}_Deployment'
  params: {
    location: location
    tag: tag
    cosmosDbName: cosmosDbName
  }
  dependsOn: []
}

/*** resource/module: Private Endpoint ***/
module cosmosPepModule '../../modules/private-endpoint/pep_module.bicep' = {
  name: '${privateEndpointName}_Deployment'
  params: {
    location: location
    tag: tag
    privateEndpointName: privateEndpointName
    privateLinkServiceId: cosmosModule.outputs.cosmosDbId
    privateLinkServiceGroupIds: privateLinkServiceGroupIds
    privateLinkServiceConnectionState: privateLinkServiceConnectionState
    assignStaticPrivateIP: assignStaticPrivateIP
    privateIPAddressInfo: privateIPAddressInfo
    virtualNetworkName: virtualNetworkName
    subnetName: privateEndpointSubnetName
    privateDnsZoneName: privateDnsZoneName
  }
  dependsOn: [
    cosmosModule
  ]
}

/*** resource/module: Role Assignment ***/
module roleModule '../../modules/cosmos-db/cosmos_add-role_module.bicep' = {
  name: '${cosmosDbName}_role_Deployment'
  params: {
    cosmosDbName: cosmosDbName
    userAssignedIdentityName: userAssignedIdentityName
    roleDefinitionId: roleDefinitionId
  }
  dependsOn: [
    cosmosModule
  ]
}

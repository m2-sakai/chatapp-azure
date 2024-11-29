targetScope = 'resourceGroup'

/*** param: 共通 ***/
@description('場所')
param location string = resourceGroup().location

@description('タグ名')
param tag object = {}

/*** param: Web PubSub ***/
@description('WebPubSub のリソース名')
param webPubSubName string

@description('WebPubSubのSKU名')
param skuName string = 'Standard_S1'

@description('WebPubSubのSKUTier')
param skuTier string = 'Standard'

@description('パブリックアクセスの有効化')
@allowed([
  'Enabled'
  'Disabled'
])
param publicNetworkAccess string = 'Disabled'

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

/*** resource/module: Web PubSub ***/
module wpsModule '../../modules/web-pubsub/wps_module.bicep' = {
  name: '${webPubSubName}_Deployment'
  params: {
    location: location
    tag: tag
    webPubSubName: webPubSubName
    skuName: skuName
    skuTier: skuTier
    publicNetworkAccess: publicNetworkAccess
  }
  dependsOn: []
}

/*** resource/module: Private Endpoint ***/
module wpsPepModule '../../modules/private-endpoint/pep_module.bicep' = {
  name: '${privateEndpointName}_Deployment'
  params: {
    location: location
    tag: tag
    privateEndpointName: privateEndpointName
    privateLinkServiceId: wpsModule.outputs.webPubSubId
    privateLinkServiceGroupIds: privateLinkServiceGroupIds
    privateLinkServiceConnectionState: privateLinkServiceConnectionState
    assignStaticPrivateIP: assignStaticPrivateIP
    privateIPAddressInfo: privateIPAddressInfo
    virtualNetworkName: virtualNetworkName
    subnetName: privateEndpointSubnetName
    privateDnsZoneName: privateDnsZoneName
  }
  dependsOn: [
    wpsModule
  ]
}

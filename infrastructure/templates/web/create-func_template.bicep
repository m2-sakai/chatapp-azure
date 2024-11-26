targetScope = 'resourceGroup'

/*** param: 共通 ***/
@description('場所')
param location string = resourceGroup().location

@description('タグ名')
param tag object = {}

/*** param: Functions ***/
@description('Functionsのリソース名')
param functionAppName string

@description('パブリックアクセスの許可')
@allowed([
  'Enabled'
  'Disabled'
])
param publicNetworkAccess string = 'Disabled'

@description('IP制限のルール')
param ipSecurityRestrictions array = []

@description('SCMのIP制限のルール')
param scmIpSecurityRestrictions array = []

@description('アプリ観点のアプリケーション設定')
param aplAppSettings array = []

@description('App Service Planのリソース名')
@minLength(1)
@maxLength(60)
param appServicePlanName string

@description('マネージドIDのリソース名')
param userAssignedIdentityName string

@description('仮想ネットワーク統合のための仮想ネットワークのリソース名')
param virtualNetworkName string

@description('仮想ネットワーク統合のための仮想ネットワークのサブネット名')
@minLength(1)
@maxLength(80)
param subnetName string

@description('ストレージアカウント Blob ストレージ用のリソース名')
@minLength(3)
@maxLength(24)
param storageAccountBlobStorageName string

@description('Application Insightsのリソース名')
@minLength(1)
@maxLength(260)
param applicationInsightsName string

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

@description('プライベートエンドポイントのための仮想ネットワークのサブネット名')
@minLength(1)
@maxLength(80)
param privateEndpointSubnetName string

@description('プライベートDNSゾーンのリソース情報')
param privateDnsZoneName string

/*** resource/module: WebApps ***/
module funcModule '../../modules/functions/func_module.bicep' = {
  name: '${functionAppName}_Deployment'
  params: {
    location: location
    tag: tag
    functionAppName: functionAppName
    aplAppSettings: aplAppSettings
    publicNetworkAccess: publicNetworkAccess
    ipSecurityRestrictions: ipSecurityRestrictions
    scmIpSecurityRestrictions: scmIpSecurityRestrictions
    appServicePlanName: appServicePlanName
    userAssignedIdentityName: userAssignedIdentityName
    virtualNetworkName: virtualNetworkName
    subnetName: subnetName
    storageAccountBlobStorageName: storageAccountBlobStorageName
    applicationInsightsName: applicationInsightsName
  }
  dependsOn: []
}

/*** resource/module: Private Endpoint ***/
module funcPepModule '../../modules/private-endpoint/pep_module.bicep' = {
  name: '${privateEndpointName}_Deployment'
  params: {
    location: location
    tag: tag
    privateEndpointName: privateEndpointName
    privateLinkServiceId: funcModule.outputs.functionAppId
    privateLinkServiceGroupIds: privateLinkServiceGroupIds
    privateLinkServiceConnectionState: privateLinkServiceConnectionState
    assignStaticPrivateIP: assignStaticPrivateIP
    privateIPAddressInfo: privateIPAddressInfo
    virtualNetworkName: virtualNetworkName
    subnetName: privateEndpointSubnetName
    privateDnsZoneName: privateDnsZoneName
  }
  dependsOn: [
    funcModule
  ]
}

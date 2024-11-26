targetScope = 'resourceGroup'

/*** param: 共通 ***/
@description('場所')
param location string = resourceGroup().location

@description('タグ名')
param tag object = {}

/*** param: Storage Account ***/
@description('ストレージアカウント Blob ストレージ用のリソース名')
@minLength(3)
@maxLength(24)
param storageAccountBlobStorageName string

@description('ストレージアカウント Blob ストレージ用のSKU名')
param skuName string = 'Standard_GRS'

@description('ストレージアカウント Blob ストレージ用のSKU名')
param kind string = 'StorageV2'

@description('パブリックアクセスの有効化')
@allowed([
  'Enabled'
  'Disabled'
])
param publicNetworkAccess string = 'Disabled'

@description('IPアドレスのACL規則')
param ipRules array = []

@description('アクセス層')
param accessTier string = 'Hot'

@description('BLOBの変更フィード有効化')
param changeFeedEnabled bool = true

@description('コンテナーのポイントインタイムリストアの有効化')
param restorePolicyEnabled bool = false

@description('暗号化キーの情報')
param encryptKeyInfo object

@description('マネージドIDの情報')
param userAssignedIdentityInfo object

/*** resource/module: Storage Account ***/
module stModule '../../modules/storage-account/st_module.bicep' = {
  name: '${storageAccountBlobStorageName}_Deployment'
  params: {
    location: location
    tag: tag
    storageAccountBlobStorageName: storageAccountBlobStorageName
    skuName: skuName
    kind: kind
    publicNetworkAccess: publicNetworkAccess
    ipRules: ipRules
    accessTier: accessTier
    changeFeedEnabled: changeFeedEnabled
    restorePolicyEnabled: restorePolicyEnabled
    encryptKeyInfo: encryptKeyInfo
    userAssignedIdentityInfo: userAssignedIdentityInfo
  }
  dependsOn: []
}

output storageAccountBlobStorageId string = stModule.outputs.storageAccountBlobStorageId

targetScope = 'resourceGroup'

@description('場所')
param location string = resourceGroup().location

@description('タグ名')
param tag object = {}

@description('仮想ネットワークのリソース名')
@minLength(2)
@maxLength(64)
param virtualNetworkName string

@description('CIDR 表記でこの仮想ネットワーク用に予約されているアドレスブロックの一覧')
param virtualNetworkAddressPrefixes string[]

@description('暗号化の有効化の有無')
param encryptionEnabled bool = false

@description('暗号化をサポートしていない VM が許可されているか')
param encryptionEnforcement string = 'AllowUnencrypted'

@description('DDoS 保護の有効化の有無')
param enableDdosProtection bool = false

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2023-11-01' = {
  name: virtualNetworkName
  location: location
  tags: tag
  properties: {
    addressSpace: {
      addressPrefixes: virtualNetworkAddressPrefixes
    }
    encryption: {
      enabled: encryptionEnabled
      enforcement: encryptionEnforcement
    }
    subnets: []
    virtualNetworkPeerings: []
    enableDdosProtection: enableDdosProtection
  }
}

output virtualNetworkId string = virtualNetwork.id

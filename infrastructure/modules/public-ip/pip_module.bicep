targetScope = 'resourceGroup'

@description('場所')
param location string = resourceGroup().location

@description('タグ名')
param tag object = {}

@description('パブリックIPアドレスのリソース名')
@minLength(1)
@maxLength(80)
param publicIPAddressName string

@description('パブリックIPアドレスのSKU名')
param skuName string = 'Standard'

@description('パブリックIPアドレスのSKUレベル')
param skuTier string = 'Regional'

@description('パブリックIPアドレスの割り当て方法')
param publicIPAllocationMethod string = 'Static'

@description('アイドル タイムアウト (分)')
param idleTimeoutInMinutes int = 4

@description('ドメイン名ラベル')
param dnsDomainNameLabel string

@description('DDoS 保護モード')
param ddosProtectionMode string = 'VirtualNetworkInherited'

resource publicIPAddress 'Microsoft.Network/publicIPAddresses@2024-01-01' = {
  name: publicIPAddressName
  location: location
  tags: tag
  sku: {
    name: skuName
    tier: skuTier
  }
  properties: {
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: publicIPAllocationMethod
    idleTimeoutInMinutes: idleTimeoutInMinutes
    dnsSettings: {
      domainNameLabel: dnsDomainNameLabel
      fqdn: '${dnsDomainNameLabel}.${location}.cloudapp.azure.com'
    }
    ipTags: []
    ddosSettings: {
      protectionMode: ddosProtectionMode
    }
  }
}

output publicIPAddressId string = publicIPAddress.id

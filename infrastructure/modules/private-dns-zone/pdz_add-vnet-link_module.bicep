targetScope = 'resourceGroup'

@description('プライベートDNSゾーンのリソース名')
@minLength(1)
@maxLength(63)
param privateDnsZoneName string

@description('プライベートDNSゾーンに追加する仮想ネットワークリンク名')
@minLength(1)
@maxLength(80)
param privateDnsZoneVnetLinkName string

@description('仮想マシンレコードの自動登録の有効有無')
param registrationEnabled bool = false

@description('仮想ネットワークのリソース名')
param virtualNetworkName string

resource existingPrivateDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' existing = {
  name: privateDnsZoneName
}

resource existingVirtualNetwork 'Microsoft.Network/virtualNetworks@2023-11-01' existing = {
  name: virtualNetworkName
}

resource privateDnsZoneVnetLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  parent: existingPrivateDnsZone
  name: privateDnsZoneVnetLinkName
  location: 'global'
  properties: {
    registrationEnabled: registrationEnabled
    virtualNetwork: {
      id: existingVirtualNetwork.id
    }
  }
}

output privateDnsZoneVnetLinkId string = privateDnsZoneVnetLink.id


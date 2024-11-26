targetScope = 'resourceGroup'

@description('場所')
param location string = resourceGroup().location

@description('タグ名')
param tag object = {}

@description('プライベートエンドポイントのリソース名')
@minLength(2)
@maxLength(64)
param privateEndpointName string

@description('プライベートリンクサービスのリソース ID')
param privateLinkServiceId string

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

@description('仮想ネットワークのサブネット名')
@minLength(1)
@maxLength(80)
param subnetName string

@description('プライベートDNSゾーンの情報')
param privateDnsZoneName string

resource existingVirtualNetwork 'Microsoft.Network/virtualNetworks@2023-11-01' existing = {
  name: virtualNetworkName
}

resource existingSubnet 'Microsoft.Network/virtualNetworks/subnets@2023-11-01' existing = {
  parent: existingVirtualNetwork
  name: subnetName
}

resource existingPrivateDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' existing = {
  name: privateDnsZoneName
}

resource privateEndpoint 'Microsoft.Network/privateEndpoints@2023-11-01' = {
  name: privateEndpointName
  location: location
  tags: tag
  properties: {
    privateLinkServiceConnections: [
      {
        name: privateEndpointName
        properties: {
          privateLinkServiceId: privateLinkServiceId
          groupIds: privateLinkServiceGroupIds
          privateLinkServiceConnectionState: privateLinkServiceConnectionState
        }
      }
    ]
    manualPrivateLinkServiceConnections: []
    customNetworkInterfaceName: '${privateEndpointName}-nic'
    subnet: {
      id: existingSubnet.id
    }
    ipConfigurations: assignStaticPrivateIP ? [
      {
        name: privateIPAddressInfo.privateIPAddressName
        properties: {
          privateIPAddress: privateIPAddressInfo.privateIPAddress
          groupId: privateIPAddressInfo.privateIPAddressGroupId
          memberName: privateIPAddressInfo.privateIPAddressMemberName
        }
      }
    ] : []
    customDnsConfigs: []
  }
}

resource privateDnsZoneGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2023-11-01' = {
  parent: privateEndpoint
  name: 'default'
  properties: {
    privateDnsZoneConfigs: [
      {
        name: privateDnsZoneName
        properties: {
          privateDnsZoneId: existingPrivateDnsZone.id
        }
      }
    ]
  }
}

output privateEndpointId string = privateEndpoint.id

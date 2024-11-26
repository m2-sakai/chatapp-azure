targetScope = 'resourceGroup'

@description('仮想ネットワークのリソース名')
@minLength(2)
@maxLength(64)
param virtualNetworkName string

@description('仮想ネットワークに割り当てるサブネット名')
@minLength(1)
@maxLength(80)
param subnetName string

@description('サブネットのアドレスプレフィックス')
param addressPrefix string

@description('サービスエンドポイントの配列')
param serviceEndpoints array = []

@description('デリゲートするリソースの配列')
param delegations array = []

@description('プライベートエンドポイントのネットワークポリシー適用の有効化の有無')
param privateEndpointNetworkPolicies string = 'Enabled'

@description('プライベートリンクサービスのネットワークポリシー適用の有効化の有無')
param privateLinkServiceNetworkPolicies string = 'Enabled'

// 既存リソースから情報を取得する場合、nullや空文字にできないため文字列で'null'とする
@description('サブネットに適用するネットワークセキュリティグループのリソース名')
@minLength(1)
@maxLength(80)
param networkSecurityGroupName string = 'null'

// 既存リソースから情報を取得する場合、nullや空文字にできないため文字列で'null'とする
@description('サブネットに適用するルートテーブルのリソース名')
@minLength(1)
@maxLength(80)
param routeTableName string = 'null'

resource existingVirtualNetwork 'Microsoft.Network/virtualNetworks@2023-11-01' existing = {
  name: virtualNetworkName
}

var hasNetworkSecurityGroupName = networkSecurityGroupName != 'null'
resource existingNetworkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2023-11-01' existing = if (hasNetworkSecurityGroupName) {
  name: networkSecurityGroupName
}

var hasrouteTableName = routeTableName != 'null'
resource existingRouteTable 'Microsoft.Network/routeTables@2023-11-01' existing = if (hasrouteTableName) {
  name: routeTableName
}

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2023-11-01' = {
  name: subnetName
  parent: existingVirtualNetwork
  properties: {
    addressPrefix: addressPrefix
    networkSecurityGroup: hasNetworkSecurityGroupName ? {
      id: existingNetworkSecurityGroup.id
    } : null
    routeTable: hasrouteTableName ? {
      id: existingRouteTable.id
    }: null
    serviceEndpoints: serviceEndpoints
    delegations: delegations
    privateEndpointNetworkPolicies: privateEndpointNetworkPolicies
    privateLinkServiceNetworkPolicies: privateLinkServiceNetworkPolicies
  }
}

output subnetId string = subnet.id

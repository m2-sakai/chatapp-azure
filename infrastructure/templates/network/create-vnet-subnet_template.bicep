targetScope = 'resourceGroup'

/*** param: 共通 ***/
@description('場所')
param location string = resourceGroup().location

@description('タグ名')
param tag object = {}

/*** param: Virtual Network ***/
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

/*** param: Subnet ***/
@description('仮想ネットワークに割り当てるサブネットの情報')
param subnets array

/*** resource/module: Virtual Network ***/
module vnetModule '../../modules/virtual-network/vnet_module.bicep' = {
  name: '${virtualNetworkName}_Deployment'
  params: {
    location: location
    tag: tag
    virtualNetworkName: virtualNetworkName
    virtualNetworkAddressPrefixes: virtualNetworkAddressPrefixes
    encryptionEnabled: encryptionEnabled
    encryptionEnforcement: encryptionEnforcement
    enableDdosProtection: enableDdosProtection
  }
  dependsOn: []
}

/*** resource/module: Subnet ***/
@batchSize(1)
module vnetSubnetModule '../../modules/virtual-network/vnet_add-subnet_module.bicep' = [
  for subnet in subnets: {
    name: '${virtualNetworkName}_${subnet.subnetName}_Deployment'
    params: {
      virtualNetworkName: virtualNetworkName
      subnetName: subnet.subnetName
      addressPrefix: subnet.addressPrefix
      serviceEndpoints: subnet.serviceEndpoints
      delegations: subnet.delegations
      privateEndpointNetworkPolicies: subnet.privateEndpointNetworkPolicies
      privateLinkServiceNetworkPolicies: subnet.privateLinkServiceNetworkPolicies
      networkSecurityGroupName: subnet.networkSecurityGroupName
      routeTableName: subnet.routeTableName
    }
    dependsOn: [
      vnetModule
    ]
  }
]

output virtualNetworkId string = vnetModule.outputs.virtualNetworkId

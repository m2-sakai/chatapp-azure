targetScope = 'resourceGroup'

@description('ネットワークセキュリティグループのリソース名')
@minLength(1)
@maxLength(80)
param networkSecurityGroupName string

@description('適用するセキュリティルールの配列')
param securityRules array

resource existingNetworkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2023-11-01' existing = {
  name: networkSecurityGroupName
}

resource networkSecurityGroupsSecurityRule 'Microsoft.Network/networkSecurityGroups/securityRules@2023-11-01' = [
  for securityRule in securityRules: {
    name: securityRule.name
    parent: existingNetworkSecurityGroup
    properties: {
      access: securityRule.access
      description: securityRule.description
      destinationAddressPrefix: securityRule.destinationAddressPrefix
      destinationAddressPrefixes: securityRule.destinationAddressPrefixes
      destinationPortRange: securityRule.destinationPortRange
      destinationPortRanges: securityRule.destinationPortRanges
      direction: securityRule.direction
      priority: securityRule.priority
      protocol: securityRule.protocol
      sourceAddressPrefix: securityRule.sourceAddressPrefix
      sourceAddressPrefixes: securityRule.sourceAddressPrefixes
      sourcePortRange: securityRule.sourcePortRange
      sourcePortRanges: securityRule.sourcePortRanges
    }
  }
]

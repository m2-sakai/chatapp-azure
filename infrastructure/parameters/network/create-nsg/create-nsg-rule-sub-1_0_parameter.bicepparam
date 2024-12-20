using '../../../templates/network/create-nsg-rule_template.bicep'

/*** param: 共通 ***/
param tag = {}

/*** param: Network Security Group ***/
param networkSecurityGroupName = 'nsg-adcl-test-je-sub-1_0'

/*** param: Security Rule ***/
param securityRules = [
  {
    name: 'Allow_In_Vnet'
    description: 'Allow_In_Vnet'
    protocol: 'TCP'
    sourcePortRange: '*'
    destinationPortRange: '*'
    sourceAddressPrefix: 'VirtualNetwork'
    destinationAddressPrefix: 'VirtualNetwork'
    access: 'Allow'
    priority: 100
    direction: 'Inbound'
    sourcePortRanges: []
    destinationPortRanges: []
    sourceAddressPrefixes: []
    destinationAddressPrefixes: []
  }
  {
    name: 'Allow_In_AzureLoadBalancer'
    description: 'Allow_In_AzureLoadBalancer'
    protocol: '*'
    sourcePortRange: '*'
    destinationPortRange: '*'
    sourceAddressPrefix: 'AzureLoadBalancer'
    destinationAddressPrefix: '*'
    access: 'Allow'
    priority: 900
    direction: 'Inbound'
    sourcePortRanges: []
    destinationPortRanges: []
    sourceAddressPrefixes: []
    destinationAddressPrefixes: []
  }
  {
    name: 'Deny_In_All'
    description: 'Deny_In_All'
    protocol: '*'
    sourcePortRange: '*'
    destinationPortRange: '*'
    sourceAddressPrefix: '*'
    destinationAddressPrefix: '*'
    access: 'Deny'
    priority: 1000
    direction: 'Inbound'
    sourcePortRanges: []
    destinationPortRanges: []
    sourceAddressPrefixes: []
    destinationAddressPrefixes: []
  }
]

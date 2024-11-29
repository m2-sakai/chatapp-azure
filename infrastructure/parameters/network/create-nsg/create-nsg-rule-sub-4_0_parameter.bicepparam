using '../../../templates/network/create-nsg-rule_template.bicep'

/*** param: 共通 ***/
param tag = {}

/*** param: Network Security Group ***/
param networkSecurityGroupName = 'nsg-adcl-test-je-sub-4_0'

/*** param: Security Rule ***/
param securityRules = [
  {
    name: 'Allow_In_Functions'
    description: 'Allow_In_Functions'
    protocol: '*'
    sourcePortRange: '*'
    destinationPortRange: '443'
    sourceAddressPrefix: '172.16.2.0/24'
    destinationAddressPrefix: '*'
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
  {
    name: 'Deny_Out_All'
    description: 'Deny_Out_All'
    protocol: '*'
    sourcePortRange: '*'
    destinationPortRange: '*'
    sourceAddressPrefix: '*'
    destinationAddressPrefix: '*'
    access: 'Deny'
    priority: 1000
    direction: 'Outbound'
    sourcePortRanges: []
    destinationPortRanges: []
    sourceAddressPrefixes: []
    destinationAddressPrefixes: []
  }
]

using '../../../templates/network/create-nsg-rule_template.bicep'

/*** param: 共通 ***/
param tag = {}

/*** param: Network Security Group ***/
param networkSecurityGroupName = 'nsg-adcl-test-je-sub-0_0'

/*** param: Security Rule ***/
param securityRules = [
  {
    name: 'Allow_In_ApiManagement'
    description: 'Allow_In_ApiManagement'
    protocol: '*'
    sourcePortRange: '*'
    destinationPortRange: '3443'
    sourceAddressPrefix: 'ApiManagement'
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
    name: 'Allow_In_Internet'
    description: 'Allow_In_Internet'
    protocol: '*'
    sourcePortRange: '*'
    destinationPortRange: null
    sourceAddressPrefix: 'Internet'
    destinationAddressPrefix: '*'
    access: 'Allow'
    priority: 200
    direction: 'Inbound'
    sourcePortRanges: []
    destinationPortRanges: [
      '80'
      '443'
      '10081'
    ]
    sourceAddressPrefixes: []
    destinationAddressPrefixes: []
  }
  {
    name: 'Allow_Out_WebPubSub'
    description: 'Allow_Out_WebPubSub'
    protocol: 'TCP'
    sourcePortRange: '*'
    destinationPortRange: null
    sourceAddressPrefix: '*'
    destinationAddressPrefix: '172.16.1.0/24'
    access: 'Allow'
    priority: 100
    direction: 'Outbound'
    sourcePortRanges: []
    destinationPortRanges: [
      '80'
      '443'
      '10081'
    ]
    sourceAddressPrefixes: []
    destinationAddressPrefixes: []
  }
  {
    name: 'Allow_Out_Functions'
    description: 'Allow_Out_Functions'
    protocol: 'TCP'
    sourcePortRange: '*'
    destinationPortRange: '443'
    sourceAddressPrefix: '*'
    destinationAddressPrefix: '172.16.3.0/24'
    access: 'Allow'
    priority: 200
    direction: 'Outbound'
    sourcePortRanges: []
    destinationPortRanges: []
    sourceAddressPrefixes: []
    destinationAddressPrefixes: []
  }
  {
    name: 'Deny_Out_All'
    description: 'Deny_Out_All'
    protocol: 'TCP'
    sourcePortRange: '*'
    destinationPortRange: '*'
    sourceAddressPrefix: '*'
    destinationAddressPrefix: '*'
    access: 'Deny'
    priority: 900
    direction: 'Outbound'
    sourcePortRanges: []
    destinationPortRanges: []
    sourceAddressPrefixes: []
    destinationAddressPrefixes: []
  }
]

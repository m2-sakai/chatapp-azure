using '../../../templates/network/create-nsg-rule_template.bicep'

/*** param: 共通 ***/
param tag = {}

/*** param: Network Security Group ***/
param networkSecurityGroupName = 'nsg-adcl-test-je-sub-2_0'

/*** param: Security Rule ***/
param securityRules = [
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
    name: 'Allow_Out_Cosmos'
    description: 'Allow_Out_Cosmos'
    protocol: 'TCP'
    sourcePortRange: '*'
    destinationPortRange: '443'
    sourceAddressPrefix: '*'
    destinationAddressPrefix: '172.16.4.0/24'
    access: 'Allow'
    priority: 200
    direction: 'Outbound'
    sourcePortRanges: []
    destinationPortRanges: []
    sourceAddressPrefixes: []
    destinationAddressPrefixes: []
  }
  // {
  //   name: 'Deny_Out_All'
  //   description: 'Deny_Out_All'
  //   protocol: '*'
  //   sourcePortRange: '*'
  //   destinationPortRange: '*'
  //   sourceAddressPrefix: '*'
  //   destinationAddressPrefix: '*'
  //   access: 'Deny'
  //   priority: 1000
  //   direction: 'Outbound'
  //   sourcePortRanges: []
  //   destinationPortRanges: []
  //   sourceAddressPrefixes: []
  //   destinationAddressPrefixes: []
  // }
]

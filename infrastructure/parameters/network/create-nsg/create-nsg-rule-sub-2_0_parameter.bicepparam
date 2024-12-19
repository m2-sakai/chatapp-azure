using '../../../templates/network/create-nsg-rule_template.bicep'

/*** param: 共通 ***/
param tag = {}

/*** param: Network Security Group ***/
param networkSecurityGroupName = 'nsg-adcl-test-je-sub-2_0'

/*** param: Security Rule ***/
param securityRules = [
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
    name: 'Allow_Out_WebPubSub'
    description: 'Allow_Out_WebPubSub'
    protocol: 'TCP'
    sourcePortRange: '*'
    destinationPortRange: '*'
    sourceAddressPrefix: '*'
    destinationAddressPrefix: '172.16.1.0/24'
    access: 'Allow'
    priority: 100
    direction: 'Outbound'
    sourcePortRanges: []
    destinationPortRanges: []
    sourceAddressPrefixes: []
    destinationAddressPrefixes: []
  }
  {
    name: 'Allow_Out_Cosmos'
    description: 'Allow_Out_Cosmos'
    protocol: 'TCP'
    sourcePortRange: '*'
    destinationPortRange: '*' // https://learn.microsoft.com/ja-jp/azure/cosmos-db/nosql/sdk-connection-modes#service-port-ranges
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
  {
    name: 'Allow_Out_Monitor'
    description: 'Allow_Out_Monitor'
    protocol: 'TCP'
    sourcePortRange: '*'
    destinationPortRange: null
    sourceAddressPrefix: '*'
    destinationAddressPrefix: 'AzureMonitor'
    access: 'Allow'
    priority: 900
    direction: 'Outbound'
    sourcePortRanges: []
    destinationPortRanges: [
      '1886'
      '443'
    ]
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

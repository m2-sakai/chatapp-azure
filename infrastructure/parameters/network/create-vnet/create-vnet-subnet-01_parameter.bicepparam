using '../../../../templates/network/create-vnet-subnet_template.bicep'

/*** param: 共通 ***/
param tag = {}

/*** param: Virtual Network ***/
param virtualNetworkName = 'vnet-adcl-test-je-01'
param virtualNetworkAddressPrefixes = [
  '172.16.0.0/16'
]

/*** param: Subnet ***/
param subnets = [
  {
    subnetName: 'sub-0_0'
    addressPrefix: '172.16.0.0/24'
    serviceEndpoints: []
    delegations: []
    privateEndpointNetworkPolicies: 'Enabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
    networkSecurityGroupName: 'nsg-adcl-test-sub-0_0'
  }
  {
    subnetName: 'sub-1_0'
    addressPrefix: '172.16.1.0/24'
    serviceEndpoints: []
    delegations: [
      {
        name: 'Microsoft.Web/serverFarms'
        properties: {
          serviceName: 'Microsoft.Web/serverFarms'
        }
        type: 'Microsoft.Network/virtualNetworks/subnets/delegations'
      }
    ]
    privateEndpointNetworkPolicies: 'Enabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
    networkSecurityGroupName: 'nsg-adcl-test-sub-1_0'
  }
  {
    subnetName: 'sub-2_0'
    addressPrefix: '172.16.2.0/24'
    serviceEndpoints: []
    delegations: []
    privateEndpointNetworkPolicies: 'Enabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
    networkSecurityGroupName: 'nsg-adcl-test-sub-2_0'
  }
  {
    subnetName: 'sub-3_0'
    addressPrefix: '172.16.3.0/24'
    serviceEndpoints: []
    delegations: []
    privateEndpointNetworkPolicies: 'Enabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
    networkSecurityGroupName: 'nsg-adcl-test-sub-3_0'
  }
  {
    subnetName: 'sub-4_0'
    addressPrefix: '172.16.4.0/24'
    serviceEndpoints: []
    delegations: []
    privateEndpointNetworkPolicies: 'Enabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
    networkSecurityGroupName: 'nsg-adcl-test-sub-4_0'
  }
]

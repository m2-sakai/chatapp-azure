using '../../../templates/database/create-cosmos_template.bicep'

/*** param: 共通 ***/
param tag = {}

/*** param: Cosmos DB ***/
param cosmosDbName = 'cosmos-adcl-test-je-01'

/*** param: Private Endpoint ***/
param privateEndpointName = 'pep-adcl-test-je-cosmos-01'
param privateLinkServiceGroupIds = [
  'Sql'
]
param virtualNetworkName = 'vnet-adcl-test-je-01'
param privateEndpointSubnetName = 'sub-4_0'
param privateDnsZoneName = 'privatelink.documents.azure.com'

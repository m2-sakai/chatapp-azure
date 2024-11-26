using '../../../templates/web/create-func_template.bicep'

/*** param: 共通 ***/
param tag = {}

/*** param: Functions ***/
param functionAppName = 'func-adcl-test-je-01'
param appServicePlanName = 'asp-adcl-test-je-01'
param userAssignedIdentityName = 'id-adcl-test-je-01'
param virtualNetworkName = 'vnet-adcl-test-je-01'
param subnetName = 'sub-2_0'
param storageAccountBlobStorageName = 'stadcltestje01'
param applicationInsightsName = 'appi-adcl-test-je-01'

/*** param: Private Endpoint ***/
param privateEndpointName = 'pep-adcl-test-je-func-01'
param privateLinkServiceGroupIds = [
  'sites'
]
param privateEndpointSubnetName = 'sub-3_0'
param privateDnsZoneName = 'privatelink.azurewebsites.net'

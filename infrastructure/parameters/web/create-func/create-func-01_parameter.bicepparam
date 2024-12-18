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
param aplAppSettings = [
  {
    name: 'COSMOS_CHAT_CONTAINER'
    value: 'ChatContainer'
  }
  {
    name: 'COSMOS_CONNECT_MSI'
    value: 'true'
  }
  {
    name: 'COSMOS_DATABASE'
    value: 'SampleDB'
  }
  {
    name: 'COSMOS_ENDPOINT'
    value: 'https://cosmos-adcl-test-je-01.documents.azure.com:443/'
  }
  {
    name: 'COSMOS_CONNECTION_STRING'
    value: 'xxx'
  }
  {
    name: 'COSMOS_USER_CONTAINER'
    value: 'UserContainer'
  }
  {
    name: 'WEBPUBSUB_ENDPOINT'
    value: 'https://wps-adcl-test-je-01.webpubsub.azure.com'
  }
  {
    name: 'WEBPUBSUB_HUB'
    value: 'chatroom'
  }
  {
    name: 'WEBPUBSUB_CONNECT_MSI'
    value: 'false'
  }
  {
    name: 'WEBPUBSUB_ACCESSKEY'
    value: 'xxx'
  }
]

/*** param: Private Endpoint ***/
param privateEndpointName = 'pep-adcl-test-je-func-01'
param privateLinkServiceGroupIds = [
  'sites'
]
param privateEndpointSubnetName = 'sub-3_0'
param privateDnsZoneName = 'privatelink.azurewebsites.net'

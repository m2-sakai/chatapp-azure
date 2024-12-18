using '../../../templates/web/create-wps_template.bicep'

/*** param: 共通 ***/
param tag = {}

/*** param: Web PubSub ***/
param webPubSubName = 'wps-adcl-test-je-01'

/*** param: Private Endpoint ***/
param privateEndpointName = 'pep-adcl-test-je-wps-01'
param privateLinkServiceGroupIds = [
  'webpubsub'
]
param virtualNetworkName = 'vnet-adcl-test-je-01'
param privateEndpointSubnetName = 'sub-1_0'
param privateDnsZoneName = 'privatelink.webpubsub.azure.com'

/*** param: Hub ***/
param hubName = 'chatroom'
param urlTemplate = 'https://func-adcl-test-je-01.azurewebsites.net/api/SaveChatMessage'

/*** param: Role Assignment ***/
param userAssignedIdentityName = 'id-adcl-test-je-01'

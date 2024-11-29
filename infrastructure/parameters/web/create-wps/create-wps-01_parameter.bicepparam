using '../../../templates/web/create-wps_template.bicep'

/*** param: 共通 ***/
param tag = {}

/*** param: Web PubSub ***/
param webPubSubName string = 'wps-adcl-test-je-01'

/*** param: Private Endpoint ***/
param privateEndpointName = 'pep-adcl-test-je-wps-01'
param privateLinkServiceGroupIds = [
  'webpubsub'
]
param privateEndpointSubnetName = 'sub-1_0'
param privateDnsZoneName = 'privatelink.webpubsub.azure.com'

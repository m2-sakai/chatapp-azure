using '../../../templates/integration/create-apim_template.bicep'

/*** param: 共通 ***/
param tag = {}

/*** param: API Management ***/
param apiManagementName = 'apim-adcl-test-je-98'
param virtualNetworkName = 'vnet-adcl-test-je-01'
param subnetName = 'sub-0_0'
param publicIPAddressName = 'pip-adcl-test-je-apim-001'
param applicationInsightsName = 'appi-adcl-test-je-01'
param globalPolicyXml = '<policies><inbound/><backend><forward-request/></backend><outbound/><on-error/></policies>'

/*** param: API Management API ***/
param apis = []

/*** param: API Management Operation ***/
param operations = []

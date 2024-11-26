using '../../../templates/network/create-pip_template.bicep'

/*** param: 共通 ***/
param tag = {}

/*** param: Public IP Address ***/
param publicIPAddressName = 'pip-adcl-test-je-apim-001'
param dnsDomainNameLabel = 'pip-adcl-test-je-apim-001'

using '../../../templates/network/create-pdz-record_template.bicep'

/*** param: 共通 ***/
param tag = {}

/*** param: Private DNS Zone ***/
param privateDnsZoneName = 'privatelink.azurewebsites.net'

/*** param: Private DNS Zone Vnet Link ***/
param vnetLinks = [
  {
    privateDnsZoneVnetLinkName: 'link-VNET-01'
    registrationEnabled: false
    virtualNetworkName: 'vnet-adcl-test-je-01'
  }
]

/*** param: Record ***/
param aRecords = []
param aaaaRecords = []
param cnameRecords = []
param mxRecords = []
param ptrRecords = []
param srvRecords = []
param txtRecords = []

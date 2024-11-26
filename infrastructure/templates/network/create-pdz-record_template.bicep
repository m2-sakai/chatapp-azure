targetScope = 'resourceGroup'

/*** param: 共通 ***/
@description('タグ名')
param tag object = {}

/*** param: Private DNS Zone ***/
@description('プライベートDNSゾーンのリソース名')
@minLength(1)
@maxLength(63)
param privateDnsZoneName string

/*** param: Private DNS Zone Vnet Link ***/
@description('仮想ネットワークリンク情報の配列')
param vnetLinks array

/*** param: Record ***/
@description('Aレコードの一覧')
param aRecords array = []

@description('AAAAレコードの一覧')
param aaaaRecords array = []

@description('CNAMEレコードの一覧')
param cnameRecords array = []

@description('MXレコードの一覧')
param mxRecords array = []

@description('PTRレコードの一覧')
param ptrRecords array = []

@description('SRVレコードの一覧')
param srvRecords array = []

@description('TXTレコードの一覧')
param txtRecords array = []

/*** resource/module: Private DNS Zone ***/
module pdzModule '../../modules/private-dns-zone/pdz_module.bicep' = {
  name: '${privateDnsZoneName}_Deployment'
  params: {
    tag: tag
    privateDnsZoneName: privateDnsZoneName
  }
  dependsOn: []
}

/*** resource/module: Private DNS Zone Vnet Link ***/
module pdzVnetLinkModule '../../modules/private-dns-zone/pdz_add-vnet-link_module.bicep' = [
  for vnetLink in vnetLinks: {
    name: '${vnetLink.privateDnsZoneVnetLinkName}_Deployment'
    params: {
      privateDnsZoneName: privateDnsZoneName
      privateDnsZoneVnetLinkName: vnetLink.privateDnsZoneVnetLinkName
      registrationEnabled: vnetLink.registrationEnabled
      virtualNetworkName: vnetLink.virtualNetworkName
    }
    dependsOn: [
      pdzModule
    ]
  }
]

/*** resource/module: Record ***/
module pdzRecordModule '../../modules/private-dns-zone/pdz_add-record_module.bicep' = {
  name: '${privateDnsZoneName}_rc_Deployment'
  params: {
    privateDnsZoneName: privateDnsZoneName
    aRecords: aRecords
    aaaaRecords: aaaaRecords
    cnameRecords: cnameRecords
    mxRecords: mxRecords
    ptrRecords: ptrRecords
    srvRecords: srvRecords
    txtRecords: txtRecords
  }
  dependsOn: [
    pdzModule
  ]
}

output privateDnsZoneId string = pdzModule.outputs.privateDnsZoneId

targetScope = 'resourceGroup'

@description('プライベートDNSゾーンのリソース名')
@minLength(1)
@maxLength(63)
param privateDnsZoneName string

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

resource existingPrivateDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' existing = {
  name: privateDnsZoneName
}

resource privateDnsZoneARecord 'Microsoft.Network/privateDnsZones/A@2020-06-01' = [
  for aRecord in aRecords: {
    parent: existingPrivateDnsZone
    name: aRecord.name
    properties: {
      ttl: aRecord.ttl
      aRecords: [
        {
          ipv4Address: aRecord.ipv4Address
        }
      ]
    }
  }
]

resource privateDnsZoneAAAARecord 'Microsoft.Network/privateDnsZones/AAAA@2020-06-01' = [
  for aaaaRecord in aaaaRecords: {
    parent: existingPrivateDnsZone
    name: aaaaRecord.name
    properties: {
      ttl: aaaaRecord.ttl
      aaaaRecords: [
        {
          ipv6Address: aaaaRecord.ipv6Address
        }
      ]
    }
  }
]

resource privateDnsZoneCNAMERecord 'Microsoft.Network/privateDnsZones/CNAME@2020-06-01' = [
  for cnameRecord in cnameRecords: {
    parent: existingPrivateDnsZone
    name: cnameRecord.name
    properties: {
      ttl: cnameRecord.ttl
      cnameRecord: {
        cname: cnameRecord.value
      }
    }
  }
]

resource privateDnsZoneMXRecord 'Microsoft.Network/privateDnsZones/MX@2020-06-01' = [
  for mxRecord in mxRecords: {
    parent: existingPrivateDnsZone
    name: mxRecord.name
    properties: {
      ttl: mxRecord.ttl
      mxRecords: [
        {
          exchange: mxRecord.exchange
          preference: mxRecord.preferece
        }
      ]
    }
  }
]

resource privateDnsZonePTRRecord 'Microsoft.Network/privateDnsZones/PTR@2020-06-01' = [
  for ptrRecord in ptrRecords: {
    parent: existingPrivateDnsZone
    name: ptrRecord.name
    properties: {
      ttl: ptrRecord.ttl
      ptrRecords: [
        {
          ptrdname: ptrRecord.ptrdname
        }
      ]
    }
  }
]

resource privateDnsZoneSRVRecord 'Microsoft.Network/privateDnsZones/SRV@2020-06-01' = [
  for srvRecord in srvRecords: {
    parent: existingPrivateDnsZone
    name: srvRecord.name
    properties: {
      ttl: srvRecord.ttl
      srvRecords: [
        {
          port: srvRecord.port
          priority: srvRecord.priority
          target: srvRecord.target
          weight: srvRecord.weight
        }
      ]
    }
  }
]

resource privateDnsZoneTXTRecord 'Microsoft.Network/privateDnsZones/TXT@2020-06-01' = [
  for txtRecord in txtRecords: {
    parent: existingPrivateDnsZone
    name: txtRecord.name
    properties: {
      ttl: txtRecord.ttl
      txtRecords: [
        {
          value: [
            txtRecord.value
          ]
        }
      ]
    }
  }
]

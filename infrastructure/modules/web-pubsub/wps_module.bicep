targetScope = 'resourceGroup'

@description('場所')
param location string = resourceGroup().location

@description('タグ名')
param tag object = {}

@description('WebPubSub のリソース名')
param webPubSubName string = 'wps-adcl-test-je-98'

@description('WebPubSubのSKU名')
param skuName string = 'Standard_S1'

@description('WebPubSubのSKUTier')
param skuTier string = 'Standard'

@description('パブリックアクセスの有効化')
@allowed([
  'Enabled'
  'Disabled'
])
param publicNetworkAccess string = 'Disabled'

resource webPubSub 'Microsoft.SignalRService/WebPubSub@2024-04-01-preview' = {
  name: webPubSubName
  location: location
  tags: tag
  sku: {
    name: skuName
    tier: skuTier
    capacity: 1
  }
  kind: 'WebPubSub'
  properties: {
    tls: {
      clientCertEnabled: false
    }
    networkACLs: {
      defaultAction: 'Deny'
    }
    applicationFirewall: {
      clientConnectionCountRules: []
    }
    publicNetworkAccess: publicNetworkAccess
    disableLocalAuth: false
    disableAadAuth: false
    regionEndpointEnabled: 'Enabled'
    resourceStopped: 'false'
  }
}

output webPubSubId string = webPubSub.id

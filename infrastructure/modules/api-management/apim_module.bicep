targetScope = 'resourceGroup'

@description('場所')
param location string = resourceGroup().location

@description('タグ名')
param tag object = {}

@description('API Managementのリソース名')
@minLength(1)
@maxLength(50)
param apiManagementName string

@description('SKU名')
param skuName string = 'Developer'

@description('SKUのデプロイされたユニットの数')
param skuCapacity int = 1

@description('通知機能で連携される管理者のメールアドレス')
param publisherEmail string = 'admin@example.com'

@description('通知機能で連携される管理者名')
param publisherName string = 'admin'

@description('通知時の送信者メールアドレス')
param notificationSenderEmail string = 'admin@example.com'

@description('仮想ネットワークの情報')
param virtualNetworkName string

@description('仮想ネットワークのサブネット名')
param subnetName string

@description('仮想ネットワーク統合の種類')
param virtualNetworkType string = 'External'

@description('パブリックIPアドレスの情報')
param publicIPAddressName string

@description('パブリックアクセスの有効化')
@allowed([
  'Enabled'
  'Disabled'
])
param publicNetworkAccess string = 'Enabled'

@description('Application Insightsのリソース名')
param applicationInsightsName string

@description('グローバルポリシーのファイルのXML文字列')
param globalPolicyXml string

resource existingVirtualNetwork 'Microsoft.Network/virtualNetworks@2023-11-01' existing = {
  name: virtualNetworkName
}

resource existingPublicIPAddress 'Microsoft.Network/publicIPAddresses@2024-01-01' existing = {
  name: publicIPAddressName
}

resource existingApplicationInsights 'microsoft.insights/components@2020-02-02' existing = {
  name: applicationInsightsName
}

/*** API Management ***/
resource apiManagement 'Microsoft.ApiManagement/service@2023-09-01-preview' = {
  name: apiManagementName
  location: location
  tags: tag
  sku: {
    name: skuName
    capacity: skuCapacity
  }
  properties: {
    publisherEmail: publisherEmail
    publisherName: publisherName
    notificationSenderEmail: notificationSenderEmail
    hostnameConfigurations: [
      {
        type: 'Proxy'
        hostName: '${apiManagementName}.azure-api.net'
        negotiateClientCertificate: false
        defaultSslBinding: true
        certificateSource: 'BuiltIn'
      }
    ]
    virtualNetworkConfiguration: virtualNetworkType != 'None' ? {
      subnetResourceId:  '${existingVirtualNetwork.id}/subnets/${subnetName}'
    } : null
    customProperties: {
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Protocols.Tls10': 'False'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Protocols.Tls11': 'False'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Protocols.Ssl30': 'False'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TripleDes168': 'False'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Backend.Protocols.Tls10': 'False'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Backend.Protocols.Tls11': 'False'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Backend.Protocols.Ssl30': 'False'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Protocols.Server.Http2': 'False'
    }
    virtualNetworkType: virtualNetworkType
    disableGateway: false
    natGatewayState: 'Unsupported'
    apiVersionConstraint: {}
    publicIpAddressId: virtualNetworkType != 'None' ? existingPublicIPAddress.id : null
    publicNetworkAccess: publicNetworkAccess
    legacyPortalStatus: 'Disabled'
    developerPortalStatus: 'Enabled'
  }
}

/*** API Management Logger Credential 名前付き値 ***/
resource apimLoggerCredential 'Microsoft.ApiManagement/service/namedValues@2023-09-01-preview' = {
  parent: apiManagement
  name: 'ApiManagementLoggerCredential'
  properties: {
    displayName: 'ApiManagementLoggerCredential'
    value: existingApplicationInsights.properties.InstrumentationKey
    secret: true
  }
}

/*** API Management Application Insights ***/
resource apimApplicationInsights 'Microsoft.ApiManagement/service/loggers@2023-09-01-preview' = {
  parent: apiManagement
  name: 'applicationInsights'
  properties: {
    loggerType: 'applicationInsights'
    credentials: {
      instrumentationKey: '{{ApiManagementLoggerCredential}}'
    }
    isBuffered: true
    resourceId: existingApplicationInsights.id
  }
  dependsOn: [
    apimLoggerCredential
  ]
}

/*** API Management Azure Monitor ***/
resource apimAzureMonitor 'Microsoft.ApiManagement/service/loggers@2023-09-01-preview' = {
  parent: apiManagement
  name: 'azuremonitor'
  properties: {
    loggerType: 'azureMonitor'
    isBuffered: true
  }
}

/*** API Management Global Policy ***/
resource apimPolicy 'Microsoft.ApiManagement/service/policies@2023-09-01-preview' = {
  parent: apiManagement
  name: 'policy'
  properties: {
    value: globalPolicyXml
    format: 'xml'
  }
}

output apiManagementId string = apiManagement.id

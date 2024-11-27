targetScope = 'resourceGroup'

/*** param: 共通 ***/
@description('場所')
param location string = resourceGroup().location

@description('タグ名')
param tag object = {}

/*** param: API Management ***/
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

/*** param: API Management API ***/
param apis array = []

/*** param: API Management Operation ***/
param operations array = []

/*** resource/module: API Management ***/
module apimModule '../../modules/api-management/apim_module.bicep' = {
  name: '${apiManagementName}_Deployment'
  params: {
    location: location
    tag: tag
    apiManagementName: apiManagementName
    skuName: skuName
    skuCapacity: skuCapacity
    publisherEmail: publisherEmail
    publisherName: publisherName
    notificationSenderEmail: notificationSenderEmail
    virtualNetworkName: virtualNetworkName
    subnetName: subnetName
    virtualNetworkType: virtualNetworkType
    publicIPAddressName: publicIPAddressName
    publicNetworkAccess: publicNetworkAccess
    applicationInsightsName: applicationInsightsName
    globalPolicyXml: globalPolicyXml
  }
  dependsOn: []
}

/*** resource/module: API Management API ***/
module apimApiModule '../../modules/api-management/apim_add-api_module.bicep' = [
  for api in apis: {
    name: '${api.apiName}_Deployment'
    params: {
      apiManagementName: apiManagementName
      apiName: api.apiName
      apiDisplayName: api.apiDisplayName
      apiDescription: api.apiDescription
      apiSubscriptionRequired: api.apiSubscriptionRequired
      subscriptionKeyParameterNames: api.subscriptionKeyParameterNames
      apiServiceUrl: api.apiServiceUrl
      apiPath: api.apiPath
      apiProtocols: api.apiProtocols
      apiPolicyXml: api.apiPolicyXml
    }
    dependsOn: [
      apimModule
    ]
  }
]

/*** resource/module: API Management API Operation ***/
module apimApiOperationModule '../../modules/api-management/apim_add-operation_module.bicep' = [
  for operation in operations: {
    name: '${operation.apiOperationName}_Deployment'
    params: {
      apiManagementName: apiManagementName
      apiName: operation.apiName
      apiOperationName: operation.apiOperationName
      method: operation.method
      urlTemplate: operation.urlTemplate
      request: operation.request
      responses: operation.responses
      apiOperationPolicyXml: operation.apiOperationPolicyXml
    }
    dependsOn: [
      apimApiModule
    ]
  }
]

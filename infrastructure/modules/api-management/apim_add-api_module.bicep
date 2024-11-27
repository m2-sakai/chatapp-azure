targetScope = 'resourceGroup'

@description('API Managementのリソース名')
@minLength(1)
@maxLength(50)
param apiManagementName string

@description('API名')
@minLength(1)
@maxLength(80)
param apiName string

@description('API表示名')
param apiDisplayName string = '${apiName}'

@description('API説明')
param apiDescription string = 'API for ${apiName}'

@description('APIにアクセスするために製品サブスクリプションが必要かどうか')
param apiSubscriptionRequired bool = true

@description('サブスクリプションキーを設定する場所とキー')
param subscriptionKeyParameterNames object = {
  header: 'Ocp-Apim-Subscription-Key'
  query: 'subscription-key'
}

@description('APIを実装するバックエンドのURL')
param apiServiceUrl string

@description('APIのフロントエンドのパス')
param apiPath string

@description('APIの操作を呼び出すプロトコル')
param apiProtocols array = [
  'https'
]

@description('APIポリシーのファイルのXML文字列')
param apiPolicyXml string

resource existingApiManagement 'Microsoft.ApiManagement/service@2023-09-01-preview' existing = {
  name: apiManagementName
}

/*** API Management API ***/
resource apimApi 'Microsoft.ApiManagement/service/apis@2023-09-01-preview' = {
  name: apiName
  parent: existingApiManagement
  properties: {
    displayName: apiDisplayName
    apiRevision: '1'
    description: apiDescription
    subscriptionRequired: apiSubscriptionRequired
    subscriptionKeyParameterNames: subscriptionKeyParameterNames
    serviceUrl: apiServiceUrl
    path: apiPath
    protocols: apiProtocols
    isCurrent: true
  }
  dependsOn: []
}

/*** API Management API Policy ***/
resource apimApiPolicy 'Microsoft.ApiManagement/service/apis/policies@2023-05-01-preview' = {
  name: 'Policy'
  parent: apimApi
  properties: {
    value: apiPolicyXml
    format: 'xml'
  }
}

output apimApiId string = apimApi.id

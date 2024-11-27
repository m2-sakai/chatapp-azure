targetScope = 'resourceGroup'

@description('API Managementのリソース名')
@minLength(1)
@maxLength(50)
param apiManagementName string

@description('API名')
@minLength(1)
@maxLength(80)
param apiName string

@description('Operation名')
@minLength(1)
@maxLength(80)
param apiOperationName string

@description('HTTP メソッド')
param method string

@description('相対 URL テンプレート')
param urlTemplate string

@description('リクエストオブジェクト')
param request object = {}

@description('レスポンスの配列')
param responses array = []

@description('API OperationポリシーのファイルのXML文字列')
param apiOperationPolicyXml string

resource existingApiManagement 'Microsoft.ApiManagement/service@2023-09-01-preview' existing = {
  name: apiManagementName
}

resource existingApimApi 'Microsoft.ApiManagement/service/apis@2023-09-01-preview' existing = {
  parent: existingApiManagement
  name: apiName
}

/*** API Management API Operation ***/
resource apimApiOperation 'Microsoft.ApiManagement/service/apis/operations@2023-09-01-preview' = {
  parent: existingApimApi
  name: apiOperationName
  properties: {
    displayName: apiOperationName
    method: method
    urlTemplate: urlTemplate
    templateParameters: []
    request: request
    responses: responses
  }
}

/*** API Management API Operation Policy ***/
resource apimApiOperationPolicy 'Microsoft.ApiManagement/service/apis/operations/policies@2023-05-01-preview' = {
  parent: apimApiOperation
  name: 'policy'
  properties: {
    value: apiOperationPolicyXml
    format: 'xml'
  }
}

output apimApiOperationId string = apimApiOperation.id

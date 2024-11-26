targetScope = 'resourceGroup'

@description('場所')
param location string = resourceGroup().location

@description('タグ名')
param tag object = {}

@description('Application Insightsのリソース名')
@minLength(1)
@maxLength(260)
param applicationInsightsName string

@description('Application Insightsコンポーネントが参照するアプリケーションの種類')
param kind string = 'web'

@description('監視対象のアプリケーションの種類')
param applicationType string = 'web'

@description('作成フローの種類を判断するためパラメータ(REST APIで作成・更新の場合 Bluefield に設定)')
param flowType string = 'Redfield'

@description('Application Insightsコンポーネントを作成したツールの種別(REST APIで作成・更新の場合 rest に設定)')
param requestSource string = 'IbizaAIExtension'

@description('保有期間 (日数)')
param retentionInDays int = 90

@description('インジェストのフロー')
param ingestionMode string = 'LogAnalytics'

@description('Application Insights インジェストにアクセスするためのネットワーク アクセスの種類')
@allowed([
  'Disabled'
  'Enabled'
])
param publicNetworkAccessForIngestion string = 'Enabled'

@description('Application Insights クエリにアクセスするためのネットワーク アクセスの種類')
@allowed([
  'Disabled'
  'Enabled'
])
param publicNetworkAccessForQuery string = 'Enabled'

@description('Log Analytics ワークスペースの情報')
param logAnalyticsWorkspaceInfo object

resource existingLogAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2023-09-01' existing = {
  scope: resourceGroup(logAnalyticsWorkspaceInfo.subscriptionId, logAnalyticsWorkspaceInfo.resourceGroupName)
  name: logAnalyticsWorkspaceInfo.logAnalyticsWorkspaceName
}

resource applicationInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: applicationInsightsName
  location: location
  tags: tag
  kind: kind
  properties: {
    Application_Type: applicationType
    Flow_Type: flowType
    Request_Source: requestSource
    RetentionInDays: retentionInDays
    WorkspaceResourceId: existingLogAnalyticsWorkspace.id
    IngestionMode: ingestionMode
    publicNetworkAccessForIngestion: publicNetworkAccessForIngestion
    publicNetworkAccessForQuery: publicNetworkAccessForQuery
  }
}

output applicationInsightsId string = applicationInsights.id

targetScope = 'resourceGroup'

/*** param: 共通 ***/
@description('場所')
param location string = resourceGroup().location

@description('タグ名')
param tag object = {}

/*** param: Log Analytics ***/
@description('Log Analytics ワークスペースのリソース名')
@minLength(4)
@maxLength(63)
param logAnalyticsWorkspaceName string

@description('ワークスペース データの保持期間 (日数)')
param logRetentionInDays int = 30

@description('使用するリソースまたはワークスペース、両方のアクセス許可の有無')
param enableLogAccessUsingOnlyResourcePermissions bool = true

@description('インジェストのワークスペースの 1 日あたりのクォータ')
param dailyQuotaGb int = 10

@description('Log Analytics インジェストにアクセスするためのネットワークアクセスの種類')
@allowed([
  'Disabled'
  'Enabled'
])
param logPublicNetworkAccessForIngestion string = 'Enabled'

@description('Log Analytics クエリにアクセスするためのネットワークアクセスの種類')
@allowed([
  'Disabled'
  'Enabled'
])
param logPublicNetworkAccessForQuery string = 'Enabled'

/*** param: Application Insights ***/
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
param appiRetentionInDays int = 90

@description('インジェストのフロー')
param ingestionMode string = 'LogAnalytics'

@description('Application Insights インジェストにアクセスするためのネットワーク アクセスの種類')
@allowed([
  'Disabled'
  'Enabled'
])
param appiPublicNetworkAccessForIngestion string = 'Enabled'

@description('Application Insights クエリにアクセスするためのネットワーク アクセスの種類')
@allowed([
  'Disabled'
  'Enabled'
])
param appiPublicNetworkAccessForQuery string = 'Enabled'

/*** resource/module: Log Analytics ***/
module logModule '../../modules/log-analytics/log_module.bicep' = {
  name: '${logAnalyticsWorkspaceName}_Deployment'
  params: {
    location: location
    tag: tag
    logAnalyticsWorkspaceName: logAnalyticsWorkspaceName
    retentionInDays: logRetentionInDays
    enableLogAccessUsingOnlyResourcePermissions: enableLogAccessUsingOnlyResourcePermissions
    dailyQuotaGb: dailyQuotaGb
    publicNetworkAccessForIngestion: logPublicNetworkAccessForIngestion
    publicNetworkAccessForQuery: logPublicNetworkAccessForQuery
  }
  dependsOn: []
}

/*** resource/module: Application Insights ***/
module appiModule '../../modules/application-insights/appi_module.bicep' = {
  name: '${applicationInsightsName}_Deployment'
  params: {
    location: location
    tag: tag
    applicationInsightsName: applicationInsightsName
    kind: kind
    applicationType: applicationType
    flowType: flowType
    requestSource: requestSource
    retentionInDays: appiRetentionInDays
    ingestionMode: ingestionMode
    publicNetworkAccessForIngestion: appiPublicNetworkAccessForIngestion
    publicNetworkAccessForQuery: appiPublicNetworkAccessForQuery
    logAnalyticsWorkspaceName: logAnalyticsWorkspaceName
  }
  dependsOn: [
    logModule
  ]
}

output logAnalyticsWorkspaceId string = logModule.outputs.logAnalyticsWorkspaceId
output applicationInsightsId string = appiModule.outputs.applicationInsightsId


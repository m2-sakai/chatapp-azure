targetScope = 'resourceGroup'

@description('場所')
param location string = resourceGroup().location

@description('タグ名')
param tag object = {}

@description('Log Analytics ワークスペースのリソース名')
@minLength(4)
@maxLength(63)
param logAnalyticsWorkspaceName string

@description('ワークスペース データの保持期間 (日数)')
param retentionInDays int = 30

@description('使用するリソースまたはワークスペース、両方のアクセス許可の有無')
param enableLogAccessUsingOnlyResourcePermissions bool = true

@description('インジェストのワークスペースの 1 日あたりのクォータ')
param dailyQuotaGb int = 10

@description('Log Analytics インジェストにアクセスするためのネットワークアクセスの種類')
@allowed([
  'Disabled'
  'Enabled'
])
param publicNetworkAccessForIngestion string = 'Enabled'

@description('Log Analytics クエリにアクセスするためのネットワークアクセスの種類')
@allowed([
  'Disabled'
  'Enabled'
])
param publicNetworkAccessForQuery string = 'Enabled'

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: logAnalyticsWorkspaceName
  location: location
  tags: tag
  properties: {
    sku: {
      name: 'pergb2018'
    }
    retentionInDays: retentionInDays
    features: {
      enableLogAccessUsingOnlyResourcePermissions: enableLogAccessUsingOnlyResourcePermissions
    }
    workspaceCapping: {
      dailyQuotaGb: dailyQuotaGb
    }
    publicNetworkAccessForIngestion: publicNetworkAccessForIngestion
    publicNetworkAccessForQuery: publicNetworkAccessForQuery
  }
}

output logAnalyticsWorkspaceId string = logAnalyticsWorkspace.id


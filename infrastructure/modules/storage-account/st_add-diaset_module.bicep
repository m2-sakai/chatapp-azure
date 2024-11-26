targetScope = 'resourceGroup'

@description('ストレージアカウント Blob ストレージ用のリソース名')
@minLength(3)
@maxLength(24)
param storageAccountBlobStorageName string

@description('診断設定名')
param diagnosticSettingName string

@description('Log Analytics ワークスペースの情報')
param logAnalyticsWorkspaceInfo object

@description('診断設定のログ設定の一覧')
param logs array = [
  {
    category: 'StorageRead'
  }
  {
    category: 'StorageWrite'
  }
  {
    category: 'StorageDelete'
  }
]

@description('診断設定のメトリック設定の一覧')
param metrics array = [
  {
    category: 'Transaction'
  }
]

resource existingLogAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2023-09-01' existing = {
  scope: resourceGroup(logAnalyticsWorkspaceInfo.subscriptionId, logAnalyticsWorkspaceInfo.resourceGroupName)
  name: logAnalyticsWorkspaceInfo.logAnalyticsWorkspaceName
}

resource existingStorageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' existing = {
  name: storageAccountBlobStorageName
}

resource existingStorageAccountBlobService 'Microsoft.Storage/storageAccounts/blobServices@2023-01-01' existing = {
  parent: existingStorageAccount
  name: 'default'
}

resource stDiagnosticSetting 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: diagnosticSettingName
  scope: existingStorageAccountBlobService
  properties: {
    workspaceId: existingLogAnalyticsWorkspace.id
    eventHubAuthorizationRuleId: null
    eventHubName: null
    logs: [
      for log in logs: {
        category: log.category
        enabled: true
      }
    ]
    metrics: [
      for metric in metrics: {
        category: metric.category
        enabled: true
      }
    ]
  }
}

output stDiagnosticSettingId string = stDiagnosticSetting.id

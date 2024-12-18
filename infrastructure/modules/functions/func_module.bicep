targetScope = 'resourceGroup'

@description('場所')
param location string = resourceGroup().location

@description('タグ名')
param tag object = {}

@description('Functionsのリソース名')
param functionAppName string

@description('パブリックアクセスの許可')
@allowed([
  'Enabled'
  'Disabled'
])
param publicNetworkAccess string = 'Disabled'

@description('IP制限のルール')
param ipSecurityRestrictions array = []

@description('SCMのIP制限のルール')
param scmIpSecurityRestrictions array = []

@description('アプリ観点のアプリケーション設定')
param aplAppSettings array = []

@description('App Service Planのリソース名')
@minLength(1)
@maxLength(60)
param appServicePlanName string

@description('マネージドIDのリソース名')
param userAssignedIdentityName string

@description('仮想ネットワーク統合のための仮想ネットワークのリソース名')
param virtualNetworkName string

@description('仮想ネットワーク統合のための仮想ネットワークのサブネット名')
@minLength(1)
@maxLength(80)
param subnetName string

@description('ストレージアカウント Blob ストレージ用のリソース名')
@minLength(3)
@maxLength(24)
param storageAccountBlobStorageName string

@description('Application Insightsのリソース名')
@minLength(1)
@maxLength(260)
param applicationInsightsName string

var vnetConnectionName = '${virtualNetworkName}_${subnetName}'

resource existingAppServicePlan 'Microsoft.Web/serverfarms@2023-12-01' existing = {
  name: appServicePlanName
}

resource existingStorageaccount 'Microsoft.Storage/storageAccounts@2023-04-01' existing = {
  name: storageAccountBlobStorageName
}

resource existingApplicationInsights 'microsoft.insights/components@2020-02-02' existing = {
  name: applicationInsightsName
}

resource existingUserAssignedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' existing = {
  name: userAssignedIdentityName
}

resource existingVirtualNetwork 'Microsoft.Network/virtualNetworks@2023-11-01' existing = {
  name: virtualNetworkName
}

resource functionApp 'Microsoft.Web/sites@2023-12-01' = {
  name: functionAppName
  location: location
  tags: tag
  kind: 'functionapp'
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${existingUserAssignedIdentity.id}': {}
    }
  }
  properties: {
    enabled: true
    hostNameSslStates: [
      {
        name: '${functionAppName}.azurewebsites.net'
        sslState: 'Disabled'
        hostType: 'Standard'
      }
      {
        name: '${functionAppName}.scm.azurewebsites.net'
        sslState: 'Disabled'
        hostType: 'Repository'
      }
    ]
    serverFarmId: existingAppServicePlan.id
    reserved: false
    isXenon: false
    hyperV: false
    dnsConfiguration: {}
    vnetRouteAllEnabled: true
    vnetImagePullEnabled: false
    vnetContentShareEnabled: false
    siteConfig: {
      appSettings: concat(
        [
          {
            name: 'AzureWebJobsStorage'
            value: 'DefaultEndpointsProtocol=https;AccountName=${existingStorageaccount.name};AccountKey=${existingStorageaccount.listKeys().keys[0].value}'
          }
          {
            name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
            value: existingApplicationInsights.properties.InstrumentationKey
          }
          {
            name: 'AZURE_CLIENT_ID'
            value: existingUserAssignedIdentity.properties.clientId
          }
          {
            name: 'FUNCTIONS_EXTENSION_VERSION'
            value: '~4'
          }
          {
            name: 'FUNCTIONS_WORKER_RUNTIME'
            value: 'dotnet-isolated'
          }
          {
            name: 'WEBSITE_USE_PLACEHOLDER_DOTNETISOLATED'
            value: '1'
          }
          {
            name: 'WEBSITE_VNET_ROUTE_ALL'
            value: '1'
          }
        ],
        aplAppSettings
      )
      numberOfWorkers: 1
      acrUseManagedIdentityCreds: false
      alwaysOn: true
      http20Enabled: false
      functionAppScaleLimit: 0
      minimumElasticInstanceCount: 1
    }
    scmSiteAlsoStopped: false
    clientAffinityEnabled: false
    clientCertEnabled: false
    clientCertMode: 'Required'
    hostNamesDisabled: false
    vnetBackupRestoreEnabled: false
    customDomainVerificationId: 'B875BA0041BFB8B8365030C3867FF9DBECF18E42DA177A47BC5F97C2B11CE337'
    containerSize: 1536
    dailyMemoryTimeQuota: 0
    httpsOnly: true
    redundancyMode: 'None'
    publicNetworkAccess: 'Enabled'
    storageAccountRequired: false
    virtualNetworkSubnetId: '${existingVirtualNetwork.id}/subnets/${subnetName}'
    keyVaultReferenceIdentity: existingUserAssignedIdentity.id
  }
}

resource functionAppFtp 'Microsoft.Web/sites/basicPublishingCredentialsPolicies@2023-12-01' = {
  parent: functionApp
  name: 'ftp'
  properties: {
    allow: false
  }
}

resource functionAppScm 'Microsoft.Web/sites/basicPublishingCredentialsPolicies@2023-12-01' = {
  parent: functionApp
  name: 'scm'
  properties: {
    allow: false
  }
}

resource functionAppWeb 'Microsoft.Web/sites/config@2023-12-01' = {
  parent: functionApp
  name: 'web'
  properties: {
    numberOfWorkers: 1
    defaultDocuments: [
      'Default.htm'
      'Default.html'
      'Default.asp'
      'index.htm'
      'index.html'
      'iisstart.htm'
      'default.aspx'
      'index.php'
    ]
    netFrameworkVersion: 'v8.0'
    requestTracingEnabled: false
    remoteDebuggingEnabled: false
    remoteDebuggingVersion: 'VS2022'
    httpLoggingEnabled: false
    acrUseManagedIdentityCreds: false
    logsDirectorySizeLimit: 35
    detailedErrorLoggingEnabled: false
    publishingUsername: '$${functionAppName}'
    scmType: 'None'
    use32BitWorkerProcess: false
    webSocketsEnabled: false
    alwaysOn: true
    managedPipelineMode: 'Integrated'
    virtualApplications: [
      {
        virtualPath: '/'
        physicalPath: 'site\\wwwroot'
        preloadEnabled: true
      }
    ]
    loadBalancing: 'LeastRequests'
    experiments: {
      rampUpRules: []
    }
    autoHealEnabled: false
    vnetName: vnetConnectionName
    vnetRouteAllEnabled: true
    vnetPrivatePortsCount: 0
    publicNetworkAccess: publicNetworkAccess
    cors: {
      allowedOrigins: [
        '*'
      ]
      supportCredentials: false
    }
    localMySqlEnabled: false
    managedServiceIdentityId: 13401
    ipSecurityRestrictions: ipSecurityRestrictions
    ipSecurityRestrictionsDefaultAction: 'Deny'
    scmIpSecurityRestrictions: scmIpSecurityRestrictions
    scmIpSecurityRestrictionsDefaultAction: 'Deny'
    scmIpSecurityRestrictionsUseMain: true
    http20Enabled: false
    minTlsVersion: '1.2'
    scmMinTlsVersion: '1.2'
    ftpsState: 'FtpsOnly'
    preWarmedInstanceCount: 0
    functionAppScaleLimit: 0
    functionsRuntimeScaleMonitoringEnabled: false
    minimumElasticInstanceCount: 1
    azureStorageAccounts: {}
  }
}

resource functionAppAzurewebsitesNet 'Microsoft.Web/sites/hostNameBindings@2023-12-01' = {
  parent: functionApp
  name: '${functionAppName}.azurewebsites.net'
  properties: {
    siteName: functionAppName
    hostNameType: 'Verified'
  }
}

resource functionAppVirtualNetworkConnections 'Microsoft.Web/sites/virtualNetworkConnections@2023-12-01' = {
  parent: functionApp
  name: vnetConnectionName
  properties: {
    vnetResourceId: '${existingVirtualNetwork.id}/subnets/${subnetName}'
    isSwift: true
  }
}

output functionAppId string = functionApp.id

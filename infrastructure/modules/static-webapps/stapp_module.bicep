targetScope = 'resourceGroup'

/*** param: 共通 ***/
@description('場所')
param location string = 'East Asia'

@description('タグ名')
param tag object = {}

@description('Static WebApps のリソース名')
param staticWebAppName string = 'stapp-adcl-test-je-01'

@description('Static WebApps のSKU名')
param sku string = 'Free'

resource staticWebApp 'Microsoft.Web/staticSites@2023-12-01' = {
  name: staticWebAppName
  location: location
  tags: tag
  sku: {
    name: sku
    tier: sku
  }
  properties: {
    repositoryUrl: 'https://github.com/m2-sakai/chatapp-azure'
    branch: 'main'
    stagingEnvironmentPolicy: 'Enabled'
    allowConfigFileUpdates: true
    provider: 'GitHub'
    enterpriseGradeCdnStatus: 'Disabled'
  }
}

resource staticWebAppAuth 'Microsoft.Web/staticSites/basicAuth@2023-12-01' = {
  parent: staticWebApp
  name: 'default'
  location: location
  properties: {
    applicableEnvironmentsMode: 'SpecifiedEnvironments'
  }
}

output staticWebAppId string = staticWebApp.id

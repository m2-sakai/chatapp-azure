targetScope = 'resourceGroup'

@description('場所')
param location string = resourceGroup().location

@description('タグ名')
param tag object = {}

@description('App Service Planのリソース名')
@minLength(1)
@maxLength(60)
param appServicePlanName string

@description('SKUの名前')
param skuName string = 'B1'

@description('リソースに割り当てられているインスタンスの数')
param skuCapacity int = 1

@description('OSの種類')
param kind string = 'app'

@description('OSの種類（Linuxの場合: true、Windowsの場合: false）')
param reserved bool = false

resource appServicePlan 'Microsoft.Web/serverfarms@2023-12-01' = {
  name: appServicePlanName
  location: location
  tags: tag
  sku: {
    name: skuName
    capacity: skuCapacity
  }
  kind: kind
  properties: {
    perSiteScaling: false
    elasticScaleEnabled: false
    maximumElasticWorkerCount: 1
    isSpot: false
    reserved: reserved
    isXenon: false
    hyperV: false
    targetWorkerCount: 0
    targetWorkerSizeId: 0
    zoneRedundant: false
  }
}

output appServicePlanId string = appServicePlan.id

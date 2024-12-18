targetScope = 'resourceGroup'

/*** param: 共通 ***/
@description('場所')
param location string = resourceGroup().location

@description('タグ名')
param tag object = {}

/*** param: App Service Plan ***/
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

/*** resource/module: App Service Plan ***/
module aspModule '../../modules/app-service-plan/asp_module.bicep' = {
  name: '${appServicePlanName}_Deployment'
  params: {
    location: location
    tag: tag
    appServicePlanName: appServicePlanName
    skuName: skuName
    skuCapacity: skuCapacity
    kind: kind
    reserved: reserved
  }
  dependsOn: []
}

output appServicePlanId string = aspModule.outputs.appServicePlanId

targetScope = 'resourceGroup'

/*** param: 共通 ***/
@description('場所')
param location string = resourceGroup().location

@description('タグ名')
param tag object = {}

/*** param: Public IP Address ***/
@description('パブリックIPアドレスのリソース名')
@minLength(1)
@maxLength(80)
param publicIPAddressName string

@description('パブリックIPアドレスのSKU名')
param skuName string = 'Standard'

@description('パブリックIPアドレスのSKUレベル')
param skuTier string = 'Regional'

@description('パブリックIPアドレスの割り当て方法')
param publicIPAllocationMethod string = 'Static'

@description('アイドル タイムアウト (分)')
param idleTimeoutInMinutes int = 4

@description('ドメイン名ラベル')
param dnsDomainNameLabel string

@description('DDoS 保護モード')
param ddosProtectionMode string = 'VirtualNetworkInherited'

/*** resource/module: Public IP Address ***/
module pipModule '../../modules/public-ip/pip_module.bicep' = {
  name: '${publicIPAddressName}_Deployment'
  params: {
    location: location
    tag: tag
    publicIPAddressName: publicIPAddressName
    skuName: skuName
    skuTier: skuTier
    publicIPAllocationMethod: publicIPAllocationMethod
    idleTimeoutInMinutes: idleTimeoutInMinutes
    dnsDomainNameLabel: dnsDomainNameLabel
    ddosProtectionMode: ddosProtectionMode
  }
  dependsOn: []
}

output publicIPAddressId string = pipModule.outputs.publicIPAddressId

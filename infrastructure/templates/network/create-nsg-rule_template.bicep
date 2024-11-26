targetScope = 'resourceGroup'

/*** param: 共通 ***/
@description('場所')
param location string = resourceGroup().location

@description('タグ名')
param tag object = {}

/*** param: Network Security Group ***/
@description('ネットワークセキュリティグループのリソース名')
@minLength(1)
@maxLength(80)
param networkSecurityGroupName string

/*** param: Security Rule ***/
@description('適用するセキュリティルールの配列')
param securityRules array

/*** resource/module: Network Security Group ***/
module nsgModule '../../modules/network-security-group/nsg_module.bicep' = {
  name: '${networkSecurityGroupName}_Deployment'
  params: {
    location: location
    tag: tag
    networkSecurityGroupName: networkSecurityGroupName
  }
  dependsOn: []
}

/*** resource/module: Security Rule ***/
module nsgSecurityRuleModule '../../modules/network-security-group/nsg_add-rule_module.bicep' = {
  name: '${networkSecurityGroupName}_sr_Deployment'
  params: {
    networkSecurityGroupName: networkSecurityGroupName
    securityRules: securityRules
  }
  dependsOn: [
    nsgModule
  ]
}

output networkSecurityGroupId string = nsgModule.outputs.networkSecurityGroupId

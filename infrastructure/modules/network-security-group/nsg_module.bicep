targetScope = 'resourceGroup'

@description('場所')
param location string = resourceGroup().location

@description('タグ名')
param tag object = {}

@description('ネットワークセキュリティグループのリソース名')
@minLength(1)
@maxLength(80)
param networkSecurityGroupName string

resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2023-11-01' = {
  name: networkSecurityGroupName
  location: location
  tags: tag
  properties: {
    securityRules: []
  }
}

output networkSecurityGroupId string = networkSecurityGroup.id

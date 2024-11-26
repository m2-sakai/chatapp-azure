using '../../../templates/network/create-nsg-rule_template.bicep'

/*** param: 共通 ***/
param tag = {}

/*** param: Network Security Group ***/
param networkSecurityGroupName = 'nsg-adcl-test-je-sub-3_0'

/*** param: Security Rule ***/
param securityRules = []

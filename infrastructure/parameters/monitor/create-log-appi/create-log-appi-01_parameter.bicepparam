using '../../../templates/monitor/create-log-appi_template.bicep'

/*** param: 共通 ***/
param tag = {}

/*** param: Log Analytics ***/
param logAnalyticsWorkspaceName = 'log-adcl-test-je-01'

/*** param: Application Insights ***/
param applicationInsightsName = 'appi-adcl-test-je-01'

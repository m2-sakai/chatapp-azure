targetScope = 'resourceGroup'

@description('WebPubSub のリソース名')
param webPubSubName string

@description('Hub のリソース名')
param hubName string

@description('イベントハンドラーのURL')
param urlTemplate string

resource existingWebPubSub 'Microsoft.SignalRService/WebPubSub@2024-04-01-preview' existing = {
  name: webPubSubName
}

resource wpsHub 'Microsoft.SignalRService/WebPubSub/hubs@2024-04-01-preview' = {
  parent: existingWebPubSub
  name: hubName
  properties: {
    eventHandlers: [
      {
        urlTemplate: urlTemplate
        userEventPattern: '*'
        systemEvents: []
        auth: {
          type: 'None'
        }
      }
    ]
    eventListeners: []
    anonymousConnectPolicy: 'Deny'
    webSocketKeepAliveIntervalInSeconds: 20
  }
}

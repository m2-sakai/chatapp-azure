# Azure Web Pubsub を使ったチャットアプリ

## 概要

Azure Web Pubsub を使ったチャットアプリです。

## どんなアプリ？

TBD...

## アーキテクチャ

![architecture](./assets/architecture.drawio.png)

## 各レイヤーのソースコード

本アプリケーションは以下のレイヤーに分かれています。各アプリの内容はそれぞれのディレクトリの README を参照してください。

| レイヤー       | ディレクトリ                        |
| -------------- | ----------------------------------- |
| フロントエンド | [frontend](./frontend)              |
| バックエンド   | [backend](./backend)                |
| 基盤（IaC）    | [infrastructure](./infrastructure/) |

## 参考情報

本アプリケーションは以下のドキュメントを主に参考にしております。<br/>
この場をお借りして感謝申し上げます。

- [Simple Chat App](https://azure.github.io/azure-webpubsub/demos/chat)
- [Chatr - Azure Web PubSub Sample App](https://code.benco.io/chatr/)]
- [Azure API Management で Web PubSub を使用して Socket.IO する](https://learn.microsoft.com/ja-jp/azure/azure-web-pubsub/socket-io-howto-integrate-apim)

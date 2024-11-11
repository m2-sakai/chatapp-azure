# Azure Web Pubsub を使ったチャットアプリ

## 概要

Azure Web Pubsub を使ったチャットアプリです。

## どんなアプリ？

TBD...

## アーキテクチャ

![architecture](./assets/architecture.drawio.png)

## 技術領域

本アプリケーションでは、以下の技術を採用しています。できる限り最新バージョンを使用しています。

| カテゴリ                  | 使用技術 | バージョン |
| ------------------------- | -------- | ---------- |
| フロントエンド            | React    |   18.3.1         |
| ランタイム                | Node.js  | 22.11.0    |
| ビルドツール              | Vite     | 5.4.10     |
| リンター & フォーマッター | Biome    | 1.9.4      |
| CSS | Tailwind CSS   | 1.9.4      |
| UIコンポーネントライブラリ | shadcn/ui    | -      |

## ローカルでの起動方法

依存ライブラリをインポートします。
```bash
$ npm install
```

以下のコマンドを実行すると、`http:localhost:5173`で見ることができます。
```bash
$ npm run dev
```
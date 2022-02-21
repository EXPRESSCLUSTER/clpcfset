# Azure プローブポートモニタリソース
- このページでは、Azure プローブポートモニタリソース固有のパラメータの設定方法について説明します。
- Azure プローブポートモニタリソースのタイプ名は azureppw です。
- 以下に記載のないパラメータについては、[リファレンスガイド](https://docs.nec.co.jp/sites/default/files/minisite/static/86695069-1c24-46d5-a3bf-72e81db4e4a7/clp_x43_linux/L43_RG_JP/L_RG_08.html#parameters-list-clpcfset-command)をご確認ください。

## 監視 (共通)
### 対象リソース
- パラメータのパス: target
- パラメータの値: [Azure プローブポートリソース](azurepp.md)名を指定してください。
- 実行例
  ```sh
  clpcfset add monparam azureppw azureppw1 target azurepp1
  ```

## 監視 (固有)
### プローブポート待ち受けタイムアウト時動作
- パラメータのパス: parameters/mode
- パラメータの値
  - 回復動作を実行しない (警告を表示しない): 0 (既定値)
  - 回復動作を実行しない (警告を表示する): 1 
  - 回復動作を実行する: 2 
- 実行例
  ```sh
  clpcfset add monparam azureppw azureppw1 parameters/mode 0
  ```
## 回復動作
### 回復対象
- 回復対象として、[Azure プローブポートリソース](azurepp.md)を設定してください。
- 実行例
  ```sh
  clpcfset add monparam azureppw azureppw1 relation/type rsc
  clpcfset add monparam azureppw azureppw1 relation/name azurepp1
  ```

## 実行例
### 全てのパラメータが既定値の場合
― モニタリソース名: azureppw1
- 監視対象リソース: azurepp1
- 回復対象: azurepp1
```sh
clpcfset add mon azureppw azureppw1
clpcfset add monparam azureppw azureppw1 target azurepp1
clpcfset add monparam azureppw azureppw1 relation/type rsc
clpcfset add monparam azureppw azureppw1 relation/name azurepp1
```
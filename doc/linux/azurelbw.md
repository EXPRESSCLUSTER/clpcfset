# Azure ロードバランスモニタリソース
- このページでは、Azure ロードバランスモニタリソース固有のパラメータの設定方法について説明します。
- Azure ロードバランスモニタリソースのタイプ名は azurelbw です。
- 以下に記載のないパラメータについては、[リファレンスガイド](https://docs.nec.co.jp/sites/default/files/minisite/static/86695069-1c24-46d5-a3bf-72e81db4e4a7/clp_x43_linux/L43_RG_JP/L_RG_08.html#parameters-list-clpcfset-command)をご確認ください。

## 監視 (固有)
### 対象リソース
- パラメータのパス: parameters/object
- パラメータの値: [Azure プローブポートリソース](azurepp.md)名を指定してください。
- 実行例
  ```sh
  clpcfset add monparam azurelbw azurelbw1 parameters/object azurepp1
  ```
## 回復動作
### 回復対象
- 回復対象として、サーバ (LocalServer) を指定してください。
- 実行例
  ```sh
  clpcfset add monparam azurelbw azurelbw1 relation/type cls
  clpcfset add monparam azurelbw azurelbw1 relation/name LocalServer
  ```

## 実行例
### 全てのパラメータが既定値の場合
― モニタリソース名: azurelbw1
- 監視対象リソース: azurepp1
- 回復対象: LocalServer
```sh
clpcfset add mon azurelbw azurelbw1
clpcfset add monparam azurelbw azurelbw1 parameters/object azurepp1
clpcfset add monparam azurelbw azurelbw1 relation/type cls
clpcfset add monparam azurelbw azurelbw1 relation/name LocalServer
```
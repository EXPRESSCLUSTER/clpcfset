# Azure プローブポートリソース
- このページでは、Azure プローブポートリソース固有のパラメータの設定方法について説明します。
- Azure プローブポートリソース名のタイプ名は azurepp です。
- 以下に記載のないパラメータについては、[リファレンスガイド](https://docs.nec.co.jp/sites/default/files/minisite/static/86695069-1c24-46d5-a3bf-72e81db4e4a7/clp_x43_linux/L43_RG_JP/L_RG_08.html#parameters-list-clpcfset-command)をご確認ください。

## 詳細
### プローブポート
- パラメータのパス: parameters/probeport
- パラメータの値: 1 - 65535
- 実行例
  ```sh
  clpcfset add rscparam azurepp azurepp1 parameters/probeport
  ```

## パラメータ
### プローブ 待ち受けのタイムアウト
- パラメータのパス: parameters/probetimeout
- パラメータの値: 5 - 999999999
- 実行例
  ```sh
  clpcfset add rscparam azurepp azurepp1 parameters/probetimeout
  ```


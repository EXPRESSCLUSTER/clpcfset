# NIC Link Up/Down モニタリソース
- このページでは、NIC Link Up/Down モニタリソース固有のパラメータの設定方法について説明します。
- NIC Link Up/Down モニタリソースのタイプ名は miiw です。
- 以下に記載のないパラメータについては、[リファレンスガイド](https://docs.nec.co.jp/sites/default/files/minisite/static/86695069-1c24-46d5-a3bf-72e81db4e4a7/clp_x43_linux/L43_RG_JP/L_RG_08.html#parameters-list-clpcfset-command)をご確認ください。

## 監視 (固有)
### 監視対象
- パラメータ: parameters/object
- パラメータの値: 監視対象の NIC (Network Interface Card) の名前を設定してください (e.g. eth0)。
- 実行例
  ```sh
  clpcfset add monparam miiw miiw1 parameters/object eth0
  ```
- 監視対象の NIC の名前が異なる場合、サーバ名を指定して実行する必要があります。例えば、server1 では eth0、 server2 では eth1 を監視する場合、以下のように実行してください。
  ```sh
  clpcfset add monparam miiw miiw1 parameters/object eth0
  clpcfset add monparam miiw miiw1 server@server2/parameters/object eth1
  ```

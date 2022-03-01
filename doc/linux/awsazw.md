# AWS AZ モニタリソース
- このページでは、AWS AZ モニタリソース固有のパラメータの設定方法について説明します。
- AWS AZ モニタリソースのタイプ名は awsazw です。
- 以下に記載のないパラメータについては、[リファレンスガイド](https://docs.nec.co.jp/sites/default/files/minisite/static/86695069-1c24-46d5-a3bf-72e81db4e4a7/clp_x43_linux/L43_RG_JP/L_RG_08.html#parameters-list-clpcfset-command)をご確認ください。

## 監視 (固有)
### アベイラビリティーゾーン
- パラメータのパス: parameters/availabilityzone
- パラメータの値: 監視対象となる Availability Zone (AZ) 名を設定してください。
- 実行例
  ```sh
  clpcfset add monparam awsazw awsazw1 parameters/availabilityzone ap-northeast-1a
  ```
- クラスタを構成するサーバが、それぞれ別の AZ に存在する場合、サーバ名を指定して実行する必要があります。例えば、サーバ名が server2 の場合、以下を実行してください。
  ```sh
  clpcfset add monparam awsazw awsazw1 server@server2/parameters/availabilityzone ap-northeast-1b
  ```
### AWS CLI コマンド応答取得失敗時動作
- パラメータのパス: parameters/mode
- パラメータの値
  - 回復動作を実行しない (警告を表示しない): 0 (既定値)
  - 回復動作を実行しない (警告を表示する): 1 
  - 回復動作を実行する: 2 
- 実行例
  ```sh
  clpcfset add monparam awsazw awsazw1 parameters/mode 0
  ```

## 実行例
### ソフトウェア構築ガイドに記載の設定
- モニタリソース名: awsazw1
- アベイラビリティゾーン
  - server1: ap-northeast-1a
  - server2: ap-northeast-1b
- 回復対象: LocalServer
- 最終動作: 何もしない
  ```sh
  clpcfset add mon awsazw awsazw1
  clpcfset add monparam awsazw awsazw1 parameters/availabilityzone ap-northeast-1a
  clpcfset add monparam awsazw awsazw1 server@server2/parameters/availabilityzone ap-northeast-1b
  clpcfset add monparam awsazw awsazw1 relation/type cls
  clpcfset add monparam awsazw awsazw1 relation/name LocalServer
  clpcfset add monparam awsazw awsazw1 emergency/threshold/fo 0
  ```
# AWS 仮想 IP リソース
- このページでは、AWS 仮想 IP リソース固有のパラメータの設定方法について説明します。
- AWS 仮想 IP リソース名のタイプ名は awsvip です。
- 以下に記載のないパラメータについては、[リファレンスガイド](https://docs.nec.co.jp/sites/default/files/minisite/static/86695069-1c24-46d5-a3bf-72e81db4e4a7/clp_x43_linux/L43_RG_JP/L_RG_08.html#parameters-list-clpcfset-command)をご確認ください。
- AWS 仮想 IP リソースの具体的な設定方法については、以下を参照してください。
  - https://jpn.nec.com/clusterpro/clpx/guide.html?#anc-lin
    - Amazon Web Services
      - CLUSTERPRO X 4.3 向け HA クラスタ 構築ガイド

## 詳細
### IP アドレス
- パラメータのパス: parameters/ip
- パラメータの値: 付与したい仮想的な IP アドレスを指定してください。
- 実行例
  ```sh
  clpcfset add rscparam awsvip awsvip1 parameters/ip 10.1.0.20
  ```
### VPC ID
- パラメータのパス: parameters/vpcid
- パラメータの値: VPC の ID を指定してください。
- 実行例
  ```sh
  clpcfset add rscparam awsvip awsvip1 parameters/vpcid vpc-1234abcd
  ```
- 2 台目以降のサーバについては、サーバ名を指定して実行する必要があります。例えば、サーバ名が server2 の場合、以下を実行してください。
  ```sh
  clpcfset add rscparam awsvip awsvip1 server@server2/parameters/vpcid vpc-1234abcd
  ```
### ENI ID
- パラメータのパス: parameters/eniid
- パラメータの値: ENI の ID を指定してください。
- 実行例
  ```sh
  clpcfset add rscparam awsvip awsvip1 parameters/eniid eni-xxxxxxxx
  ```
- 2 台目以降のサーバについては、サーバ名を指定して実行する必要があります。例えば、サーバ名が server2 の場合、以下を実行してください。
  ```sh
  clpcfset add rscparam awsvip awsvip1 server@server2/parameters/eniid eni-yyyyyyyy
  ```

## 調整プロパティ
### AWS CLI
#### タイムアウト
- パラメータのパス: parameters/awsclitimeout
- パラメータの値: 1 - 999 (既定値: 100)
- 実行例
  ```sh
  clpcfset add rscparam awsvip awsvip1 parameters/awsclitimeout 100
  ```
- awsclitimeout を既定値から変更した場合、180 + awsclitimeout × 3 の値を act/timeout に設定してください。
- 実行例 
  ```sh
  clpcfset add rscparam awsvip awsvip1 parameters/awsclitimeout 30
  clpcfset add rscparam awsvip awsvip1 act/timeout 270
  ```
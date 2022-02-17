# exec リソース
- このページでは、exec リソース固有のパラメータの設定方法について説明します。
- exec リソース名のタイプ名は exec です。
- パラメータに、[この製品で作成したスクリプト] を指定する場合、クラスタ構成情報ファイルをクラスタに適用するためには、クラスタ構成情報ファイル (clp.conf) と同じディレクトリに、シェルスクリプトを保存する必要があります。詳細は [ディレクトリ構成](#ディレクトリ構成) を参照してください。
- 以下に記載のないパラメータについては、[リファレンスガイド](https://docs.nec.co.jp/sites/default/files/minisite/static/86695069-1c24-46d5-a3bf-72e81db4e4a7/clp_x43_linux/L43_RG_JP/L_RG_08.html#parameters-list-clpcfset-command)をご確認ください。

## Start Script
- パラメータのパス: parameters/act/path
- パラメータの値
  - この製品で作成したスクリプト (既定値)
    - start.sh
  - ユーザアプリケーション
    - 任意のシェルファイルのパス (e.g. /opt/test/start.sh)
- 実行例
  ```sh
  clpcfset add rscparam exec exec1 parameters/act/path start.sh
  ```

## Stop Script
- パラメータのパス: parameters/deact/path
- パラメータの値
  - この製品で作成したスクリプト (既定値)
    - stop.sh
  - ユーザアプリケーション
    - 任意のシェルファイルのパス (e.g. /opt/test/stop.sh)
- 実行例
  ```sh
  clpcfset add rscparam exec exec1 parameters/deact/path stop.sh
  ```
## パラメータ
### 開始スクリプト 待機系サーバで実行する
- パラメータのパス: parameters/act/postrunothers
- パラメータの値
  - オン: 1
  - オフ: 0 (既定値)
- 実行例
  ```sh
  clpcfset add rscparam exec exec1 parameters/act/postrunothers 1
  ```
### 開始スクリプト (待機系)タイムアウト
- パラメータのパス: parameters/timeout/startothers
- パラメータの値: 1 - 9999
- 実行例
  ```sh
  clpcfset add rscparam exec exec1 parameters/timeout/startothers 30
  ```

### 終了スクリプト 待機系サーバで実行する
- パラメータのパス: parameters/deact/prerunothers
- パラメータの値
  - オン: 1
  - オフ: 0 (既定値)
- パラメータのパス: parameters/act/path
- パラメータの値: stop.sh
- 実行例
  ```sh
  clpcfset add rscparam exec exec1 parameters/deact/prerunothers 1
  ```

### 終了スクリプト (待機系)タイムアウト
- パラメータのパス: parameters/timeout/stopothers
- パラメータの値: 1 - 9999
- 実行例
  ```sh
  clpcfset add rscparam exec exec1 parameters/timeout/stopothers 30
  ```

## メンテナンス
### ログ出力先
- パラメータのパス: parameters/userlog
- パラメータの値
  - ファイルへの絶対パス: /opt/nec/clusterpro/log/exec1-log
- 実行例
  ```sh
  clpcfset add rscparam exec exec1 parameters/userlog /opt/nec/clusterpro/log/exec1-log
  ```
### ローテートする
- パラメータのパス: parameters/logrotate/use
- パラメータの値
  - ローテートしない: 0 (既定値)
  - ローテートする: 1
- 実行例
  ```sh 
  clpcfset add rscparam exec exec1 parameters/logrotate/use 1
  ```

### ローテートサイズ
- パラメータのパス: parameters/logrotate/size
- パラメータの値: 1 - 999999999
- 実行例
  ```sh 
  clpcfset add rscparam exec exec1 parameters/logrotate/size 3000000
  ```
## ディレクトリ構成
- [この製品で作成したスクリプト] を設定する場合、ディレクトリ構成を以下のようにしてください。
  ```
  clp.conf
  scripts/
   |
   +-- フェイルオーバグループ名/ 
        |
        +-- exec リソース名/ 
             |
             +-- start.sh
             |
             +-- stop.sh
  ```
- 例えば、フェイルオーバグループ名が failover1、execリソース名が exec1 の場合、以下のように配置してください。
  ```
  E.g.
  clp.conf
  scripts/
   |
   +-- failover1/ 
        |
        +-- exec1/ 
             |
             +-- start.sh
             |
             +-- stop.sh
  ```
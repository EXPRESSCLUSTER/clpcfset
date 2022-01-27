# exec リソース
- このページでは、exec リソース固有のパラメータの設定方法について説明します。
- exec リソース名のタイプ名は exec です。
- パラメータに、[この製品で作成したスクリプト] を指定する場合、クラスタ構成情報ファイルをクラスタに適用するためには、クラスタ構成情報ファイル (clp.conf) と同じディレクトリに、シェルスクリプトを保存する必要があります。詳細は [ディレクトリ構成](#ディレクトリ構成) を参照してください。

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
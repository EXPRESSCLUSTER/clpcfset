# AWS 仮想 IP モニタリソース
- このページでは、AWS 仮想 IP モニタリソース固有のパラメータの設定方法について説明します。
- AWS 仮想 IP モニタリソースのタイプ名は awsvipw です。
- 以下に記載のないパラメータについては、[リファレンスガイド](https://docs.nec.co.jp/sites/default/files/minisite/static/86695069-1c24-46d5-a3bf-72e81db4e4a7/clp_x43_linux/L43_RG_JP/L_RG_08.html#parameters-list-clpcfset-command)をご確認ください。

## 監視 (共通)
### 対象リソース
- パラメータのパス: target
- パラメータの値: [AWS 仮想 IP リソース](awsvip.md)名を指定してください。
- 実行例
  ```sh
  clpcfset add monparam awsvipw awsvipw1 target awsvip1
  ```

## 監視 (固有)
### AWS CLI コマンド応答取得失敗時動作
- パラメータのパス: parameters/mode
- パラメータの値
  - 回復動作を実行しない (警告を表示しない): 0 (既定値)
  - 回復動作を実行しない (警告を表示する): 1 
  - 回復動作を実行する: 2 
- 実行例
  ```sh
  clpcfset add monparam awsvipw awsvipw1 parameters/mode 0
  ```
## 回復動作
### 回復対象
- 回復対象として、[AWS 仮想 IP リソース](awsvip.md)を設定してください。
- 実行例
  ```sh
  clpcfset add monparam awsvipw awsvipw1 relation/type rsc
  clpcfset add monparam awsvipw awsvipw1 relation/name awsvip1
  ```

## 実行例
### 全てのパラメータが既定値の場合
- モニタリソース名: awsvipw1
- 監視対象リソース: awsvip1
- 回復対象: awsvip1
  ```sh
  clpcfset add mon awsvipw awsvipw1
  clpcfset add monparam awsvipw awsvipw1 target awsvip1
  clpcfset add monparam awsvipw awsvipw1 relation/type rsc
  clpcfset add monparam awsvipw awsvipw1 relation/name awsvip1
  ```
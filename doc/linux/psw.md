# プロセス名モニタリソース
- このページでは、プロセス名モニタソース固有のパラメータの設定方法について説明します。
- プロセス名モニタリソースのタイプ名は psw です。
- 以下に記載のないパラメータについては、[リファレンスガイド](https://docs.nec.co.jp/sites/default/files/minisite/static/86695069-1c24-46d5-a3bf-72e81db4e4a7/clp_x43_linux/L43_RG_JP/L_RG_08.html#parameters-list-clpcfset-command)をご確認ください。

## 監視 (固有)
### プロセス名
- パラメータ: parameters/processname
- パラメータの値: 監視対象のプロセス名を設定してください。
- 実行例
  ```sh
  clpcfset add monparam psw psw1 parameters/processname proccess1
  ```

### プロセス数下限値
- パラメータ: parameters/processnum
- パラメータの値: 1 - 999
- 実行例
  ```sh
  clpcfset add monparam psw psw1 parameters/processnum 1
  ```
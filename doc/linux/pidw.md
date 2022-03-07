# PID モニタリソース
- このページでは、PID モニタリソース固有のパラメータの設定方法について説明します。
- PID モニタリソースのタイプ名は pidw です。
- 以下に記載のないパラメータについては、[リファレンスガイド](https://docs.nec.co.jp/sites/default/files/minisite/static/86695069-1c24-46d5-a3bf-72e81db4e4a7/clp_x43_linux/L43_RG_JP/L_RG_08.html#parameters-list-clpcfset-command)をご確認ください。
- PID モニタリソースは、開始スクリプトの設定が [非同期] に設定されている exec リソースから実行されるプロセスの PID (プロセス ID) を監視します。つまり、常駐するプロセスの PID を監視します。左記の PID は監視処理時に自動で取得するため、以下の実行例のように監視対象や回復動作のみを設定してください。

## 実行例
- 監視対象のリソース名: exec-async
- 回復動作
  - 回復対象: exec-async
  - 最大再活性回数: 3回
  - 最大フェイルオーバ回数: 1回
  - 最終動作: 何もしない
    ```sh
    clpcfset add mon pidw pidw1
    clpcfset add monparam pidw pidw1 target exec-async
    clpcfset add monparam awsazw awsazw1 relation/type rsc
    clpcfset add monparam awsazw awsazw1 relation/name exec-async
    ```
    - 最大再活性回数、最大フェイルオーバ回数、最終動作は既定値のため、上記コマンドでは明示的に設定していません。
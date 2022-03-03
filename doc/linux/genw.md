# カスタムモニタリソース
- このページでは、カスタムモニタリソース固有のパラメータの設定方法について説明します。
- カスタムモニタリソースのタイプ名は genw です。
- 以下に記載のないパラメータについては、[リファレンスガイド](https://docs.nec.co.jp/sites/default/files/minisite/static/86695069-1c24-46d5-a3bf-72e81db4e4a7/clp_x43_linux/L43_RG_JP/L_RG_08.html#parameters-list-clpcfset-command)をご確認ください。

## 監視 (固有)
### 監視タイプ
- パラメータのパス: parameters/sync
- パラメータの値
  - 同期: 1 (既定値)
  - 非同期: 0
- 実行例
  ```sh
  clpcfset add monparam genw genw1 parameters/sync 1
  ```
### アプリケーション/スクリプトの監視開始を一定時間待ち合わせる
- 監視タイプが非同期の場合に設定してください。
- パラメータのパス: parameters/waitmonstart
- パラメータの値: 0 - 9999 (秒)
- 実行例
  ```sh
  clpcfset add monparam genw genw1 parameters/sync 0
  clpcfset add monparam genw genw1 parameters/waitmonstart 60
  ```

### ログ出力先
- パラメータのパス: parameters/userlog
- パラメータの値: ログ出力先の絶対パスを設定してください。
- 実行例
  ```sh
  clpcfset add monparam genw genw1 parameters/userlog /opt/nec/clusterpro/log/genw-log.txt
  ```

### ローテートする
- パラメータのパス: parameters/logrotate/use
- パラメータの値
  - オン: 1
  - オフ: 0 (既定値)
- 実行例
  ```sh
  clpcfset add monparam genw genw1 parameters/logrotate/use 1
  ```

### ローテートサイズ
- [ローテートする] がオンの場合に設定してください。
- パラメータのパス: parameters/logrotate/size
- パラメータの値: 1 - 999999999 (バイト、既定値: 1000000)
- 実行例
  ```sh
  clpcfset add monparam genw genw1 parameters/logrotate/use 1
  clpcfset add monparam genw genw1 parameters/logrotate/size 1000000
  ```

### 正常な戻り値
- パラメータのパス: parameters/normalval
- パラメータの値: [監視タイプ] が [同期] の場合に、スクリプトが返す [正常な戻り値] を設定してください。
- 実行例
  ```sh
  clpcfset add monparam genw genw1 parameters/normalval 0
  ```

### クラスタ停止時に活性時監視の停止を待ち合わせる
- パラメータのパス: parameters/waitstop
- パラメータの値
  - オン: 1
  - オフ: 0 (既定値)
- 実行例
  ```sh
  clpcfset add monparam genw genw1 parameters/waitstop 0
  ```

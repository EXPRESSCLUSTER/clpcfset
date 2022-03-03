# SMPT モニタリソース
- このページでは、SMTP モニタリソース固有のパラメータの設定方法について説明します。
- SMTP モニタリソースのタイプ名は smtpw です。
- 以下に記載のないパラメータについては、[リファレンスガイド](https://docs.nec.co.jp/sites/default/files/minisite/static/86695069-1c24-46d5-a3bf-72e81db4e4a7/clp_x43_linux/L43_RG_JP/L_RG_08.html#parameters-list-clpcfset-command)をご確認ください。

## 監視 (固有)
### IP アドレス
- パラメータのパス: parameters/ipaddress
- パラメータの値: 監視対象の SMTP サーバの IP アドレスを設定してください (既定値: 127.0.0.1) 。
- 実行例
  ```sh
  clpcfset add monparam smtpw smtpw1 parameters/ipaddress 127.0.0.1
  ```

### ポート番号
- パラメータのパス: parameters/port
- パラメータの値: 監視対象の SMTP サーバのポート番号を設定してください。
- 実行例
  ```sh
  clpcfset add monparam smtpw smtpw1 parameters/port 25
  ```

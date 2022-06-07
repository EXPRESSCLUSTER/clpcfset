# FTP モニタリソース
- このページでは、FTP モニタリソース固有のパラメータの設定方法について説明します。
- FTP モニタリソースのタイプ名は fftpw です。

## 監視 (固有)
### IP アドレス
- パラメータのパス: parameters/ipaddress
- パラメータの値: 監視対象の FTP サーバの IP アドレスを設定してください (既定値: 127.0.0.1) 。
- 実行例
  ```sh
  clpcfset add monparam ftpw ftpw1 parameters/ipaddress 127.0.0.1
  ```
### ポート番号
- パラメータのパス: parameters/port
- パラメータの値: 監視対象の FTP サーバのポート番号を設定してください (既定値: 21) 。
- 実行例
  ```sh
  clpcfset add monparam ftpw ftpw1 parameters/port 21
  ```
### ユーザ名
- パラメータのパス: parameters/username
- パラメータの値: 監視対象の FTP サーバにログイン可能なユーザ名を設定してください。
- 実行例
  ```sh
  clpcfset add monparam ftpw ftpw1 parameters/username anonymous
  ```

### パスワード
- [ユーザ名] で定しているユーザで FTP サーバのログイン時にパスワードが必要な場合、パスワードも設定してください。
- CLUSTERPRO X 4.3 以降、[clpencrypt](https://docs.nec.co.jp/sites/default/files/minisite/static/7046aab7-c76f-436d-b513-53b9a20df485/clp_x43_linux/L43_RG_JP/L_RG_08.html#clpencrypt) コマンドを利用することで、暗号化したパスワードを得ることが可能です。
- 実行例
  ```sh
  clpcfset add monparam ftpw ftpw1 parameters/password 暗号化されたパスワード
  clpcfset add monparam ftpw ftpw1 parameters/encrypwd 1
  ```
### プロトコル
- パラメータのパス: parameters/protocol
- パラメータの値
  - FTP: 0
  - FTPS: 1
- 実行例
  ```sh
  clpcfset add monparam ftpw ftpw1 parameters/protocol 0
  ```
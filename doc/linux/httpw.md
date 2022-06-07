# HTTP モニタリソース
- このページでは、HTTP モニタリソース固有のパラメータの設定方法について説明します。
- HTTP モニタリソースのタイプ名は httpw です。

## 監視 (固有)
### 接続先
- パラメータのパス: parameters/servername
- パラメータの値: 監視対象の Web サーバの IP アドレスまたは名前解決可能なホスト名を設定してください (既定値: localhost) 。
- 実行例
  ```sh
  clpcfset add monparam httpw httpw1 parameters/servername localhost
  ```

### ポート番号
- パラメータのパス: parameters/port
- パラメータの値: 監視対象の Web サーバのポート番号を設定してください。
- 実行例
  ```sh
  clpcfset add monparam httpw httpw1 parameters/port 80
  ```

### Request URI
- パラメータのパス: parameters/requesturi
- パラメータの値: 任意の URI を設定してください。
- 実行例
  ```sh
  clpcfset add monparam httpw httpw1 parameters/requesturi /index.html
  ```

### プロトコル
- パラメータのパス: parameters/https
- パラメータの値
  - HTTP: 0 (既定値)
  - HTTPS: 1
- 実行例
  ```sh
  clpcfset add monparam httpw httpw1 parameters/https 0
  ```

### リクエスト種別
- パラメータのパス: parameters/requesttype
- パラメータの値
  - HEAD: 0 (既定値)
  - GET: 1
- 実行例
  ```sh
  clpcfset add monparam httpw httpw1 parameters/requesttype 0 
  ```

### ユーザ名
- パラメータのパス: parameters/username
- パラメータの値: 監視対象の Web サーバにログインする必要がある場合、ログイン可能なユーザ名を設定してください。
- 実行例
  ```sh
  clpcfset add monparam httpw httpw1 parameters/username foo
  ```

### パスワード
- [ユーザ名] を設定している場合、パスワードも設定してください。
- CLUSTERPRO X 4.3 以降、[clpencrypt](https://docs.nec.co.jp/sites/default/files/minisite/static/7046aab7-c76f-436d-b513-53b9a20df485/clp_x43_linux/L43_RG_JP/L_RG_08.html#clpencrypt) を利用することで、暗号化したパスワードを得ることが可能です。
- 実行例
  ```sh
  clpcfset add monparam httpw httpw1 parameters/password 暗号化されたパスワード
  clpcfset add monparam httpw httpw1 parameters/encrypwd 1
  ```
## 実行例
### 監視パラメータを既定値で設定する

```sh
clpcfset add mon httpw httpw1
clpcfset add monparam httpw httpw1 target exec1
clpcfset add monparam httpw httpw1 relation/target exec1
clpcfset add monparam httpw httpw1 relation/type rsc
clpcfset add monparam httpw httpw1 relation/name exec1
```

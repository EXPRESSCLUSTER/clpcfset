# PostgreSQL モニタリソース
- このページでは、PostgreSQL モニタリソース固有のパラメータの設定方法について説明します。
- PostgreSQL モニタリソースのタイプ名は psqlw です。
- 以下に記載のないパラメータについては、[リファレンスガイド](https://docs.nec.co.jp/sites/default/files/minisite/static/86695069-1c24-46d5-a3bf-72e81db4e4a7/clp_x43_linux/L43_RG_JP/L_RG_08.html#parameters-list-clpcfset-command)をご確認ください。

## 監視 (固有)
### 監視レベル
- パラメータのパス: parameters/docreatedrop
- パラメータの値
  - レベル1 (select での監視): 3
  - レベル2 (update/select での監視): 0 (既定値)
  - レベル3 (毎回 create/drop も行う): 1
- 実行例
  ```sh
  clpcfset add monparam psqlw psqlw1 parameters/docreatedrop 0
  ```

### データベース名
- パラメータのパス: parameters/database
- パラメータの値: 監視対象のデータベース名を設定してください。
- 実行例
  ```sh
  clpcfset add monparam psqlw psqlw1 parameters/database mydb
  ```

### IP アドレス
- パラメータのパス: parameters/ipaddress
- パラメータの値: 監視対象の IP アドレスを設定してください (既定値: 127.0.0.1)
- 実行例
  ```sh
  clpcfset add monparam psqlw psqlw1 parameters/ipaddress 127.0.0.1
  ```

### ポート番号
- パラメータのパス: parameters/port
- パラメータの値: 監視対象のポート番号を設定してください (既定値: 5432)
- 実行例
  ```sh
  clpcfset add monparam psqlw psqlw1 parameters/port 5432
  ```

### ユーザ名
- パラメータのパス: parameters/username
- パラメータの値: 監視対象のデータベースにアクセス可能なユーザを設定してください。
- 実行例
  ```sh
  clpcfset add monparam mysqlw mysqlw1 parameters/username foo
  ```

### パスワード
- CLUSTERPRO X 4.3 以降は、[clpencrypt](https://docs.nec.co.jp/sites/default/files/minisite/static/7046aab7-c76f-436d-b513-53b9a20df485/clp_x43_linux/L43_RG_JP/L_RG_08.html#clpencrypt) を利用することで、暗号化したパスワードを得ることが可能です。
- 実行例
  ```sh
  clpcfset add monparam mysqlw mysqlw1 parameters/password 暗号化されたパスワード
  clpcfset add monparam mysqlw mysqlw1 parameters/encrypwd 1
  ```

### 監視テーブル名
- パラメータのパス: parameters/table
- パラメータの値: 監視用のテーブルを設定してください。
- 実行例
  ```sh
  clpcfset add monparam psqlw psqlw1 parameters/table psqlwatch
  ```

### ライブラリパス
- パラメータのパス: parameters/libraryfullpath
- パラメータの値: ライブラリへの完全パスを設定してください。
- 実行例
  ```sh
  clpcfset add monparam psqlw psqlw1 parameters/libraryfullpath /opt/PostgreSQL/10/lib/libpq.so.5.10
  ```

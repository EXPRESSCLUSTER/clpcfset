# Oracle モニタリソース
- このページでは、Oracle モニタリソース固有のパラメータの設定方法について説明します。
- Oracle モニタリソースのタイプ名は oraclew です。
- 以下に記載のないパラメータについては、[リファレンスガイド](https://docs.nec.co.jp/sites/default/files/minisite/static/86695069-1c24-46d5-a3bf-72e81db4e4a7/clp_x43_linux/L43_RG_JP/L_RG_08.html#parameters-list-clpcfset-command)をご確認ください。

## 監視 (固有)
### 監視方式
- パラメータのパス: parameters/monmethod
- パラメータの値
  - リスナーとインスタンスを監視: 0 (既定値)
  - リスナーのみ監視: 1 
  - インスタンスのみ監視: 2 
- 実行例
  ```sh
  clpcfset add monparam oraclew oraclew1 parameters/monmethod 0
  ```

### 監視レベル
- パラメータのパス: parameters/docreatedrop
- パラメータの値
  - レベル0 (データベースステータス): 2
  - レベル1 (select での監視): 3
  - レベル2 (update/select での監視): 0 (既定値)
  - レベル3 (毎回 create/drop も行う): 1
- 実行例
  ```sh
  clpcfset add monparam oraclew oraclew1 parameters/docreatedrop 0
  ```
### パスワード
- CLUSTERPRO X 4.3 以降は、[clpencrypt](https://docs.nec.co.jp/sites/default/files/minisite/static/7046aab7-c76f-436d-b513-53b9a20df485/clp_x43_linux/L43_RG_JP/L_RG_08.html#clpencrypt) を利用することで、暗号化したパスワードを得ることが可能です。
- 実行例
  ```sh
  clpcfset add monparam oraclew oraclew1 parameters/password 暗号化されたパスワード
  clpcfset add monparam oraclew oraclew1 parameters/encrypwd 1
  ```

### ライブラリパス
- パラメータのパス: parameters/libraryfullpath
- パラメータの値: ライブラリの絶対パスを指定してください。
- 実行例
  ```sh
  clpcfset add monparam oraclew oraclew1 parameters/libraryfullpath /u01/app/oracle/product/19.0.0/dbhome_1/lib/libclntsh.so.19.1
  ```

### 障害発生時にアプリケーションの詳細情報を採取する
- パラメータのパス: emergency/infocollect/use
- パラメータの値
  - オフ: 0 (既定値)
  - オン: 1
- 実行例
  ```sh
  clpcfset add monparam oraclew oraclew1 emergency/infocollect/use 0
  ```
### 採取タイムアウト
- パラメータのパス: emergency/infocollect/timeout
- パラメータの値: 1 - 9999 (既定値: 600)
- 実行例
  ```sh
  clpcfset add monparam oraclew oraclew1 emergency/infocollect/timeout 600
  ```

### Oracle の初期化中またはシャットダウン中をエラーにする
- パラメータのパス: parameters/ignoreuse
- パラメータの値
  - オフ: 0 (既定値)
  - オン: 1
- 実行例
  ```sh
  clpcfset add monparam oraclew oraclew1 parameters/ignoreuse 0
  ```

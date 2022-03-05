# ユーザ空間モニタリソース
- このページでは、ユーザ空間モニタリソース固有のパラメータの設定方法について説明します。
- ユーザ空間モニタリソースのタイプ名は userw です。
- 以下に記載のないパラメータについては、[リファレンスガイド](https://docs.nec.co.jp/sites/default/files/minisite/static/86695069-1c24-46d5-a3bf-72e81db4e4a7/clp_x43_linux/L43_RG_JP/L_RG_08.html#parameters-list-clpcfset-command)をご確認ください。

## 監視 (固有)
### ハートビートのインターバル/タイムアウトを使用する
- パラメータのパス: parameters/usehb
- パラメータの値
  - オン: 1 (既定値)
  - オフ: 0
- 実行例
  ```sh
  clpcfset add monparam userw userw1 parameters/usehb 1
  ```

### 監視方法
- パラメータのパス: parameters/method
- パラメータの値
  - keepalive (既定値)
  - softdog
  - ipmi
- 実行例
  ```sh
  clpcfset add monparam userw userw1 parameters/method keepalive
  ```

### タイムアウト発生時動作
- [監視方法] によって、設定できる動作が異なります。
- パラメータのパス: parameters/action
- 実行例
  - keepalive + PANIC
    ```sh
    clpcfset add monparam userw userw1 parameters/method keepalive
    clpcfset add monparam userw userw1 parameters/action PANIC
    ```
  - softdog + RESET
    ```sh
    clpcfset add monparam userw userw1 parameters/method softdog
    clpcfset add monparam userw userw1 parameters/action RESET
    ```

### ダミーファイルのオープン/クローズ
- パラメータのパス: parameters/repopen
- パラメータの値
  - オン: 1
  - オフ: 0 (既定値)
- 実行例
  ```sh
  clpcfset add monparam userw userw1 parameters/repopen 1
  ```

### 書き込みを行う
- パラメータのパス: parameters/repwrite
- パラメータの値
  - オン: 1
  - オフ: 0 (既定値)
- 実行例
  ```sh
  clpcfset add monparam userw userw1 parameters/repwrite 1
  ```

### サイズ
- [書き込みを行う] がオンの場合に設定してください。
- パラメータのパス: parameters/writesize
- パラメータの値: 1 - 9999999 バイト (既定値: 10000)
- 実行例
  ```sh
  clpcfset add monparam userw userw1 parameters/repwrite 1
  clpcfset add monparam userw userw1 parameters/writesize 10000
  ```

### ダミースレッドの作成
- パラメータのパス: parameters/mkthread
- パラメータの値
  - オン: 1
  - オフ: 0 (既定値)
- 実行例
  ```sh
  clpcfset add monparam userw userw1 parameters/mkthread 1
  ```

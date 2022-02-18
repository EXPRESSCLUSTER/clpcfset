# ミラーディスクリソース
- このページでは、ミラーディスクリソース固有のパラメータの設定方法について説明します。
- ディスクリソース名のタイプ名は md です。
- 以下に記載のないパラメータについては、[リファレンスガイド](https://docs.nec.co.jp/sites/default/files/minisite/static/86695069-1c24-46d5-a3bf-72e81db4e4a7/clp_x43_linux/L43_RG_JP/L_RG_08.html#parameters-list-clpcfset-command)をご確認ください。

## マウント
### マウントオプション
- パラメータのパス: parameters/mount/option
- パラメータの値: 任意のマウントオプション (既定値: rw)
- 実行例
  ```sh
  clpcfset add rscparam md md1 parameters/mount/option rw
  ```
### タイムアウト
- パラメータのパス: parameters/mount/timeout
- パラメータの値: 1 - 999 (既定値: 120)
- 実行例
  ```sh
  clpcfset add rscparam md md1 parameters/mount/timeout 120
   ```
### リトライ回数 
- パラメータのパス: parameters/mount/retry
- パラメータの値: 0 - 999 (既定値: 3)
- 実行例
  ```sh
  clpcfset add rscparam md md1 parameters/mount/retry 3
  ```

## アンマウント
### タイムアウト
- パラメータのパス: parameters/umount/timeout
- パラメータの値: 1 - 999 (既定値: 300)
- 実行例
  ```sh
  clpcfset add rscparam md md1 parameters/umount/timeout 120
  ```
### リトライ回数
- パラメータのパス: parameters/umount/retry
- パラメータの値: 0 - 999 (既定値: 3)
- 実行例
  ```sh
  clpcfset add rscparam md md1 parameters/umount/retry 3
  ```
### リトライインターバル
- パラメータのパス: parameters/umount/interval
- パラメータの値: 0 - 999 (既定値: 5)
- 実行例
  ```sh
  clpcfset add rscparam md md1 parameters/umount/interval 5
  ```
### 異常検出時の強制動作
- パラメータのパス: parameters/umount/action
- パラメータの値
  - 強制終了: kill (既定値)
  - 何もしない: none
- 実行例
  ```sh
  clpcfset add rscparam md md1 parameters/umount/action kill
  ```
## fsck
- ファイルシステムに ext2, ext3, ext4 を設定した場合に以下のパラメータを設定してください。
### fsck オプション
- パラメータのパス: parameters/fsck/option
- パラメータの値: fsck コマンドのオプションを指定してください (既定値: -y)
- 実行例
  ```sh
  clpcfset add rscparam md md1 parameters/fsck/option -y
  ```
### fsck タイムアウト
- パラメータのパス: parameters/fsck/timeout
- パラメータの値: 1 - 9999 (既定値: 7200)
- 実行例
  ```sh
  clpcfset add rscparam md md1 parameters/fsck/timeout 7200
  ```
### Mount 実行前の fsck アクション
- パラメータのパス: parameters/fsck/timing
- パラメータの値
  - 実行しない: 0
  - 必ず実行する: 1
  - 指定回数に達したら実行する: 2 (既定値)
- 実行例
  ```sh
  clpcfset add rscparam md md1 parameters/fsck/timing 2
  ```
#### 回数
- [指定回数に達したら実行する] を指定した場合に
- パラメータのパス: parameters/fsck/interval
- パラメータの値: 0 - 999 (既定値: 10)
- 実行例
  ```sh
  clpcfset add rscparam md md1 parameters/fsck/interval 10
  ```
### Mount 失敗時の fsck アクション
- パラメータのパス: parameters/mount/action
- パラメータの値: 実行する
  - オフ: 0 
  - オン: 1 (既定値)
- 実行例
  ```sh
  clpcfset add rscparam md md1 parameters/mount/action 1
  ```
### reiserfs の再構築
- パラメータのパス: parameters/fsck/fixopt
- パラメータの値: 実行する
  - オフ: 0 (既定値) 
  - オン: 1
- 実行例
  ```sh
  clpcfset add rscparam md md1 parameters/fsck/fixopt 0
  ```
## xfs_repair
- ファイルシステムに xfs を設定した場合に以下のパラメータを設定してください。
### xfs_repair オプション
- パラメータのパス: parameters/fsck/xfsoption
- パラメータの値: xfs_repair コマンドのオプションを指定してください (既定値: 指定なし)
- 実行例
  ```sh
  clpcfset add rscparam md md1 parameters/fsck/xfsoption -L
  ```
### xfs_repair タイムアウト
- パラメータのパス: parameters/fsck/xfstimeout
- パラメータの値: 1 - 9999 (既定値: 7200)
- 実行例
  ```sh
  clpcfset add rscparam md md1 parameters/fsck/xfstimeout 7200
  ```
### Mount 失敗時の xfs_repair アクション
- パラメータのパス: parameters/mount/xfsaction
- パラメータの値: 実行する
  - オフ: 0 (既定値) 
  - オン: 1
- 実行例
  ```sh
  clpcfset add rscparam md md1 parameters/mount/xfsaction 0
  ```

## ミラー
### 初期ミラー構築を行う
- コピー元とコピー先のディスクのイメージが一致している場合にのみ、オフを設定していただくことが可能です。
- パラメータのパス: parameters/fullcopy
- パラメータの値
  - オン: 1 (既定値)
  - オフ: 0
- 実行例
  ```sh
  clpcfset add rscparam md md1 parameters/fullcopy 1
  ```
### 初期 mkfs を行う
- ミラーディスクで利用するディスク上に既にデータが存在する場合には、オフを設定してください。
- パラメータのパス: parameters/mkfs
- パラメータの値
  - オン: 1
  - オフ: 0 (既定値)
- 実行例
  ```sh
  clpcfset add rscparam md md1 parameters/mkfs 0
  ```
### データを同期する
- こちらのパラメータはスケジュールミラー利用時のみ設定してください。
- パラメータのパス: parameters/mddriver/sync
- パラメータの値
  - オン: 1 (既定値)
  - オフ: 0
- 実行例
  ```sh
  clpcfset add rscparam md md1 parameters/mddriver/sync 1
  ```
### モード
- パラメータのパス: parameters/mddriver/syncmode
- パラメータの値
  - 同期: 1 (既定値)
  - 非同期: 0
- 実行例
  ```sh
  clpcfset add rscparam md md1 parameters/mddriver/syncmode 1
  ```
### キューの数
- 非同期モードの場合に設定可能なパラメータです。
- パラメータのパス: parameters/mddriver/sendqueuesize
- パラメータの値
  - 無制限: 0
  - 数を指定: 1 - 999999 (既定値: 2048)
- 実行例
  ```sh
  clpcfset add rscparam md md1 parameters/mddriver/sendqueuesize 2048
  ```
### 通信帯域を制限する
- 非同期モードの場合に設定可能なパラメータです。
- パラメータのパス: parameters/mddriver/bandlimit/mode
- パラメータの値
  - オン: 1
  - オフ: 0 (既定値)
- 実行例 (オフ)
  ```sh
  clpcfset add rscparam md md1  parameters/mddriver/bandlimit/mode 0
  ```
### 帯域上限
- 非同期モードの場合に設定可能なパラメータです。
- [通信帯域を制限する] がオンの場合に設定してください。
- パラメータのパス: parameters/mddriver/bandlimit/limit
- パラメータの値: 1 - 999999 [KB/秒]
- 実行例
  ```sh
  clpcfset add rscparam md md1 parameters/mddriver/bandlimit/mode 1
  clpcfset add rscparam md md1 parameters/mddriver/bandlimit/limit 2048
  ```
### 履歴ファイル格納ディレクトリ
- 非同期モードの場合に設定可能なパラメータです。
- パラメータのパス: parameters/mddriver/historydir
- パラメータの値: 任意のディレクトリを設定してください。
- 実行例
  ```sh
  clpcfset add rscparam md md1 parameters/mddriver/historydir /mnt/history
  ```
### 履歴ファイルサイズ制限
- 非同期モードの場合に設定可能なパラメータです。
- パラメータのパス: parameters/mddriver/historymax
- パラメータの値: 1 - 999999999 [MB]
- 実行例
  ```sh
  clpcfset add rscparam md md1 parameters/mddriver/historymax 2048
  ```
### データを圧縮する、復帰時データを圧縮する
- 同期モードの場合、0 または 2 のみ設定可能です。
- パラメータのパス: parameters/mddriver/compress
- パラメータの値
  - データを圧縮するがオフ、復帰時データを圧縮するがオフ: 0
  - データを圧縮するがオン、復帰時データを圧縮するがオフ: 1
  - データを圧縮するがオフ、復帰時データを圧縮するがオン: 2
  - データを圧縮するがオン、復帰時データを圧縮するがオン: 3
- 実行例
  ```sh
  clpcfset add rscparam md md1 parameters/mddriver/compress 3
  ```
### ミラー通信を暗号化する
- パラメータのパス: parameters/mddriver/crypto/use
- パラメータの値
　- オン: 1
  - オフ: 0 (既定値)
- 実行例
  ```sh
  clpcfset add rscparam md md1 parameters/mddriver/crypto/use 1
  ```
### 鍵ファイルフルパス
- [ミラー通信を暗号化する] がオンの場合にのみ設定してください。
- パラメータのパス: parameters/mddriver/crypto/keyfile
- パラメータの値: ファイルへの絶対パスを設定してください。
- 実行例
  ```sh
  clpcfset add rscparam md md1 parameters/mddriver/crypto/keyfile /root/keyfile
  ```

## ミラードライバ
### 送信タイムアウト
- パラメータのパス: parameters/mddriver/sendtimeout
- パラメータの値: 10 - 99 (既定値: 30)
- 実行例
  ```sh
  clpcfset add rscparam md md1 parameters/mddriver/sendtimeout 30
  ```
### 接続タイムアウト
- パラメータのパス: parameters/mddriver/connecttimeout
- パラメータの値: 5 - 99 (既定値: 10)
- 実行例
  ```sh
  clpcfset add rscparam md md1 parameters/mddriver/connecttimeout 10
  ```
### Ack タイムアウト
- パラメータのパス: parameters/mddriver/acktimeout
- パラメータの値: 1 - 600 (既定値: 100)
- 実行例
  ```sh
  clpcfset add rscparam md md1 parameters/mddriver/acktimeout 100
  ```
### 受信タイムアウト
- パラメータのパス: parameters/mddriver/recvnormaltimeout
- パラメータの値: 1 - 600 (既定値: 100)
- 実行例
  ```sh
  clpcfset add rscparam md md1 parameters/mddriver/recvnormaltimeout 100
  ```
### ハートビートインターバル
- パラメータのパス: parameters/mddriver/hbinterval
- パラメータの値: 1 - 600 (既定値: 10)
- 実行例
  ```sh
  clpcfset add rscparam md md1 parameters/mddriver/hbinterval 10
  ```
### ICMP Echo Reply 受信タイムアウト
- パラメータのパス: parameters/mddriver/pingtimeout
- パラメータの値: 1 - 100 (既定値: 2)
- 実行例
  ```sh
  clpcfset add rscparam md md1 parameters/mddriver/pingtimeout 2
  ```
### ICMP Echo Request リトライ回数
- パラメータのパス: parameters/mddriver/pingretry
- パラメータの値: 1- 50 (既定値: 8)
- 実行例
  ```sh
  clpcfset add rscparam md md1 parameters/mddriver/pingretry 8
  ```

## 実行例
### ファイルシステムが ext4 かつ他のパラメータが既定値の場合
- フェイルオーバグループ名: failover1
- ディスクリソース名: md1
```sh
clpcfset add rsc failover1 md md1
clpcfset add rscparam md md1 parameters/netdev@0/priority 0
clpcfset add rscparam md md1 parameters/netdev@0/device 0
clpcfset add rscparam md md1 parameters/netdev@0/mdcname mdc1
clpcfset add rscparam md md1 parameters/nmppath /dev/NMP1
clpcfset add rscparam md md1 parameters/mount/point /mnt/md1
clpcfset add rscparam md md1 parameters/diskdev/dppath /dev/mapper/md1-dp
clpcfset add rscparam md md1 parameters/diskdev/cppath /dev/mapper/md1-cp
clpcfset add rscparam md md1 parameters/fs ext4
```
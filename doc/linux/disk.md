# ディスクリソース
- このページでは、ディスクリソース固有のパラメータの設定方法について説明します。
- ディスクリソース名のタイプ名は disk です。
- 以下に記載のないパラメータについては、[リファレンスガイド](https://docs.nec.co.jp/sites/default/files/minisite/static/86695069-1c24-46d5-a3bf-72e81db4e4a7/clp_x43_linux/L43_RG_JP/L_RG_08.html#parameters-list-clpcfset-command)をご確認ください。

## マウント
### マウントオプション
- パラメータのパス: parameters/mount/option
- パラメータの値: 任意のマウントオプション (既定値: rw)
- 実行例
  ```sh
  clpcfset add rscparam disk disk1 parameters/mount/option rw
  ```
### タイムアウト
- パラメータのパス: parameters/mount/timeout
- パラメータの値: 1 - 999 (既定値: 180)
- 実行例
  ```sh
  clpcfset add rscparam disk disk1 parameters/mount/timeout 120
   ```
### リトライ回数 
- パラメータのパス: parameters/mount/retry
- パラメータの値: 0 - 999 (既定値: 3)
- 実行例
  ```sh
  clpcfset add rscparam disk disk1 parameters/mount/retry 3
  ```
## アンマウント
### タイムアウト
- パラメータのパス: parameters/umount/timeout
- パラメータの値: 1 - 999 (既定値: 120)
- 実行例
  ```sh
  clpcfset add rscparam disk disk1 parameters/umount/timeout 120
  ```
### リトライ回数
- パラメータのパス: parameters/umount/retry
- パラメータの値: 0 - 999 (既定値: 3)
- 実行例
  ```sh
  clpcfset add rscparam disk disk1 parameters/umount/retry 3
  ```
### リトライインターバル
- パラメータのパス: parameters/umount/interval
- パラメータの値: 0 - 999 (既定値: 5)
- 実行例
  ```sh
  clpcfset add rscparam disk disk1 parameters/umount/interval 5
  ```
### 異常検出時の強制動作
- パラメータのパス: parameters/umount/action
- パラメータの値
  - 強制終了: kill (既定値)
  - 何もしない: none
- 実行例
  ```sh
  clpcfset add rscparam disk disk1 parameters/umount/action kill
  ```
## fsck
- ファイルシステムに ext2, ext3, ext4 を設定した場合に以下のパラメータを設定してください。
### fsck オプション
- パラメータのパス: parameters/fsck/option
- パラメータの値: fsck コマンドのオプションを指定してください (既定値: -y)
- 実行例
  ```sh
  clpcfset add rscparam disk disk1 parameters/fsck/option -y
  ```
### fsck タイムアウト
- パラメータのパス: parameters/fsck/timeout
- パラメータの値: 1 - 9999 (既定値: 7200)
- 実行例
  ```sh
  clpcfset add rscparam disk disk1 parameters/fsck/timeout 7200
  ```
### Mount 実行前の fsck アクション
- パラメータのパス: parameters/fsck/timing
- パラメータの値
  - 実行しない: 0
  - 必ず実行する: 1
  - 指定回数に達したら実行する: 2 (既定値)
- 実行例
  ```sh
  clpcfset add rscparam disk disk1 parameters/fsck/timing 2
  ```
#### 回数
- [指定回数に達したら実行する] を指定した場合に
- パラメータのパス: parameters/fsck/interval
- パラメータの値: 0 - 999 (既定値: 10)
- 実行例
  ```sh
  clpcfset add rscparam disk disk1 parameters/fsck/interval 10
  ```
### Mount 失敗時の fsck アクション
- パラメータのパス: parameters/mount/action
- パラメータの値: 実行する
  - オフ: 0 
  - オン: 1 (既定値)
- 実行例
  ```sh
  clpcfset add rscparam disk disk1 parameters/mount/action 1
  ```
### reiserfs の再構築
- パラメータのパス: parameters/fsck/fixopt
- パラメータの値: 実行する
  - オフ: 0 (既定値) 
  - オン: 1
- 実行例
  ```sh
  clpcfset add rscparam disk diskoption1 parameters/fsck/fixopt 0
  ```
## xfs_repair
### xfs_repair オプション
- パラメータのパス: parameters/fsck/xfsoption
- パラメータの値: xfs_repair コマンドのオプションを指定してください (既定値: 指定なし)
- 実行例
  ```sh
  clpcfset add rscparam disk diskoption1 parameters/fsck/xfsoption -L
  ```
### xfs_repair タイムアウト
- パラメータのパス: parameters/fsck/xfstimeout
- パラメータの値: 1 - 9999 (既定値: 7200)
- 実行例
  ```sh
  clpcfset add rscparam disk diskoption1 parameters/fsck/xfstimeout 7200
  ```
### Mount 失敗時の xfs_repair アクション
- パラメータのパス: parameters/mount/xfsaction
- パラメータの値: 実行する
  - オフ: 0 (既定値) 
  - オン: 1
- 実行例
  ```sh
  clpcfset add rscparam disk disk1 parameters/mount/xfsaction 0
  ```
## 実行例
### ファイルシステムが ext4 かつ他のパラメータが既定値の場合
- フェイルオーバグループ名: failover1
- ディスクリソース名: disk1
```sh
clpcfset add rsc failover1 disk disk1
clpcfset add rscparam disk disk1 parameters/fs ext4
clpcfset add rscparam disk disk1 parameters/device /dev/sdb1
clpcfset add rscparam disk disk1 parameters/mount/point /mnt/disk1
```
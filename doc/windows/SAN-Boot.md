# SAN ブート構成で共有ディスク型クラスタを構築する

## 構成図
```
+---------+       +---------+
| server1 |       | server2 |
+-----+---+       +---+-----+
      |               |
      +-------+-------+
              |
+-------------+-------------+
| Storage                   |
|                           |
|  For server1              |
| +-----------------------+ |
| | System Volume         | |
| +-----------------------+ |
| | C: OS                 | |
| +-----------------------+ |
|                           |
|  For server2              |
| +-----------------------+ |
| | System Volume         | |
| +-----------------------+ |
| | C: OS                 | |
| +-----------------------+ |
|                           |
|  Shared Volume            |
| +-----------------------+ |
| | R: NP Resolution      | |
| +-----------------------+ |
| | S: Data               | |
| +-----------------------+ |
| | T: Data               | |
| +-----------------------+ |
+---------------------------+
```
- C: OS 領域
- R: Disk 方式のネットワークパーティション (NP) 解決リソース用のドライブ
- S, T: サーバ間で引き継ぐデータを保存するドライブ

## 注意事項
- サイレントインストールの場合、全てのサーバから共有ディスク上のファイルシステムにアクセス可能な状態 (共有ディスク上のファイルシステムに影響を与える恐れがあります) で作業を進めることになります。そのため、共有ディスク上にはデータがない状態でのクラスタ構築をお勧めいたします。また、クラスタ構築完了後には、該当のドライブに対して、chkdsk を実行することをお勧めします。

## 構築手順
### CLUSTERPRO のインストール
#### GUI によるインストール
1. インストール & 設定ガイドに従い、CLUSTERPRO をインストールしてください。
   - [共有ディスクのフィルタリング設定] にて、該当の HBA に対してフィルタリング設定を行ってください。また、ブート領域および C: ドライブに対しては、除外設定を行ってください。除外設定を行わないと、OS が起動しなくなります。 

#### サイレントインストール
1. インストール & 設定ガイドに従い、CLUSTERPRO をインストールしてください。
1. インストール後、全てのサーバを再起動してください。

### ライセンスファイルの登録
1. サーバ再起動後、clplcnsc コマンドでライセンスを登録してください。

### 構成情報の作成
1. サンプルスクリプト (PowerShell) をクラスタサーバに保存してください。
   - Oracle Cloud Infrastructure (OCI)
     - [Paravirtualized](../../sample/windows/sd/oci/virtio)
1. サンプルスクリプト内のパラメータを適宜変更してください。
   - $HBAPORT, $DEVICEID, $INSTANCEID
     - フィルタリングを行いたいドライブが接続されている HBA の情報を設定してください。以下で取得可能です。
       - 実行例
         ```bat
         clpdiskctrl get hba R:
         ```
       - 実行結果 (OCI)
         ```
         0,PCI\VEN_1AF4&DEV_1004&SUBSYS_0008108E&REV_00,20
         ```
         - 0: $HBAPORT
         - PCI\VEN_1AF4&DEV_1004&SUBSYS_0008108E&REV_00: $DEVICEID
         - 20: $INSTANCEID
   - $SYSTEMGUID1, $SYSTEMGUID2
     - システムドライブをフィルタリングの除外対象に設定します。以下で取得可能です。systemvolum の列が True となっているドライブの GUID を設定してください。
       - 実行例 
         ```ps
         get-wmiobject -class win32_volume |ft -Property name,deviceid,bootvolume,systemvolume |out-string -width 4096
         ```
      - 実行結果
        ```ps
         name                                              deviceid                                          bootvolume systemvolume
         ----                                              --------                                          ---------- ------------
         C:\                                               \\?\Volume{e5ed6e77-9bf5-4c2f-8e37-00cad39ab7c6}\       True        False
         \\?\Volume{55edbb61-db75-49cc-9e3e-5c108aae6c04}\ \\?\Volume{55edbb61-db75-49cc-9e3e-5c108aae6c04}\      False         True
         ```       
   - $CGUID1, $CGUID2, $NPGUID, $SD1GUID, $SD2GUID
     - 以下のコマンドを実行してください。
       - 実行例
         ```bat
         clpdiskctrl get guid R:
         ```
       - 実行結果
         ```
         a1f0d795-caa3-47a2-b911-598c7e38a2da
         ```
       - 共有ディスクの LUN が GPT でフォーマットされていることを前提としたスクリプトになっています。MBR でフォーマットした場合、NPGUID, SD1GUID, SD2GUID がそれぞれのサーバで異なります。
1. 管理者権限で PowerShell を起動し、サンプルスクリプトを実行してください。
1. 実行後、サンプルスクリプトと同ディレクトリ内に clp.conf ファイルが作成されていることを確認してください。

### 構成情報の適用
1. clp.conf ファイルがあるディレクトリにて、以下のコマンドを実行してください。
   ```bat
   clpcfctrl --push -w -x .
   ```
1. 構成情報反映後、全てのサーバの OS を再起動してください。
1. OS 再起動後、クラスタが正常に動作していることを Cluster WebUI または clpstat コマンドで確認してください。
1. サイレントインストールでインストールした場合、ディスクリソースに設定されているドライブ (E.g. S: ドライブ) に対して、chkdsk を実行してください。

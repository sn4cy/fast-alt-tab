# Fast Alt Tab

Hyprland向けの軽量な、Windows風Alt+Tabウィンドウ切り替えアプリ。
QuickshellのUIと小さなC製クライアントをUNIXソケットで接続し、キー入力ごとのQtやPython起動を省きます。

## 操作

- **Alt + Tab**：現在のワークスペースのウィンドウを最近使用した順に選択。
- **Alt + Shift + Tab**：逆順に選択。
- **Altを離す**：選択したウィンドウに切り替え。
- **Alt + Escape**：キャンセル。
- カードをクリックして切り替えることもできます。

最初のTabで直前のウィンドウを選択します。100ms以内の素早い操作ではパネルを表示しません。
UIは半透明のダークパネル、静止プレビュー、淡いブルーの選択枠、アプリのアイコンを使用します。
見出しや操作説明は表示しません。

## 動作環境

- Linux / Wayland
- **Hyprland 0.56.2のLua設定環境**で確認（従来のhyprland.conf向けではありません）
- **Quickshell 0.3.1**で確認
- Cコンパイラ、systemdのユーザーサービス

## インストール

リポジトリのディレクトリで実行します。

```sh
bash install.sh
```

`examples/hyprland.lua`を既存のHyprland Lua設定へ追加してください。
既存のAlt+Tab設定がある場合は置き換えます。`transparent = true`はAlt解放時の確定に必要です。

```sh
systemctl --user restart fast-alt-tab.service
hyprctl reload
```

次回以降は設定例の起動フックでサービスが起動します。
インストーラーはHyprland設定を自動編集しません。

## ファイル

| ファイル | 内容 |
| --- | --- |
| `shell.qml` | UI、ウィンドウ一覧、選択、確定、ソケットサーバー |
| `client.c` | キー操作を送る小さなクライアント |
| `install.sh` | コンパイルとユーザー領域へのインストール |
| `examples/hyprland.lua` | 起動フックとキー設定 |

Ghostty、Firefox、Zenにはインストール済みのアプリ付属アイコンを使用します。
ZenのパスはArchの`zen-browser-bin`向けです。その他はdesktop entryからアイコンを取得します。
アイコン画像はこのリポジトリに同梱していません。

## 状態確認・停止

```sh
~/.local/bin/fast-alt-tab status
journalctl --user -u fast-alt-tab.service
systemctl --user stop fast-alt-tab.service
```

削除する場合は、まず追加したキー設定と起動フックを削除し、サービスを停止してください。
その後、`~/.local/bin/fast-alt-tab`、設定ディレクトリの`hypr/alt-tab`と
`systemd/user/fast-alt-tab.service`を削除し、`systemctl --user daemon-reload`を実行します。

## 制限

動作確認は上記バージョンと単一モニター環境で実施しています。
プレビューは静止画で、選択中に継続更新しません。
一部アプリではdesktop entryやアイコンが見つからず汎用アイコンになる場合があります。

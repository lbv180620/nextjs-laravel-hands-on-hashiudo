#todo [tmux]


# My dev workflow using tmux and vim - a productive way to develop apps on your terminal
# https://www.youtube.com/watch?v=sSOfr2MtRU8&list=PLxQA0uNgQDCICMRwlOzWAZBPL05XBC_br&index=1

# https://blog.inkdrop.app/my-dev-workflow-using-tmux-vim-video-e30e78a9acce
# https://blog.inkdrop.app/vscode-like-environment-with-vim-tmux-4c2bfe17d31e

# https://github.com/craftzdog/dotfiles-public/tree/master/.config/tmux


# linuxにおけるtmuxの設定(クリップボード, ステータスライン)
# https://qiita.com/atsuya0/items/f9fa3f2018d63b85c1dd

# tmuxの使い方
# https://tex2e.github.io/blog/linux/tmux-tutorial


# ==== Screen ====

#* 操作方法

# Client → Screen > Session > Window > Pane(画面)

# 起動
# screen

# 横画面分割
# <C-a> + S

# 画面移動
# <C-a> + Tab

# プロセス起動
# <C-a> + c

# 縦画面分割
# <C-a> + Pipe(mac does not support)

# Paneを閉じる
# <C-a> + Q

# デタッチ
# <C-a> + d

# screen画面チェック
# screen -ls

# アタッチ
# screen -r


# ==== Tmux ====

# **** Tmux Serverの運用例 ****

# https://www.udemy.com/course/vim-tmux-zsh/learn/lecture/27876524#overview

  #        [Home PC]
  #       VPN ⬇️ ssh
  #   [Office PC(tmux server)] ➡️ [社内サーバー]
  #      ⬇           ⬇️
  #     [AWS]        [GCP]

#^ メリット:
# ssh接続を切断しても、tmux windowをデタッチしておけばsessionが残っているので、再度ssh接続した時に以前作業していたwindowで作業ができる。


# **** 操作方法 ****

# Client → Tmux server > Session > Window > Pane

#~ Session

# 起動
# tmux

# デタッチ
# <C-t> + d

# セッションの一覧
# tmux ls

# アタッチ
# tmux a -t <セッション名>

# セッション一覧から選択
# <C-t> + s → 0 or 1

# tmuxのシャットダウン
# tmux kill-server

# 時計を表示
# <C-t> t

# ※Prefixのデフォルトは<C-b>だが、tmux.confで変更可能(<C-t>に変更済み)


# ................

#~ Pane

# 横(左右)に分ける
# <C-t> + %
# → \ に変更

# 縦(上下)に分ける
# <C-t> + "
# → ^ に変更

# Pane破棄
# <C-t> + x
# or
# Ctrl + d (通常のターミナルのexit)

# Pane拡大/縮小
# <C-t> + z

# 次のPaneに移動
# <C-t> + o

# Paneを移動
# <C-t> + 矢印key

# Paneの順序を前方向に入れ替え
# <opy
# bind-key -T copy-mode-vi 'v' send -X begin-selection
# bind-key -T copy-mode-vi 'C-v' send -X rectangle-toggle
# # Mac
# bind-key -T copy-mode-vi 'y' send -X copy-selection
# # WSL
# # bind-key -T copy-mode-vi 'y' send-keys -X copy-pipe-and-cancel clip.exe
# # Paneの順序を後方向に入れ替え
# <C-t> + }

# レイアウトの変更
# <C-t> + space

# Paneの番号の表示から移動
# <C-t> + q → 数字

# 表示時間の設定
# set -g display-panes-time 2000

# ................

#~ Window

# create window (新規ウィンドウ)
# <C-t> + c

# next window (次のウィンドウ)
# <C-t> + n

# previos window (前のウィンドウ)
# <C-t> + p

# 指定番号のウィンドウに移動
# <C-t> + 数字

# ウィンドウを破棄する
# <C-t> + &

# rename window (ウィンドウの名前を変える)
# <C-t> + ,

# move window position
# <C-Shift> + 矢印


# ................

#~ その他(カスタマイズ)

# 各Paneに番号が表示される
# <C-t> + q

# IDEのように画面が分割される
# ide

# vim-likeなPaneの移動
# <C-t> + k/j/h/l

# カレントディレクトリでFinderを開く
# <C-t> + f


# ----------------

#? クリッピボードへのコピーをVimの機能で使えるようにする

# tmux.conf

# setw -g mode-keys vi
# bind-key -T copy-mode-vi 'v' send -X begin-selection
# bind-key -T copy-mode-vi 'C-v' send -X rectangle-toggle
# bind-key -T copy-mode-vi 'y' send -X copy-selection

#^ WSLの場合は、
# bind-key -T copy-mode-vi 'y' send-keys -X copy-pipe-and-cancel clip.exe


# ................

# tmux vim-like mode
# <C-t> → [

# tmux copy
# コピー&ペースト(Mac)
# <C-t> → [ → 移動(jkhl) → v → 移動(jkhl) → y → enter → Command + v
# # コピー&ペースト(WSL)
# <C-t> → [ → 移動(jkhl) → v → 移動(jkhl) → y → enter → Contrl + v


# ----------------

#? tmux上でvimで作業する場合の[esc]の反応速度が遅くなる場合の対処

# tmux起動時のvimのescapeの反応速度の設定: 推奨 0
# set -sg escape-time 10


# ----------------

#? Prefixの変更

# デフォルトのPrefixを <C-b> から <C-g> に変更

# tmux.conf
# unbind C-b
# set -g prefix C-g
# bind C-g send-prefix


# ----------------

#? tmux status lineに表示したwindow nameを自動renameしない

# https://qiita.com/Sho2010@github/items/aacf9ce7c33efbe8a831
# https://www.hiroom2.com/2018/06/05/tmux-2-7-allow-rename-0-ja/

# set-option -g allow-rename off


# ----------------

#? tmux の status line の設定方法

# https://qiita.com/nojima/items/9bc576c922da3604a72b
# https://blog.black-cat.jp/2018/12/tmux-status-line/
# https://yiskw713.hatenablog.com/entry/2022/05/17/230443
# https://qiita.com/ringtail003/items/524cdbb38dd97891b95e



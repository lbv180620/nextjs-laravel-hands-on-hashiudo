#todo [シェル]

# https://github.com/craftzdog/dotfiles-public

# https://shiimanblog.com/engineering/shell/


# ----------------

#? シェルの切り替え

# https://hirooooo-lab.com/development/change-mac-shell/
# https://blog-and-destroy.com/34392
# https://rurukblog.com/post/mac-shell/
# https://qiita.com/djkazunoko/items/5f2979e2f902247aac3f

# 現在の設定の確認
# echo $SHELL

# 変更可能なシェルの確認
# cat /etc/shells

# 使用するターミナルのシェルを変更する
# chsh -s /bin/zsh


# ................

#! エラーの場合→【chsh: no changes made】

# chsh: no changes madeのエラーが出た場合は以下の手順でシェルを変更します。

# 「システム環境設定」
# ↓
# 「ユーザとグループ」
# ↓
# 左下の鍵アイコンをクリックしてロック解除
# ↓
# 現在のユーザを右クリックして「詳細オプション」
# ↓
# 「ログインシェル」を変更


# ==== fish ====

# fish shellチュートリアル
# http://fish.rubikitch.com/tutorial/

# 記事
# https://www.wantedly.com/companies/luxy-inc/post_articles/362074
# https://zenn.dev/sawao/articles/0b40e80d151d6a
# https://qiita.com/toda-axiaworks/items/7376aee0a47400a35190
# https://original-game.com/how-to-use-fishshell/
# https://blog.ojisan.io/to-fish/
# https://omkz.net/fish-shell/
# https://zenn.dev/tamanugi/articles/e4fb17a0fed671


# ----------------

#? zsh → fish

# https://www.soudegesu.com/sh/fish/
# https://qiita.com/sifue/items/20ae88730ab929ccf420
# https://muunyblue.github.io/7476533956dd3568c1d787c5d33a547f.html
# https://zenn.dev/estra/articles/zenn-fish-add-path-final-answer
# https://www.dkrk-blog.net/shell/fish_ha_iizo


# 代入 → set 変数名 値

#' && → and
# || → or
#' !  → not

# = → 半角スペース
# : → 半角スペース

# export → set -x


# .............

#? evalの設定方法

# https://ema-hiro.hatenablog.com/entry/20170523/1495519890
# https://qiita.com/1natsu172/items/6f74688918b808e7a4b2

# bashrc での rbenv の設定
# eval "$(rbenv init -)" と同様のことを書きたい時
# eval (rbenv init - | source)

# その他の書き方
# eval () ← zshやbashで言うところの $ を付けない
# source () 直に指定

# eval "$(ssh-agent -s)"
# ↓
# eval (ssh-agent -c)


# .............

#? fish で ssh agent を永続化

# https://qiita.com/hayatejvn/items/e1bb1900c7d0c4d15f05

# set SSH_AGENT_FILE "$HOME/.ssh/ssh_agent"
# test -f $SSH_AGENT_FILE; and source $SSH_AGENT_FILE > /dev/null 2>&1
# if not ssh-add -l > /dev/null 2>&1
#   if not ps -ef | grep -v grep | grep ssh-agent
#     ssh-agent -c > $SSH_AGENT_FILE 2>&1
#   end
#   source $SSH_AGENT_FILE > /dev/null 2>&1
#   find $HOME/.ssh -name id_rsa | xargs ssh-add
# end


# **** fishの設定 ****

#~ fishのインストールと切り替え
# $ brew install fish
# $ fish -v # バージョンが返ってくれば成功です。
# $ which fish # パスをひかえておきます。
# $ sudo vi /etc/shells # 末尾に /usr/local/bin/fish を追加
# $ chsh -s /usr/local/bin/fish #デフォルトのshellを切り替えます。
# ここまでやってターミナルを開き直せば完了です。

#~ パッケージマネージャー fisherをインストール
#$ curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish
# $ fisher -v #バージョンが返ってくれば完了です。

# $ fisher install [インストールするプラグイン] # e.g.) fisher install jethrokuan/z


#~ install oh-my-fish/bobthefish
# $ fisher install oh-my-fish/theme-bobthefish
# $ git clone https://github.com/powerline/fonts.git
# $ cd fonts
# $ ./install.sh
# $ rm -rf ./fonts
# powerlineフォントをインストールしたら、terminal or iTerm2 のフォントをfor powerlineがつくものに選択
# (自分は Source Code Pro for Powerline)


#? $ fish_config と打って実行すると web ブラウザが立ち上がり、GUI で設定ができる


# ****  設定ファイル ****

# 1. ログイン時に実行されるファイル
# `~/.config/fish/functions/fish_greeting.fish`

# function fish_greeting
#   set_color $fish_color_autosuggestion
#   echo "Hello, your name is Yuta. Now, Let's programming!!"
#   set_color normal
# end


# .................

# 2. ほとんどの設定をここに書く
# `~/.config/fish/config.fish`

# #view
# set -g theme_display_date yes
# set -g theme_date_format "+%F %H:%M"
# set -g theme_display_git_default_branch yes
# set -g theme_color_scheme dark

# #path
# set -x PATH $HOME/.nodebrew/current/bin $PATH

# set -x PYENV_ROOT $HOME/.pyenv
# set -x PATH  $PYENV_ROOT/bin $PATH
# pyenv init - | source

# #peco setting
# set fish_plugins theme peco

# function fish_user_key_bindings
#   bind \cw peco_select_history
# end


# # view の設定を説明
# - set -g theme_display_date yes → 日付表示します
# - set -g theme_date_format "+%F %H:%M" → 日付のフォーマット指定
# set -g theme_display_git_default_branch yes → git のブランチ master と main も表示
# set -g theme_color_scheme dark → bobthefish のテーマが選べる デフォルトは dark
# #path のところに, node や pyenv の記述をしているが、使わない人は書かなくて良い


# ----------------

# My Fish shell workflow for coding
# https://www.youtube.com/watch?v=KKxhf50FIPI&list=PLxQA0uNgQDCICMRwlOzWAZBPL05XBC_br&index=5

# https://github.com/craftzdog/dotfiles-public/tree/master/.config/fish

# https://zenn.dev/sugitlab/scraps/103237de3129bf


# I use Fish shell
# https://fishshell.com/
#◉ Fisher: User-friendly interactive shell
#◉ Useful features out of the box
# → Syntax highlighting
# → Autosuggestions
# → Tab completions
# etc.

# My Fish setup
#◉ Fisher: Plugin manager for Fish
#◉ shellder: Shell theme
#◉ Nerd fonts: Powerline-patched font
#◉ z: Directory jumping
#◉ peco: Interactive filtering tool
# → `ctrl-r` to search the command history
# → `ctrl-f` to search the configured directories
#◉ Exa: A modern replacement for `ls`
#◉ ghq: Local Git repository organizer

# Fisher
# https://github.com/jorgebucaran/fisher
#◉ Plugin manager
# → curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish
#◉ Installing a plugin
# → fisher install <GH_REPOSITORY>
#◉ Ex. Insatlling `z`
# → fisher install jethrokuan/z

# Shellder: Shell theme
# https://github.com/simnalamburt/shellder
#◉ fisher install simnalamburt/shellder

# Tide: Shell theme (推奨)
# https://github.com/IlanCosman/tide
#◉ fisher install ilancosman/tide@v5

# Nerd fonts
# https://github.com/ryanoasis/nerd-fonts
#◉ Powershell-patched fonts

# z
# ディレクトリを自由に移動できるプラグイン
# https://github.com/jethrokuan/z
#◉ brew install z
#◉ fisher install jethrokuan/z

# exa
# https://the.exa.website/
#◉ brew install exa

# ghq
# https://github.com/x-motemen/ghq
#◉ brew install ghq

# peco
# コマンドを履歴から検索できるプラグイン
# https://github.com/peco/peco
#◉ brew install peco
#◉ fisher install oh-my-fish/plugin-peco

# fish-bd
# ディレクトリを上に遡れるプラグイン
#◉ fisher install 0rax/fish-bd

# fzf
# コマンドやファイルの検索
#◉ brew install fzf
#◉ fisher install jethrokuan/fzf


# ----------------

#? 色の設定

# Fishの色設定をターミナルだけで完結する
# https://qiita.com/Dooteeen/items/e098755afc4acd25d81f

# set_color-端末の色を設定する
# https://runebook.dev/ja/docs/fish/cmds/set_color

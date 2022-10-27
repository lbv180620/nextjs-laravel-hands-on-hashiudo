#todo 25. iTerm2 zshの設定

# https://bottoms-programming.com/archives/mac-terminal-to-iterm2.html



# zsh-syntax-highlighting
# https://github.com/zsh-users/zsh-syntax-highlighting

# brew install zsh
# brew install zsh-completions
# brew install zsh-syntax-highlighting

# sudo vi /etc/shells
# /usr/local/bin/zshを追記

# chsh -s /usr/local/bin/zsh

# echo $SHELL
# /usr/local/bin/zsh

# zsh --version
# zsh 5.8 (x86_64-apple-darwin19.6.0)

# ---------------------------

# vi ~/.zshrc

# # 環境変数
# export LANG=ja_JP.UTF-8

# # ヒストリの設定
# HISTFILE=~/.zsh_history
# HISTSIZE=50000
# SAVEHIST=50000

# # 直前のコマンドの重複を削除
# setopt hist_ignore_dups

# # 同じコマンドをヒストリに残さない
# setopt hist_ignore_all_dups

# # 同時に起動したzshの間でヒストリを共有
# setopt share_history

# # 補完機能を有効にする
# autoload -Uz compinit
# compinit -u
# if [ -e /usr/local/share/zsh-completions ]; then
#   fpath=(/usr/local/share/zsh-completions $fpath)
# fi

# # 補完で小文字でも大文字にマッチさせる
# zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# # 補完候補を詰めて表示
# setopt list_packed

# # 補完候補一覧をカラー表示
# autoload colors
# zstyle ':completion:*' list-colors ''

# # コマンドのスペルを訂正
# setopt correct
# # ビープ音を鳴らさない
# setopt no_beep

# # ディレクトリスタック
# DIRSTACKSIZE=100
# setopt AUTO_PUSHD

# # git
# autoload -Uz vcs_info
# setopt prompt_subst
# zstyle ':vcs_info:git:*' check-for-changes true
# zstyle ':vcs_info:git:*' stagedstr "%F{magenta}!"
# zstyle ':vcs_info:git:*' unstagedstr "%F{yellow}+"
# zstyle ':vcs_info:*' formats "%F{cyan}%c%u[%b]%f"
# zstyle ':vcs_info:*' actionformats '[%b|%a]'
# precmd () { vcs_info }

# # プロンプトカスタマイズ
# PROMPT='
# [%B%F{red}%n@%m%f%b:%F{green}%~%f]%F{cyan}$vcs_info_msg_0_%f
# %F{yellow}$%f '


# source ~/.zshrc


# ---------------------------

# https://bottoms-programming.com/archives/termina-git-branch-name-zsh.html

# ---------------------------

# zshでプロンプトをカラー表示する
# https://qiita.com/mollifier/items/40d57e1da1b325903659


# # プロンプトカスタマイズ
# PROMPT='[%B%F{red}%n@%m%f%b:%F{green}%~%f]%F{cyan}$vcs_info_msg_0_%f%F{yellow}$%f '

# 色の名前	数字
# black	0
# red	1
# green	2
# yellow	3
# blue	4
# magenta	5
# cyan	6
# white	7


# backgroundカラー
# 16171e

# ---------------------------

# .zshrcを晒す(2019年版)
# https://qiita.com/reireias/items/60ee9934fb1f5d94f125

# https://qiita.com/iwaseasahi/items/a2b00b65ebd06785b443

# https://awesomecatsis.com/iterm2-oh-my-zsh/

# https://qiita.com/shionit/items/31bfffa5057e66e46450

# https://qiita.com/syui/items/ed2d36698a5cc314557d


# https://zenn.dev/sprout2000/articles/bd1fac2f3f83bc

# https://takake-blog.com/zsh-setting/


# https://gist.github.com/atakig/1555225/ede34a0fc6b44b4d8416d8917b9d90d908346e19

# ---------------------------

# zsh-syntax-highlightingの設定

# https://qiita.com/don-bu-rakko/items/027fdc3852fbb9cd10da

# https://suin.io/564

# brew install zsh-syntax-highlighting
# インストール後は、.zshrcに一行足します。

# source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# sudo find / -name zsh-syntax-highlighting.zsh

# /usr/local/Cellar/zsh-syntax-highlighting/0.7.1/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh



# https://qiita.com/KazIgu/items/6aa66560c4137ede25a1

# ZSH_HIGHLIGHT_STYLES[default]=none
# ZSH_HIGHLIGHT_STYLES[unknown-token]=fg=red,bold
# ZSH_HIGHLIGHT_STYLES[reserved-word]=fg=yellow

# ZSH_HIGHLIGHT_STYLES[alias]=fg=green
# ZSH_HIGHLIGHT_STYLES[builtin]=fg=green
# ZSH_HIGHLIGHT_STYLES[function]=fg=green
# ZSH_HIGHLIGHT_STYLES[command]=fg=green

# ZSH_HIGHLIGHT_STYLES[precommand]=fg=green,underline
# ZSH_HIGHLIGHT_STYLES[commandseparator]=none
# ZSH_HIGHLIGHT_STYLES[hashed-command]=fg=green

# ZSH_HIGHLIGHT_STYLES[path]=underline
# ZSH_HIGHLIGHT_STYLES[path_prefix]=underline
# ZSH_HIGHLIGHT_STYLES[path_approx]=fg=yellow,underline

# ZSH_HIGHLIGHT_STYLES[globbing]=fg=blue
# ZSH_HIGHLIGHT_STYLES[history-expansion]=fg=blue

# ZSH_HIGHLIGHT_STYLES[single-hyphen-option]=none
# ZSH_HIGHLIGHT_STYLES[double-hyphen-option]=none

# ZSH_HIGHLIGHT_STYLES[back-quoted-argument]=none

# ZSH_HIGHLIGHT_STYLES[single-quoted-argument]=fg=yellow
# ZSH_HIGHLIGHT_STYLES[double-quoted-argument]=fg=yellow

# ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]=fg=cyan
# ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]=fg=cyan

# ZSH_HIGHLIGHT_STYLES[assign]=none


# ---------------------------

# zsh-autosuggestionsの設定

# https://qiita.com/shionit/items/31bfffa5057e66e46450

# brew install zsh-autosuggestions
# source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh


# ---------------------------

# lsコマンド実行時のディレクトリの色の設定

# https://yuk.hatenablog.com/entry/2014/09/23/072648

# https://qiita.com/nishina555/items/c3cdab6d059ee494c66e

# https://kojinjigyou.org/20342/


# alias ll='ls -lGF'
# alias ls='ls -GF'
# この設定のそれぞれの意味は以下の通りです。

# alias：入力コマンド='実際に実行するコマンド'
# -G：lsの結果を色付き表示にする。
# -F：ファイル名の後にタイプ識別子（*/@など）を付けて表示する。


# export LSCOLORS=cxfxcxdxbxegedabagacad

# LSCOLORSのデフォルトはexfxcxdxbxegedabagacad

# LSCOLORS=gxfxcxdxbxegedabagacad

# ---------------------------

#  lsコマンドとzsh補完候補の色をそろえる

# https://gist.github.com/atakig/1555225/ede34a0fc6b44b4d8416d8917b9d90d908346e19

# #色の設定
# export CLICOLOR=1
# export LSCOLORS=gxfxcxdxbxegedabagacad
# export LS_COLORS='di=36:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
# zstyle ':completion:*' list-colors 'di=36' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'

# ---------------------------

# https://gist.github.com/mmasaki/9523518

# https://www-tap.scphys.kyoto-u.ac.jp/~shima/zsh.php

# .zshenv
# # $LS_COLORS
# if [ "$LS_COLORS" -a -f /etc/DIR_COLORS ]; then
#   eval $(dircolors /etc/DIR_COLORS)
# fi

# .zshrc
# autoload -U compinit
# compinit
# zstyle ':completion:*' list-colors "${LS_COLORS}" # 補完候補のカラー表示


# https://news.mynavi.jp/article/zsh-9/
# リスト5.1 lsコマンドとzsh補完候補の色をそろえる設定
# autoload -U compinit
# compinit

# export LSCOLORS=exfxcxdxbxegedabagacad
# export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'

# alias ls="ls -G"
# alias gls="gls --color"

# zstyle ':completion:*' list-colors 'di=34' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'



# http://neko-mac.blogspot.com/2015/03/mac_18.html

# LSCOLORS=exfxcxdxbxegedabagacad

# １組目	1,2	ディレクトリ	e,x	青,デフォ
# ２組目	3,4	シンボリックリンク	f,x	マジェンタ,デフォ
# ３組目	5,6	ソケット	c,x	緑,デフォ
# ４組目	7,8	パイプ	d,x	ブラウン
# ５組目	9,10	実行可能ファイル	b,x	赤,デフォ
# ６組目	11,12	ブロックデバイス	e,g	青,シアン
# ７組目	13,14	キャラクタデバイス	e,d	青,ブラウン
# ８組目	15,16	setuid付実行ファイル	a,b	黒,赤
# ９組目	17,18	setgid付実行ファイル	a,g	黒,シアン
# １０組目	19,20	書き込み可能ディレクトリstickybit付	a,c	黒,緑
# １１組目	21,22	書き込み可能ディレクトリstickybitなし	a,d	黒,ブラウン


# ---------------------------

# LS_COLORSを設定しよう
# https://qiita.com/yuyuchu3333/items/84fa4e051c3325098be3

# https://blog.ashija.net/2018/09/04/post-3883/


# LS_COLORSの各項目の意味
# https://qiita.com/aosho235/items/6e4737a1eca11c41da9b

# LS_COLORS | lsコマンドの結果に色を付ける
# https://tanakatarou.tech/675/

# https://www.gfd-dennou.org/arch/morikawa/memo/ls_colors.txt

# export LS_COLORS="di=36:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:s    g=30;46:tw=30;42:ow=30;43:"


# export LS_COLORS="
# di=36: //ディレクトリ=水色
# ln=35: // シンボリックリンク=紫
# so=32: // ソケット=緑
# pi=33: // パイプ=オレンジ
# ex=31: // 実行可能ファイル=赤
# bd=34;46: // block device driver=青,背景水色
# cd=34;43: // character device driver=青,背景オレンジ
# su=30;41: // =黒,背景赤
# sg=30;46: // =黒,水色
# tw=30;42: // =黒,緑
# ow=30;43: // =黒,オレンジ
# "

# 環境変数「LS_COLORS」を設定することで、自由に色を変更することができます

# export LS_COLORS="<ファイルタイプ>=<値>:<ファイルタイプ>=<値>"

# 「;」で一度に複数の効果を設定できます


# export LS_COLORS="<ファイルタイプ>=<値>;<値>;<値>:<ファイルタイプ>;<値>;<値>"


# ファイルタイプ	説明
# no	デフォルト
# fi	ファイル
# di	ディレクトリ
# ln	シンボリックリンク
# ex	実行可能ファイル
# ow	誰でも(other user)書き込み可能ディレクトリ
# *.<拡張子>	自由な拡張子に色づける（例：*.bmp=91）

# 	 fi     普通のファイル(file)
# 	 di     ディレクトリ(directory)
#  	 ln     シンボリックリンク(symbolic link)
#          pi     パイプ(pipe)
#          so     ソケット(socket)
#  	 bd     block device driver
# 	 cd     character device driver
#          or     orphaned syminks
#          ex     実行ファイル(実行権限がついたファイル)

#          *.tar  拡張子 tar  がついたファイル
# 		(つまり, ファイル名の末尾が tar のファイルのこと)


# 色の効果を設定します

# 値	効果
# 00	デフォルト
# 01	明るくする
# 04	下線を付ける
# 文字の色を設定します

# 値	文字色
# 30	黒
# 31	赤
# 32	緑
# 33	オレンジ
# 34	青
# 35	紫
# 36	水色
# 37	グレー
# 90	暗いグレー
# 91	明るい赤
# 92	明るい緑
# 93	黄色
# 94	明るい青
# 95	明るい紫
# 96	ターコイズ
# 97	白

# 背景色を設定します

# 値	背景色
# 40	黒
# 41	赤
# 42	緑
# 43	オレンジ
# 44	青
# 45	紫
# 46	水色
# 47	グレー
# 100	暗いグレー
# 101	明るい赤
# 102	明るい緑
# 103	黄色
# 104	明るい青
# 105	明るい紫
# 106	ターコイズ
# 107	白


# ※LSCOLORSとLS_COLORSの項目の順番は揃える必要がある

# ---------------------------

# dircolorsコマンドを使えるように


# https://qiita.com/y_310/items/101ef023124072b9c73f

# https://linuxcommand.net/dircolors/

# brew install coreutils
# export PATH="$(brew --prefix coreutils)/libexec/gnubin:$PATH"

# これで標準のlsがGNU lsに変わり、dircolorsコマンドもインストールされて使えるようになります。

# GNU ls オプション
# https://kazmax.zpp.jp/cmd/l/ls.1.html#ah_5


# # GNU ls
# alias ls='ls --color -F'
# alias ll='ls --color -alF'

# こうしないと色がつかない

# ---------------------------

# 【Mac】ターミナルの配色設定は「Solarized」がおしゃれで見やすくておすすめ
# https://reasonable-code.com/solarized/

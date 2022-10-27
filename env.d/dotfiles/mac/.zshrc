export PATH=$HOME/.nodebrew/current/bin:$PATH

export PATH="/usr/local/opt/openssl@1.1/bin:$PATH"

export PGDATA=/usr/local/var/postgres
export PATH="/usr/local/opt/mysql@5.7/bin:$PATH"

alias updatedb='sudo /usr/libexec/locate.updatedb'

export PATH="/usr/local/sbin:$PATH"


SSH_AGENT_FILE=$HOME/.ssh-agent
test -f $SSH_AGENT_FILE && source $SSH_AGENT_FILE
if ! ssh-add -l > /dev/null 2>&1; then
    ssh-agent > $SSH_AGENT_FILE
    source $SSH_AGENT_FILE
    ssh-add $HOME/.ssh/id_rsa_github # この位置にOpenSSHの秘密鍵があると仮定
fi

# anyenv
eval "$(anyenv init -)"

# yarn
export PATH="$HOME/.yarn/bin:$PATH"

if which ruby >/dev/null && which gem >/dev/null; then
    PATH="$(ruby -r rubygems -e 'puts Gem.user_dir')/bin:$PATH"
fi

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# php
# export PATH="/usr/local/opt/php@8.0/bin:$PATH"
# export PATH="/usr/local/opt/php@8.0/sbin:$PATH"
export PATH="/usr/local/opt/php@7.4/bin:$PATH"
export PATH="/usr/local/opt/php@7.4/sbin:$PATH"

# Laravel Sail Command Alias
alias sail='[ -f sail ] && bash sail || bash vendor/bin/sail'

# golang
export PATH="$GOROOT/bin:$PATH"
export PATH="$PATH:$GOPATH/bin"
# export GOENV_DISABLE_GOPATH=1

# alias
#ls
#alias ls='ls -GF'
#alias ll='ls -alGF'
# GNU ls
alias ls='ls --color -F'
alias ll='ls --color -alF'
# cd
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias cdw='cd ~/Desktop/workspace'
alias cdi='cd ~/IdeaProjects'
# popd
alias p='popd'
# history
alias hs='history'
# clear
alias cl='clear'
# exit
alias e='exit'
# quit
alias q='quit'
#exec
alias restart='exec $SHELL -l'
# Makefile関連
alias m='make'
# Docker関連
alias d='docker'
alias dp='docker ps'
alias dc='docker-compose'
alias dcp='docker-compose ps'
# Git関連
alias g='git'
# Heroku関連
alias h='heroku'
# Vagrant関連
alias vm='vagrant'
# CircleCI関連
alias ci='circleci'
alias cicv='circleci config validate'
alias cile='circleci local execute --job build'
# Terraform関連
alias tf='terraform'
alias te='tfenv'
# Yarn関連
alias y='yarn'
alias yw='yarn workspace'
# npm関連
alias n='npm'
alias nr='npm run'
# Composer関連
alias c='composer'
# Firebase関連
alias f='firebase'
# golang
alias gb='go build'
alias gr='go run'
alias gf='go fmt'
# NeoVim関連
alias v='nvim'
alias vi='nvim'
alias vim='nvim'
alias view='nvim -R'
alias vd='nvim -d'
# Tmux関連
alias t='tmux'
alias ide="source ~/.config/tmux/ide.sh"
alias tk='tmux kill-server'

# Globパターンの拡張
setopt extended_glob

# GNU ls
export PATH="$(brew --prefix coreutils)/libexec/gnubin:$PATH"

export CLICOLOR=1

# lsの色の設定
# デフォルト ブルー
#export LSCOLORS=exfxcxdxbxegedabagacad
# シアン
export LSCOLORS=gxfxcxdxbxegedabagacad
# グリーン
#export LSCOLORS=cxfxcxdxbxegedabagacad

export LS_COLORS="di=36:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43:"

# 以下iTerm2設定
# 環境変数
export LANG=ja_JP.UTF-8

# ヒストリの設定
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000

# 直前のコマンドの重複を削除
setopt hist_ignore_dups

# 同じコマンドをヒストリに残さない
setopt hist_ignore_all_dups

# 同時に起動したzshの間でヒストリを共有
setopt share_history

# 即座に履歴を保存する
setopt inc_append_history

# 補完機能を有効にする
autoload -Uz compinit
compinit -u
if [ -e /usr/local/share/zsh-completions ]; then
    fpath=(/usr/local/share/zsh-completions $fpath)
fi

# 補完で小文字でも大文字にマッチさせる
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# 補完候補を詰めて表示
setopt list_packed

# 補完候補一覧をカラー表示
autoload -Uz colors
colors
#autoload colors
#デフォルト
#zstyle ':completion:*' list-colors ''
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# コマンドのスペルを訂正
setopt correct
# ビープ音を鳴らさない
setopt no_beep

# ディレクトリスタック
DIRSTACKSIZE=100
setopt AUTO_PUSHD

# スタック内で重複がある場合は削除
setopt pushd_ignore_dups

# 一致するディレクトリにcdなしで移動できる
setopt auto_cd

# glod表現使用許可
# https://www.wwwmaplesyrup-cs6.work/entry/2020/08/08/030240
setopt +o nomatch

# git
autoload -Uz vcs_info
setopt prompt_subst
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr "%F{magenta}!"
zstyle ':vcs_info:git:*' unstagedstr "%F{yellow}+"
zstyle ':vcs_info:*' formats "%F{cyan}%c%u[%b]%f"
zstyle ':vcs_info:*' actionformats '[%b|%a]'
precmd () { vcs_info }

# プロンプトカスタマイズ
PROMPT='
[%B%F{red}%n@%m%f%b:%F{green}%~%f]%F{cyan}$vcs_info_msg_0_%f
%F{yellow}$%f '

# zsh-syntax-highlightingの設定
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]=fg=white
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]=fg=white
ZSH_HIGHLIGHT_STYLES[unknown-token]=fg=magenta,bold
ZSH_HIGHLIGHT_STYLES[alias]=fg=cyan
ZSH_HIGHLIGHT_STYLES[builtin]=fg=cyan
ZSH_HIGHLIGHT_STYLES[function]=fg=cyan
ZSH_HIGHLIGHT_STYLES[command]=fg=cyan

# zsh-autosuggestionsの設定
source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/kazuaki/opt/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/kazuaki/opt/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/kazuaki/opt/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/kazuaki/opt/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

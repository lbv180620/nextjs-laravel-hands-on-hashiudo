# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  zsh-syntax-highlighting 
  zsh-autosuggestions
  z
  web-search
  python
  fzf
  extract
  history
)

source $ZSH/oh-my-zsh.sh

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
alias zshconfig="vim ~/.zshrc"
alias ohmyzsh="vim ~/.oh-my-zsh"



##### My Cutstomize ####
# You may need to manually set your language environment
# export LC_CTYPE=UTF-8
# export LANGUAGE =
# export LC_ALL=ja_JP.UTF-8
export LANG=ja_JP.UTF-8

# plugins=(… zsh-completions)
# autoload -U compinit && compinit

# genie
# Are we in the bottle?
if [[ ! -v INSIDE_GENIE ]]; then
  read -t 3 -p "yn? * Preparing to enter genie bottle (in 3s); abort? " yn
  echo

  if [[ $yn != "y" ]]; then
    echo "Starting genie:"
    exec /usr/bin/genie -s
  fi
fi

# GitHubにSSH接続
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa_github

# Linux Brewのパス
export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
# anyenvのパス
eval "$(anyenv init -)"
# yarnのパス
export PATH="$HOME/.yarn/bin:$PATH"
# codeコマンドのパス
# Visual Studio Code
export PATH="/mnt/c/Users/k_yoshikawa/AppData/Local/Programs/Microsoft VS Code/bin:$PATH"

# Docker Content Trust（DCT）を有効
export DOCKER_CONTENT_TRUST=1
# X11アプリケーション
export DISPLAY=172.30.208.1:0.0


#### alias ####
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
# shortcut
alias cdc='cd /mnt/c'
alias cdh='cd /mnt/c/Users/k_yoshikawa'
alias cdi='cd /mnt/c/Users/k_yoshikawa/IdeaProjects'
alias cdw='cd /mnt/c/Users/k_yoshikawa/IdeaProjects/workspace'
alias cdx='cd /mnt/c/xampp'
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
# exec
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
# Terraform関連
alias tf='terraform'
alias te='tfenv'
# Yarn関連
alias y='yarn'
alias yw='yarn workspace'
# Firebase関連
alias f='firebase'
# Python関連
alias python='python3'
alias py='python3'
alias pip='pip3'
# Golang関連
alias gb="go build"
alias gr="go run"
alias gf="go fmt"
# Vim関連
alias v='nvim'
alias vi='nvim'
alias vim='nvim'
alias view='nvim -R'
# Tmux関連
alias t='tmux'
alias ide='source ~/.config/tmux/ide.sh'
alias tk='tmux kill-server'


# Globパターンの拡張
setopt extended_glob

# GNU ls
export PATH="$(brew --prefix coreutils)/libexec/gnubin:$PATH"

# 配色の設定
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
# export LANG=ja_JP.UTF-8

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

# 補完機能を有効にする(zshのみ)
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
# source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]=fg=white
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]=fg=white
ZSH_HIGHLIGHT_STYLES[unknown-token]=fg=magenta,bold
ZSH_HIGHLIGHT_STYLES[alias]=fg=cyan
ZSH_HIGHLIGHT_STYLES[builtin]=fg=cyan
ZSH_HIGHLIGHT_STYLES[function]=fg=cyan
ZSH_HIGHLIGHT_STYLES[command]=fg=cyan

# zsh-autosuggestionsの設定
# source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# WSL2上のdocker-composeの認証エラー対策
export PATH="$PATH:/mnt/c/Program Files/Docker/Docker/resources/bin:/mnt/c/ProgramData/DockerDesktop/version-bin"

# docker.credentials.errors.StoreError: Credentials store docker-credential-desktop.exe exited with "".対策
FILE="$HOME/.docker/config.json"
if [ -e $FILE ];then
    rm $FILE
fi

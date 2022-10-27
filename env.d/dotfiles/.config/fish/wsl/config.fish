#* default

set fish_greeting ""

set -gx TERM xterm-256color

# theme
set -g theme_color_scheme terminal-dark
set -g fish_prompt_pwd_dir_length 1
set -g theme_display_user yes
set -g theme_hide_hostname no
set -g theme_hostname always

set -gx EDITOR nvim

set -gx PATH bin $PATH
set -gx PATH ~/bin $PATH
set -gx PATH ~/.local/bin $PATH

# NodeJS
set -gx PATH node_modules/.bin $PATH

# Go
set -g GOPATH $HOME/go
set -gx PATH $GOPATH/bin $PATH

# NVM
function __check_rvm --on-variable PWD --description 'Do nvm stuff'
  status --is-command-substitution; and return

  if test -f .nvmrc; and test -r .nvmrc;
    nvm use
  else
  end
end

switch (uname)
  case Darwin
    source (dirname (status --current-filename))/config-osx.fish
  case Linux
    source (dirname (status --current-filename))/config-linux.fish
  case '*'
    source (dirname (status --current-filename))/config-windows.fish
end

set LOCAL_CONFIG (dirname (status --current-filename))/config-local.fish
if test -f $LOCAL_CONFIG
  source $LOCAL_CONFIG
end


# -----------------

#* aliases

#ls
alias ls "ls -p -G"
alias la "ls -A"
alias ll "ls -l"
alias lla "ll -A"
#alias ls "ls -GF"
#alias ll "ls -alGF"
# GNU ls
# alias ls "ls --color -F"
# alias ll "ls --color -alF"
# exa
alias ee "exa -l"
alias eea "ee -a"
# cd
# alias .. "cd .."
# alias ... "cd ../.."
# alias .... "cd ../../.."
# alias ..... "cd ../../../.."
# alias ...... "cd ../../../../.."
alias cdw "cd ~/Desktop/workspace"
alias cdi "cd ~/IdeaProjects"
# clear
alias cl clear
# exec
alias restart "exec $SHELL -l"
# Makefile関連
alias m "make"
# Docker関連
alias d docker
alias dp "docker ps"
alias dc docker-compose
alias dcp "docker-compose ps"
# Git関連
alias g git
# Heroku関連
alias h heroku
# Vagrant関連
alias vm vagrant
# CircleCI関連
alias ci circleci
alias cicv "circleci config validate"
alias cile "circleci local execute --job build"
# Terraform関連
alias t terraform
alias tf tfenv
# Yarn関連
alias y yarn
alias yw "yarn workspace"
# npm関連
alias n npm
alias nr "npm run"
# Composer関連
alias c composer
# Firebase関連
alias f firebase
# golang
alias gb "go build"
alias gr "go run"
alias gf "go fmt"
# NeoVim関連
# alias vi nvim
# alias vim nvim
alias view "nvim -R" && alias vw "nvim -R"
alias vd "nvim -d"
command -qv nvim && \
  alias vim nvim && \
  alias vi nvim && \
  alias v nvim
# Tmux関連
alias tm tmux  
# Laravel Sail Command Alias
alias sail "[ -f sail ] && bash sail || bash vendor/bin/sail"


# -----------------

#* paths

# yarn
set -x  PATH $HOME/.yarn/bin $PATH

# php
# set -x  PATH /usr/local/opt/php@8.0/bin $PATH
# set -x PATH /usr/local/opt/php@8.0/sbin $PATH
set -x PATH /usr/local/opt/php@7.4/bin $PATH
set -x PATH /usr/local/opt/php@7.4/sbin $PATH

# golang
set -x PATH $GOROOT/bin $PATH
set -x PATH $PATH $GOPATH/bin
# set -x GOENV_DISABLE_GOPATH 1

# Linux Brewのパス
set -x PATH /home/linuxbrew/.linuxbrew/bin $PATH

# codeコマンドのパス
# Visual Studio Code
set -x PATH /mnt/c/Users/k_yoshikawa/AppData/Local/Programs/Microsoft VS Code/bin $PATH

# Docker Content Trust（DCT）を有効
set -x DOCKER_CONTENT_TRUST 1

# X11アプリケーション
set -x DISPLAY 172.30.208.1:0.0


# -----------------

# ssh-agent
set SSH_AGENT_FILE "$HOME/.ssh_agent"
test -f $SSH_AGENT_FILE; and source $SSH_AGENT_FILE
if not ssh-add -l > /dev/null 2>&1
  ssh-agent -c > $SSH_AGENT_FILE
  source $SSH_AGENT_FILE
  ssh-add $HOME/.ssh/id_rsa_github
end

# anyenv
# eval (anyenv init - | source)

# genie
# Are we in the bottle?
# if [[ ! -v INSIDE_GENIE ]]; then
#  read -t 3 -p "yn? * Preparing to enter genie bottle (in 3s); abort? " yn
#  echo

#  if [[ $yn != "y" ]]; then
#    echo "Starting genie:"
#    exec /usr/bin/genie -s
#  fi
#fi

# GitHubにSSH接続
# eval "$(ssh-agent -s)"
# ssh-add ~/.ssh/id_rsa_github


# -----------------

# その他

# export PATH=$HOME/.nodebrew/current/bin:$PATH

# export PATH="/usr/local/opt/openssl@1.1/bin:$PATH"

# export PGDATA=/usr/local/var/postgres
# export PATH="/usr/local/opt/mysql@5.7/bin:$PATH"

# alias updatedb='sudo /usr/libexec/locate.updatedb'

# export PATH="/usr/local/sbin:$PATH"


# if which ruby >/dev/null && which gem >/dev/null; then
#     PATH="$(ruby -r rubygems -e 'puts Gem.user_dir')/bin:$PATH"
# fi

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
# export SDKMAN_DIR="$HOME/.sdkman"
# [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

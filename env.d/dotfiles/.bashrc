# プロンプトの設定
# Git
source /home/linuxbrew/.linuxbrew/Cellar/git/2.33.0_1/etc/bash_completion.d/git-prom    pt.sh source /home/linuxbrew/.linuxbrew/Cellar/git/2.33.0_1/share/zsh/site-functions/git-c    ompletion.bash
GIT_PS1_SHOWDIRTYSTATE=true
export PS1='\[\033[32m\]\u@\h\[\033[00m\]:\[\033[34m\]\w\[\033[31m\]$(__git_ps1)\[\0    33[00m\]\n\$ '
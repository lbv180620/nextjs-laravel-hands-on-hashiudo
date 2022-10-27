#todo WSL2 + zsh 環境構築

# 1. WSLを有効化し、WSL2に変更

# WSLの有効化
# https://www.aise.ics.saitama-u.ac.jp/~gotoh/HowToEnableWSL.html

# Windows 10におけるWSL2を用いたUbuntu環境の構築
# https://www.aise.ics.saitama-u.ac.jp/~gotoh/UbuntuOnWSL2.html


# WSL1からWSL2への移行
# https://www.aise.ics.saitama-u.ac.jp/~gotoh/WSL1ToWSL2.html


# Windows10+Dockerでの開発環境をWSL2化
# https://zenn.dev/hrs/articles/windows10-docker-wsl2
# ーーーーー

# Windows＋WSL2でDocker環境を用意しよう
# https://www.kagoya.jp/howto/cloud/container/wsl2_docker/


# docker.credentials.errors.StoreError: Credentials store docker-credential-desktop.exe exited with "".
# → buildできない！
# https://roy-n-roy.nyan-co.page/Windows/WSL%EF%BC%86%E3%82%B3%E3%83%B3%E3%83%86%E3%83%8A/DockerDesktopError/

# echo 'export PATH="$PATH:/mnt/c/Program Files/Docker/Docker/resources/bin:/mnt/c/ProgramData/DockerDesktop/version-bin"' >> ~/.zshrc

# tail ~/.zshrc


# Error: unknown command "/usr/bin/docker-credential-desktop.exe" for "docker-credential-desktop"

# https://www.codegrepper.com/code-examples/shell/docker.credentials.errors.StoreError%3A+Credentials+store+docker-credential-desktop.exe+exited+with+%22%22

# sudo  ln -s /mnt/c/Program\ Files/Docker/Docker/resources/bin/docker-credential-desktop.exe /usr/bin/docker-credential-desktop.exe

# -------------------------

# docker.credentials.errors.StoreError: Credentials store docker-credential-desktop.exe exited with "".


# docker-credential-desktop.exe not installed or not available in PATH
# https://sunday-morning.app/posts/2020-07-28-docker-credential-desktop-exe-not-installed-or-not-available-in-path

# https://github.com/docker/for-win/issues/12355

# docker-composeでdocker.credentials.errors.StoreError
# https://www.ninton.co.jp/archives/5526

# rm ~/.docker/config.json

# -------------------------

# ubuntuのdockerコンテナをdocker desktopにひょうじさせる
# https://zenn.dev/kathmandu/articles/4a86c3d75b93c3

# ========================

# 2. Ubuntu20.04のインストールとセットアップ

# ＊注意：必ずWSL2に変更してから、ディストリビューションをインストールすること。


# ========================

# 3. zshに変更

# Zsh on Ubuntu on Windows
# https://qiita.com/mu_tomoya/items/4c9cf14a48af27907f86

# sudo apt update && sudo apt upgrade -y

# sudo apt install zsh -y


# curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh


# git clone https://github.com/zsh-users/zsh-completions ~/.oh-my-zsh/custom/plugins/zsh-completions

# vi ~/.zshrc
# plugins=(… zsh-completions)
# autoload -U compinit && compinit

# which zsh
# chsh

# Password:
# Changing the login shell for <username>
# Enter the new value, or press ENTER for the default
#         Login Shell [/bin/bash]: /usr/bin/zsh

# 再起動

# -------------------------

# WSL2でWeb開発環境の構築メモ (zsh, node, dockerなど)
# https://zenn.dev/moroya/articles/0ab24a733e4b7a


# ========================

# 4. .zshrcの編集

# Zsh
# https://wiki.archlinux.jp/index.php/Zsh

# 【ロードマップ】zshで超快適にLinuxコマンド【0から解説】
# https://suwaru.tokyo/%e3%80%90%e3%83%ad%e3%83%bc%e3%83%89%e3%83%9e%e3%83%83%e3%83%97%e3%80%91zsh%e3%81%a7%e8%b6%85%e5%bf%ab%e9%81%a9%e3%81%ablinux%e3%82%b3%e3%83%9e%e3%83%b3%e3%83%89%e3%80%900%e3%81%8b%e3%82%89%e8%a7%a3/#anc_4

# vi ~/.zshrc
# 自分のテンプレの貼り付け

# alias cdk='cd /mnt/c/Users/k_yoshikawa'
# alias cdx='cd /mnt/c/xampp'

# # GitHubにSSH接続
# eval "$(ssh-agent -s)"
# ssh-add ~/.ssh/id_rsa_github

# 再起動

# -------------------------

# 文字化けの解消:

# Ubuntu, Zsh環境で文字化け問題に遭遇したときの対処方法
# https://zenn.dev/tkngue/articles/6cf20367245b44d25607

# sudo ln -sf /etc/profile /etc/zsh/zprofile


# -------------------------

# zsh-syntax-highlighting

# Zshメモ : zsh-syntax-highlightingでコマンドに色付け
# https://wonderwall.hatenablog.com/entry/2016/06/25/205033

# ★zsh-syntax-highlighting が使用できない場合
# https://qiita.com/don-bu-rakko/items/027fdc3852fbb9cd10da


# zsh-users/zsh-syntax-highlighting
# https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/INSTALL.md

# git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# .zshrc
# plugins=(git zsh-syntax-highlighting)


# -------------------------

# zsh-autosuggestions

# zsh-users/zsh-autosuggestions
# https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md


# お願いだから zsh ユーザーは zsh-autosuggestions 入れて
# https://zenn.dev/luvmini511/articles/8d427e1faa089f


# git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# plugins=(
#     # other plugins...
#     zsh-autosuggestions
# )

# ========================

# 5. genieの設定

# この記事に従う。

# WSL2のUbuntuにリモートデスクトップ接続する。（その１：genieインストール）
# https://qiita.com/sakai00kou/items/0b401faf6dd72ad63d87


# sudo apt update && sudo apt upgrade -y
# sudo apt install daemonize -y

# wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb

# sudo dpkg -i packages-microsoft-prod.deb

# rm packages-microsoft-prod.deb


# sudo apt-get update; \
#   sudo apt-get install -y apt-transport-https && \
#   sudo apt-get update && \
#   sudo apt-get install -y dotnet-sdk-5.0


# sudo apt-get update; \
#   sudo apt-get install -y apt-transport-https && \
#   sudo apt-get update && \
#   sudo apt-get install -y aspnetcore-runtime-5.0



# sudo wget -O /etc/apt/trusted.gpg.d/wsl-transdebian.gpg https://arkane-systems.github.io/wsl-transdebian/apt/wsl-transdebian.gpg

# sudo chmod a+r /etc/apt/trusted.gpg.d/wsl-transdebian.gpg

# sudo tee /etc/apt/sources.list.d/wsl-transdebian.list << EOF > /dev/null
# deb https://arkane-systems.github.io/wsl-transdebian/apt/ $(lsb_release -cs) main
# deb-src https://arkane-systems.github.io/wsl-transdebian/apt/ $(lsb_release -cs) main
# EOF

# sudo apt update -y


# sudo apt install -y systemd-genie


# sudo rm /etc/systemd/system/multipath-tools.service
# sudo rm /etc/systemd/system/sysinit.target.wants/multipathd.service
# sudo rm /etc/systemd/system/sockets.target.wants/multipathd.socket


# sudo ssh-keygen -A

# sudo e2label $(df / | awk '/\//{print $1}') cloudimg-rootfs


# sudo tee /etc/rc.local << _EOF_ > /dev/null
# #!/bin/bash
# ls /proc/sys/fs/binfmt_misc > /dev/null 2>&1 || mount -t binfmt_misc binfmt_misc /proc/sys/fs/binfmt_misc
# exit 0
# _EOF_

# sudo chmod +x /etc/rc.local



# cat << _EOF_ >> ~/.zshrc

# # Are we in the bottle?
# if [[ ! -v INSIDE_GENIE ]]; then
#   read -t 3 -p "yn? * Preparing to enter genie bottle (in 3s); abort? " yn
#   echo

#   if [[ \$yn != "y" ]]; then
#     echo "Starting genie:"
#     exec /usr/bin/genie -s
#   fi
# fi
# _EOF_


# genie -s


# ========================

# 6. Ubutntuの設定

# python aws lampは入れなくていい。

# ＊注意：。.zshrcに気を付ける

# -------------------------

# apt updateできなくなったら、wsl --shutdown


# -------------------------

# WSL2から見たWindows側フォルダの所有者がおかしいときは
# https://astherier.com/blog/2020/08/wsl2-wrong-directory-ownership/

# sudo chown k_yoshikawa:k_yoshikawa -R .
# wsl -t Ubuntu-20.04

# -------------------------

# localeの変更:

# sudo apt install language-pack-ja -y
# sudo update-locale LANG=ja_JP.UTF8


# Ubuntu 20.04: デフォルトのロケールを英語に変更する
# https://www.kwonline.org/memo2/2020/09/23/ubuntu-20_04_update-locale/

# $ sudo update-locale LANG=en_US.UTF-8
# # 一度ログアウト
# # またはこっちの書き方も可
# $ sudo localectl set-locale LANG=en_US.UTF-8


# UbuntuでBashログイン後に「warning: setlocale: LC_ALL: cannot change locale (ja_JP.UTF-8)」が表示された場合の対処
# https://genzouw.com/entry/2013/06/04/223158/36/

#  sudo apt-get install language-pack-ja


# ========================

# 7. VSCodeの設定

# Linux 用 Windows サブシステムで Visual Studio Code の使用を開始する
# https://docs.microsoft.com/ja-jp/windows/wsl/tutorials/wsl-vscode

# WSL2からVSCodeが起動しない場合の対処方法　（Command ‘code’ not found, but can be installed with: sudo snap install code）
# https://snowsystem.net/other/windows/vscode-wsl-run-error/

# https://stackoverflow.com/questions/29955500/code-is-not-working-in-on-the-command-line-for-visual-studio-code-on-os-x-ma

# .bashrc
# export PATH=$PATH:'/mnt/c/Users/[ユーザ名]/AppData/Local/Programs/Microsoft VS Code/bin'

# code .

# →開けないから、'/mnt/c/Users/[ユーザ名]でローカルとリモートが繋がっていることを利用して、Phellから開く。


# VSCodeのターミナルを変更：
# C:\WINDOWS\System32\cmd.exe
# ↓
# C:\Users\k_yoshikawa\AppData\Local\Microsoft\WindowsApps\Microsoft.WindowsTerminal_8wekyb3d8bbwe\wt.exe


# ========================

# WSL + Dockerの問題点：

# ⑴ 仮想環境上にdockerを起動させるので、どうしてもローカルとパーミッションが揃わないので、それを調整する必要がある。

# ⑵ volumeコンテナを以下のように設定すると、dbコンテナがExit 1を引き越して落ちてしまう。

# volumes:
#   db-store:
#     # driver: local
#     # driver_opts:
#     #   type: none
#     #   device: $PWD/infra/data
#     #   o: bind

# ⇩

# volumes:
#   db-store:

# ⑶ コンテナ内でユーザーを追加する場合は、先にグループを追加する必要がある。

# ========================

# Windows支配下の/mnt/c下に公開鍵, 秘密鍵を作ってしまうとpushできない問題

# → WSL支配下の/home下で作った.sshのシンボリックリンクを貼る


# /mnt/c/Users/k_yoshikawa/.ssh
# に秘密鍵を作ると以下のエラーが出る。

# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# @         WARNING: UNPROTECTED PRIVATE KEY FILE!          @
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# Permissions 0777 for '/mnt/c/Users/k_yoshikawa/.ssh/id_rsa_github' are too open.
# It is required that your private key files are NOT accessible by others.
# This private key will be ignored.

# 解決策：

# [WSL] Windows支配下に公開鍵, 秘密鍵を作ってしまうとpermissionを変更できない！
# https://qiita.com/roadricefield/items/70ccc1416fe6f3d979a2

# cd /mnt/c/Users/k_yoshikawa
# ln -s /home/k_yoshikawa/.ssh .


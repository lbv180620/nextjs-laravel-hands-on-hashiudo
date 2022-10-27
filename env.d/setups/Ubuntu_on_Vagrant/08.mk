#todo 8.  Docker 環境構築

# curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"

# sudo apt update && sudo apt install -y docker-ce

# sudo systemctl start docker

# --------------

# sudo curl -L https://github.com/docker/compose/releases/download/1.26.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose

# sudo chmod +x /usr/local/bin/docker-compose

# --------------

# # sudo無しでdockerが使えるように

# sudo gpasswd -a $USER docker

# sudo chgrp docker /var/run/docker.sock

# sudo systemctl restart docker

# exit

# --------------

# docoker(rootless)のインストール

# https://www.ukkari-san.net/ubuntu-20-04%E3%81%A7docker-rootless%E3%83%A2%E3%83%BC%E3%83%89%E3%82%92%E8%B5%B7%E5%8B%95%E3%81%99%E3%82%8B/

# https://qiita.com/74th/items/09eeaebb0f38650a36dd

# $ sudo apt update
# $ sudo apt-get install -y uidmap

# sudo systemctl stop docker
# sudo systemctl stop docker.socket
# sudo systemctl disable docker
# sudo systemctl disable docker.socket

# export FORCE_ROOTLESS_INSTALL=1
# curl -fsSL https://get.docker.com/rootless | sh


# sudo vim ~/.bashrc
# export PATH=/home/vagrant/bin:$PATH
# export DOCKER_HOST=unix:///run/user/1000/docker.sock

# $ source ~/.bashrc

# $ systemctl --user start docker

# systemctl disable --user docker


# --------------

# Docker Content Trust（DCT）を有効にする

# ~/.bashrc や ~/.zshrc に追記する。

# ~/.bashrc
# export DOCKER_CONTENT_TRUST=1


# DCTは、Dockerイメージを「なりすまし」と「改ざん」から保護するセキュリティ機能です。

# Docker イメージへ発行者のデジタル署名を付ける
# イメージの利用時(pull など)に「発行者」と「イメージが改ざんされていないこと」を検証する
# push, build, create, pull, run のコマンド実行時に自動で機能します。

#todo 9.  X Window System 環境構築

# Mac + Vagrant
# ①XQuartz(X11)のインストール(ホスト側)
# brew install -cask xquartz

# ②VagrantFileの編集(最小限)
# Vagrant.configure(2) do |config|
# #略
#   config.vm.box = "bento/ubuntu-20.04"
#   config.ssh.forward_x11 = true
#   config.vm.network "private_network", ip: "192.168.33.10"
# #略
# end

# ③ sudo apt install -y x11-apps xauth

# ④sshdの設定
# Ubuntsなどのリモートサーバ側のsshdの設定を行います。

# 以下のように設定しsshdを再起動しておきます。

# vagrant ssh
# sudo vim /etc/ssh/sshd_config

# X11Forwarding yes

# X11DisplayOffset 10
# -> DISPLAY = vagrant:10.0

# X11UseLocalhost no
# -> DISPLAY = localhost0.0

# sudo systemctl restart sshd

# ⑤exit -> vagrant halt -> vagrant up -> vagrant ssh

# ⑥ xeyes

# --------------------

# sudo apt install -y xclip

# sudo vim ~/.bash_aliases

# alias pbcopy='xclip -selection c'
# alias pbpaste='xclip -selection c -o'

# source ~/.bash_aliases

# ------------------------

# exit

# vagrant ssh-config --host 192.168.33.22 >> ~/.ssh/config

# ssh 192.168.33.22


# =========================

# WSLの場合

# Windows10のWSLでX11アプリケーションを実行してみた
# https://dev.classmethod.jp/articles/wsl-x-window/

# WSL2側からWindows側のIPアドレスを調べる方法
# https://qiita.com/samunohito/items/019c1432161a950892be

# sudo apt install x11-apps -y

# ip route | grep 'default via' | grep -Eo '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}'

# export DISPLAY=172.30.208.1:0.0
# echo $DISPLAY

# xeyes

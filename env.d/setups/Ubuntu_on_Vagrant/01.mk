#todo 1. vagrant + VirtualBox + Ubuntu20.04 環境構築

# mkdir ubuntu220811_workspace

# cd ubuntu220811_workspace

# vagrant init bento/ubuntu-20.04

# sudo vim Vagrantfile
# config.vm.network "private_network", ip: "192.168.33.22"

# vagrant up --provider virtualbox

# vagrant ssh

# sudo apt update && sudo apt upgrade -y

# sudo apt-get install -y linux-headers-generic

# sudo apt-get install -y gcc make perl

# exit

# vagrant reload

# vagrant plugin install vagrant-vbguest

# vagrant halt
# vagrant up

# sudo vim Vagrantfile
# if Vagrant.has_plugin?("vagrant-vbguest")
#       config.vbguest.auto_update = false
#       config.vbguest.no_remote = true
#  end

# ----------------------

# エラー：

# vagrant box update

# GuestAdditions are newer than your host but, downgrades are disabled. Skipping.
# 　
# vagrant vbguest --do install

# An error occurred during installation of VirtualBox Guest Additions 6.1.22. Some functionality may not work as intended.
# In most cases it is OK that the "Window System drivers" installation failed.

# vagrant reload

# vagrant vbguest --status

# ----------------------

# #削除
# https://maku77.github.io/vagrant/destroy-vm.html

# https://qiita.com/DQNEO/items/5ee05ce7afb8fc9c6656

# vagrant global-status

# vagrant destroy ID

# rm -r .vagrant && sudo rm Vagrantfile

# 作り直し：
# vagrant halt && vagrant destroy -f && vagrant up
# vagrant vbguest --do install

#todo 10.  Gitの設定

# Gitの設定をgit configで確認・変更
# https://note.nkmk.me/git-config-setting/

# 一覧
# g config --global -l

# ----------------

# git config --global user.name "kazuaki_ubuntu220811"
# git config --global user.email "0chlbv7420t18063263g7t20@gmail.com"

# ----------------

# git config --global core.editor 'vim -c "set fenc=utf-8"'

# git config --global color.diff auto
# git config --global color.status auto
# git config --global color.branch auto

# git config --global push.default simple
# git config --global --unset push.default

# git config --global core.quotepath false

# [追加]
# git config --global merge.ff false
# →マージの際にファストフォワードが起こらないようにする

# git config --global pull.rebase true
# →pullの時に常にrebaseする


# [エイリアス]

# git config --global alias.c commit
# git config --global alias.st status
# git config --global alias.br branch
# git config --global alias.co checkout
# git config --global alias.sw switch


# [トークン作成]

# トークンの作成
# settings->Developer setings->Personal access tokens
# generate new token
# Note: admin
# Expiration 90days
# Select scopes: 全部

# Generate token

# 生成されたトークンはメモ
# pushする度にこれを使う。これが無いとpushできない。
# 無くしたら再度生成し直す。

# GitHubにpush際にGitHubのユーザ名とパーソナルアクセストークンの二つを使って、この人は本当にGitHubのアカウントの持ち主だよって言う認証を行う。これがパスワードの代わりになる。
# GitHubにpushするときには、ユーザ名とこのトークンを使う。



# ---------------

#^ 無視していい：
#  mkdir -p ~/.config/git
# echo '.DS_Store' >> ~/.config/git/ignore

# ---------------

# cat <<EOF > ~/.gitignore_global
# .DS_Store
# EOF

# git config --global core.excludesFile ~/.gitignore_global

# ---------------

# cd ~/.ssh

# ssh-keygen -t rsa -b 4096 -C "$(git config user.email)"
# /home/vagrant/.ssh/id_rsa_github
# lbv180620

# C:\Users\k_yoshikawa/.ssh/id_rsa_github
# /home/k_yoshikawa/.ssh/id_rsa_github

# pbcopy ~/.ssh/id_rsa_github.pub

# https://github.com/settings/keysで貼り付け
# Kazuaki_ubuntu220811_id_rsa_github

# ---------------

# config設定
# vim ~/.ssh/config
# 下記を追記

# Host github github.com
#   HostName github.com
#   IdentityFile ~/.ssh/id_rsa_github
#   User git

# 権限を修正する
# sudo chmod 600 ~/.ssh/config

# ---------------

# 秘密鍵をssh-agentに登録する

# ### ssh-agentが動作しているか確認
# eval "$(ssh-agent -s)"

# Agent pid 32047
# # 動いていることが確認できました。

# $ ssh-add ~/.ssh/id_rsa_github
# Enter passphrase for /Users/ts/.ssh/id_rsa_github: # 鍵のpassword入力
# Identity added: /Users/ts/.ssh/id_rsa_github (/Users/ts/.ssh/id_rsa_github)

# ---------------

# [事後確認・作業]
# 接続確認をしてみる
# 下記のように出れば、接続はできています。


# ssh -T git@github.com
# # yes
# Hi mackerel7! You've successfully authenticated, but GitHub does not provide shell access

# ---------------

# エラー：

# https://qiita.com/aki4000/items/4c81bc2747bbd5e96d85
# https://qiita.com/yysskk/items/974c9c55d66a26515651

# Warning: Permanently added the RSA host key for IP address '52.192.72.89' to the list of known hosts.

# ssh-add -l

# ssh-add ~/.ssh/id_rsa_github

# ---------------

# vim cdjaval

# #!/bin/bash
# DIR=learning/Java_learning
# select i in 1 2 3
# do
# case $i in
# 1) cd "${DIR}/スッキリわかるJava入門"; break;;
# 2) cd "${DIR}/スッキリわかるJava入門実践編"; break;;
# 3) cd "${DIR}/スッキリわかるサーブレット&JSP入門"; break;;
# esac
#  done


# ---------------

# bashでgitのブランチ名を表示

# https://qiita.com/kuniatsu/items/e2de0d37cdb63b77fbd4


# sudo find / -name git-prompt.sh
# sudo find / -name git-completion.bash


# ・ターミナルのプロンプトにgitのブランチ名を常に表示させる（git-prompt）
# ・gitコマンドをTab補完できるようにする（git-completion）



# ================================

# WSL SSH接続

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

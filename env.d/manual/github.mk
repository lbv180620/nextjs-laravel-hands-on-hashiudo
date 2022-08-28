#todo [Git & GitHub Tips ①]

# git msg=save
git:
	git add .
	git commit -m $(msg)
	git push origin $(br)
g:
	@make git
git-msg:
	env | grep "msg"
git-%:
	git add .
	git commit -m $(@:git-%=%)
	git push origin


# --------------------

# ? Githubにアップされている画像の取り込み方法

# 1. 画像ファイルを開く
# 2. ダウンロードボタンをクリック
# 3. ダウンロード画面のURLをコピー
# 4. 適当なフォルダでwgetコマンドで取り込みむ
# 例) https://raw.githubusercontent.com/deatiger/ec-app-demo/develop/src/assets/img/src/no_image.png
# wget <URL>


# --------------------

# ? GitHubから特定の「ファイル」だけを直接ダウンロードする方法

# 記事
# https://tetsufuku-blog.com/github-download/

# wgetコマンド
# https://ex1.m-yabe.com/archives/2817
# https://mebee.info/2021/12/03/post-50090/
# https://orebibou.com/ja/home/201603/20160322_002/

# 方法①
# 対象のファイルをコピーして、用意したファイルに貼り付け

# 方法②
# 1. 対象のファイルを開く
# 2. Rawをクリック
# 3. URLをコピー
# 4. wget -O <ファイル名> <URL>
# ※ ファイル名にトークンが含まれるため、-Oで名前を修正

# 方法③
# GitHub → 対象のリポジトリのTopページ → 「.」をタイプし、VSCodeに切り替える → ダウンロードしたいファイルやディレクトリの上で、[右クリック] → [Download] を選択
# Finderの「ダウンロード」にダウンロードされるので、それをプロジェクトにドラッグ&ドロップ


# --------------------

# ? GitHubから特定の「ディレクトリ」だけを直接ダウンロードする方法

# 記事
# https://www.sukerou.com/2021/11/github.html

# 方法① zip
# GitHub → 対象のリポジトリのTopページ → Code → Download Zip でソース全体をダウンロード→ 必要なフォルダだけ取り出して使う
# ※ cloneしたソースはgitの管理下に置かれるが、zipでdownloadした場合は置かれない。


# 方法② web editor [推奨]
# GitHub → 対象のリポジトリのTopページ → 「.」をタイプし、VSCodeに切り替える → ダウンロードしたいファイルやディレクトリの上で、[右クリック] → [Download] を選択
# ※ ディレクトリをダウンロードする時は、保存先を選択するダイアログが表示される。
# ! ブラウザのセキュリティ制限から、ダウンロード先のフォルダは中身が空のフォルダである必要がある。


# --------------------

# ? 既にGitHubにpushしたファイルを後からgitignoreに含めたい時

# 記事
# https://qiita.com/YotaHamasaki/items/9f674f2a56381eb9888e

# 実行手順：
# ①「git rm --cached ファイル名」コマンドにて該当ファイルの削除。(ディレクトリ毎削除する場合は-rをつける。)
# ②.gitignoreファイルにプッシュしたくないファイル名を追記。
# ③再度git addからpushまでを実行する。

# ※①のコマンド入力時に「fatal: pathspec 'ファイル名' did not match any files」と表示される場合は、「git rm --cached --ignore-unmatch .」コマンドを入力してみてください。
# このエラーはgitの管理対象外のファイルが含まれていることが原因みたい。

# ※ gitignoreに追加したファイルやディレクトリは、マージするとディレクトリは残るがファイルは消えることに注意！


# --------------------

# ? [git rebase -i] コミットメッセージの修正と削除方法

# ◆ push前の修正

# 記事
# https://zenn.dev/sykn/articles/43368a38fa8052

# git commit --amend -m "変更したいメッセージ"

# git push -f

# git log --oneline


# .......................


# ◆ push後の修正

# 記事
# https://saikeblog.com/2019/04/20/%E9%81%8E%E5%8E%BB%E3%81%AB%E3%83%AA%E3%83%A2%E3%83%BC%E3%83%88%E3%81%B8push%E3%81%97%E3%81%9F%E3%82%B3%E3%83%9F%E3%83%83%E3%83%88%E3%81%AE%E3%82%B3%E3%83%A1%E3%83%B3%E3%83%88%E3%82%92%E5%A4%89/

# ✅ push済みの複数のコミットを修正する場合
# → ひとつならrevertでもいい

# ✅ 修正する前に、修正すると影響を受けるファイルを確認し、残したいファイルや影響受けて欲しく無いファイルは、一旦ステージング前に戻し、
# まとめてひとつのコミットにする。
# ※ git show <Commit ID> or git diff で中身を確認

# git rebase -i HEAD~<数字: 現在から修正したいコミットがいくつ前か指定>

# 例) git rebase -i HEAD~5
# → 現在から５つ前のコミットを修正したいので、HEAD~5と指定。
# HEAD~5と指定すると、5つ前までのコミットの歴史を見ることができます。

# pickをeまたはedit

# ※ 削除する場合は、dまたはdrop
# ※ 注意：コミットを削除すると、そのコミットで修正したファイルが削除される！→ 削除する前にコミットでどんな修正をしたかを確認する！

# git commit --amend

# 編集

# git rebase --continue
# → 編集するコミットが無くなるまで、再度git commit --amendする

# git push -f origin リポジトリ

# git log --oneline


# --------------------

# ? [git revert] push済みのコミットを取り消す

# git revert <commit ID>
# で、指定したcommit IDのコミットの変更点を無かったことにする。

# .......................

# コミットメッセージ編集:
# git revert <commit ID>
# = git revert <commit ID> -e
# or git revert <commit ID> --edit

# .......................

# コミットメッセージを編集しない:
# git revert <commit ID> --no-edit

# .......................

# コミットしない = indexに戻すだけでコミットを行なわない:
# ※revertコマンドを使用するとコミットまで行なわれる
# git revert <commit ID> -n
# or git revert <commit ID> --no-commit

# .......................

# マージコミット:
# git revert -m 1 <commit ID>

# マージコミットを取り消そうとした場合、マージした2つのコミット(親)のうちどちらに戻すのかを指定する必要があります。
# -mオプションの後に戻したい親を数字(基本的に1もしくは2)で指定し、revertを実行します。


# git showコマンドやgit logコマンドで対象のマージコミットを見ると、親の数字(1もしくは2)がわかります。

# $ git show
# commit xyz
# Merge: 1a1a1a 2b2b2b    #ここに注目
# Author: xxxx xxxx
# Date:   Thu Jul 13 09:00:00 2017 +0000

#     Merge commit

# revertしたいマージコミットが、この「xyz」という番号のコミットだとします。
# このマージコミットは、「1a1a1a」というコミットに「2b2b2b」というコミットがマージされてできたものです。

# 番号は、ログを表示させたときの、「Merge:」という行に書かれている順番に1、2とつきます。
# この場合は、「1a1a1a」の番号が1、「2b2b2b」の番号が2となります。


# --------------------

# ? [git reflog] コミットの復元 ブランチの復元

# 直前のコミットを消したい場合：

# git reset --hard HEAD^

# .......................

# ✅ 復元の方針
# ① git reflog で削除したコミットを確認
# ② git reset --hard HEAD@{戻したいコミットの数字} 削除したコミットがあるところまで戻る
# ③ 復元したいファイルをコピーして確保する
# ④ 不要になったコミットをgit rebase -i で削除
# ⑤ 確保したファイルを復元し、再コミットしてpush

# 消しすぎてしまったという場合：

#  git reflog
# で過去のコミットとそれに対応するコミットメッセージを、先ほど消したものも含めて見ることが出来ます。
# 各コミットの行の頭に「HEAD@{数字}」のような単語があるので、元に戻したいコミットの数字を確認し、

# git reset --hard HEAD@{戻したいコミットの数字}
# で元に戻ることが出来ます。

# また、reflogで確認することの出来るHEAD@{数字}はそのまま$ git reset –hard HEAD^のHEAD^の代わりに置き換えることで、指定したコミットを消去することが出来るらしいです。

# ※resetは指定したコミット状態まで戻るコマンド！
# → なので指定したコミットの後のコミットは消える！


# --------------------

# ? [git switch] 過去のcommitに移動 最新のコミットに移動

# ◆ 一時的に過去のコミットに戻る:
# git switch -d <コミット>

# ※ -d オプションは移動後の HEAD を「detached HEAD」という使い捨ての HEAD にするという意味

# ❗️注意：
# ところが、このコマンドはワーキングツリーとインデックスと HEAD の内容が一致していないとエラーが出て実行出来ない事があります。
# そういう場合は次の様に stash 機能を使ってワーキングツリーとインデックスの内容を一時的に保存してから git switch を実行します。

# .......................

# ◆ 一時的に過去のコミットに戻る(stash を使う場合):

# ⑴ ワーキングツリーとインデックスの内容を stash に一時保存する: git stash
# ⑵ 過去のコミットに戻る: git switch -d <コミット>
# ⑶ 過去に戻れたか確認: git log --all --oneline

# 何らかの作業が終わったら以下の手順で元の状態に戻すことが出来ます。
# ただしファイルを更新した場合はエラーが出て戻る事が出来ないので、変更したファイルの内容をgit restoreコマンドで復元する必要があります。

# .......................

# ◆ 元の状態に復帰する:

# ⑷ (ファイルを更新した場合) git restoreコマンドで更新したファイルを復元
# ⑸ 元の HEAD に戻る: git switch -
# ⑹ (git stash を行った場合)は stash から内容を復元: git stash pop --index
# ⑺ 元に戻れたか確認: git log --all --oneline


# .......................

# # 戻す対象のハッシュ値を調べる
# $ git log --oneline -3

# # 指定したハッシュ値のコミットまで戻す
# $ git reset --hard {ハッシュ値}

# # ちゃんと消えたか確認
# $ git log --oneline -3

# # 直前のリセットを取り消す
# $ git reset --hard ORIG_HEAD

# resetコマンドのオプション
# --hard コミット、インデックス、ファイルの変更をすべて削除する。
# --mixed コミット、インデックスを削除。ファイルの変更だけは残す。
# --soft コミットだけを削除する。インデックス、ファイルの変更は残す。

# ステージング前に戻す
# git restore --staged <file>


# --------------------

#? ステージング前に戻す方法

# [git] 戻したい時よく使っているコマンドまとめ
# https://qiita.com/rch1223/items/9377446c3d010d91399b


# ステージング前に戻す
# git restore --staged <file>


# --------------------

#? コミットメッセージ無しでコミットする方法

# https://qiita.com/lni_T/items/36abcff16256282a1a6e
# https://kentarotawara.hatenablog.com/entry/2020/11/05/223639
# https://shuzo-kino.hateblo.jp/entry/2014/07/15/234404


# git commit -m --allow-empty


# --------------------

#? GitのRemoteの更新

# https://qiita.com/tiruka/items/43710eac5d43847aacd6


# Remoteの追加
# git remote add origin http://xxxxxx/yyy.git

# 登録URLの変更
# git remote set-url origin http://zzzzz/wwww.git

# Remote名の変更
# git remote rename origin newone

# Remoteの削除
# git remote rm origin

# 全てのRemoteを表示
# git remote

# 全てのRemoteの詳細を表示
# git remote　-v


# 特定のRemoteの超詳細を表示
# git remote origin


# Remote Trackingを表示
# git branch -vv


# .......................

# originの変更

# GitHubをHTTPS接続で使っている人の場合
# git remote set-url origin https://github.com/(あなたのGitHunアカウント名)/laravel-ci.git

# GitHubをSSH接続で使っている人の場合
# git remote set-url origin git@github.com:(あなたのGitHubアカウント名)/laravel-ci.git


# --------------------

#? aliasの設定方法

# https://qiita.com/chihiro/items/04813c707cc665de67c5

# git config --global --edit


# ==== エラー集 ====

#! 【git】error: failed to push some refs to "URL"のエラー対処法

# https://qiita.com/chiaki-kjwr/items/118a5b3237c78d720582
# https://ja.stackoverflow.com/questions/57780/git-push%E6%99%82%E3%81%ABerror-failed-to-push-some-refs-to%E3%81%A8%E3%82%A8%E3%83%A9%E3%83%BC%E3%81%8C%E3%81%A7%E3%82%8B
# https://dianxnao.com/git-push%E3%82%A8%E3%83%A9%E3%83%BC%EF%BC%9Aerror-failed-to-push-some-refs-to-%E3%81%AF%E3%83%AA%E3%83%A2%E3%83%BC%E3%83%88%E3%81%AE%E6%96%B9%E3%81%8C%E6%96%B0%E3%81%97%E3%81%84%E3%81%AE%E3%81%A7/
# https://omkz.net/error-git-push/
# https://fuuengineer.hatenablog.com/entry/2021/10/03/182156
# https://algorithm.joho.info/heroku/error-failed-to-push-some-refs-to/
# https://ideallife-blog.com/detail/when-git-push-error-failed-to-push-some-refs-to/


# ==== Gitの設定 ====

# Gitの設定をgit configで確認・変更
# https://note.nkmk.me/git-config-setting/

# 一覧
# g config --global -l


# .......................

# git config --global user.name "kazuaki_ubuntu220811"
# git config --global user.email "0chlbv7420t18063263g7t20@gmail.com"


# .......................

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


# .......................

#! 無視していい：
#  mkdir -p ~/.config/git
# echo '.DS_Store' >> ~/.config/git/ignore


# .......................

# cat <<EOF > ~/.gitignore_global
# .DS_Store
# EOF

# git config --global core.excludesFile ~/.gitignore_global


# .......................

# cd ~/.ssh

# ssh-keygen -t rsa -b 4096 -C "$(git config user.email)"
# /home/vagrant/.ssh/id_rsa_github
# lbv180620

# C:\Users\k_yoshikawa/.ssh/id_rsa_github
# /home/k_yoshikawa/.ssh/id_rsa_github

# pbcopy ~/.ssh/id_rsa_github.pub

# https://github.com/settings/keysで貼り付け
# Kazuaki_ubuntu220811_id_rsa_github


# .......................

# config設定
# vim ~/.ssh/config
# 下記を追記

# Host github github.com
#   HostName github.com
#   IdentityFile ~/.ssh/id_rsa_github
#   User git

# 権限を修正する
# sudo chmod 600 ~/.ssh/config


# .......................

# 秘密鍵をssh-agentに登録する

# ### ssh-agentが動作しているか確認
# eval "$(ssh-agent -s)"

# Agent pid 32047
# # 動いていることが確認できました。

# $ ssh-add ~/.ssh/id_rsa_github
# Enter passphrase for /Users/ts/.ssh/id_rsa_github: # 鍵のpassword入力
# Identity added: /Users/ts/.ssh/id_rsa_github (/Users/ts/.ssh/id_rsa_github)

# .......................

# [事後確認・作業]
# 接続確認をしてみる
# 下記のように出れば、接続はできています。


# ssh -T git@github.com
# # yes
# Hi mackerel7! You've successfully authenticated, but GitHub does not provide shell access


# --------------------

# エラー：　

# https://qiita.com/aki4000/items/4c81bc2747bbd5e96d85
# https://qiita.com/yysskk/items/974c9c55d66a26515651

# Warning: Permanently added the RSA host key for IP address '52.192.72.89' to the list of known hosts.

# ssh-add -l

# ssh-add ~/.ssh/id_rsa_github


# --------------------

# bashでgitのブランチ名を表示

# https://qiita.com/kuniatsu/items/e2de0d37cdb63b77fbd4


# sudo find / -name git-prompt.sh
# sudo find / -name git-completion.bash


# ・ターミナルのプロンプトにgitのブランチ名を常に表示させる（git-prompt）
# ・gitコマンドをTab補完できるようにする（git-completion）


# --------------------

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

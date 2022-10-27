#todo [Git & GitHub Tips ②]


# https://www.udemy.com/course/unscared_git/


# git chockout

# git reset

# git restore

# git revert


# git checkout -b <ブランチ名> == git switch -c <ブランチ名>

# git checkout <ブランチ名> == git switch <ブランチ名>


# --------------------

# 補足：

# Git で変更を取り消して、元に戻す方法 (事例別まとめ)
# https://www-creators.com/archives/1290#_git_add


# --------------------

#* 15. Gitってどのようにデータを管理しているの？１
#* 16. Gitってどのようにデータを管理しているの？２

# git add index.html

# リポジトリ：圧縮fileA

# ステージ： インデックス[index.html=>圧縮ファイル
# A]

# ワークツリー：index.html

# git commit

# リポジトリ：
# 圧縮fileA
# tree1[index.html=>圧縮ファイルA]
# commit1[tree1, name, date, message]

# ステージ：
# index[index.html=>圧縮ファイルA]

# ワークツリー：i
# index.html

# git add index.css

# リポジトリ：
# 圧縮fileA
# tree1=[index.html=>圧縮ファイルA]
# commit1=[tree1, name, date, message]
# 圧縮fileB

# ステージ：
# index=[
# index.html=>圧縮fileA,
# index.css=>圧縮fileB
# ]


# ワークツリー：i
# index.html
# index.css

# git commit

# リポジトリ：
# 圧縮fileA
# tree1=[index.html=>圧縮ファイルA]
# commit1=[tree1, name, date, message]
# 圧縮fileB
# tree2=[
# index.html=>圧縮fileA,
# index.css=>圧縮fileB
# ]
# commit2=[tree2, commit1, name date, message]

# ステージ：
# index=[
# index.html=>圧縮fileA,
# index.css=>圧縮fileB
# ]


# ワークツリー：i
# index.html
# index.css

# index.htmlを変更して、git add

# リポジトリ：
# 圧縮fileA
# tree1=[index.html=>圧縮ファイルA]
# commit1=[tree1, name, date, message]
# 圧縮fileB
# tree2=[
# index.html=>圧縮fileA,
# index.css=>圧縮fileB
# ]
# commit2=[tree2, commit1, name date, message]
# 圧縮fileC

# ステージ：
# index=[
# index.html=>圧縮fileC,
# index.css=>圧縮fileB
# ]


# ワークツリー：i
# index.html
# index.css

# git commit

# リポジトリ：
# 圧縮fileA
# tree1=[index.html=>圧縮ファイルA]
# commit1=[tree1, name, date, message]
# 圧縮fileB
# tree2=[
# index.html=>圧縮fileA,
# index.css=>圧縮fileB
# ]
# commit2=[tree2, commit1, name date, message]
# 圧縮fileC
# tree3=[
# index.html=>圧縮fileC,
# index.css=>圧縮fileB
# ]
# commit3=[tree3, commit2, name, date, message]

# ステージ：
# index=[
# index.html=>圧縮fileC,
# index.css=>圧縮fileB
# ]


# ワークツリー：i
# index.html
# index.css


# --------------------

#* 17. Gitのデータ管理の補足
# https://www.udemy.com/course/unscared_git/learn/lecture/6990142#overview

# blob == 圧縮ファイル

# tree == ディレクトリ

# git cat-file -p HEAD
# 最新のcommitオブジェクト表示

# git cat-file -p treeのID
# treeオブジェクトの中身確認

# git cat-file -p parentのID
# 親commitオブジェクトの中身確認


# --------------------

#* 18. Gitを始めよう

# git init
# .gitディレクトリが作成される

# .git/
# ・リポジトリ
# →圧縮ファイル(blob)
# →ツリーファイル(tree)
# →コミットファイル(parent)
# ・インデックスファイル
# ・設定ファイル


# --------------------

#* 19. GitHub上にあるプロジェクトから始めよう

# git clone
# リーモートリポジトリからローカルに
# Gitリポジトリ(.git)
# と
# ワークツリーにファイル群がコピーされる。


# --------------------

#* 20. 変更をステージに追加しよう

# なぜステージがるのか？
# →コミットする変更を準備するため。

# git add <ファイル名>
# git add .

# すべてのファイルではなく、一部のファイルをコミットしたい場合がある。


# --------------------

#* 21. 変更を記録しよう

# git commit // gitエディタが立ち上がる
# git commit -m "<メッセージ>" // gitのエディタが立ち上がらない
# git commit -v

# ・変更
# ・新規作成
# ・削除
# ・複数ファイルの変更、作成、削除


# わかりやすいコミットメッセージを書こう

# ・簡単に書くとき
# 変更内容の要点と理由を１行で簡潔に書いてね
# →個人プロジェクトの場合

# ・正式に書くとき
# １行目：変更内容の要約
# ２行目：空行
# ３行目：変更した理由
# →チーム開発やオープンソースにコミットするときなど


# --------------------

#* 22. 現在の変更状況を確認しよう

# コミットやステージに追加する前にどのファイルが変更されたかを確認する癖を付けよう

# git status
# 現在の変更状況を確認する
# ・ワークツリーとステージとの間で変更されたファイル
# ・ステージとリポジトリとの間で変更されたファイル


# --------------------

#* 23. 何を変更したのかを確認しよう

# コミットやステージに追加する前にどんな変更をしたかを確認しよう

# 変更差分を確認
# git addする前の変更差分
# git diff
# git diff <ファイル名> // 特定のファイルの差分をみたい場合

# git addした後の変更差分
# git diff --staged // ステージングはしたがまだコミットしていない変更が対象

# worktree
# ⇅ git diff(ワークツリーとインデックス)
# stage
# ⇅ git diff --staged(ツリー・コミットとインデックス)
# repogitry


# --------------------

#* 24. 変更履歴を確認しよう

# 変更履歴を確認
# git log
# git log --online // １行で表示
# git log -p <ファイル名> // ファイルの変更差分を表示
# git log -n <コミット数> // 表示するコミット数を制限


# --------------------

#* 25. ファイルの削除を記録しよう

# ファイルの削除を記録するには、git addとは別のコマンドを使う必要がある

# ファイルの削除を記録する

# // ファイルごと削除
# git rm <ファイル名>
# git rm -r <ディレクトリ名>
# →コミットされたGitリポジトリからもワークツリーからも消える
# →そもそもファイルがいらなくなった場合

# //ファイルを残したいとき
# git rm --chached <ファイル名>
# →ワークツリーには残る
# →ファイルはいるけど、Gitリポジトリからだけ消した。
# 例えば、コミットメッセージを書き間違えたからやパスワードが載っているファイルを間違ってコミットしてしまったとか。パスワードの記載されたファイルはワークツリーには残したけど、Gitリポジトリから削除したい場合。

# ※rmじゃなくてgit rmコマンドを使ってファイル削除すると、Gitに削除履歴を残して消せる！

# git rm
# [リポジトリ] ❌index.html

# [ステージ]

# [ワークツリー] ❌index.html

# git rm --chached
# [リポジトリ] ❌index.html

# [ステージ]

# [ワークツリー] index.html


# git rm index.html
# git status
# Changes to be committed: // ステージに上げられている変更があるよ！
#   (use "git restore --staged <file>..." to unstage)
# 	deleted:    index.html

# ※git rm は git add と同じようにステージングする

# もともとリポジトリに記録されていたindex.htmlが削除されて、今その削除された変更状態がステージ(インデックス)に記録されている。

# 元の状態に戻す

# git reset HEAD index.html // リポジトリが元の状態に
# git checkout index.html // ワークツリーも元の状態に

# git rm --cached index.html

# Changes to be committed: // コミットすべき変更
#   (use "git restore --staged <file>..." to unstage)
# 	deleted:    index.html

# // リポジトリからは削除されて、その変更状態がステージに追加されている。

# Untracked files:
#   (use "git add <file>..." to include in what will be committed)
# 	index.html

# // まだGitで追跡できていないファイルがある。index.htmlという新規ファイルがワークツリーにあるよ。ステージングしてねと。
# リポジトリからだけ削除したので、今Gitの状態としては、index.htmlはGitに記録されていない状態になっている。しかし、ワークツリーにはindex.htmlがあるので、これを新しいファイルとGitが認識している。

# 元の状態にもどす。

# git reset HEAD index.html


# # git rm コマンドの挙動の補足

# 動画の中では git rm コマンドは「ファイルの削除をリポジトリに記録する」と解説しております。
# ファイル自体を削除しても git add コマンドではリポジトリの記録からファイルは削除されず、リポジトリから削除するためには git rm コマンドを使う必要があるためこのように説明しております。

# 正確には、git rm コマンドを実行すると、ステージにファイルの削除が記録されます。
# それをコミットすると、リポジトリからも削除されるというのが正確な挙動になります。

# git rm コマンド自体は「ファイルの削除をリポジトリに記録する」ためにあり、挙動としては「ステージにファイルの削除を記録する」とご理解ください。


# --------------------

#* 26. ファイルの移動を記録しよう

# ファイルの移動を記録する

# git mv <旧ファイル> <新ファイル>

# // 以下の一連のコマンド操作と同じ
# mv <旧ファイル> <新ファイル>
# git rm <旧ファイル>
# git add <新ファイル>


# git add .... ファイルの追加・変更をステージングする
# git rm .... ファイルの削除をステージングする
# git mv .... ファイルの移動をステージングする


# git mv
# [リポジトリ]

# [ステージ]
# index=[index.html] → index=[index2.html]

# [ワークツリー]
# index.html → index2.html

# git mv index.html index2.html
# git status
# Changes to be committed:
#   (use "git restore --staged <file>..." to unstage)
# 	renamed:    index.html -> index2.html

# 元に戻す。

# git mv index2.html index.html


# --------------------

#* 27. GitHubにプッシュしよう

# リモートリポジトリを新規追加する

# git remote add origin <URL>

# originというショートカットでGitHibのリモートリポジトリを登録するという意味。
# これをすると、今後originという名前でGitHubリポジトリにアップしたり取得したりできる。

# もしこのようにgit remote add コマンドでリモートリポジトリを登録したおかなかったら、GitHubにpushするときに毎回GitHubのリポジトリのURLを記載する必要がある。

# これは便利なのでpushする前に一回行っておく。

# なぜoriginという名前を使うかというと、こちらGitの慣用句になる。
# 実は、git cloneした時に、そのクローン元のもともとのリモートリポジトリをGitではoriginというショートカットに割り当てる。そのため、メインのリモートリポジトリのことをGitでは普通originという名前をつける。

# リモートリポジトリへ送信する

# git push <リモート名> <ブランチ名>
# git push origin master

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


# git remote add origin git@github.com:lbv180620/git_tutorial.git

# git push -u origin master
# // -uオプションを使うと、次回以降origin masterにpushする時に、git pushだけでpushできるようになる。

# ※Macでusernameとpasswordが表示されなかった場合：
# キーチェーンアクセスというアプリを開く。
# Mac側がusernameとpasswordを保存している

# 検索でGitHubと検索し、そこで出てきた項目を削除。

# 逆にここにusernameとpassword(トークン)を登録すると省略できる。


# --------------------

#* 28. GitHubの画面を確認しよう

# Raw
# コピーするときに

# Blame
# 誰がいつ変更しやのかが分かる

# History
# 個別ファイルのコミットの履歴を追うことができる

# Commits
# プロジェクト全体のコミットの履歴を追うことができる

# Add file -> Create new file
# 新規ファイル作成
# Add file -> Upload file
# ファイルをアップロード
# ※GitHub上にファイル作成するよりも、普通はローカルでやる

# Code -> Clone


# --------------------

#* 29. コマンドにエイリアスを付けよう

# git config --global alias.ci commit
# git config --global alias.st status
# git confiig --global alias.br branch
# git config --global alias.co checkout

# --globalをつけた場合：
# ~/.gitconfig
# ~/.config/git/config
# ※ --globalをつけるとPC全体の設定になる

# --globalをつけない場合：
# project/.git/config


# --------------------

#* 30. バージョン管理しないファイルは無視しよう

# バージョン管理したくないファイルというのはどのようなファイル？
# ①パスワードなどの機密情報が記載されたファイル(.env, AWS)
# ②チームの開発で必要でないファイル(OSで自動生成されるファイル、キャッシュ)

# 管理しないファイルをGitから外す

# .gitignoreファイルに指定する
# →こういったファイルは管理しない
# ・自動生成されるファイル
# ・パスワードが記載されているファイル

# ,gitignoreファイルの書き方
# # #から始まる行はコメント

# # 指定したファイルを除外
# index.html

# # ルートディレクトリを指定
# /root.html

# # ディレクトリ以下を除外
# dir/

# # /以外の文字列にマッチ「*」
# /*/*.css


# --------------------

#* 31. ファイルへの変更を元に戻そう

# ワークツリーのファイルを元の状態に戻したいとき

# ファイルへの変更を取り消す

# git checkout -- <ファイル名>
# git checkout -- <ディレクトリ名>

# # 全変更を取り消す
# git checkout -- .

# ※「--」 をつけるのは、ブランチ名とファイル名が被った時に、どちらを指しているかGitが分からなくなるのを避けるため。
# つまり「--」はブランチじゃないよということを明示するため。


# ※レクチャー内容の補足

# レクチャー中では

# $ git checkout -- .

# を「全変更を取り消す」と解説しておりますが、正確には「現在いるディレクトリ以下の変更を全て取り消す」になります。

# `.` というのは、「現在いるディレクトリ以下の全てのファイル」を指します。

# 自分が現在いるディレクトリより上のファイルの変更に関しては取り消せないため、その点はご注意ください。


# git checkout -- index.html
# [リポジトリ]

# [ステージ]


# [ワークツリー]
# index.html(変更)　←変更内容を取り消し

# 内部では、ワークツリーの状態をステージの状態と同じにする。ステージにはまだ変更前の状態が残っているので、それをワークツリーに上書きすればいい。

# ステージからgit checkoutで指定されたファイルの情報を取得し、取得してきた情報をワークツリーに反映させる。

# ※git restore <file>...
# 最新版だと、こう。

# ※git checkout HEAD <file>
# 最新のコミット状態にワークツリーまたはファイルの状態を戻す


# --------------------

#* 32. ステージングした変更を取り消そう

# ステージに追加した変更を元に戻したいとき

# ステージングした変更を取り消す

# git reset HEAD <ファイル名>
# git reset HEAD <ディレクトリ名>

# # 全変更を取り消す
# git reset HEAD .

# ※指定した変更をステージから取り消すだけなので、ワークツリーのファイルには影響を与えない。
# ※ワークツリーの変更も取り消したい場合は、この後にgit checkoutする。


# git reset HEAD index.html
# [リポジトリ]
# blobA 最新のcommit

# [ステージ]
# index=[blobA=>index.html] ←変更を取り消し

# [ワークツリー]
# index.html(変更)

# 裏側では、リポジトリから最新のコミットの情報を取得し、その情報でステージの内容を上書きする。

# HEADとは、今自分がいるブランチの最新のコミットのこと。
# つまり、git reset HEAD index.htmlとは、
# 今自分がいるブランチの最新のコミット情報からステージのindex.htmlの内容を上書きするということ。

# --はステージのこと？

# ※git restore --staged <file>...
# 最新版だと、これがunstageコマンドになってるgit


# --------------------

#* 33. 直前のコミットをやり直そう

# 何か変更をコミットし忘れたり、コミットメッセージを書き直したいとき、直前のコミットを修正したい。

# 直前のコミットやり直す。

# git commit --amend

# ※リモートリポジトリにpushしたコミットはやり直したらダメ！
# なぜかというと、Aさんがpushされたデータを自分のワークツリーに取り込んで、何か作業をしていたとする。その状態で自分がコミットをやり直したいなっと思ってgit commit --amendしてから再度pushしたとする。
# 何が起きるかというと、リモートリポジトリの履歴の状態とAさんのローカルリポジトリの履歴の状態が別のものになってしまう。
# すると、Aさんが変更を加えて、その変更をリモートリポジトリにマージしようとしたときに、履歴の状態が違うからコンフリクトを起こして取り込めないといったことが起こる。

# ※pushする前は修正が許されるが、push後は絶対に修正してはいけない！
# ※もしpush後にやり直したいなら、１から新しいコミットを作ることで、その内容修正するようにする。


# git commit --amend
# [リポジトリ]
# blobA Tree1 Commit1
# ↑ git commit --amend
# [ステージ]
# index=[blobA=>index.html]
# ↑ git add
# [ワークツリー]
# index.html(変更)


# 今何かの変更をコミットした直後だとする。コミットした後に、あるファイルの修正を忘れていたことに気づく。
# その場合どうすればいいか。

# まずワークツリーに修正漏れ部分の変更を加えて、git addでステージに追加。ステージに追加したら、git commit --amendを使って直前のコミットを修正する。

# 今のステージの状態を元に、直前のコミットと作り直す、やり直すことする。ゆえに、修正した場合は、まずワークツリーから修正し、ステージングした後で、git commit --amendすれば、修正済みのステージの情報を元に直前のコミットが修正される。

# ファイルの内容を間違ってコミットした場合
# →ワークツリーでファイルの内容を修正。git addでステージング。git commit --amendで直前のコミットメッセージを確認した後、保存。

# コミットメッセージが間違った場合
# → git commit --amendして、直前のコミットメッセージを修正

# 直前のコミットが修正できたか確認
# git log -p -n 1

# プッシュ
# git push origin master


# --------------------

#* 34. リモートの情報を確認しよう

# リモートを表示する

# # 登録されているリモート名だけ表示
# git remote

# origin

# # 対応するURLも表示
# git remote -v

# origin	git@github.com:lbv180620/git_tutorial.git (fetch)
# origin	git@github.com:lbv180620/git_tutorial.git (push)

# →fetchとpushでURLを振り分けることができる。

# ※設定しているリモートリポジトリの情報を表示する


# --------------------

#* 35. リモートリポジトリを追加しよう

# リモートリポジトリは複数登録することができる

# リモートリポジトリを新規追加する

# git remote add <リモート名> <リモートURL>

# git remote add tutorial https://github.com/user/~.git
# →tutorialというショートカットでURLのリモートリポジトリを登録する


# git remote add bak git@github.com:lbv180620/git_tutorial_bak.git
# git remote
# git remote -v
# git push -u bak master


# --------------------

#* 36. リモートから取得しよう (フェッチ編)

# リモートから情報を取得するのには２種類のやり方がある

# git fetch <リモート名>
# git fetch origin

# ※取ってくるということ

# [リモートリポジトリ]

# ↓　git fetch

#  remotes/リモート/ブランチ
# ここに保存される

# [ローカルリポジトリ]

# ↓ git merge

# [ワークツリー]

# ※git fetchはローカルリポジトリに情報を取得してくるだけで、ワークツリーには反映されない。


# 一人でやるので、GitHub上でファイルを編集。
# Create new file
# Commit new file

# git fetch origin



# // すべてのブランチを確認
# git branch -a // all

# * master
#   remotes/bak/master
#   remotes/origin/master

# // remotes/origin/masterというブランチに自分のワークツリーの内容を切り替える
# git checkout remotes/origin/master

# // 取得したファイルを確認
# ls
# cat

# このようにgit fetchするとremotesというリモートブランチの方に情報が格納されてそちらで情報を確認することができる。

# 元に戻す。
# git checkout master

# // 取得した情報をワークツリーに取り込む
# git merge origin/master

# これでoriginリポジトリのmasterブランチの情報を自分のワークツリーに取り込むことができる。

# このようにgit fetchを使った場合、git fetchでローカルリポジトリに情報を取得して来て、その情報をワークツリーに反映させたい場合は、git mergeする。


# --------------------

#* 37. リモートから取得しよう (プル編)

# リモートから情報を取得してマージまで一度にやりたいとき

# リモートから情報を取得してマージする(プル)

# git pull <リモート名> <ブランチ名>
# git pull origin master

# # 上記コマンドは省略可能
# git pull

# # これは書きコマンドと同じ
# git fetch origin master
# git merge origin/master


# --------------------

#* 38. フェッチとプルを使い分けよう

# fetchを基本的に使うのがおすすめ。
# pullは挙動が特殊なので気をつけて。

# pullの注意点


# [リモートリポジトリ]

# ---------       ↓
# 　　　     ↓ git pull origin hoge
#                  ↓

# [ローカルリポジトリ]
# remotes/origin/hogeブランチ
#                 ↓
# [ワークツリー]
# *master
# hoge

#  ※masterブランチにhogeブランチがマージされる！
# git pull すると今自分がいるブランチにpullしてきたブランチの内容がマージされる。
# 今自分がhogeブランチに入れば問題ない。
# pullするときは、今いるブランチを事前に確認すること！

# 運用ルールとして、自分がmasterブランチにいて何の変更もされてないとき、その時に限ってgit pull して情報を取得してくるようにする。
# masteブランチ以外にいるときは、git pullすると大丈夫かなといちいち考えないといけないので、そうしなくてもいいように毎回fetchを使うようにする。


# --------------------

#* 39. リモートの情報を詳しく知ろう

# リモートの情報を詳しく確認したいとき

# git remote show <リモート名>
# git remote show origin

# ※git remote コマンドより詳しい情報を表示する

# 表示される情報

# ・fetchとpushのURL
# ・リモートブランチ
# ・git pullの挙動
# ・git pushの挙動

# git remote show origin

# remote origin
#   Fetch URL: git@github.com:lbv180620/git_tutorial.git
#   Push  URL: git@github.com:lbv180620/git_tutorial.git
#   HEAD branch: master
#   Remote branch:
#     master tracked
#   Local ref configured for 'git push':
#     master pushes to master (up to date)
# // masterブランチのリモートブランチにpushされる


# --------------------

#* 40. リモートを変更・削除しよう

# 別のリモート名を使いたくなったとき、リモートを使わなくなったとき


# リモート名の変更・リモートの削除

# 変更する：
# git remote rename <旧リモート名> <新リモート名>


# 削除する：
# git remote rm <リモート名>

# // 今あるリモートの確認
# git remote

# git remote rename bak backup

# git remote rm backup


# --------------------

#* 41. ブランチって何？

# 並行して複数機能を開発するためにあるのがブランチ

# ブランチは分岐して開発していくためのもの


# --------------------

#* 42. ブランチの仕組みを知ろう

# ・コミットはスナップショット。それが時系列順に連なる

# ・ブランチはコミットを指したポインタ
# ・HEADは今自分が作業しているブランチを指したポインタ

# HEAD -> ブランチ -> コミット -> 親コミット

# ・コミットしたらブランチが指すコミットファイルが変わる


# ブランチとHEADの中身

# ブランチにはブランチファイルがあって、その中身に指しているコミットのID番号が記載されている。

# つまり、ブランチはコミットIDを記録したポインタ。

# HEADには、HEADというファイルがあって、そこには、
# ref: ブランチ名
# と記載されている。
# 記載されているブランチ名のブランチを参照しているという意味。
# つまり、HEADは現在作業中のブランチへのポインタ。

# [リポジトリ]
# .git/HEAD
# .git/refs/


# ブランチの仕組みのまとめ
# ・分岐することで複数の機能を同時並行で開発するための仕組みがブランチ
# ・ブランチとはコミットを指すポインタ
# ↓スナップショットを記録しているのと相まって
# ・ブランチの作成や切り替え、マージが他のバージョン管理ツールより高速

# ※従来は記録を変更差分で記録しているので、ブランチを切り替える際に毎回変更差分を計算しなければならなかった。Gitでのブランチの切り替えはスナップショットでのポインタを切り替えるだけでいい。

# ・結果、Gitは大規模開発において最も使われているツールとなり、普及した


# --------------------

#* 43. 新しいブランチを作成しよう

# ブランチを新規追加する

# git branch <ブランチ名>

# ※ブランチを作成するだけで、ブランチの切り替えまでは行わない。
# つまり、HEADが指すブランチは切り替わらない。

# ブランチの一覧を表示する

# git branch
# // 今あるブランチの一覧を表示する

# # 全てのブランチを表示する
# git branch -a
# // リモートリポジトリにあるブランチも表示する

# ※何のブランチがあるかを確認したい時に使う。

# 各ブランチがどのコミットを指しているかを確認

# git log --oneline --decorate

# git log --oneline --decorate -n 1

#  a9d659b (HEAD -> master, origin/master, feature) Update home.html

# a9d659b ( // コミットID
# HEAD -> master, // HEADが指しているブランチはmaster
#  origin/master, // GitHubのリモートリポジトリのoriginもこのコミットを指している
# feature // featureもこのコミットを指している
# ) Update home.html


# --------------------

#* 44. ブランチを切り替えよう

# ブランチを切り替える

# git checkout <既存ブランチ名>

# # ブランチを新規作成して切り替える
# git checkout -b <新ブランチ名>

# ※-bオプションを付けるとブランチの作成と切り替えを一度にしてくれるので楽。

# // HEADポインタを切り替える

# これで分岐して並行して作業することができる。

# ※pushすると、git push <リモートリポジトリ名> <そのブランチ名> で指定したブランチがpushしたコミット指し示すようになる。
# ※git push <リモートリポジトリ名> <そのブランチ名> すると、リモートリポジトリに存在しないブランチ名の場合、そのブランチ名のブランチを作成する


# --------------------

#* 45. 変更をマージしよう

# マージとは、他の人の変更内容を取り込む作業のこと

# 変更履歴をマージする

# git merge <ブランチ名>
# git merge <リモート名/ブランチ名>

# git merge origin/master
# // GitHubにあるoriginという名前のリモートリポジトリのmasterブランチが指しているコミットの内容を自分の作業中のブランチにマージする。

# ※作業中のブランチにマージする


# 　　　　　master
#                         ↓
# [a6923] ← [23q1a]
#       ↑
# [rf54h] ← feature


# 　　　　　                        master
#                                              ↓
# [a6923] ← [23q1a] ← [6847g]
#       ↑                                  |
# [rf54h] ←------------------------
#      ↑
#  feature

# // 元々のmasterブランチのコミットをベースにfeatureブランチのコミットの変更分を取り込む

# git checkout master
# git merge feature
# // masterブランチが新たなコミットに進み、そのコミットが直前にmasterブランチが指していたコミットとfeatureブランチが指しているコミットの二つを親コミットとして指す。


# マージには3種類ある

# ⑴ Fast Foward：早送りになるマージ


# master     hotfix
# ↓                 ↓
# a6923 ← 23q1a

# git merge hotfix

# 　　　　master
#                 ↓
#               hotfix
#                ↓
# a6923 ← 23q1a

# ※ブランチが枝分かれしてなかったときは、ブランチのポインタを前にすすめるだけ


# ⑵ Auto Merge：基本的なマージ

# 　　　　　master
#                      ↓
# a6923 ← 23q1a
#    ↑
# rf54h
# ↑
# feature

# git merge feature
# 　　　　　　　　    master
# 　　　　                      ↓
# a6923 ← 23q1a ← 6847g  //新しいコミットファイルが作成される
#    ↑                                 |
# rf54h ←----------------------
# ↑
# feature

# ※枝分かれして開発していた場合、マージコミットという新しいコミットを作る

# マージコミットファイルは通常のコミットファイルと何が違うかと言うと、通常のコミットファイルはparentにはひとつのコミットファイルしか持たない。しかしこのマージコミットファイル場合、parentを二つもっているというのが大きく異なる。

# ⑶ コンフリクト

# ..............

# ⑴ Fast Foward

# GitHubでorigin/masterブランチのコミットをすすめる
# git pull origin master

# fetchの段階：
# master      origin/master
# ↓                  ↓
# a345r ← t86ii

# mergeの段階：
#           origin/master
#                  ↓
# a345r ← t86ii
#                   ↑
#                master

# ⑵ Auto Merge

# git branch
# git checkout feature
# vim feature.html
# git add .
# git commit
# git checkout master
# git merge feature
# エディタが立ち上がる

# git log --oneline


# --------------------

#* 46. コンフリクトを解決しよう

# コンフリクトとは、複数人が同じ箇所で別々の変更をしたときにどの変更を優先したらいいかわからないという状態のこと。

# コンフリクトはどのような時に起こるのか？

# 同じファイルの同じ行に対して異なる編集を行ったとき


# コンフリクトの解決の仕方

# <<HEAD ~ == ：HEADの変更分 // 取り込む側
# == ~ >> feature：featureの変更分 // 取り込まれる側

# ①ファイルの内容を書き換える
# ②「<<」「==」「>>」の記述を削除する


# ................

# コンフリクトを起こす
# masterとfeatureで共通してあるindex.htmlを同時に編集しマージする

# git merge feature
# Auto-merging index.html
# CONFLICT (content): Merge conflict in index.html
# Automatic merge failed; fix conflicts and then commit the result.

# どのファイルがコンフリクトが起きているか確認

# git status
# On branch master
# You have unmerged paths.
#   (fix conflicts and run "git commit")
#   (use "git merge --abort" to abort the merge)

# Unmerged paths:
#   (use "git add <file>..." to mark resolution)
# 	both modified:   index.html

# no changes added to commit (use "git add" and/or "git commit -a")


#  コンフリクトの解決

# vim index.html

#   1 <h1>Gitチュートリアル</h1>
#   2 <p>git status</p>
#   3 <p>git diff</p>
#   4 <p>git commit --amend</p>
#   5 <<<<<<< HEAD
#   6 <p>git merge</p>
#   7 <p>conflict</p>
#   8 =======
#   9 <p>コンフリクト</p>
#  10 >>>>>>> feature

# ↓ 修正

#   1 <h1>Gitチュートリアル</h1>
#   2 <p>git status</p>
#   3 <p>git diff</p>
#   4 <p>git commit --amend</p>
#   5 <p>git merge</p>
#   6 <p>conflict</p>

# git add .
# git commit


# --------------------

#* 47. コンフリクトが起きないようにするには？

# コンフリクト関連の事故が起きにくい運用ルール

# ・複数人で同じファイルを変更しない
# ・pullやmergeする前に変更中の状態を無くしておく (commitやstashをしておく、git statusで確認)
# ・pullするときは、pullするブランチと同じ名前のブランチに移動してからpullする (git checkoutで移動、git branchで確認)
# ・コンフリクトしても慌てない


# --------------------

#* 48. ブランチを変更・削除しよう

# ブランチ名を変更する

# git branch -m <ブランチ名> // move

# ※自分が作業しているブランチの名前を変更

# ブランチを削除する

# git branch -d <ブランチ名>
# ※masterにマージされていない変更が残っている場合削除しない

# # 強制削除する
# git branch -D <ブランチ名>


# --------------------

#* 49. ブランチを利用した開発の流れ

# masterブランチをリリース用ブランチに、開発はトピックブランチを作成して進めるのが基本


# ブランチを利用した開発の流れ

# https://backlog.com/ja/git-tutorial/stepup/05/


# --------------------

#* 50. リモートブランチって何？

# リモートブランチとは、リモートのブランチの状態へのポインタ

# リモートブランチは<リモート>/<ブランチ>で参照できる


# git fetchすると、リモートリポジトリの内容を取得できるが、これはリモートリポジトリのコミットファイルをローカルにも保存し、またブランチに関してはorigin/<ブランチ名>という形でブランチを作成して、ローカルに保存したコミットファイルのポインタとして機能する。

# リモートブランチの確認
# git branch -a


# --------------------

#* 51. プルリクエストの流れ

# プルリクエストは、自分の変更したコードをリポジトリに取り込んでもらえるよう依頼する機能

# プルリクエストの手順

# ①ワークツリーでmasterブランチを最新の状態に更新
# ②ブランチを作成
# ③ファイルを変更
# ④変更をコミット

# ⑤GitHubへpush

# ⑥プルリクエストを送る
# ⑦チームメイトにコードレビューしてもらう
# ⑧許可が降りたら、プルリクエストをGitHubのmasterブランチにマージ
# ⑨ブランチを削除


# git branch

# ①git pull origin master

# ※rebase：自分のmasterブランチの履歴が書き換えられたという意味

# ②git checkout -b pull_request

# ⑥ compareの方がプルリクエストするブランチ。baseは基盤となるブランチ。意味はpull_requestブランチからmasterブランチにプルリクエストを送るという意味。


# --------------------

#* 52. GitHub Flowの流れ

# GitHub Flowとは、GitHub社のワークフロー

# master ------------｜
#      |　　　　プルリクエスト
#     ↓                   ↑
# branch ----------

# [本番サーバ]
# ↑⑥masterブランチをデプロイ
# ↑⑤コードレビューし、masterブランチにマージ
# ↑④プルリクエストを送る
# [リモートリポジトリ]
# ↑③同名のブランチをGitHubへプッシュ
# [ローカルリポジトリ]
# ↑②ファイルを変更しコミット
# ↑①masterブランチからブランチを作成
# [ワークツリー]

# GitHub Flowを実践する上でのポイント

# ・masterブランチは常にデプロイできる状態に保つ
# ・新開発はmasterブランチから新しいブランチを作成してスタート
# ・作成した新しいブランチ上で作業しコミットする
# ・定期的にPushする
# ・masterにマージするためにプルリクエストを使う
# ・必ずレビューを受ける
# ・masterブランチにマージしたらすぐにデプロイする←テストとデプロイ作業は自動化


# --------------------

#* 53. GitHub Flowを実践しよう

# git branch
# git status
# git pull origin master
# git checkout -b github_flow
# vim index.html
# git add .
# git commit -v
# git push origin github_flow

# Pull requests
# base: master <- compare: github_flow
# Create pull request
# Create pull request

# reviewers
# Files changed
# Review changes

# Conversation
# Merge pull request
# Confirm Merge
# Delete branch

# デプロイ

# git checkout master
# git pull origin master
# git branch -d github_flow


# ===================


# https://www.udemy.com/course/unscared_git/


# file:///Users/kazuaki/Downloads/Git%E3%82%B3%E3%83%9E%E3%83%B3%E3%83%88%E3%82%99%E9%9B%86.pdf

# file:///Users/kazuaki/Downloads/Git%E3%82%B3%E3%83%9E%E3%83%B3%E3%83%88%E3%82%99%E9%9B%86%20(1).pdf


# --------------------

#* 54. リベースする

# 変更を統合する際に、履歴をきれいに整えるために使うのがリベース

# リベースで履歴を整えた形で変更を統合する

# git rebase <ブランチ名>
# // 指定したブランチが指すコミットを親コミットとなるように統合する
# ※ブランチの基点となるコミットを別のコミットに移動する

#    HEAD
#   feature
# 　　↓
# コミット３
#        ↓
# コミット１ ← コミット２
#                                ↑
# 　　　　　　　master

# git rebase master
# 　                                                    HEAD
#                                                       feature
#                　　　　　　　　　　　↓
# コミット１ ← コミット２ ← コミット３’
#                                ↑
# 　　　　　　　master

# featureブランチが指しているコミット３が指す親コミットがコミット１からコミット２になった。

# masterブランチの変更分がfeatureブランチに取り込まれた

# リベースの一連の作業の流れ

# feature
# コミット１
# master

# feature
# コミット１ ← コミット２
#                            master

# feature
# 　↓
# コミット３
#       ↓
# コミット１← コミット２
# 　　　　　　　master


# 今回はただ取り込みだけでなく、履歴もきれいにしたい
# git checkout feature
# git rebase master

#                                                       feature
# コミット１← コミット２ ← コミット3'
# 　　　　　　　master

# コミット３の親コミットがコミット１からコミット２に変わった。

# git checkout master
# git merge feature

# 　　　　　　　　　　　　　　feature
# コミット１← コミット２ ← コミット3'
#                                                         master

# Fast forwardなので、マージの際に新しいコミットは生まれない。
# ※featureブランチが指し示すコミットがmasterブランチが指し示すコミットの直接の子コミットなので、Fast forwardでマージする。

# このようにリベースを使うことで、履歴を一直線にした上で他のブランチの変更分を取り込むことができる。

# リベースとマージの違い

# なぜリベースというかと言うと、featureブランチの親となるコミットつまりベースとなるコミットをリベースしているつまり新しく親コミットを切り替えているから。
# base == 親コミット re == 改める

# [リベース]

# 　　　　　　　　　　　　　　feature
# コミット１← コミット２ ← コミット3'
#                                                         master


# [マージ]

#  feature
# コミット３ ←---------------------------------
# 　　↓                                                   |
# コミット１← コミット２ ← マージコミット
#                                                          master

# リベースもマージもfeatureブランチを取り込んでいる。
# リベースは履歴が一直線に並んでいる。
# マージは履歴が枝分かれしている。


# git status
# git branch
# git branch feature
# git branch

# vim master2.html
# git add .
# git commit -v

# git checkout feature
# vim feature2.html
# git add .
# git commit

# git rebase master
# git log

# git checkout master
# git merge feature
# git log

# git push origin master
# git log
# git checkout master
# git branch -d feature


# git config --global merge.ff false
# Fast forwardを禁止にし、Auto Mergeにするモード。Gitエディタが立ち上がる。
# 作業の履歴を残すため。
# Fast Forwardすると、別のブランチで作業した内容がどこまで別のブランチで作業したのかmasterで作業したのか分からなくなってしまう。
# いつもマージコミットを作るようにしておけば、そのマージコミットがある場所で別のブランチで作業してそれを取り込んだということがわかる。


# --------------------

#* 55. リベースでしてはいけないこと

# GitHubにプッシュしたコミットをリベースするのはNG

# GitHubにプッシュしたコミットをリベースすると・・・

# [ローカル]
#                                  master
# コミット１← コミット３ ← コミット２'
#                                                        feature

# ↓ pushできなくなる！コミット１の次のコミットが２と３で異なるから。

# [GitHub]

# master
# コミット１← コミット２
#                             feature

# GitHubはローカルとリモートで履歴に矛盾が生じた場合、リモートの履歴を優先させる。ゆえに、ローカルで新しくpushされたデータは受けとらない。

# GitHUbにプッシュしたコミットをリベースするのはNG
# git push -f は絶対NG。Gitの履歴が完全に壊れてしまう。

# もしGitHubにプッシュした内容を修正したい場合は、コミットの履歴を修正するのではなく、もう一度作業して新しいコミットをしてその内容を修正するようにする。


# --------------------

#* 56. リベースとマージのどちらを使う？

# マージかリベースかは考え方次第

# [マージ]
# + コンフリクトの解決が比較的簡単
# - マージコミットがたくさんあると履歴が複雑化する
# ※作業の履歴を残したいならマージを使う

# [リベース]
# + 履歴をきれいに保つことができる
# - コンフリクトの解決が若干面倒(コミットそれぞれに解消が必要)
# ※作業履歴を残す必要が無く、履歴をきれいにしたいならリベースを使う

# マージとリベースのコンフリクトの違い

# [マージ]
# マージの場合、コンフリクトが1度しか発生しない

# [リベース]
# コンフリクトが各コミットごとに発生する

# リベースに含まれるコミットが複数あった場合、それぞれのコミットごとにリベースを実行して全部のコミットのリベースが完了した時点でリベースが完了するという挙動をする。


# 方針：
# ・プッシュしていないローカルの変更にはリベースを使い、プッシュした後はマージを使おう

# ・コンフリクトしそうならマージを使おう
# →チームで開発している場合は、他の人がどのような変更をしているのか把握しておいて、それでコンフリクトしそうか判断する
# →一回ローカルの変更をGitHubにpushしてPull requestを作成する。するとGitHubは親切にもコンフリクトしている場合、GitHub上でコンフリクトしているよとアラートを表示してくれる。アラートが出たら、その場合はマージを使って変更内容を取り込む。


# --------------------

#* 57. プルの設定をリベースに変更する

# プルにはマージ型とリベース型がある

# プルのマージ型
# git pull <リモート名><ブランチ名>
# git pull origin master

# ※マージコミットが残るから、マージしたという記録を残したい場合に使おう


# プルのリベース型
# git pull --rebase <リモート名><ブランチ名>
# git pull --rebase origin master

# ※マージコミットが残らないから、GitHubの内容を取得したいだけの時は --rebaseを使う

# GitHub上のmasterブランチの最新の内容を取得したいだけなら、--rebaseをつける。


# プルをリベースに設定する

# git config --gloabl pull.rebase true

# # masterブランチでgit pullする時だけ
# git config branch.master.rebase true

# ※--rebaseオプションを付けなくてもgit pullの挙動がリベース型になる


# [PC全体]
# ~/.gutconfig
# ~/.config/git/config
# ※--globalを付けるとPC全体の設定になる

# [ローカルリポジトリ]
# project/.git/cofig


# --------------------

#* 58. リベースで履歴を書き換える①

# コミットをきれいに整えてから、pushしたい時は履歴を書き換えよう。
# ※GitHubにpushしていないコミット

# 直前のコミットをやり直す
# git commit --amend
# ※リモートリポジトリにpushしたコミットはやり直したらダメ。


# 複数のコミットをやり直す
# git rebase -i <コミットID>
# git rebase -i HEAD~3
# // 直前３つのコミットのやり直しができる
# //まずコミットエディタが立ち上がる

# pick コミットID コミットメッセージ

# ※-iは--interactiveの略。対話的リベースといって、やり取りしながら履歴を変更していく。

# # やり直したいcommitをeditにする
# // するとこのコミットのところをリベースして修正することができるようになる
# edit コミットID コミットメッセージ

# # やり直したら実行する
# git commit --amend

# # 次のコミットへ進む(リベース完了)
# git rebase --continue


# コミットの指定の方法

# HEAD~3 ----- HEAD~2 ------- HEAD~1(HEAD^1) ------- HEAD
#                                                                                               |
#                                                                                             HEAD^2

# HEAD~
# １番目の親を指定する。
# HEADを基点にして数値分の親コミットまで指定する。

# HEAD^
# マージした場合の２番目の親を指定する。


# rebase -i コマンドの一連の流れ

# HEAD~3 ----- HEAD~2 ------- HEAD~1------- HEAD
#                         edit                     pick              pick

# git rebase -i HEAD~3と入力すると、HEAD~3を起点として、それ以降のgitをリベースしていく。つまり、HEAD~2以降の内容をリベースして修正していく。

# ①git rebase -iコマンドで対話的リベースモードに入る
# ②修正したいコミットをeditにしてコミットエディタうを終了する
# ③editのコミットのところでコミットの適用が止まる

# ④git commit --amendコマンドで修正
# // HEAD~2がeditなので、ここのコミットを修正

# ⑤git rebase --continueで次のコミットへいく

# ⑥pickだとそのままのコミット内容を適用して次にいく
# // HEADまで来ると、そこで対話的リベースモードが自動的に終了する



# touch first.html
# git add first.html
# git commit -m "first.htmlを追加"

# touch second.html
# git add second.html
# git commit -m "second.htmlを追加"

# touch third.html
# git add third.html
# git commit -m "third.htmlを追加"

# git log --oneline

# ３つのコミットの履歴(履歴順やコミットメッセージ、内容)を修正していく。

# git rebase -i HEAD~3

# third.htmlのコミットメッセージを修正
# pick -> edit

# Stopped at 5cdc6ca...  third.htmlを追加
# You can amend the commit now, with

#   git commit --amend

# Once you are satisfied with your changes, run

#   git rebase --continue

# コミットをやり直したい場合は、
#  git commit --amend

# amendした後、もうこれ以上変更しなくてもいい場合は、
# git rebase --continue
# をして、次の修正(edit)へ。

# コミットメッセージを修正したいだけなら、
#  git commit --amend
# だけでいいが、ファイルの内容を修正したい場合は、ステージングからやり直してから、git commit --amendするように。

# git commit --amend
# git log
# * (no branch, rebasing master)
# // この段階ではno branchでHEADがどのブランチも指していない

# git rebase --continue
# // これでHEADがmasterブランチを指すようになった
# git rebase --continue

# git status


# --------------------

#* 59. リベースで履歴を書き換える②

# コミットを並び替える、削除する

# git reabase -i HEAD~3

# pick コミットID コミットメッセージ

# pick gh21f6d ヘッダー修正
# pick 193054e ファイル追加
# pick 84gha0d README修正

# ※履歴は古い順に表示される。git logとは逆！
# ※リベースを適用するコミット順に表示されている。git rebase -iは基盤となるコミットがあって、そのコミット以降のリベース対象のコミットが書かれている。その元となるコミット以降のコミットを順にリベースしていくのでこのような順番になっている。

# # ①84gha0dのコミットを消す
# # ②193054eを先に適用する
# pick 193054e ファイル追加
# pick gh21f6d ヘッダー修正

# ※コミットを削除したり、並び替えたりできる


# git log --oneline -n 3

# git reabse -i HEAD~3
#   1 pick 7caf5a0 first.htmlを追加
#   2 pick f0bb4df second.htmlを追加
#   3 pick e3cbc4a third.htmlを追加しました

# ↓修正

#   1 pick f0bb4df second.htmlを追加
#   2 pick 7caf5a0 first.htmlを追加
#   3 pick e3cbc4a third.htmlを追加しました

# git log --oneline -n 3
# bcb0258 (HEAD -> master) third.htmlを追加しました
# fa06858 first.htmlを追加
# 1de3317 second.htmlを追加


# コミットをまとめる

# git rebase -i HEAD~3

# pick gh21f6d ヘッダー修正
# pick 193054e ファイル追加
# pick 84gha0d README修正

# # コミットを１つにまとめる
# pick gh21f6d ヘッダー修正
# squash 193054e ファイル追加
# squash 84gha0d README修正

# ※squashを指定するとそのコミットを直前のコミットとひとつにまとめる
# ※squash: 押しつぶす、ぺちゃんこにする

# ※一番古いコミットをpickのままにしておいて、それ以外をsquashにすると、すべてのコミットがひとまとめになる

# git rebase -i HEAD~3

#   1 pick 1de3317 second.htmlを追加
#   2 squash fa06858 first.htmlを追加
#   3 squash bcb0258 third.htmlを追加しました

# git log --oneline
# 50112d8 (HEAD -> master) second.htmlを追加

# ls
# feature2.html  first.html  index.html    master.html  secret.txt
# feature.html   home.html   master2.html  second.html  third.html

# ファイルもひとつにまとまった。



# コミットを分割する

# git rebase -i HEAD~3

# pick gh21f6d ヘッダー修正
# pick 193054e ファイル追加
# pick 84gha0d README修正とindex修正

# # コミットを分割する
# pick gh21f6d ヘッダー修正
# pick 193054e ファイル追加
# edit 84gha0d README修正とindex修正

# git reset HEAD^
# git add README
# git commit -m "README修正"
# git add index.html
# git commit -m "index.html修正"
# git rebase --continue

# ※git resetはコミットを取り消してステージングしていない状況まで戻すコマンド。HEAD^というのがeditと記載しているコミットを指す。

# ※【訂正】HEAD^ に関する説明
# 7:32のあたりの git reset HEAD^ の説明のところで、「HEAD^」は「edit」に変更したコミットのことを指す、と説明しました。
# こちらは誤りで、HEAD^はHEADの1つ前のコミットを表すので、正しくは「193054e ファイル追加」のコミットを指します。

# git reset HEAD^ とすると、「193054e ファイル追加」の状態に戻すので、結果として「84gha0d READMEとindex修正」のコミットが取り消される形になります。


# git log --oneline -n 3

# git rebase -i HEAD~3

#   1 pick d685036 master2を新規作成
#   2 pick 689f057 feature2を新規作成
#   3 pick 50112d8 second.htmlを追加

# ↓

#   1 pick d685036 master2を新規作成
#   2 pick 689f057 feature2を新規作成
#   3 edit 50112d8 second.htmlを追加

# git reset HEAD^
# git status

# git add first.html
# git add second.html
# git commit -m "first.htmlとsecond.htmlを追加"

# git add third.html
# git commit -m "third.htmlを追加"

# git rebase --continue

# git log --oneline -n 3
# e9161da (HEAD -> master) third.htmlを追加
# cc1e392 first.htmlとsecond.htmlを追加
# 689f057 (origin/master) feature2を新規作成

# このようにrebaseコマンドを使うことで、コミットの順番を入れ替えたり、まとめたり、分割したり、削除したりできる。

# git push origin master
# ※pushする前に、ローカル(git log)とリモート(commits)の履歴に齟齬がないか確認する


# --------------------

#* 60. タグの一覧を表示する

# コミットを参照しやすくするためにわかりやすい名前を付けるのがタグ。
# よくリリースポイントに使う。

# タグの一覧を表示する

# git tag

# # パターンを指定してタグを表示
# git tag -l "201705"
# 20170501_01
# 20170501_02
# 20170503_01

# ※git tagコマンドはアルファベット順にタグを表示する


# コミット１← コミット２← コミット３
# 20170501_01                           20170501_02

# コミット１が2017/5/1に1回目にリリースしたリリースポイント、
# コミット２が2017/5/1に2回目にリリースしたリリースポイント
# という意味。


# --------------------

#* 61. タグを作成する

# タグには、注釈付き(annotated)版と軽量(lightweight)版の2種類がある。
# 注釈付き(annotated)版が正式なタグで、しっかりとした情報が付いたタグ(おすすめ)。
# 軽量(lightweight)版が情報量を減らした省略形式のタグ。

# タグを作成する(注釈付きタグ)

# git tag -a <タグ名> -m "<メッセージ>"

# git tag -a 20170520_01 -m "version 20170520_01"

# ※-aオプションを付けると注釈付きタグを作成する
# ※-mオプションを付けるとエディタを立ち上げずにメッセージを入力できる



# コミット１← コミット２← コミット３
# 20170501_01                           20170501_02

# ↑
# ・名前を付けられるだけでなく、
# ・コメントを付けられる
# ・署名をつけられる(誰がこのタグを付けたか)


# タグを作成する(軽量版タグ)

# git tag <タグ名>
# git tag 20170520_01

# # 後からタグ付けする
# git tag <タグ名> <コミットID>
# git tag 20170520_01 8a6cbc4

# ※オプションを付けないと軽量版タグを作成する

# コミット１← コミット２← コミット３
# 20170501_01                           20170501_02

# ↑
# ・名前を付けられるだけ

# タグのデータを表示する

# git show <タグ名>
# git show 20170520_01

# ※タグのデータと関連付けられたコミットを表示する

# コミット１← コミット２← コミット３
# 20170501_01                           20170501_02

# ↑
# ・名前を付けした人の情報
# ・タグ付けした日時
# ・注釈メッセージ
# ・コミット


# git tag -a "20211124" -m "version 20211124"

# git tag
# 20211124

# git show 20211124

#  //タグ名
# tag 20211124
# // 名前を付けした人の情報
# Tagger: kazuaki_ubuntu220811 <0chlbv7420t18063263g7t20@gmail.com>
# // タグ付けした日時
# Date:   Tue Nov 23 02:19:05 2021 +0000

# // 注釈メッセージ
# version 20211124

# // コミット情報
# commit e9161dabc159d37fbdadb9dc54dec55bc1f08daf (HEAD -> master, tag: 20211124, origin/master)
# Author: kazuaki_ubuntu220811 <0chlbv7420t18063263g7t20@gmail.com>
# Date:   Tue Nov 23 00:37:52 2021 +0000

#     third.htmlを追加

# diff --git a/third.html b/third.html
# new file mode 100644
# index 0000000..e69de29


# タグはリリースしたポイントにタグ名を付けておくことで、バグが起きたときに後で修正がしやすくなったり、いつ何をリリースしたかが分かりやすくなったりする。



# ※後からタグを付けることは注釈付きタグでも軽量版タグでも可能。

# git tag -a <タグ名><コミットID>


# --------------------

#* 62. タグをリモートリポジトリに送信する

# タグをリモートに送信するには、git pushコマンドで別途指定する
# git pushではタグは送信されないため。


# タグをリモートリポジトリに送信する
# git push <リモート名><タグ名>
# git push origin 20170520_01

# # タグを一斉に送信する
# git push origin --tags

# ※--tagsを付けるとローカルにあってリモートリポジトリに存在しないタグを一斉に送信する


# [リモートリポジトリ]

# ↑ git push origin 20170520_01

# [ローカルリポジトリ]
# コミット１ー 20170520_01



# git tag
# git push origin 20211124

# GitHub
# tag → Tags


# --------------------

#* 63. 作業を一時避難しよう

# 作業が途中でコミットしたくないけど、別のブランチで作業しないといけない。そういう時に作業を一次避難する。


# 作業を一次非難する

# git stash
# git stash save // saveは省略可

# ※stashは「隠す」という意味


# [stash]

# [ステージ]
# top.hrml(変更)

# [ワークツリー]
# index.html(変更)

# この状況でバグが発生！バグ修正用のブランチを立ち上げて、バグを修正しなければならなくなった。


# [stash]
# top.hrml(変更)
# index.html(変更)

# // 変更分をstashに一次避難し、ワークツリーとステージの変更を無かったことにし、別のブランチで作業できるようにする

# ↑ git stash

# [ステージ]


# [ワークツリー]

# git status
# vim home.html

# git status
# Changes not staged for commit:
#   (use "git add <file>..." to update what will be committed)
#   (use "git restore <file>..." to discard changes in working directory)
# 	modified:   home.html

# git stash
# Saved working directory and index state WIP on master: e9161da third.htmlを追加

# git status
# On branch master
# Your branch is up to date with 'origin/master'.

# nothing to commit, working tree clean


# cat home.html
# <p>home</p>
# <p>git pull</p>

# // ファイルの変更分も無かったことになってる


# --------------------

#* 64. 避難した作業を確認しよう

# 避難した作業を確認する

# git stash list

# ※避難した作業の一覧を表示する


# [stash]
# 避難作業１[
# top.hrml(stage)
# index.html(worktree)
# ]
# 避難作業２ [
# top.html(stage)
# index.html(stage)
# ]

# ↑

# [ステージ]

# [ワークツリー]


# git stash list
# stash@{0}: WIP on master: e9161da third.htmlを追加

# stash@{0}
# stash@{1}
# stash@{2}
# とstashを追加するとこうなる。


# --------------------

#* 65. 避難した作業を復元しよう

# 避難した作業を復元する

# # 最新の作業を復元する
# git stash apply
# // ステージの状況までは復元されない

# # ステージの状況も復元する
# git stash apply --index

# # 特定の作業を復元する
# git stash apply <スタッシュ名>
# git stash apply stash@{1}

#  ※applyは適用という意味

# ※stash@の番号は一番最新の避難したstash@が0となる。

# [stash]

# stash@{1}[
# top.hrml(stage)
# index.html(worktree)
# ]

# stash@{0} [
# top.html(stage)
# index.html(stage)
# ]

# ↑

# [ステージ]

# [ワークツリー]



# [stash]

# stash@{1}[
# top.hrml(stage)
# index.html(worktree)
# ]

# ↓ git stash apply --index

# [ステージ]

# top.html(変更)
# index.html(変更)

# [ワークツリー]

# git status

# // home.html(worktree)

# git stash apply

# On branch master
# Your branch is up to date with 'origin/master'.

# Changes not staged for commit:
#   (use "git add <file>..." to update what will be committed)
#   (use "git restore <file>..." to discard changes in working directory)
# 	modified:   home.html

# no changes added to commit (use "git add" and/or "git commit -a")

# cat home.html
# <p>home</p>
# <p>git pull</p>
# <p>git stash</p>


#* --------------------

# 66. 避難した作業を削除しよう

# 避難した作業を削除する

# # 最新の作業を削除する
# git stash drop

# # 特定の作業を削除する
# git stash drop <スタッシュ名>
# git stash drop stash@{1}

# # 全作業を削除する
# git stash clear



# [stash]

# 2回目のgit stash dropで削除された
# #stash@{1}[
# #top.hrml(stage)
# #index.html(worktree)
# #]

# １回目のgit stash dropで削除された
# #stash@{0} [
# #top.html(stage)
# #index.html(stage)
# #]

# ↑

# [ステージ]

# [ワークツリー]

# git stash list
# stash@{0}: WIP on master: e9161da third.htmlを追加
# // スタッシュを復元しても、スタッシュは残るので、復元したら削除する

# git stash drop
# Dropped refs/stash@{0} (02354272d663e9f9b8f22d2e67b0bcc595d5c9ee)


# 最後にhome.htmlの変更を取り消す
# git status
# git checkout home.html

# git stashコマンドは今作業中で急遽別の作業をしなければならないとき、特にbugfixで使うと便利

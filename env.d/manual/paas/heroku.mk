#todo [Heroku Tips]


# !!!! Heroku有料化 !!!!
# https://www.udemy.com/course/nestjs-nextjs-restapi-react/learn/lecture/33696222#questions


# ------------

# 記事
# https://snow-cat.net/?p=959


#* ①事前準備

# ・Githubの登録
# ・Herokuに登録
# ・Herokuにクレジットカードの登録
# ・HerokuのCLIのインストール

# ------------

#* ②Laravel設定

# ・config/database.phpの設定

# $db = parse_url(env('DATABASE_URL'));

# 'cleardb' => [
#             'driver' => 'mysql',
#             'url' => env('DATABASE_URL'),
#             'host' => $db['host'],
#             'port' => env('DB_PORT', '3306'),
#             'database' => ltrim($db['path'], '/'),
#             'username' => $db['user'],
#             'password' => $db['pass'],
#             'unix_socket' => env('DB_SOCKET', ''),
#             'charset' => 'utf8mb4',
#             'collation' => 'utf8mb4_unicode_ci',
#             'prefix' => '',
#             'prefix_indexes' => true,
#             'strict' => true,
#             'engine' => null,
#             'options' => extension_loaded('pdo_mysql') ? array_filter([
#                 PDO::MYSQL_ATTR_SSL_CA => env('MYSQL_ATTR_SSL_CA'),
#             ]) : [],
#         ],


# ・環境の切り替え m sw paas=heroku

# ・プロキシ設定
# TrustProxies.php
# ⑴ protected $proxies = '**';
# ⑵ protected $headers = Request::HEADER_X_FORWARDED_AWS_ELB;

# ・Procfile作成
mkproc:
	echo 'web: vendor/bin/heroku-php-apache2 public/' > backend/Procfile

# Appacheの場合:
# web: vendor/bin/heroku-php-apache2 public/

# NginXの場合:
# web: vendor/bin/heroku-php-nginx public/

# ------------

#* ③Herokuにログイン

# ・Herokuにログイン h-login
# ・Herokuコンテナレジストリにログイン h-container-login

# Herokuにログイン
h-login:
	heroku login

h-auth-login:
	heroku auth:login

# Herokuコンテナレジストリにログイン(Dockerを使う場合)
h-container-login:
	heroku container:login

# ------------

#* ④Herokuアプリを作成

# ・Herokuアプリの作成 h-create

# ・後々必要になる設定
# https://tools.heroku.support/limits/boot_timeout

# Herokuアプリ作成(アプリ名：<環境>-<アプリ名>-<ユーザ名>)
h-create:
	heroku create $(app)

h-create-remote:
	heroku create $(app) --remote $(app)

# remote repository を登録
h-git-remote:
	heroku git:remote -a $(app)

# ------------

#* ⑤ClearDBアドオンの追加・DB作成

# ・ClearDBアドオンの追加 h-addons-create-cleardb

# ClearDBアドオンの追加
h-addons-create-cleardb:
	heroku addons:create cleardb:ignite -a $(app)

# ClearDBのドキュメントの確認
h-addons-docs-cleardb:
	heroku addons:docs cleardb

# ------------

#* ⑥buildpackの設定

# buildpackの登録
# https://tech.innovator.jp.net/entry/2018/10/22/131853

#^ Heroku UIで手動で設定した方が確実

# ・heroku-buildpack-monorepoの場合：
# heroku buildpacks:set https://github.com/lstoll/heroku-buildpack-monorepo
# heroku buildpacks:set heroku/php
h-config-set-base:
	heroku config:set APP_BASE=backend/ -a $(app)

# ・subdir-heroku-buildpackの場合：
# heroku buildpacks:set https://github.com/timanovsky/subdir-heroku-buildpack
# heroku buildpacks:set heroku/php
h-config-set-path:
	heroku config:set PROJECT_PATH=backend/ -a $(app)

h-buildpacks-set:
	heroku buildpacks:set $(bp) -a $(app)

# buildpack確認
h-buildpacks:
	heroku buildpacks

# buildpackの削除
h-buildpacks-remove:
	heroku buildpacks:remove $(bp) -a $(app)

# サードパーティbuildpackの検索
h-buildpacks-search:
	heroku buildpacks:search $(bp)
h-buildpacks-info:
	heroku buildpacks:info $(bp)
h-buildpacks-clear:
	heroku buildpacks:clear

# ------------

#* ⑦Herokuに環境変数登録

# ・APP_KEY h-config-set-appkey
# ・LOG_CHANNEL h-config-set-logchannel
# ・DARABASE_URL DB_CONNECTION h-config-set-cleardb
# ・PROJECT_PATH h-config-set-path
# ・DATABASE_URLに値を代入

# 一括で環境変数登録
h-config-set-all:
	@make h-config-set-appkey
	@make h-config-set-logchannel
	@make h-config-set-cleardb
	@make h-config-set-path
# @make h-config-set-base

# Herokuに環境変数登録
h-config-set:
	heroku config:set $(key)=$(val) -a $(app)
h-config-unset:
	heroku config:unset $(key) -a $(app)

# アプリキーをHerokuに設定
h-config-set-appkey:
	heroku config:set APP_KEY="$$(make keyshow | grep base64)" -a $(app)

# ログの書き込み先を設定
h-config-set-logchannel:
	heroku config:set LOG_CHANNEL=errorlog -a $(app)

# HerokuのDB接続先情報を確認
h-config:
	heroku config -a $(app)
h-config-info:
	heroku config -a $(app) | grep $(key)

# DB接続方式の指定
h-config-set-dbconnection:
	heroku config:set DB_CONNECTION=$(db) -a $(app)

# CLEARDB_DATABASE_URLをHerokuに登録
h-config-set-cleardb:
	heroku config:set DATABASE_URL="$$(heroku config -a $(app) | grep CLEARDB_DATABASE_URL | awk '{print $$2}')" -a $(app)
	@make h-config-set-dbconnection db=cleardb

# ------------

#* ⑧Dockerイメージをビルド・リリース

# ・heroku.yml作成
# ・ローカルのサーバを削除 m down
# ・Dockerイメージをビルドして、コンテナレジストリにビルドしたイメージをpush
# ・コンテナレジストリにあげたイメージからHerokuの方からDockerイメージをリリース

# イメージをビルドし、Container Registry にプッシュ
h-container-push:
	heroku container:push web -a $(app)

# イメージをアプリにリリース
h-container-release:
	heroku container:release web -a $(app)

# ------------

#* ⑨公開

# Laravelプロジェクト配下で、git init
# コミット g add . g c -m "first commit"
# リモートリポジトリ h-remote
# デプロイ h-deploy

h-remote:
	heroku git:remote -a $(app)
h-deploy:
	git push heroku master
h-deploy-dev:
	git push heroku develop:main --force

# マイグレーション
h-mig:
	heroku run "php artisan migrate" -a $(app)
h-mig-seed:
	heroku run "php artisan migrate --seed" -a $(app)
h-seed:
	heroku run "php artisan db:seed" -a $(app)

# ブラウザに表示
h-open:
	heroku open -a $(app)

# その他
# Herokuからログアウト
h-logout:
	heroku logout

# ログの確認
h-logs:
	heroku logs -t -a $(app)

# 開発環境での変更をHerokuに反映
h-push:
	@make down
	@make h-container-push
	@make h-container-release
	@make h-open

# PostgreSQL
h-addons-create-posgresql:
	heroku addons:create heroku-postgresql:hobby-dev -a $(app)

# Redis
h-addons-create-redis:
	heroku addons:create heroku-redis:hobby-dev -a $(app)


# ==== UI利用版 ====

# ⑴ ログイン

# https://jp.heroku.com/home

# ↓

# Herokuにログイン


# --------------------

# ⑵ アプリの作成

# https://dashboard.heroku.com/apps

# New → Create new app

# ↓

# アプリ名: 一意

# Create app

# ↓


# --------------------

# ⑶ アドオンの追加

# https://dashboard.heroku.com/apps

# Overviewの選択

# ↓

# Installed add-ons の Configure Add-ons を選択

# ↓

# Add-ons で 追加したいアドオン名で検索

# 例) postgres で検索し、「Heroku Postgres」を選択

# ⬇️

# Submit Order Form

# ⬇️

# 以下が表示されれば成功

# The add-on heroku-postgresql has been installed. Check out the documentation in its Dev Center article to get started.


# --------------------

# ⑷ 追加したアドオンがLaravelで使用できるように設定

# https://dashboard.heroku.com/apps

# Settingsの選択

# ↓

# Reveal Config Varsの選択

# ※ Herokuアプリケーションの環境変数を確認、設定するための画面

# ↓

# 環境変数DATABASE_URLの値の確認

# DATABASE_URLの値をペースト

# 例)
# DATABASE_URL

# postgres://qvbnvcwfhlwltp:2fb623b48495eb6c8988b215f30f4f38e6bbde6cddfeecdd232f2535e6ff97ae@ec2-3-224-164-189.compute-1.amazonaws.com:5432/dcopsj6jjple01

# ↓

# Laravelのデータベース関連の環境変数を確認

# ※DATABASE_URLの値は、以下のような形式になっている

# 例)

# postgres://(ユーザー名):(パスワード)@(ホスト名):5432/(データベース名)

# 上記を元にすると、Laravelのデータベース関連の環境変数は以下となる。


# DB_CONNECTION=pgsql
# DB_HOST=上記のホスト名(ec2-xxx...amazonaws.comという文字列)
# DB_PORT=5432
# DB_DATABASE=上記のデータベース名(14文字程度)
# DB_USERNAME=上記のユーザー名名(14文字程度)
# DB_PASSWORD=上記のパスワード(64文字程度)

# ↓

# これらをConfig VarsでHerokuの環境変数に設定する


# --------------------

# ⑸ データベース関連以外の環境変数をHerokuに設定

# Settingsを選択

# ↓

# Reveal Config Varsを選択

# ↓

# APP_KEYの設定

# ※Laravelを動かす環境では、環境変数APP_KEYが設定されている必要がある

# APP_KEYの発行
# docker-compose exec <コンテナ名> php artisan key:generate --show


# ※なお、現在laravel/.envに記述されているAPP_KEYの値を設定してもHeroku上のLaravelは動きます。

# しかし、APP_KEYはLaravelでの各種の暗号化などに関わる値であるので、開発環境と、Herokuのような本番環境では異なる値を設定するのが一般的


# 例) base64:FwF7CkbIWyJQ2TotvX+6DI6erN3YEFJnXhgk5wvh/FY=

# 上記をAPP_KEYとしてHeroku登録


# ↓

# APP_URLの設定

# Herokuでは、APP_URLを以下のように設定してください。

# https://(Herokuのアプリケーション名).herokuapp.com

# ※なお、herokuapp.comの最後には/を付けないよう注意してください。


# ↓

# Sendgrid/Google関連の環境変数の設定

# laravel/.envの以下の環境変数をHerokuの環境変数に設定



# #Sendgrid
# MAIL_DRIVER=smtp
# MAIL_HOST=smtp.sendgrid.net
# MAIL_PORT=587
# MAIL_USERNAME=apikey
# MAIL_PASSWORD=SG.xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
# MAIL_ENCRYPTION=tls
# MAIL_FROM_NAME=memo
# MAIL_FROM_ADDRESS=(6章のパート8の「5. 送信元メールアドレスの受信確認」で使用したメールアドレス)


# # Google
# GOOGLE_CLIENT_ID=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.apps.googleusercontent.com
# GOOGLE_CLIENT_SECRET=xxxxxxxxxxxxxxxxxxxxxxxx


# --------------------

# ⑹ Herokuのビルドに関する設定

# https://www.techpit.jp/courses/11/curriculums/12/sections/106/parts/381


# 前提：

# あなたの開発環境のPCには、

# laravel/vendorディレクトリには、LaravelのフレームワークのコードやLaravel SocialiteといったPHPのライブラリ
# laravel/node_modulesディレクトリには、Vue.jsなどのJavaScriptのフレームワーク
# laravel/public/jsディレクトリには、Laravel MixでコンパイルされたJavaScript
# などが入っています。

# これらのファイルは、Herokuには直接デプロイせず、Heroku上で改めてインストール、コンパイルするようにします。

# こうした一連の作業をビルドと呼びます(デプロイした際にHerokuが自動で行なってくれます)。


# --------------------

# ① buildpackの追加

# Settingsの選択

# ↓

# Add buildpackの選択

# ↓

# ・node.jsの選択

# ・同様にして PHPの選択


# ....................

# ② package.jsonの編集

# ※ HerokuでJavaScriptをコンパイルするための設定

# laravelのpackage.jsonを開く

# ↓

# 以下を追記

# "scripts": {
#         "heroku-postbuild": "npm run prod",


# 上記の設定を追加したことで、Herokuへデプロイした際に、Herokuがnpm run prodを実行してJavaScriptをコンパイルしてくれるようになります。

# Customizing the build process - Heroku公式(英語)
# https://devcenter.heroku.com/articles/nodejs-support#customizing-the-build-process


# ....................

# ③ composer.jsonの編集とcomposer.lockの更新

# 本教材のアプリケーションはPHP8系の環境でcomposer installを行うと、エラーになります。

# そのため、Heroku環境のPHPバージョンを8系ではなく、7系になるようにします

# laravelのcomposer.json

# ↓

# {
#   "name": "laravel/laravel",
#   "type": "project",
#   "description": "The Laravel Framework.",
#   "keywords": [
#     "framework",
#     "laravel"
#   ],
#   "license": "MIT",
#   "require": {
#     "php": "^7.2.5",　//-- この行を編集( |^8.0 の部分を削除)
# // 略

# ↓

# 編集したcomposer.jsonの内容に基づいてcomposer.lockを更新

# docker compose exec workspace php -d memory_limit=-1 /usr/bin/composer update


# 上記の設定を行ったことで、Herokuへデプロイした際に、HerokuにPHP8系ではなく、PHP7系がインストールされるようになります。


# Heroku PHP Support - Heroku公式(英語)
# https://devcenter.heroku.com/articles/php-support#selecting-a-runtime


# --------------------

# ⑺ Procfileの作成

# https://www.techpit.jp/courses/11/curriculums/12/sections/106/parts/382

# Heroku での PHP アプリのデプロイ
# https://devcenter.heroku.com/ja/articles/deploying-php


# laravelプロジェクト配下に、Procfileを作成

# 以下をペーストして編集

# web: vendor/bin/heroku-php-apache2 public/

# ※ HerokuでのWebサーバーにはApacheを使用し、そのドキュメントルートがpubllic/という意味。


# --------------------

# ⑻ Herokuへのデプロイとデータベースマイグレーション


# https://www.techpit.jp/courses/11/curriculums/12/sections/106/parts/375

# ① Heroku CLIでのHerokuログイン

# heroku login


# ....................

# ② Herokuへのデプロイ

# Herokuへのデプロイは、Gitコマンドを使って実施

# Herokuで公開する、Laravelプロジェクト配下で、

# $ git init
# $ git add .
# $ git commit -m "first commit"

# ↓

# $ heroku git:remote -a herokuのアプリケーション名

# ↓

# 以下が表示。

# set git remote heroku to https://git.heroku.com/herokuのアプリケーション名.git

# ↓

# $ git push heroku master

# ↓

# 以下が表示されれば、デプロイ完了

# remote: Verifying deploy... done.
# To https://git.heroku.com/laravel-simple-sns.git
#  * [new branch]      master -> master


# ....................

# ③ データベースのマイグレーション

# Herokuからデータベース(PostgreSQL)に接続できるよう設定済みですが、まだテーブルを作成していません。

# そこで、Laravelのマイグレーションコマンドを使ってテーブルを作成します。

# $ heroku run php artisan migrate

# ※ heroku run (実行したいコマンド)で、Heroku上でコマンドを実行できます。

# ↓

# Do you really wish to run this command? (yes/no) [no]:

# yes

# ↓

# 以下のような表示がされれば、マイグレーションが完了。
# Heroku上にアップしたマイグレーションファイルから、Heroku上でテーブルが作成された。

# Migration table created successfully.
# Migrating: 2014_10_12_000000_create_users_table
# Migrated:  2014_10_12_000000_create_users_table (0.1 seconds)
# Migrating: 2014_10_12_100000_create_password_resets_table
# Migrated:  2014_10_12_100000_create_password_resets_table (0.04 seconds)
# Migrating: 2019_08_19_000000_create_failed_jobs_table
# Migrated:  2019_08_19_000000_create_failed_jobs_table (0.05 seconds)
# Migrating: 2020_01_23_221657_create_articles_table
# Migrated:  2020_01_23_221657_create_articles_table (0.07 seconds)
# Migrating: 2020_02_14_212406_create_likes_table
# Migrated:  2020_02_14_212406_create_likes_table (0.03 seconds)
# Migrating: 2020_02_16_205740_create_tags_table
# Migrated:  2020_02_16_205740_create_tags_table (0.07 seconds)
# Migrating: 2020_02_16_205945_create_article_tag_table
# Migrated:  2020_02_16_205945_create_article_tag_table (0.04 seconds)
# Migrating: 2020_02_18_100555_create_follows_table
# Migrated:  2020_02_18_100555_create_follows_table (0.05 seconds)


# ....................

# ④ Heroku上のWebサービスにアクセスする

# 以下にアクセスする

# https://herokuのアプリケーション名.herokuapp.com

# もしくは、

# heroku open -a herokuのアプリケーション名


# ------------------------

# 🟣 Herokuで稼働するLaravelアプリケーションのエラー調査方法について

# Herokuのダッシュボード画面右上のMoreを押して、View logsを選択

# ↓

# ただし、status=500といったエラーが発生していることを示す情報までしかわからず、それ以上の詳細がログに出ていないため原因が調査できない、といったことがありえるかと思います。

# そこで、より詳細なエラー情報をログに出す方法を説明します。

# エラー発生前からあらかじめ設定しておく必要がありますが、Herokuアプリケーションの環境変数にLOG_CHANNEL=errorlogを設定しておいてください。


# ------------------------

# 🟣 Herokuへの再デプロイについて

# 機能を追加し、Herokuに再デプロイしたい場合、

# Herokuへ再デプロイするにはlaravelプロジェクト配下で、以下のGitコマンドを順に実行してください。

# $ git add .
# $ git commit -m "更新した内容を説明する文章(日本語でも英語でも構いません)"
# $ git push heroku master


# ------------------------

# 🟣 Change Boot Timeout

# https://tools.heroku.support/limits/boot_timeout

# 60 → 120


# ------------------------

# 🟣 Herokuアプリの停止


# Heroku アプリの再起動
# heroku restart

# Heroku アプリの停止
# heroku ps:scale web=0

# Heroku アプリの起動
# heroku ps:scale web=1

# heroku ps:scale web=0 --app myAppName


# $ heroku maintenance:on
# Maintenance mode enabled.

# $ heroku maintenance:off
# Maintenance mode disabled.


# Herokuのアプリケーションの停止 / 再開
# https://qiita.com/akiko-pusu/items/dec93cca4855e811ba6c

# Heroku デプロイしてるサービスを一時停止する方法
# https://qiita.com/kokogento/items/a858c6b3cc66c5be6fff


# 使っていないHerokuアプリを停止してdynoの消費を節約する
# https://510052.xyz/posts/di3ie5cd6hdpqwjz2hnm/

#^ ※herokuはデフォルトで30分間アクセスがないと停止という仕様


# Heroku アプリ再起動、停止、起動コマンド
# https://codenote.net/heroku/3957.html


# 【無料】Herokuを初めて使う人に向けてのデプロイ(サービス公開)方法解説
# https://reffect.co.jp/html/%E3%80%90%E7%84%A1%E6%96%99%E3%80%91heroku%E3%82%92%E5%88%9D%E3%82%81%E3%81%A6%E4%BD%BF%E3%81%86%E4%BA%BA%E3%81%AB%E5%90%91%E3%81%91%E3%81%A6%E3%81%AE%E3%83%87%E3%83%97%E3%83%AD%E3%82%A4%E3%82%B5


# ==== Next.js + Laravel Sanctum のプロジェクトをデプロイする手順 ====

#* Laravel側(Heroku):

# ⑴ Herokuアカウントにログイン

# https://jp.heroku.com/home


# ....................

# ⑵ アプリの作成

# https://dashboard.heroku.com/apps

# New → Create new app

# ↓

# アプリ名: 一意

# Create app


# ....................

# ⑶ herokuにログイン

# make h-login
# or
# h login


# ....................

# ⑷ デプロイしてブラウザで確認

# デプロイ用にブランチを切る:
# g sw -c deploy

# Herokuのリモートリポジトリを登録:
# g r add heroku <Heroku上のアプリのURL>

# Laravelプロジェクトのソースだけをコミットしてpush:
# g add .
# g c -m '<コミットメッセージ>'
# git subtree push --prefix backend/ heroku <ブランチ名>:main

# ブラウザで確認:
# h open


# ....................

# ⑸ Laravel設定

# ・config/database.phpの設定

# $db = parse_url(env('DATABASE_URL'));

# 'cleardb' => [
#             'driver' => 'mysql',
#             'url' => env('DATABASE_URL'),
#             'host' => $db['host'],
#             'port' => env('DB_PORT', '3306'),
#             'database' => ltrim($db['path'], '/'),
#             'username' => $db['user'],
#             'password' => $db['pass'],
#             'unix_socket' => env('DB_SOCKET', ''),
#             'charset' => 'utf8mb4',
#             'collation' => 'utf8mb4_unicode_ci',
#             'prefix' => '',
#             'prefix_indexes' => true,
#             'strict' => true,
#             'engine' => null,
#             'options' => extension_loaded('pdo_mysql') ? array_filter([
#                 PDO::MYSQL_ATTR_SSL_CA => env('MYSQL_ATTR_SSL_CA'),
#             ]) : [],
#         ],


# ・環境の切り替え m sw paas=heroku

# ・プロキシ設定
# TrustProxies.php
# ⑴ protected $proxies = '**';
# ⑵ protected $headers = Request::HEADER_X_FORWARDED_AWS_ELB;

# ・Procfile作成
mkproc:
	echo 'web: vendor/bin/heroku-php-apache2 public/' > backend/Procfile

# Appacheの場合:
# web: vendor/bin/heroku-php-apache2 public/

# NginXの場合:
# web: vendor/bin/heroku-php-nginx public/


# ....................

# ⑹ アドオンの追加

# https://dashboard.heroku.com/apps

# Overviewの選択

# ↓

# Installed add-ons の Configure Add-ons を選択

# ↓

# Add-ons で 追加したいアドオン名で検索

# 例) postgres で検索し、「Heroku Postgres」を選択

# ⬇️

# Submit Order Form

# ⬇️

# 以下が表示されれば成功

# The add-on heroku-postgresql has been installed. Check out the documentation in its Dev Center article to get started.


# --------------------

#* Next.js側(Vercel)


# ==== Tips ====

#? 設定手順

# herokuにdocker-composeを使ってLaravel製個人アプリを作成する方法
# https://snow-cat.net/?p=959

#~ アプリの作成

# ⑴ Dynoの作成

# heroku create app_name


# ⑵ Add-onsの登録

# - MySQL
# heroku addons:create cleardb:ignite

# - PostgreSQL
# heroku addons:create heroku-postgresql:hobby-dev

# - Redis
# heroku addons:create heroku-redis:hobby-dev


# ⑶ 環境変数の登録

# heroku config

#^ Laravelの環境変数は.envファイルを参照しますが、herokuではなぜか参照されない

# heroku config:set ENV_PARAM=param
#^ UIで設定した方が楽

# (例)

# - MySQL
# CLEARDB_DATABASE_URL: mysql://ggh389wg45nw7890:ac64bi56@us-cdbr-east-03.cleardb.com/heroku_56b4ky6hl74?reconnect=true

# ⬇️ (mysql://DB_USER_NAME:DB_PASSWORD@DB_HOST/DB_DATABASE)

# heroku config:add DB_NAME=heroku_56b4ky6hl74
# heroku config:add DB_USERNAME=ggh389wg45nw7890
# heroku config:add DB_PASSWORD=ac64bi56
# heroku config:add DB_HOSTNAME=us-cdbr-east-03.cleardb.com
# heroku config:add DB_PORT=3306


# - PostgreSQL
# DATABASE_URL: postgres://gbe3ousoggboeyr:52347056t4846b73oly6hyvo3yvoy7v63o67b3y6@ec2-11-111-111-111.compute-1.amazonaws.com:5432/4hv324vuy

# ⬇️ (postgres://USER_NAME:DB_PASSWORD@DB_HOST:DB_PORT/DATABASE)

# heroku config:add DB_HOST=ec2-11-111-111-111.compute-1.amazonaws.com
# heroku config:add DB_PORT=5432
# heroku config:add DB_DATABASE=4hv324vuy
# heroku config:add DB_USERNAME=gbe3ousoggboeyr
# heroku config:add DB_PASSWORD=52347056t4846b73oly6hyvo3yvoy7v63o67b3y6


# - Redis
# REDIS_URL: redis://:7v6l34u237l6v7627y274v5h5vl2by9285gb2po45builbvy2o84v2@ec2-11-111-111-11.compute-1.amazonaws.com:11059

# ⬇️ (redis://:REDIS_PASSWORD＠REDIS_HOST:REDIS_PORT)

# heroku config:add REDIS_HOST=ec2-11-111-111-11.compute-1.amazonaws.com
# heroku config:add REDIS_PASSWORD=7v6l34u237l6v7627y274v5h5vl2by9285gb2po45builbvy2o84v2
# heroku config:add REDIS_PORT=11059


# ⑷ buildpackの登録

# heroku buildpacks:add https://github.com/lstoll/heroku-buildpack-monorepo
# heroku buildpacks:add heroku/php

#^ 上のbuildpackがDockerfileがディレクトリ直下になくてもリリースできるようにするやつです。順番が大事みたいなので、気をつけてください。

#^ ちなみに、最初のビルドパックを使うためにはAPP_BASEの変数を設定する必要があります。

# heroku config:add APP_BASE=src

# 追加されたbuildpackは以下のコマンドで確認できます。
# heroku buildpacks


# ....................

#~ デプロイ

# デプロイする方法は以下の3種類あります。

#・gitを使用する方法
#・dockerを使用する方法
#・Terraformを使用する方法


#* gitでデプロイする仕組み:

# herokuでプロジェクトを作るとherokuプロジェクトのデプロイ用のリモートブランチが作成されます。そこにGithubとかで開発したコードをコミットするとデプロイされます。

# 以下のコマンドで remotes/heroku/mainブランチがあるか確認します。

# git branch -a

# デプロイは以下のコマンドで最新のブランチをリリースするブランチにpushします。
# git push heroku main


#! gitのデプロイに失敗する場合:

# git push heroku masterと打って以下のエラーが出てませんか？

# error: src refspec master does not match any
# error: failed to push some refs to 'https://git.heroku.com/app.git'
# masterは人種差別撤廃のためmainになっています。

# git push heroku mainのコマンドを打ってみてください。


#* procfileの作成

# アプリケーションのディレクトリにProcfileを作成して、以下のように記載してコミットします。

# web: vendor/bin/heroku-php-apache2 public/


#* 追加の環境変数設定

# APP_KEY=
# APP_URL=
# DB_CONNECTION=
# LOG_CHANNEL=errorlog


#* .env.herokuの設定

# APP_NAME=Laravel_Heroku
# APP_ENV=production
# APP_KEY=
# APP_DEBUG=false
# APP_URL=http://localhost
# # APP_SERVICE="web"
# APP_SERVICE="app"
# # APP_PORT=8080


# DB_CONNECTION=cleardb
# DATABASE_URL=mysql://bc9cc1e5ea3f13:2ed4a549@us-cdbr-east-06.cleardb.net/heroku_44e3acdada217bc?reconnect=true

# LOG_CHANNEL=errorlog

# ---------

# Laravel Sanctum
# SANCTUM_STATEFUL_DOMAINS=nextjs-laravel-hands-on.herokuapp.com
# SESSION_DOMAIN=.nextjs-laravel-hands-on.herokuapp.com


#* Laravelの初期化

# 次に、Laravelの初期設定を行います。

# まずは以下のコマンドでherokuにbashで入ります。

# heroku run bash

# 次に、以下のコマンドでLaravelの初期設定を行います。

# cp heroku.env .env

# composer install

# php artisan key:generate


#* 環境の切り替え・環境変数の反映

# herokuでLaravelアプリをリリースしても.envファイルが読み込まれません。

# なので、以下のコマンドで環境変数をセットする必要があります。

# heroku config:set  ENV_PARAM=param

# 環境をprod,stg,devで切り分けたい場合はAPP_ENVで指定する必要があります。


# ちなみに、以下のshellscriptを作成すると起動するだけで反映されます。

# #!/bin/bash
# while read line
# do
#   heroku config:set $line
# done < ./.env


# ------------

#? サブディレクトリにあるプロジェクトをデプロイする方法

# 方法①: Heroku側(heroku-buildpack-monorepo)

# HerokuにGitHubリポジトリの一部だけデプロイする
# https://qiita.com/v2okimochi/items/c85e199c210a8d32cbdb

# Herokuでサブディレクトリをデプロイできるらしいのでメモ
# https://namonakimichi.hatenablog.com/entry/2020/09/21/204503


# ....................

# 方法②: Git側(git subtree)

# git subtree push --prefix backend/ heroku <ブランチ名>:main

# git subtree の使い方メモ
# https://coffee-nominagara.com/git-subtree-memo

#【heroku 】サブディレクトリにあるRailsプロジェクトをデプロイする
# https://zenn.dev/emono/articles/5a263944c9464f


# ------------

#? アドオンのDATABASE_URLのLaravel側の設定方法

# [2020年12月版]herokuデプロイ時のDB設定まとめ
# https://qiita.com/hiro5963/items/4e94ff02ad0faa63e4ef

# Heroku Postgres への接続
# https://devcenter.heroku.com/ja/articles/connecting-heroku-postgres#connecting-in-php


# ------------

#? HerokuのDBにアクセスする方法:

#* [ClearDB]

# heroku mysql へ接続
# https://qiita.com/keisukeYamagishi/items/444ef89590323af8a7ac

# mysql -u <DB_USERNAME> -p -h <DB_HOSTNAME> <DB_NAME>
# Enter password: <DB_PASSWORD>


#* [Postgres]


# ------------

#? Heroku特有のLaravel側の設定:

# Laravel・Vue.jsで作ったアプリをherokuで公開する
# https://qiita.com/zako1560/items/32a58940de0e564754ca


# ⑴ インデックス用の文字列長を指定する
#^ これをしないと、php artisan migrateがパスしない

# app/Providers/AppServiceProvider.php

# public function boot()
# {
#     Schema::defaultStringLength(191);
# }


# Laravel5.4以上、MySQL5.7.7未満 でusersテーブルのマイグレーションを実行すると Syntax error が発生する
# https://qiita.com/beer_geek/items/6e4264db142745ea666f


# ................

# ⑵ ダミーデータには、idカラムも明示的に指定する
#^ ClearDBを使うと、idが初期値が4でそれ以降10ずつ増える仕様になっている
#^ これをしないと、php artisan db:seedがパスしない

# herokuでmysql(ClearDB)を使うとidが10ずつ増える
# https://qiita.com/nsatohiro/items/0458e63c47c3d6ff37d0



# ------------

#! Heroku ! [remote rejected] main -> main (pre-receive hook declined)

# Herokuでgit push heroku masterした時にrejectされたら見る記事
# https://qiita.com/flour/items/985b4628672a85b8e4f3


# ------------

#! SQLSTATE[42000]: Syntax error or access violation: 1071 Specified key was too long;
#!    max key length is 767 bytes (SQL: alter table `users` add unique `users_email_unique`(`email`))

# Laravel5.4以上、MySQL5.7.7未満 でusersテーブルのマイグレーションを実行すると Syntax error が発生する
# https://qiita.com/beer_geek/items/6e4264db142745ea666f


# 対策1：MySQLのバージョンを最新にする
# 特段の事情がなければベストの対応。MySQL5.6系のPremier Support期限は2018年2月に終了している。


# 対策2：使用するcharasetをutf8mb4から変更する
# Laravel5.3まではcharsetの標準設定はUTF-8だった。
# config/database.php よりcharsetを以下のように変更すれば、Laravel5.3以前と同じ挙動で使用することができる。
# ただし、絵文字 :sushi: は使えなくなる。


# 'charset' => 'utf8',
# 'collation' => 'utf8_unicode_ci',


# 対策3：カラムの最大長を変更し、767bytes以上の文字列が入らないようにする
# varchar(191) のカラムを作成すれば、191 * 4 = 764bytesのため、エラーが発生しない。

# //個別で指定する例
#  $table->string('email', 191)->unique();
# 上記のようにカラムごと個別に最大長を指定してもよいが、
# app\Providers\AppServiceProvider.php に以下の記載を追加することで、最大長未指定時のdefault値を変更することが可能である。

# use Illuminate\Support\Facades\Schema;

# public function boot()
# {
#     Schema::defaultStringLength(191);
# }
# これでマイグレーションを実行すれば、正常に動作する。


# ------------

#! SQLSTATE[42S01]: Base table or view already exists: 1050 Table 'users' already exis ts

# Laravelのmigrationエラー解決方法　SQLSTATE[42S01]: Base table or view already exists: 1050 Table 〇〇 already exists
# https://qiita.com/namizatork/items/f8c414fec4e6b76b3ed4


# ------------

#! QLSTATE[23000]: Integrity constraint violation: 1452 Cannot add or update a child row: a foreign key constraint fails

# Laravel・Vue.jsで作ったアプリをherokuで公開する
# https://qiita.com/zako1560/items/32a58940de0e564754ca


# ------------

#! Access to XMLHttpRequest at 'https://nextjs-laravel-hands-on.herokuapp.com/sanctum/csrf-cookie' from origin 'https://nextjs-laravel-hands-on-hashiudo.vercel.app' has been blocked by CORS policy: Response to preflight request doesn't pass access control check: No 'Access-Control-Allow-Origin' header is present on the requested resource.

# Laravel で Access-Control-Allow-Origin ヘッダーを付与しても CORS エラーが解消しない
# https://qiita.com/madayo/items/8a31fdd4def65fc08393

# ReactからLaravelのAPIサーバーを叩く + CORS概説
# https://qiita.com/10mi8o/items/2221134f9001d8d107d6

# Laravel 7におけるCORS（Cross-Origin Resource Sharing）リクエストの処理
# https://www.twilio.com/blog/handling-cross-origin-resource-sharing-cors-requests-laravel-7-jp

# No 'Access-Control-Allow-Origin' header is present on the requested resource.
# https://github.com/fruitcake/laravel-cors/issues/481


# ====================

#! Node version not specified in package.json

# Heroku環境でReactアプリのビルドに失敗する(Node version not specified in package.json)原因はNodeのバージョン違いでした
# https://qiita.com/AK_-_-_-I/items/ad2f45d4a1c79c38d55f

# Specifying a Node.js Version
# https://devcenter.heroku.com/articles/nodejs-support#specifying-a-node-js-version

# Heroku の Node.js サポート
# https://devcenter.heroku.com/ja/articles/nodejs-support

# HerokuはNode.jsのバージョンを指定してデプロイできる
# https://relativelayout.hatenablog.com/entry/2018/11/08/092143

# 【まとめ】Node.js製WebアプリをHerokuで公開する方法
# https://inno-tech-life.com/dev/js/heroku_nodejs/


#原因: ビルドに使用するnodeとnpmのバージョンがローカルとHerokuでは違っていることが原因

# ローカル
# node: v15.8.0
# npm: 7.18.1

# Heroku
# node: v14.17.1
# npm: 6.14.13

# 解決: package.jsonに以下を追記。

# {
#   ...
#   "engines": {
#     "node": "15.x",
#     "npm": "7.x"
#   },
#   ...
# }


# remote:        Resolving node version 18.x...
# remote:        Downloading and installing node 18.12.0...
# remote:        Using default npm version: 8.19.2
# remote:        Resolving yarn version 1.22.x...
# remote:        Downloading and installing yarn (1.22.19)
# remote:        Installed yarn 1.22.19

# node -v v14.18.1
# npm -v 8.14.0
# yarn -v 1.22.17

# "engines": {
# "node": "14.x",
# "npm": "8.x",
# "yarn": "1.22.x"
# }

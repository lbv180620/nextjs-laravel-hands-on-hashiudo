#todo [Heroku Tips]

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

#todo [API Heroku Tips]

# !!!! Heroku有料化 !!!!
# https://www.udemy.com/course/nestjs-nextjs-restapi-react/learn/lecture/33696222#questions


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


# ==== CORS対策 ====

#! Access to XMLHttpRequest at 'https://nextjs-laravel-hands-on.herokuapp.com/sanctum/csrf-cookie' from origin 'https://nextjs-laravel-hands-on-hashiudo.vercel.app' has been blocked by CORS policy: Response to preflight request doesn't pass access control check: No 'Access-Control-Allow-Origin' header is present on the requested resource.


# proxy

# middleware

# header()


# -------------

# Laravel で Access-Control-Allow-Origin ヘッダーを付与しても CORS エラーが解消しない
# https://qiita.com/madayo/items/8a31fdd4def65fc08393

# ReactからLaravelのAPIサーバーを叩く + CORS概説
# https://qiita.com/10mi8o/items/2221134f9001d8d107d6

# Laravel 7におけるCORS（Cross-Origin Resource Sharing）リクエストの処理
# https://www.twilio.com/blog/handling-cross-origin-resource-sharing-cors-requests-laravel-7-jp

# No 'Access-Control-Allow-Origin' header is present on the requested resource.
# https://github.com/fruitcake/laravel-cors/issues/481

# Laravel8でCORSが失敗するくだらない理由
# https://rugoh.co.jp/blog/2021/04/13/laravel8%E3%81%A7cors%E3%81%8C%E5%A4%B1%E6%95%97%E3%81%99%E3%82%8B%E3%81%8F%E3%81%A0%E3%82%89%E3%81%AA%E3%81%84%E7%90%86%E7%94%B1/

#【Laravel】クロスオリジン（CORS）を有効にするには？
# https://takabus.com/tips/341/

# corsの対応方法(vercel編)
# https://qiita.com/kouji0705/items/f92026c722c18d5fcaa2

# Next.jsのチュートリアル、その6
# https://www.yoshida.red/2021/05/06/nextjs-tutorial/

# これから始める、Next.js  第1回
# Next.jsとは
# https://www.codegrid.net/articles/2021-nextjs-1/#toc-6

# Laravel Sanctumの使い方(フロントエンド編)
# https://codelikes.com/use-laravel-sanctum-front/

# [Nuxt.js]axiosをnuxtで使う方法とproxyでのCROS制約回避
# https://codelikes.com/nuxt-axios-and-proxy/#toc7

# Next.js でProxyAPIを実装する
# https://zenn.dev/rmanzoku/articles/85637a010b37c8

# Next Http Proxy Middlewareで Next.js × Rust間のリクエストをproxyする
# https://sayu-do.com/2022-2-3/196/

# Next.jsでプロキシを使用する
# https://morioh.com/p/215d1c10b5f5

# LaravelでのCORS対策とmiddlewareへの理解
# https://qiita.com/kyo-san/items/a507aa0b46037df1b139

# React.js × Expressで発生したCORSエラーの解決
# https://qiita.com/iiiiiiiiih/items/18648b001a502b67ae61

# Next.js で API リクエストを proxy する
# https://imatomix.com/imatomix/notes/1629523270000

# https://laracasts.com/discuss/channels/laravel/laravel-8-api-autorization-header-cors

# https://github.com/zuka-e/laravel-react-task-spa/tree/development/backend/config
# https://github.com/digitalnomad91/laravel-next-backend


# Laravel SanctumのXSRF-TOKENクッキーを環境毎に使えるようにする方法
# https://qiita.com/10mi8o/items/2221134f9001d8d107d6

#【Laravel】クロスオリジン（CORS）を有効にするには？
# https://takabus.com/tips/341/

# LaravelでのCORS設定のベストプラクティスは何なのか…２つの方法
# https://pisuke-code.com/laravel-best-way-for-cors-setting/

# CORSのプリフライトリクエスト（OPTIONメソッド）はAPI Keyの認証なしでOKにしておかないと失敗する話
# https://future-architect.github.io/articles/20200717/

# CORSエラーの回避方法【cors-anywhereを利用してプロキシサーバーを立てる】
# https://zukkiblog.com/cors-error/

# CORS未対応APIに、PROXYを中継して通信を行う
# https://zenn.dev/sohhakasaka/articles/41aa0fd95d3c0c


# -------------

#* Nginx Procfile 対策

# Heroku × nginx × MySQL × Laravel × Reactで本番環境を構築する
# https://qiita.com/k_kuma/items/236294af58e7084c029b

# Procfile
# web: vendor/bin/heroku-php-nginx -C heroku_nginx.conf public/

# heroku_nginx.conf
# location / {
#     try_files $uri @rewriteapp;
# }

# location @rewriteapp {
#     rewrite ^(.*)$ /index.php$1 last;
# }


# ....................

# https://github.com/kentsunekawa/rodoma-backend

# Procfile
# web: vendor/bin/heroku-php-nginx -C .heroku/nginx/nginx.conf public/

# .heroku/nginx/nginx.conf
# location / {
#     # try to serve file directory, fallback to rewrite
#     try_files $uri @rewriteapp;
# }

# location @rewriteapp {
#     # rewrite all to index.php
#     rewrite ^(.*)$ /index.php$1 last;
# }


#^ 効果: エラー内容が変わった。
#! POST https://nextjs-laravel-hands-on.herokuapp.com/login 419 (unknown status)
#^ 一応レスポンスが返って来た
# {data: {…}, status: 419, statusText: 'unknown status', headers: {…}, config: {…}, …}
# config
# :
# {url: '/login', method: 'post', data: '{"email":"test@example.com","password":"password"}', headers: {…}, baseURL: 'https://nextjs-laravel-hands-on.herokuapp.com', …}
# data
# :
# {message: 'CSRF token mismatch.'}
# headers
# :
# {cache-control: 'no-cache, private', content-type: 'application/json'}
# request
# :
# XMLHttpRequest {readyState: 4, timeout: 0, withCredentials: true, upload: XMLHttpRequestUpload, onreadystatechange: ƒ, …}
# status
# :
# 419
# statusText
# :
# "unknown status"


# Laravel SanctumのXSRF-TOKENクッキーを環境毎に使えるようにする方法
# https://techblog.roxx.co.jp/entry/2022/06/27/120000

# Laravel Sanctum SPA認証の実装
# https://zenn.dev/yudai64/articles/7caaa3c828b828

# Next.js（axios）とlaravelを使ってhttp通信がしたい（POST、PUT、DELETE）
# https://teratail.com/questions/smpmo3bbcee51z

# SPAにおけるLaravelのCORS設定周辺でつまずいた
# https://qiita.com/hikkappi/items/1b51b9e58e8e391762de


# app/Http/Middleware/VerifyCsrfToken.php
# class VerifyCsrfToken extends Middleware
# {
#     /**
#      * The URIs that should be excluded from CSRF verification.
#      *
#      * @var array<int, string>
#      */
#     protected $except = [
#         //
#         'login',
#     ];
# }
# → 結果:
# POST https://nextjs-laravel-hands-on.herokuapp.com/login 500 (Internal Server Error)
# {data: {…}, status: 500, statusText: 'Internal Server Error', headers: {…}, config: {…}, …}


# Sanctum を使用して Laravel を Heroku にデプロイする - CSRF トークンの不一致 (Deploy Laravel with Sanctum into Heroku - CSRF token mismatch)
# https://jp.coderbridge.com/questions/545be20eb0be46b9963cf6600a4be0b5

# Laravel 7 Sanctum: Same domain (*.herokuapp.com) but separate React SPA gets CSRF Token Mismatch
# https://stackoverflow.com/questions/61961955/laravel-7-sanctum-same-domain-herokuapp-com-but-separate-react-spa-gets-csr

# herokuで本番環境までを構築する上で知っておきたいこと
# https://qiita.com/undrthemt/items/1f49cc2bc9aabeb35a4c


#^ Herokuの問題な気がする

# Sanctum を使用して Laravel を Heroku にデプロイする - CSRF トークンの不一致 (Deploy Laravel with Sanctum into Heroku - CSRF token mismatch)
# https://jp.coderbridge.com/questions/545be20eb0be46b9963cf6600a4be0b5

# Heroku のアプリでは Cookie に XSRF_TOKEN がありませんが、localhost にはあります。セッション ドライバーをファイルからデータベース ドライバーに変更しようとしましたが、Heroku ではストレージ システムが原因でファイル ドライバーが正常に動作せず、同じ結果 (CSRF トークンが一致せず、XSRF‑TOKEN が一致しない) であることがわかりました。


# headers
# :
# Accept
# :
# "application/json, text/plain, */*"
# Content-Type
# :
# "application/json;charset=utf-8"
# X-Requested-With
# :
# "XMLHttpRequest"


# ....................

# Kernel.php
# // \App\Http\Middleware\VerifyCsrfToken::class,
# とすると、

# 結果:
# {data: {…}}
# data
# :
# id
# :
# 1

# {data: {…}, status: 500, statusText: 'Internal Server Error', headers: {…}, config: {…}, …}
# config
# :
# {url: '/api/memos', method: 'get', headers: {…}, baseURL: 'https://nextjs-laravel-hands-on.herokuapp.com', transformRequest: Array(1), …}
# data
# :
# {message: 'Server Error'}
# headers
# :
# {cache-control: 'no-cache, private', content-type: 'application/json'}
# request
# :
# XMLHttpRequest {readyState: 4, timeout: 0, withCredentials: true, upload: XMLHttpRequestUpload, onreadystatechange: ƒ, …}
# status
# :
# 500
# statusText
# :
# "Internal Server Error"


# -------------

#* Redisに変更

# 結果:
#! GET https://nextjs-laravel-hands-on.herokuapp.com/sanctum/csrf-cookie 500 (Internal Server Error)

# Heroku×Laravelで Class 'Redis' not found エラーが出た時の対処法
# https://bel-itigo.com/heroku-redis-not-found-error/

# LaravelのセッションをHeroku Redisに保存する
# https://blog.hrendoh.com/laravel-store-session-on-heroku-redis/

# PHP での接続
# https://devcenter.heroku.com/ja/articles/connecting-heroku-redis#connecting-in-php


# PHP7.2 以前は 3.x
# PHP7.3 は 4.x
# PHP7.4 以降は 5.x
# "require": {
#     "ext-redis": "(インストールしたいバージョン)"  // 追加する1行
# },

# 例えば、PHP8.1 を使っている場合は以下のようになります。

# "require": {
#     "ext-redis": "5.*"
# },

# composer update --ignore-platform-reqs


# // config/database.php
# <?php

# use Illuminate\Support\Str;

# if (getenv('REDIS_URL')) {
#     $url = parse_url(getenv('REDIS_URL'));
#     putenv('REDIS_HOST='.$url['host']);
#     putenv('REDIS_PORT='.$url['port']);
#     putenv('REDIS_PASSWORD='.$url['pass']);
# }

# return [
#     ...
# ];


# -------------


#* 手動でX-XSRF-TOKENを設定する


# Laravel 8.x CSRF保護
# https://readouble.com/laravel/8.x/ja/csrf.html

# Laravel SanctumでSPA認証
# https://webxreal.com/laravel-sanctum-spa/?amp=1

# Nuxt Laravel Sanctum CSRF token mismatch 419 error
# https://www.codeprintr.com/thread/1497536.html

# Laravel SanctumのXSRF-TOKENクッキーを環境毎に使えるようにする方法
# https://techblog.roxx.co.jp/entry/2022/06/27/120000

#【Vue】axiosで、デフォルトでCSRFトークンを設定できるようにする
# https://qiita.com/ngron/items/2faae8068baa093d6aba

# LaravelのCSRF対策の処理を実際のコードから見てみる
# https://qiita.com/SanQ/items/e12083fce1de3f569df1

# Laravel+axiosのCSRF対策
# https://www.softel.co.jp/blogs/tech/archives/3461

# CypressでLaravel Sanctumなバックエンドにログイン
# https://zenn.dev/garypippi/articles/3b1580b742ac6508d64f

# Vue + Vue Router + Vuex + Laravelで写真共有アプリを作ろう (6) 認証機能とVuex
# https://www.hypertextcandy.com/vue-laravel-tutorial-authentication-part-3

# Laravel でクッキーベースのセッション認証を使った Web API を実装する
# https://jamband.github.io/blog/2022/01/web-api-with-cookie-based-session-authentication-in-laravel/


# -------------

#* proxy対策

# CORSエラーの回避方法【cors-anywhereを利用してプロキシサーバーを立てる】
# https://zukkiblog.com/cors-error/

# CORS未対応APIに、PROXYを中継して通信を行う
# https://zenn.dev/sohhakasaka/articles/41aa0fd95d3c0c


# -------------

#* header()対策

#【Laravel】クロスオリジン（CORS）を有効にするには？
# https://takabus.com/tips/341/

# LaravelでのCORS設定のベストプラクティスは何なのか…２つの方法
# https://pisuke-code.com/laravel-best-way-for-cors-setting/


# ==== 419 CSRF token mismatch レポート ====

# 結論:

#^ herokuapp.comはPublic Suffix Listに載っているため、eTLDとブラウザは判断する。
#^ そのため、*.herokuapp.com​に対するCookieの設定が阻止される。
#^ その結果、リクエスト時にCookieヘッダー自体が存在しないため、当然XSRF-TOKENとその値も無く、Axiosがその値を読み取って、X-XSRF-TOKENヘッダーを自動付与することも無い。

#^ なぜこのような仕組みにしているかと言うと、もし仮に*.herokuapp.com​に対するCookieの設定が許可されるなら、他のHerokuユーザーがデプロイしたアプリにもCookieが設定されてしまうから。

#^ よって、自分がデプロイしたHerokuアプリ以外のアプリにCookieが設定されるのを防ぎつつ、Cookieを設定するためには、独自ドメインを取得し、Heroku側でカスタムドメインとして設定する必要がある。




# 抱えている問題の対処法について検討していました。
# 問題解決のために、Freenomというサービスを使って無料の独自ドメインを取得し、CloudFlareというサービスを使って無料でSSL化させて、実験的にHerokuアプリをカスタムドメインに変更させてみました。


# 以下経緯：
# 自宅でbackendとfrontendともにHerokuでデプロイし、TLD(トップレベルドメイン)が「herokuapp.com」になるようにしたのですが、ブラウザでXSRF-TOKENの値がCookieに保持されませんでした。

# どうやら、Public Suffix Listってのが関係あるようです。
# このリストは、TLDとeTLDをブラウザに判別させるためのものらしく、このリストに載っているドメインはeTLDとみなすようです。

# Public Suffix List の用途と今起こっている問題について
# https://blog.jxck.io/entries/2021-04-21/public-suffix-list.html

# 例)
#  ⑴「herokuapp.com」がTLDの場合
# 「.com」がTLDで、「herokuapp」はサブドメイン

# ⑵ 「herokuapp.com」がeTLD(Effective Top Level Domain)の場合
# 「herokuapp.com」でTLD扱いになる


# 案の定、「herokuapp.com」も載っていました。(他のPaaSも同様)
# この場合、「*.herokuapp.com」に対してCookieの設定が阻害されます。

# なので、Cookieがブラウザに保持されないので、認証が上手くいかないと今は推測しています。

# なぜこのような仕組みが必要かと言えば、「herokuapp.com」のドメインは他ユーザーも使っているため、仮にCookieの設定を許可してしまうと、このドメインを使っているすべてのアプリにCookieが渡ってしまうことになるからだそうです。

# Cookieを阻害されずにbackendとfrontendのTLDを同一にするには、独自ドメインが必要だと結論付けました。


# -------------

# 原因:

#! Cookie および Public Suffix List
#! https://devcenter.heroku.com/ja/articles/cookies-and-herokuapp-com

# Cookies not being sent to browser
# https://stackoverflow.com/questions/72179796/cookies-not-being-sent-to-browser

# Laravel 7 Sanctum: Same domain (*.herokuapp.com) but separate React SPA gets CSRF Token Mismatch
# https://stackoverflow.com/questions/61961955/laravel-7-sanctum-same-domain-herokuapp-com-but-separate-react-spa-gets-csr


# -------------

# Public Suffix List について:

#! Public Suffix List の用途と今起こっている問題について
#! https://blog.jxck.io/entries/2021-04-21/public-suffix-list.html

# https://publicsuffix.org/

# https://github.com/publicsuffix/list


# -------------

# 対処法① Heroku側が問題:

# 初めてHerokuで独自ドメインを公開するあなたへ
# https://qiita.com/kenjikatooo/items/07c3d911210a4ca96781

# Heroku (無料プラン)で独自ドメインでSSLを使う方法
# https://www-serversus-work.cdn.ampproject.org/v/s/www.serversus.work/topics/yhyqln2f0bgw2yuak8vw/?amp_gsa=1&amp_js_v=a9&usqp=mq331AQKKAFQArABIIACAw%3D%3D

# [無料!]Herokuで独自ドメインをかんたんにSSL化させる
# https://osamudaira-com.cdn.ampproject.org/v/s/osamudaira.com/461/?amp=1&amp_gsa=1&amp_js_v=a9&usqp=mq331AQKKAFQArABIIACAw%3D%3D#amp_tf=%251%24s%20%E3%82%88%E3%82%8A&aoh=16648399480450&referrer=https%3A%2F%2Fwww.google.com&ampshare=https%3A%2F%2Fosamudaira.com%2F461%2F

# Heroku と Cloudflare で無料の独自ドメイン SSL ウェブサイトを公開する
# http://dotnsf.blog.jp/archives/1080330846.html

# Herokuとお名前.comでサブドメインなしの独自ドメインを使う方法
# https://zenn.dev/fj68/articles/12a2e514a221fa

# Herokuの無料プランで独自ドメインを設定し、HTTPS通信を行う方法【ムームードメイン+Cloudflare】
# https://noauto-nolife.com/post/heroku-origin-domain/

# 全部無料でWebサービスを公開しよう！(Heroku + Laravel + MySQL + 独自ドメイン + SSL)
# https://crieit.net/posts/WEB-Heroku-Laravel-MySQL-SSL

# Heroku x Cloudflare: 無料で独自ドメインのホームページ立ち上げ+SSL化
# https://note.com/zivatad/n/n6ac9959f9ee2

# Laravelがデプロイできるオススメのレンタルサーバーを比較！[無料お試しあり]
# https://wiz-t.jp/blog/laravel-rental-server/


# Next.js on Heroku
# https://github.com/mars/heroku-nextjs

# Nuxt.js + LaravelでSSRチュートリアル (herokuデプロイまで)
# https://qiita.com/MyPoZi/items/19df4258287a5bc25829


# ................

#~ 無料独自ドメイン取得

# 【Domain】HerokuサイトはFreenomの無料Domainで使う
# https://colorfullife.ml/pages/diary/erics-daily-life/eric7/

# 【Heroku】独自ドメイン取得～SSL化まで【完全無料】
# https://qiita.com/doiko/items/d1500a929cf508194976

# freenomで無料ドメインを取得する
# https://note.com/dafujii/n/n406f385651e2

# Freenomで取得した独自ドメインのネームサーバーを設定する。
# https://zenn.dev/hatotk/articles/set-name-server-of-domain-by-freenom


# ................

#~ CloudFlareでHttps化

# 無料で独自ドメインをHTTPS公開する
# https://qiita.com/shin555/items/edf6831aba051fe7ece7

# herokuに独自ドメインでssl設定する方法（すべて無料）
# https://marimoko3.hatenablog.com/entry/2019/10/17/114047


# ................

#~ Herokuでカスタムドメイン設定


# -------------

#⭐️ 対処法②(推奨) Laravel側が問題:

# LaravelでCookieのSameSite属性を設定する
# https://qiita.com/kusano00/items/e5861af3eb7221a006c3

# Laravel でクッキーベースのセッション認証を使った Web API を実装する
# https://jamband.github.io/blog/2022/01/web-api-with-cookie-based-session-authentication-in-laravel/

# LaravelのセッションCookieにSameSite属性を付与
# https://blog.motikan2010.com/entry/2019/01/30/Laravel%E3%81%AE%E3%82%BB%E3%83%83%E3%82%B7%E3%83%A7%E3%83%B3Cookie%E3%81%ABSameSite%E5%B1%9E%E6%80%A7%E3%82%92%E4%BB%98%E4%B8%8E

# SPAセキュリティ入門～PHP Conference Japan 2021
# https://www.docswell.com/s/ockeghem/ZM6VNK-phpconf2021-spa-security

# Laravel SanctumのSPA認証でつまづいたところのメモ
# https://zenn.dev/tekihei2317/articles/911b0428144c96

# Laravel Sanctum でハマったところ
# https://zenn.dev/kra8/articles/3f15d8a4ef8318

# Laravel+Nuxt 環境で sanctum の SPA(クッキー)認証する
# https://qiita.com/kiyoshi999/items/9ef7c89e3eaff444286d

# Spring Security + SPA(Nuxt.js)でX-XSRF-TOKENヘッダーが無くてCSRFで拒否される
# https://qiita.com/hamada1207jyo/items/6d6a6ab4a99e33aa15fa

# CSRFの基本的な対策とLaravelにおけるCSRF対策の実装 ...
# https://turningp.jp/network_and_security/csrf-laravel

# Laravel Sanctum (SPA認証) がしてくれること
# https://qiita.com/pikanji/items/040fa4ab6976059f3762

# Laravel/Sanctum：別ドメインからVue/AxiosでBearerトークンによるAPIユーザ認証
# https://scramblenote.com/article/laravel-sanctum-bearer-token

# Laravel SanctumでSPA認証機能をつくる 1 Base
# https://www.aska-ltd.jp/jp/blog/215

# CypressでLaravel Sanctumなバックエンドにログイン
# https://zenn.dev/garypippi/articles/3b1580b742ac6508d64f

# 【Laravel】Laravel Sanctum－SPA認証➁ログイン
# https://cont365.hatenablog.com/entry/2022/01/31/220429

# 【Laravel 8 / Sail / Fortify / Sanctum】タスク管理アプリ (ポートフォリオ) の実装過程 (バックエンド編)
# https://qiita.com/zuka-e/items/3faf100cbcdf7ec40ee6#sanctum

# Laravel Sanctum: Login fails using Fetch API #42729
# https://github.com/laravel/framework/discussions/42729

# LaravelのCSRF対策の処理を実際のコードから見てみる
# https://qiita.com/SanQ/items/e12083fce1de3f569df1

# https://stackoverflow.com/questions/68320800/laravel-sanctum-react-with-axios-post-return-419

# export const sendLogin = (data) => {
#     axios.defaults.withCredentials = true;
#     const response = axios.get(apiUrl('sanctum/csrf-cookie','backend-non-api-route')).then(response => {
#         return axios.post(apiUrl('user/login','backend-non-api-route'),data,{
#             xsrfHeaderName: "X-XSRF-TOKEN", // change the name of the header to "X-XSRF-TOKEN" and it should works
#             withCredentials: true
#           });
#     })
#     return response;
# }


# 【React + Laravel】SPAで認証機能と権限管理(fortify+sanctum)
# https://www.google.com/search?q=laravel+sanctum+axios+xsrf+manual&rlz=1C1PWSB_jaJP1013JP1013&sxsrf=ALiCzsZn2uVcmQvOJTWvbTGpf9FyWJYtZw:1666574082496&source=lnt&tbs=qdr:y&sa=X&ved=2ahUKEwiX-rah2Pf6AhWEgFYBHW6UC5wQpwV6BAgCEB4&biw=1366&bih=625&dpr=1


# Laravelのweb.phpとapi.phpの違いを調べるために外からPOSTしてみた
# https://awesome-linus.com/2019/04/06/laravel-api-php-csrf/


# NextjsのmiddlewareからLaravel Sanctumの認証を通す方法
# https://zenn.dev/nicopin/articles/2cf7d90edc8b07

# Laravel API SanctumでSPA認証する
# https://qiita.com/ucan-lab/items/3e7045e49658763a9566


# https://laracasts.com/discuss/channels/laravel/laravel-sanctum-with-reactjs-spa


# Rails API + SPAのCSRF対策例
# https://zenn.dev/leaner_dev/articles/20210930-rails-api-spa-csrf

# 【Laravel】【JavaScript】axios と Laravel の通信は CSRF 関連の対策を自動でしてくれる
# https://cpoint-lab.co.jp/article/202012/18113/


# Laravel : Sanctumってどうなのよ？
# https://www.wetch.co.jp/laravel-sanctum%E3%81%A3%E3%81%A6%E3%81%A9%E3%81%86%E3%81%AA%E3%81%AE%E3%82%88%EF%BC%9F/


# Laravel SanctumでBearerトークンによるAPI認証
# https://webxreal.com/laravel-sanctum-api/


# Next.js + TypeScript + Laravel Passportで実装するOAuth2認証
# https://zenn.dev/kaibuki0315/articles/39fe0e38f6635e


# ..................

#! 異なるオリジンへのリクエストの場合axiosはCSRFトークンを付与しない

# https://zenn.dev/tekihei2317/articles/911b0428144c96

# CSRFの基本的な対策とLaravelにおけるCSRF対策の実装 ...
# https://turningp.jp/network_and_security/csrf-laravel

# laravelとvueで作る認証機能
# https://zenn.dev/kawataku/articles/71468ceb6d96e8

# Laravel Passportで自身のJavaScriptからAPIを利用する方法
# https://s8a.jp/laravel-passport-javascript-api


# Sanctumのドキュメントには、SPA認証の手順について以下のように書かれています。

# 最初に/sanctum/csrf-cookieにリクエストを送る
# レスポンスのクッキーで受け取ったXSRF-TOKENを、リクエストヘッダのX-XSRF-TOKENに付与してリクエストを送る
# axiosはこの処理を自動で行ってくれるので、特別な処理を書かなくてもよい
# しかし、CSRFトークンの自動付与はAPIとSPAが同一オリジンの場合しか行ってくれません。なぜなら、axiosのCSRFトークンの設定箇所に以下のような条件分岐があるためです。

# https://github.com/axios/axios/blob/c714cffa6c642e8e52bf1a3dfc91a63bef0f6a29/lib/adapters/xhr.js#L143-L155

# if (utils.isStandardBrowserEnv()) {
#   // withCredentialsオプションがtrueで、
#   // リクエスト元とリクエスト先が同一オリジンの場合のみ、クッキーからCSRFトークンを取得する
#   var xsrfValue = (config.withCredentials || isURLSameOrigin(fullPath)) && config.xsrfCookieName ?
#     cookies.read(config.xsrfCookieName) :
#     undefined;

#   if (xsrfValue) {
#     requestHeaders[config.xsrfHeaderName] = xsrfValue;
#   }
# }

# つまり、Laravel Mixを使っていてSPAとAPIを同じサーバーで動かす場合はCSRFトークンは送信されますが、別オリジンにデプロイする場合はCSRFトークンが付与されません。


# console.log(decodeURIComponent(document.cookie).replace(`${res.config.xsrfCookieName}=`, ""));

# await axios
#   .post("/login", data, {
#     headers: {
#       test: decodeURIComponent(document.cookie).replace(`${res.config.xsrfCookieName}=`, ""),
#     },
#   })


# =============

#* General:
# Request URL: http://localhost:8080/sanctum/csrf-cookie
# Request Method: GET
# Status Code: 204 No Content
# Remote Address: [::1]:8080
# Referrer Policy: strict-origin-when-cross-origin
#* Response Headers:
# Access-Control-Allow-Credentials: true
# Access-Control-Allow-Origin: http://localhost:3000
# Cache-Control: no-cache, private
# Connection: keep-alive
# Date: Sun, 23 Oct 2022 22:28:51 GMT
# phpdebugbar-id: Xad6163f9711c3f77e9a0a04b3560d383
# Server: nginx/1.20.2
# Set-Cookie: XSRF-TOKEN=eyJpdiI6IncrcVBIeEdyQVhkdU9wTUN0Zzl6OVE9PSIsInZhbHVlIjoiQ3NRSmVnOUw3eEYwaEVoSUxRZzNySlFpQmwzQXg4bnp6ejFRYUJkeDc1a3FISVYyTC9TYkNGVXRyb0VPQ1lWeDIvOVFoWmc4OENmUjU4SDZHNndNR1FmMlExMExaenFqcS9ST3k2QWF2eXBTeEp6RjVPamFGTWRUQk1RRjQxeVUiLCJtYWMiOiIyZWRhMWFjMDc3NGE4OGQyMWE0ZGI4MTBhMWJkNTczOWQzZTdiMGZmNmFhYmQxMmY5NjVkNWFhOWEyODkwMWRiIiwidGFnIjoiIn0%3D; expires=Mon, 24-Oct-2022 00:28:51 GMT; Max-Age=7200; path=/; domain=localhost; samesite=lax
# Set-Cookie: laravel_session=eyJpdiI6Im1KTm5vNWFwU09EZ1oyQ0V2RkVnUmc9PSIsInZhbHVlIjoibDdRQ3Azb214YTFXMWRMOU5GbForTC9DOUYwQ0JvQ3dDbXZJdVZaTkY4VW1UY2pqV0ZFNUMyRzd1ajhEckdXczFUVUJrQ1NlQjMwclVucXYveHQ1N3ZaNjJ0dVZCZHJwRDVLcDVCUHNadlovWEltb1J4REh2MHROdWZoUWE5aloiLCJtYWMiOiI1MDRkMmM2OTk5MmNmZWQ4M2E4ZmY2YTIzYmIyNDFjOWYyZGZhNDlmMzU5ZWM2Y2I0YmE1YjZhMGYwYmI0ZmZjIiwidGFnIjoiIn0%3D; expires=Mon, 24-Oct-2022 00:28:51 GMT; Max-Age=7200; path=/; domain=localhost; httponly; samesite=lax
# Vary: Origin
# X-Content-Type-Options: nosniff
# X-Frame-Options: SAMEORIGIN
# X-Powered-By: PHP/8.0.22
# X-XSS-Protection: 1; mode=block
#* Request Headers:
# Accept: application/json, text/plain, */*
# Accept-Encoding: gzip, deflate, br
# Accept-Language: ja,en-US;q=0.9,en;q=0.8
# Connection: keep-alive
# Cookie: pma_lang=ja
# Host: localhost:8080
# Origin: http://localhost:3000
# Referer: http://localhost:3000/
# sec-ch-ua: "Chromium";v="106", "Google Chrome";v="106", "Not;A=Brand";v="99"
# sec-ch-ua-mobile: ?0
# sec-ch-ua-platform: "macOS"
# Sec-Fetch-Dest: empty
# Sec-Fetch-Mode: cors
# Sec-Fetch-Site: same-site
# User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36

# ↓

#* General:
# Request URL: https://nextjs-laravel-hands-on.herokuapp.com/sanctum/csrf-cookie
# Request Method: GET
# Status Code: 204 No Content
# Remote Address: 54.159.116.102:443
# Referrer Policy: strict-origin-when-cross-origin
#* Response Headers:
# Access-Control-Allow-Credentials: true
# Access-Control-Allow-Origin: https://nextjs-laravel-hands-on-hashiudo.vercel.app
# Cache-Control: no-cache, private
# Connection: keep-alive
# Content-Length: 0
# Date: Sun, 23 Oct 2022 22:11:02 GMT
# Server: nginx
# Set-Cookie: XSRF-TOKEN=eyJpdiI6InF0SGVNUDBmWVlEd2R6SGZOY0N6aHc9PSIsInZhbHVlIjoiNzZURTBhT1ZCSHZpZ3F5d1RIS0xHclpHdlBYUEx6VER5dDA3ZHZ4L2ExbWZMVTViQm5IaEZ0c09zbitQTFd4bVB0ZGxQU2NOZHpDcFlQSWJic1M1ODkzc2ZOd3BVYXFtMWVidXM1UUIzSTA5c1JiMVU0MzJ3K3FRdlh6T2RpVzAiLCJtYWMiOiJjODFhYmZmZDA2ODk1NWZkZTEwZjA1ZDYwMzEzZTc3NzA5NWZlYzI4NzIwZmE3NzExNTM4YjBhMjc0ZGNjNDk2IiwidGFnIjoiIn0%3D; expires=Mon, 24-Oct-2022 00:11:02 GMT; Max-Age=7200; path=/; domain=.vercel.app
# Set-Cookie: laravel_session=eyJpdiI6IldTY1lDT2l5ekRpRm4vUnF5RHpGNGc9PSIsInZhbHVlIjoiSTk3MU9WZjVTSFp3a3A0RUloTlFjbDlhYVZyUE9NWUphd2YxSm1Dd2QxRjhTVmhMTDY4cFVUaXJsYUVHOUNkTVM3VFFMNFAvY2k5R1AxMFNzRmF1TUkrTnQzUS9ocWxIT2tXdFRNOUdnN2dKWHc0cWlCZVloaHlycjFZUUxGSU0iLCJtYWMiOiIxOTQzYzcwNGMzNGE2M2E3YTQ3ZDMyMzU1NjE2ZWI2YjZmMGQ4ZDRiMDQ2ZjM2NDc0YzEzZDQxMTAzMjJmMjA4IiwidGFnIjoiIn0%3D; expires=Mon, 24-Oct-2022 00:11:02 GMT; Max-Age=7200; path=/; domain=.vercel.app; httponly
# Via: 1.1 vegur
#* Request Headers:
# Accept: application/json, text/plain, */*
# Accept-Encoding: gzip, deflate, br
# Accept-Language: ja,en-US;q=0.9,en;q=0.8
# Connection: keep-alive
# Host: nextjs-laravel-hands-on.herokuapp.com
# Origin: https://nextjs-laravel-hands-on-hashiudo.vercel.app
# Referer: https://nextjs-laravel-hands-on-hashiudo.vercel.app/
# sec-ch-ua: "Chromium";v="106", "Google Chrome";v="106", "Not;A=Brand";v="99"
# sec-ch-ua-mobile: ?0
# sec-ch-ua-platform: "macOS"
# Sec-Fetch-Dest: empty
# Sec-Fetch-Mode: cors
# Sec-Fetch-Site: cross-site
# User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36
# X-Requested-With: XMLHttpRequest



#* General:
# Request URL: http://localhost:8080/login
# Request Method: POST
# Status Code: 200 OK
# Remote Address: [::1]:8080
# Referrer Policy: strict-origin-when-cross-origin
#* Response Headers:
# Access-Control-Allow-Credentials: true
# Access-Control-Allow-Origin: http://localhost:3000
# Cache-Control: no-cache, private
# Connection: keep-alive
# Content-Type: application/json
# Date: Sun, 23 Oct 2022 22:28:54 GMT
# phpdebugbar-id: X9529349f9cd5919e26edb4dffd802523
# Server: nginx/1.20.2
# Set-Cookie: XSRF-TOKEN=eyJpdiI6Ik4zMzFsVlp6MWtNM0V5Ykw3Z203ekE9PSIsInZhbHVlIjoiZDk3TGJsVHVqUC9uYXZaTngxaEhlbXo2TDJLdVpoUWxYeXUva2RuLzlCcDJHLzJManNZQ2JVZzg4SndrVnlHcFVLdmNVSUxsdXNLcjRhNkdUNUNqc0owZ0R4WnNsT2tKQkhqMnYxZUJrdnllbEd2bjk3a1lEb1k3TGtMMkNjaFMiLCJtYWMiOiI3OWViNzRjYjg3Mzc2ODk5M2FhYTVhN2JkZDlmYzNmYTQ2NjkwMTA5YjM0Nzk4NjE4ZDA4NmVmZTI5ZTYxNGZhIiwidGFnIjoiIn0%3D; expires=Mon, 24-Oct-2022 00:28:54 GMT; Max-Age=7200; path=/; domain=localhost; samesite=lax
# Set-Cookie: laravel_session=eyJpdiI6IkJLN2NBTkloUFFsUTFPQVVPYlN3emc9PSIsInZhbHVlIjoid1kwZG1ZWHIyY2sxRGpqNXVlUG5xWE5HTWpmM2R1MTQ1M3d1aVc2eVlGVlRhZkYyWlpMYTF3U0J0OEMwbjBQYVFDN2Vod2lwUmwyWGJsRE0vRXRXSlBWTlM5dlBXZHh4dkZPTXFlTzA5SDg0ak1GNDNuM2lMelVVRzZyNTA3ZVkiLCJtYWMiOiIxNDc3MWYzZDFlYzI1NTIwYWRhZGU3ODI0YjIwZTQwODExYWFlOWNiY2ZhNjJjZGJiMTY3Y2NkMjRmZjE2NmJkIiwidGFnIjoiIn0%3D; expires=Mon, 24-Oct-2022 00:28:54 GMT; Max-Age=7200; path=/; domain=localhost; httponly; samesite=lax
# Transfer-Encoding: chunked
# Vary: Origin
# X-Content-Type-Options: nosniff
# X-Frame-Options: SAMEORIGIN
# X-Powered-By: PHP/8.0.22
# X-XSS-Protection: 1; mode=block
#* Request Headers:
# Accept: application/json, text/plain, */*
# Accept-Encoding: gzip, deflate, br
# Accept-Language: ja,en-US;q=0.9,en;q=0.8
# Connection: keep-alive
# Content-Length: 50
# Content-Type: application/json;charset=UTF-8
# Cookie: pma_lang=ja; XSRF-TOKEN=eyJpdiI6IncrcVBIeEdyQVhkdU9wTUN0Zzl6OVE9PSIsInZhbHVlIjoiQ3NRSmVnOUw3eEYwaEVoSUxRZzNySlFpQmwzQXg4bnp6ejFRYUJkeDc1a3FISVYyTC9TYkNGVXRyb0VPQ1lWeDIvOVFoWmc4OENmUjU4SDZHNndNR1FmMlExMExaenFqcS9ST3k2QWF2eXBTeEp6RjVPamFGTWRUQk1RRjQxeVUiLCJtYWMiOiIyZWRhMWFjMDc3NGE4OGQyMWE0ZGI4MTBhMWJkNTczOWQzZTdiMGZmNmFhYmQxMmY5NjVkNWFhOWEyODkwMWRiIiwidGFnIjoiIn0%3D; laravel_session=eyJpdiI6Im1KTm5vNWFwU09EZ1oyQ0V2RkVnUmc9PSIsInZhbHVlIjoibDdRQ3Azb214YTFXMWRMOU5GbForTC9DOUYwQ0JvQ3dDbXZJdVZaTkY4VW1UY2pqV0ZFNUMyRzd1ajhEckdXczFUVUJrQ1NlQjMwclVucXYveHQ1N3ZaNjJ0dVZCZHJwRDVLcDVCUHNadlovWEltb1J4REh2MHROdWZoUWE5aloiLCJtYWMiOiI1MDRkMmM2OTk5MmNmZWQ4M2E4ZmY2YTIzYmIyNDFjOWYyZGZhNDlmMzU5ZWM2Y2I0YmE1YjZhMGYwYmI0ZmZjIiwidGFnIjoiIn0%3D
# Host: localhost:8080
# Origin: http://localhost:3000
# Referer: http://localhost:3000/
# sec-ch-ua: "Chromium";v="106", "Google Chrome";v="106", "Not;A=Brand";v="99"
# sec-ch-ua-mobile: ?0
# sec-ch-ua-platform: "macOS"
# Sec-Fetch-Dest: empty
# Sec-Fetch-Mode: cors
# Sec-Fetch-Site: same-site
# test: eyJpdiI6IncrcVBIeEdyQVhkdU9wTUN0Zzl6OVE9PSIsInZhbHVlIjoiQ3NRSmVnOUw3eEYwaEVoSUxRZzNySlFpQmwzQXg4bnp6ejFRYUJkeDc1a3FISVYyTC9TYkNGVXRyb0VPQ1lWeDIvOVFoWmc4OENmUjU4SDZHNndNR1FmMlExMExaenFqcS9ST3k2QWF2eXBTeEp6RjVPamFGTWRUQk1RRjQxeVUiLCJtYWMiOiIyZWRhMWFjMDc3NGE4OGQyMWE0ZGI4MTBhMWJkNTczOWQzZTdiMGZmNmFhYmQxMmY5NjVkNWFhOWEyODkwMWRiIiwidGFnIjoiIn0=
# User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36
# X-XSRF-TOKEN: eyJpdiI6IncrcVBIeEdyQVhkdU9wTUN0Zzl6OVE9PSIsInZhbHVlIjoiQ3NRSmVnOUw3eEYwaEVoSUxRZzNySlFpQmwzQXg4bnp6ejFRYUJkeDc1a3FISVYyTC9TYkNGVXRyb0VPQ1lWeDIvOVFoWmc4OENmUjU4SDZHNndNR1FmMlExMExaenFqcS9ST3k2QWF2eXBTeEp6RjVPamFGTWRUQk1RRjQxeVUiLCJtYWMiOiIyZWRhMWFjMDc3NGE4OGQyMWE0ZGI4MTBhMWJkNTczOWQzZTdiMGZmNmFhYmQxMmY5NjVkNWFhOWEyODkwMWRiIiwidGFnIjoiIn0=


# ↓

#* General:
# Request URL: https://nextjs-laravel-hands-on.herokuapp.com/login
# Request Method: POST
# Status Code: 419 unknown status
# Remote Address: 54.159.116.102:443
# Referrer Policy: strict-origin-when-cross-origin
#* Response Headers:
# Access-Control-Allow-Credentials: true
# Access-Control-Allow-Origin: https://nextjs-laravel-hands-on-hashiudo.vercel.app
# Cache-Control: no-cache, private
# Connection: keep-alive
# Content-Type: application/json
# Date: Sun, 23 Oct 2022 22:11:03 GMT
# Server: nginx
# Set-Cookie: laravel_session=eyJpdiI6IjFRR29DbW14SFRGOGZqOXpkY2I4VUE9PSIsInZhbHVlIjoiWldBRkdoT0V4N0dkYS92NXFRU2RZNTF2TFFob3FjQkNhZUJwa0d6ek9YM2w3WUY0MnRDZ1hEOExwQXpCNDhOVm9rM1RMR1J6RWNHY0Z2V0xUNXBYVnplMDQ3Si91ZWZBdm9TMDhsbUFBSzYrYnFsK0hRcENEbXpZK0oxNlhUY1ciLCJtYWMiOiI5MzY0NWVmYWUwOTRjYzhiYTkyYjBlNjU5MzBjOGQyZTIyZTExOTBlMjlmMWY4NDkxMzQyMWM2ZWRmYWM4OTY2IiwidGFnIjoiIn0%3D; expires=Mon, 24-Oct-2022 00:11:03 GMT; Max-Age=7200; path=/; domain=.vercel.app; httponly
# Transfer-Encoding: chunked
# Via: 1.1 vegur
#* Request Headers:
# Accept: application/json, text/plain, */*
# Accept-Encoding: gzip, deflate, br
# Accept-Language: ja,en-US;q=0.9,en;q=0.8
# Connection: keep-alive
# Content-Length: 50
# Content-Type: application/json;charset=UTF-8
# Host: nextjs-laravel-hands-on.herokuapp.com
# Origin: https://nextjs-laravel-hands-on-hashiudo.vercel.app
# Referer: https://nextjs-laravel-hands-on-hashiudo.vercel.app/
# sec-ch-ua: "Chromium";v="106", "Google Chrome";v="106", "Not;A=Brand";v="99"
# sec-ch-ua-mobile: ?0
# sec-ch-ua-platform: "macOS"
# Sec-Fetch-Dest: empty
# Sec-Fetch-Mode: cors
# Sec-Fetch-Site: cross-site
# User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36
# X-Requested-With: XMLHttpRequest
# X-XSRF-TOKEN



# --------------------

# Laravel+axiosのCSRF対策
# https://www.softel.co.jp/blogs/tech/archives/3461

# LaravelはミドルウェアVerifyCsrfTokenが以下のCookieを送る。

# Set-Cookie: XSRF-TOKEN=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
# axiosはCookieにXSRF-TOKENがあると、リクエスト時に以下のヘッダを送るようになっている。

# X-XSRF-TOKEN: xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
# LaravelはX-XSRF-TOKENがあるか確認し、値をチェックする。


# [Client] GET: /sanctum/csrf-cookie
# ↓ Req
# [Laravel]
# - VerifyCsrfToken → Set-Cookie: XSRF-TOKEN=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
# ↓ Res
# [Client] Set-Cookieを見て、ブラウザのCookieに保存

# [Client] POST: /login
# - Cookie: XSRF-TOKEN を見て、Axiosが自動的にX-XSRF-TOKENヘッダーを自動的に付与
# ↓ Req
# [Laravel] X-XSRF-TOKENがあるか確認し、値をチェック

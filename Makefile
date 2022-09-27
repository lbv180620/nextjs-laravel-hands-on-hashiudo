include Makefile.env

# 擬似ターゲット
# .PHONEY:

ps:
	docker compose ps

# npm-script
y:
	cd frontend && yarn install
yd:
	cd frontend && yarn dev
yb:
	cd frontend && yarn build
ys:
	cd frontend && yarn start
yl:
	cd frontend && yarn lint
yf:
	cd frontend && yarn format
ylf:
	cd frontend && yarn lint-format
yt:
	cd frontend && yarn test
yg:
	cd frontend && yarn gen-types

# Laravel Mix用npm-script
x:
	cd backend && yarn install
xd:
	cd backend && yarn dev
xw:
	cd backend && yarn watch
xwp:
	cd backend && yarn watch-poll
xh:
	cd backend && yarn hot
xp:
	cd backend && yarn prod


# ==== 役立つ情報 ====

#* WEBアプリ開発まとめ(AWS, PHP, Laravel, Linux, Github, MySQL, JavaScript, CSS, Vueなど)
# https://zenn.dev/takahiroinoway/books/30510b7bc78514

#* Laravel使いの情報源まとめ
# https://zenn.dev/imah/articles/31c28f306487e2e5d141#%E5%9F%BA%E6%9C%AC
# https://laravel.com/
# https://laracasts.com/
# https://laravel-news.com/
# https://laracon.net/
# https://larajobs.com/

#* Laravelチートシート
# https://dev.to/ericchapman/my-beloved-laravel-cheat-sheet-3l73

#* ヘルパ関数まとめ
# Laravel 6.x ヘルパ
# https://readouble.com/laravel/6.x/ja/helpers.html
# https://blog.capilano-fw.com/?p=837

#* PHPコーディング規約
# https://qiita.com/namizatork/items/79b0a8002575bc74dfd8
# https://qiita.com/hshimo/items/04be1f432240c58300f4

#* Laravel 論理削除(Soft Delete)の書き方
# https://yutaro-blog.net/2022/03/10/laravel-softdelete/
# https://biz.addisteria.com/laravel_softdelete/

#* HTTP リクエストメソッド
# https://developer.mozilla.org/ja/docs/Web/HTTP/Methods
# https://architecting.hateblo.jp/entry/2020/03/26/124952
# https://omathin.com/http-method/
# https://qiita.com/morikuma709/items/956d7c58908cb481d7e8
# https://shiro-secret-base.com/?p=578

# POST: リソースの新規作成 [CREATE]
# PUT: リソースが存在しない→リソースの新規作成|リソースが存在する→既存リソースの完全置換(上書き)
# PATCH: 既存リソースの部分置換(差分のみ) [UPDATE|SOFT DELETE]
# DELETE: 既存リソースの完全削除 [HARD DELETE]

#* トランザクション
# https://readouble.com/laravel/8.x/ja/database.html
# https://codelikes.com/laravel-use-transactions/
# https://qiita.com/yukachin0414/items/97194eb8e6f51cece9f3
# https://www.hypertextcandy.com/laravel-tips-transaction-method-returns-value

# ⑴ トランザクション(取引)とは?
# →トランザクションはDBの整合性を守るための手法
# ⑵ トランザクションの使い所
# - 複数テーブルを同時に更新
# → 複数テーブル or レコードで成り立つ1つの処理使うことが多い
# ⑶ トランザクションの流れ
# - 例) Aさんの口座からBさんの口座に100万円振り込む
# この場合2つの処理を行う必要がある。
# 「Aさんの口座から100万円減らす処理」➡️「Bさんの口座に100万円増やす処理」
# 途中で処理が止まってしまったら、データに不整合が生じてしまう。
# ⬇️
# この2つの処理をひとまとめにして、2つの処理が両方成功したら確定(Commit)し、
# もし仮に途中で処理が止まってしまったら、元の状態に戻す(Rollback)という処理を行う処理がトランザクション。

# トランザクションを設定するタイミング
# ✔︎ トランザクションの開始
# → コードの中に開始位置を書く必要がある
# ✔︎ 確定のタイミングの決定
# → 必要なDB処理が終わったら任意のタイミングで確定させる
# ✔︎ ロールバックのタイミング
# → もし途中で処理が止まったタイミングでDBの変更を戻す
# ✔︎ 例外処理
# → もし例外(DBが思ったとおりに更新されなかった場合)は何らかの処理をする


# ==== プロジェクトの立ち上げ ====

launch:
	@make chinfra
	@make file-set
	@make publish-phpmyadmin
	@make publish-redisinsight
	@make build
	@make up
	@make $(db)-set
	@make useradd
# @make useradd-client
	@make laravel-install
	@make laravel-env
	@make laravel-set


#& clientのみ起動
# launch:
# 	cp env/docs/docker-compose.env .env
# 	@make build
# 	@make up
# 	@make useradd-client


#& Laravelアプリをgit cloneした場合の起動手順:
# ⑴ env/とMakefile.envをプロジェクトのルートに配置
# ⑵ make relaunch
relaunch:
	@make file-set
	@make publish-phpmyadmin
	@make publish-redisinsight
	@make build
	@make up
	@make $(db)-set
	@make useradd
	@make composer
	@make yarn
	@make laravel-env
	@make laravel-set

# ! 「service "db" is not running container」 relaunchしてdbコンテナがexited(1)のときの対処法
# Docker Desktopをrestart → もう一度relaunch
# ※ 一連の流れで処理を実行していくと、dbコンテナが立ち上がらない現象がよく出る。処理を個別で実行すると上手く立ち上がる。


#& プロジェクトの作り直し
reborn:
	@make destory
	@make relaunch


#**** インフラ環境の切り替え ****

# Makefile.envで環境変数を指定
# デフォルト: os=mac, web=apache, db=mysql, ctr=web
# wsl2の場合、Makefileもコピー
chinfra:
	rm -rf infra/docker/backend/*
	cp -rf env/configs/$(os)/$(web)/$(db)/backend/* infra/docker/backend
	cp env/configs/$(os)/$(web)/$(db)/docker-compose.yml docker-compose.yml

chmk:
	cp env/configs/wsl/Makefile Makefile


# **** Laravelの設定 ****

# Laravelのインストール
#^ ※ Mix: v9.18.0以前, Vite: v9.19.0以降
# Laravel 9でMixを使いたい場合は、laravel_version=9.18 と指定
laravel-install:
	docker compose exec $(ctr) php -d memory_limit=-1 /usr/bin/composer create-project --prefer-dist "laravel/laravel=$(laravel_version).*" .

laravel-env:
	cp env/docs/.env.example backend/.env
	cp env/docs/Makefile backend/Makefile
	@make clear-cache

laravel-set:
	@make keygen
	docker compose exec $(ctr) php artisan storage:link
	docker compose exec $(ctr) chown -R www-data storage/ bootstrap/cache
	@make fresh-seed


# **** ディレクトリとファイルの作成と削除 ****

# backend単体で使う → mkdir backend
# backendとfrontendを併用して使う → mkdir backend frontend
file-set:
	mkdir -p sqls/{sql,script} infra/{data,redis,pgadmin4}
	touch sqls/sql/query.sql sqls/script/set-query.sh
	mkdir -p .vscode && cp env/docs/{launch.json,settings.json} .vscode
	cp env/docs/docker-compose.env .env
	mkdir -p backend
# mkdir -p backend frontend

# phpMyAdmin
publish-phpmyadmin:
	mkdir -p ./infra/phpmyadmin/sessions
	sudo chown 1001 ./infra/phpmyadmin/sessions

# redisinsight
publish-redisinsight:
	mkdir -p ./infra/redisinsight/sessions
	sudo chown 1001 ./infra/redisinsight/sessions

file-delete:
	rm -rf infra/{data,redis,pgadmin4} sqls .vscode && rm .env
	rm -rf backend frontend infra/{redisinsight,phpmyadmin}


# **** SQLファイルの設定 ****

mysql-set:
	docker compose exec db bash -c 'mkdir -p /var/lib/mysql/sql && \
		touch /var/lib/mysql/sql/query.sql && \
		chown -R mysql:mysql /var/lib/mysql'

mariadb-set:
	docker compose exec db bash -c 'mkdir -p /var/lib/mysql/sql && \
		touch /var/lib/mysql/sql/query.sql && \
		chown -R mysql:mysql /var/lib/mysql'

postgres-set:
	docker compose exec db bash -c 'mkdir -p /var/lib/postgresql/data/sql && \
		touch /var/lib/postgresql/data/sql/query.sql && \
		chown -R postgres:postgres /var/lib/postgresql/data'


# **** パーミッションの設定 ****

chown:
	@make chown-data
	@make chown-backend

chown-backend:
	sudo chown -R $(USER):$(GNAME) backend

chown-work:
	docker compose exec $(ctr) bash -c 'chown -R $$USER_NAME:$$GROUP_NAME /work'

chown-data:
	sudo chown -R $(USER):$(GNAME) infra/data

chown-mysql:
	docker compose exec db bash -c 'chown -R mysql:mysql /var/lib/mysql'

chown-mariadb:
	docker compose exec db bash -c 'chown -R mysql:mysql /var/lib/mysql'

chown-postgres:
	docker compose exec db bash -c 'chown -R postgres:postgres /var/lib/postgresql/data'


# **** ユーザーとグループの設定 ****

useradd:
# ctr-root
	docker compose exec $(ctr) bash -c ' \
		useradd -s /bin/bash -m -u $$USER_ID -g $$GROUP_ID $$USER_NAME'
# db-root
	docker compose exec db bash -c ' \
		useradd -s /bin/bash -m -u $$USER_ID -g $$GROUP_ID $$USER_NAME'

groupadd:
# ctr-root
	docker compose exec $(ctr) bash -c ' \
		groupadd -g $$GROUP_ID $$GROUP_NAME'
# db-root
	docker compose exec db bash -c ' \
		groupadd -g $$GROUP_ID $$GROUP_NAME'


useradd-client:
# client-root
	docker compose exec client bash -c ' \
		useradd -s /bin/bash -m -u $$USER_ID -g $$GROUP_ID $$USER_NAME'

groupadd-client:
# client-root
	docker compose exec client bash -c ' \
		groupadd -g $$GROUP_ID $$GROUP_NAME'


# ==== フロントエンドの設定 ====

# **** Webpackの設定 ****

# ※手動でルーティング編集しないといけない
# backendとfrontendで併用する場合 mkdir -p frontend/public && cp env/.htaccess $(env)/public/ コメントアウト
webpack-set:
	mkdir -p $(env)/resources/{scripts,styles,templates,images}
	cp -r env/webpack-$(env)/{*,.eslintrc.js,.prettierrc} $(env)/
	mkdir $(env)/resources/styles/scss
	mv $(env)/styles/* $(env)/resources/styles/scss/
	rm -rf $(env)/styles
	mv $(env)/setupTests.ts $(env)/resources/
	mkdir -p frontend/public
	cp env/.htaccess $(env)/public/

webpack-del:
	rm -r $(env)/{webpack,webpack.common.js,webpack.dev.js,webpack.prod.js,jsconfig.json,tsconfig.json,babel.config.js,postcss.config.js,stylelint.config.js,.eslintrc.js,.prettierrc,package.json,tailwind.config.js,tsconfig.jest.json,jest.config.js}

# **** Reactの設定 ****

# toolkit + react-query + axios
react-set:
	yarn create react-app --template redux-typescript frontend
	mkdir frontend/styles
	cp -r env/react/common/. frontend/
	chmod +x frontend/.husky/pre-commit
	cd frontend && yarn install
	@make tailwind-set
	mv frontend/styles frontend/src/

# **** Next.jsの設定 ****

next-set:
	yarn create next-app --typescript frontend
	rm frontend/.eslintrc.json
	rm -rf frontend/pages
	rm frontend/styles/Home.module.css
	cp -r env/nextjs/$(v)/* frontend/
	cp -r env/nextjs/common/. frontend/
	chmod +x frontend/.husky/pre-commit
	cd frontend && yarn install
	@make tailwind-set

# ^ yarn installでerror : The engine "node" is incompatible with this module. が出たときの対処法
# https://nashidos.hatenablog.com/entry/2020/08/30/231517

#* Next.jsアプリをgit cloneした場合の手順:
# ⑴ .husky/-/{.gitignore,husky.sh}のコピーを.husky下に配置
# ⑵ make next-reset
next-reset:
	chmod +x frontend/.husky/pre-commit
	cd frontend && yarn install

# **** Tailwind CSSの設定 ****

tailwind-set:
	cd frontend && yarn add -D tailwindcss postcss autoprefixer prettier-plugin-tailwindcss
	cp -r env/tailwind/{tailwind.config.js,postcss.config.js} frontend/
	cp -r env/tailwind/styles frontend/

# **** GraphQLの設定 ****

graphql-set:
	cd frontend && yarn add graphql @apollo/client @apollo/react-hooks cross-fetch
	cd frontend && yarn add -D jest@26.6.3 @testing-library/react@11.2.6 @types/jest@26.0.22 @testing-library/jest-dom@5.11.10 @testing-library/dom@7.30.3 babel-jest@26.6.3 @testing-library/user-event@13.1.3 jest-css-modules msw@0.35.0 next-page-tester@0.29.0 @babel/core@7.17.9
	@make codegen-init

codegen-init:
	cd frontend && yarn add -D @graphql-codegen/cli
	cd frontend && yarn graphql-codegen init
	cd frontend && yarn
	cd frontend && yarn add -D @graphql-codegen/typescript
	cd frontend && mkdir src/queries && touch src/queries/queries.ts

# - What type of application are you building?: Application built with React
# - Where is your schema?: GraphQLサーバーのURLパスを指定
# → Hasuraを使用する場合: プロジェクトのLaunch Console → API → POSTのURLを貼り付け
# Where are your operations and fragments?: 読みに行くクエリの階層を指定
# → src/queries/**/*.ts
# Pick plugins: デフォルト
# Where to write the output: 自動生成した型の出力先の指定
# → src/types/generated/graphql.tsx
# Do you want to generate an introspection file?: n
# How to name the config file?: codegen.yml
# What script in package.json should run the codegen?: gen-types


# ==== docker composeコマンド群 ====

# **** Build & Up ****

build:
	docker compose build --no-cache --force-rm

up:
	docker compose up -d

rebuild:
	@make build
	@make up


# **** Start & Stop ****

start:
	docker compose start

stop:
	docker compose stop

restart:
	@make stop
	@make start


# **** Down系 ****

# コンテナを消去
down:
	docker compose down --remove-orphans

# コンテナを再生成
reset:
	@make down
	@make up

# ソースコード,データ,コンテナ,イメージ,ボリューム,ネットワークを消去
destroy:
	@make stop
	@make chown
	@make file-delete
	@make purge

# ボリュームを消去
destroy-volumes:
	docker compose down --volumes --remove-orphans

# コンテナ,イメージ,ボリューム,ネットワークを消去
purge:
	docker compose down --rmi all --volumes --remove-orphans


# **** インフラのみ再生成 ****

# インフラを再ビルド
init:
	@make rebuild
	@make chown-$(db)
	@make useradd
	@make composer
	@make yarn
	@make clear-cache
	@make laravel-set

# ソースコードとデータは消さずに、インフラだけを作り直す
remake:
	@make purge
	@make init


# **** log関連 ****

logs:
	docker compose logs

logs-watch:
	docker compose logs --follow

log-web:
	docker compose logs web

log-web-watch:
	docker compose logs --follow web

log-app:
	docker compose logs app

log-app-watch:
	docker compose logs --follow app

log-db:
	docker compose logs db

log-db-watch:
	docker compose logs --follow db


# ==== コンテナ操作コマンド群 ====

# app
app:
	docker compose exec app bash
app-usr:
	docker compose exec -u $(USER) app bash
stop-app:
	docker compose stop app


# web
web:
	docker compose exec web bash
web-sh:
	docker compose exec web sh
web-usr:
	docker compose exec -u $(USER) web bash
stop-web:
	docker compose stop web


# db
db:
	docker compose exec db bash
db-usr:
	docker compose exec -u $(USER) db bash


# mysql
sql:
	docker compose exec db bash -c 'mysql -u $$MYSQL_USER -p$$MYSQL_PASSWORD $$MYSQL_DATABASE'
sql-root:
	docker compose exec db bash -c 'mysql -u root -p'
sqlc:
	@make query
	docker compose exec db bash -c 'mysql -u $$MYSQL_USER -p$$MYSQL_PASSWORD $$MYSQL_DATABASE < /var/lib/mysql/sql/query.sql'


# postgres
psql:
	docker compose exec db bash -c 'PGPASSWORD=$$POSTGRES_PASSWORD psql -U $$POSTGRES_USER -d $$POSTGRES_DB'
psqlc:
	@make query
	docker compose exec db bash -c 'PGPASSWORD=$$POSTGRES_PASSWORD psql -U $$POSTGRES_USER -d $$POSTGRES_DB < /var/lib/postgresql/data/sql/query.sql'


query:
	@make chown-data
	cp ./sqls/sql/query.sql ./infra/data/sql/query.sql
# cp ./sqls/sql/query.sql ./_data/sql/query.sql
	@make chown-$(db)

cp-sql:
	@make chown-data
	cp -r -n ./sqls/sql/** ./data/sql
# cp -r -n ./sqls/sql ./_data/sql
	@make chown-$(db)


# redis
redis:
	docker compose exec redis redis-cli --raw


# client
client:
	docker compose exec client bash
client-usr:
	docker compose exec -u $(USER) client bash
stop-client:
	docker compose stop clinet


# ------------------------

#* テスト用DBコンテナのコマンド群

# db-test
db-test:
	docker compose exec db-test bash
db-test-usr:
	docker compose exec -u $(USER) db-test bash

# mysql
sql-test:
	docker compose exec db-test bash -c 'mysql -u $$MYSQL_USER -p$$MYSQL_PASSWORD $$MYSQL_DATABASE'
sql-test-root:
	docker compose exec db-test bash -c 'mysql -u root -p'
sqlc-test:
	@make query
	docker compose exec db-test bash -c 'mysql -u $$MYSQL_USER -p$$MYSQL_PASSWORD $$MYSQL_DATABASE < /var/lib/mysql/sql/query.sql'

# postgres
psql-test:
	docker compose exec db-test bash -c 'PGPASSWORD=$$POSTGRES_PASSWORD psql -U $$POSTGRES_USER -d $$POSTGRES_DB'
psqlc-test:
	@make query
	docker compose exec db-test bash -c 'PGPASSWORD=$$POSTGRES_PASSWORD psql -U $$POSTGRES_USER -d $$POSTGRES_DB < /var/lib/postgresql/data/sql/query.sql'


# ==== Laravel artisanコマンド群 ====

# Laravel 6.x サービスプロバイダ
# https://readouble.com/laravel/6.x/ja/providers.html

# Artisanチートシート
# https://artisan.page/

# Laravelのバージョン確認
art-v:
	docker compose exec $(ctr) php artisan --version
laravel-v:
	@make art-v

# artisanコマンドの一覧
art-l:
	docker compose exec $(ctr) php artisan list $(cmd)

# commandを作成する
#^ app/Console/Commands配下にファイルが生成される
mkcmd:
	docker compose exec $(ctr) php artisan make:command $(cmd)

# commandの実行
runcmd:
	docker compose exec $(ctr) php artisan $(cmd):$(name)

# 例外の作成
#^ app/Exceptions配下にファイルが生成される
mkexcep:
	docker compose exec $(ctr) php artisan make:exception $(excep)


# **** Migration関連 ****

# Laravel 6.x データベース：マイグレーション
# https://readouble.com/laravel/6.x/ja/migrations.html
# → 使用できるカラムタイプとカラム修飾子を参照しながらテーブル定義
# → 外部キー制約
# → 使用可能なインデックスタイプ

# Laravel 8.x マイグレーション
# https://readouble.com/laravel/8.x/ja/migrations.html
# → 利用可能なカラムタイプとカラム修飾子を参照しながらテーブル定義

# まとめ
# https://codelikes.com/laravel-migration-summary/#toc6
# https://zenn.dev/person_link/articles/47898d68812e61

# make mkmig-create_<テーブル名>
mkmig-%:
	docker compose exec $(ctr) php artisan make:migration $(@:mkmig-%=%)_table

# テーブルの作成: make mkmigc table=<テーブル名>
mkmigc:
	docker compose exec $(ctr) php artisan make:migration create_$(table)_table

# テーブルの作成(上記と同じ意味): make mkmigc-c table=<テーブル名>
mkmigc-c:
	docker compose exec $(ctr) php artisan make:migration create_$(table)_table --create=$(table)

# テーブルの作成: make mkmigc-<テーブル名>
mkmigc-%:
	docker compose exec $(ctr) php artisan make:migration create_$(@:mkmigc-%=%)_table

# カラムの追加: make mkmiga col=<カラム名> table=<テーブル名> --table=<テーブル名>
#^ カラムを追加したら、rollback時に削除されるようにする！
# $table->dropColumn('<追加したカラム名>');
mkmiga:
	docker compose exec $(ctr) php artisan make:migration add_$(col)_to_$(table)_table --table=$(table)

# カラムの削除: make mkmigr col=<カラム名> table=<テーブル名> --table=<テーブル名>
mkmigr:
	docker compose exec $(ctr) php artisan make:migration remove_$(col)_from_$(table)_table --table=$(table)

# カラムの編集: make mkmige col=<カラム名> table=<テーブル名> --table=<テーブル名>
# ※ docker compose exec $(ctr) composer require doctrine/dbal が必要
mkmige:
	docker compose exec $(ctr) php artisan make:migration edit_$(col)_of_$(table)_table --table=$(table)


# .envファイルのDB_DATABASEで指定されたデータベースにマイグレートする
# デフォルトデータベースは larabel_local
migrate:
	docker compose exec $(ctr) php artisan migrate --env=$(env)

mig:
	@make migrate

# マイグレート先のデータベースを指定
# make mig-d-<データベース名>
mig-d-%:
	docker compose exec $(ctr) php artisan migrate --database=$(@:mig-d-%=%)

# fresh: 全テーブルをドロップ → 再マイグレート
# --seed: ダミーデータも反映
fresh:
	docker compose exec $(ctr) php artisan migrate:fresh --env=$(env)
fresh-seed:
	docker compose exec $(ctr) php artisan migrate:fresh --seed --env=$(env)

# refresh: ロールバック → 再マイグレート
# --seed: ダミーデータも反映
refresh:
	docker compose exec $(ctr) php artisan migrate:refresh --env=$(env)
refresh-seed:
	docker compose exec $(ctr) php artisan migrate:refresh --seed --env=$(env)

rollback-test:
	docker compose exec $(ctr) php artisan migrate:fresh
	docker compose exec $(ctr) php artisan migrate:refresh

# ロールバック: 同時に実行した最後のマイグレーションをまとめて元に戻す
#^ デフォルトでは、Batch数が最大のものをrollbackする。
# ロールバック時にカラムも消したい場合、マイグレーションファイルのdown関数に$table->dropColumn('消したいカラム名'); を書いて置く。
# ロールバックとdownメソッドに関する参考記事:
# https://qiita.com/MitsukiYamauchi/items/e43bb38006a4bed230cb
# https://qiita.com/masuda-sankosc/items/2a6999cca62de4facd45#%E3%83%AD%E3%83%BC%E3%83%AB%E3%83%90%E3%83%83%E3%82%AF
rollback:
	docker compose exec $(ctr) php artisan migrate:rollback

# 指定した個数分のマイグレーションファイルまでロールバックする
#^ make migstでmigrationsテーブルの状態を確認し、下から数えてロールバックしたいマイグレーションファイルの個数を指定
# --step={ロールバックする個数}
rollback-s:
	docker compose exec $(ctr) php artisan migrate:rollback --step=$(step)


# 実行されているマイグレーションファイルの確認
# migrationsテーブルからレコードを全件取得しているだけ。
# select * from migrations;
migst:
	docker compose exec $(ctr) php artisan migrate:status

# rollback
migrb:
	@make rollback
migrb-s-%:
	docker compose exec $(ctr) php artisan migrate:rollback --step=$(@:migrb-s-%=%)

# reset
migreset:
	docker compose exec $(ctr) artisan migrate:reset

# refresh
migrefresh:
	docker compose exec $(ctr) artisan migrate:refresh
migrefresh-s:
	@make refresh-seed

# fresh
migfresh:
	docker compose exec $(ctr) artisan migrate:fresh
migfresh-s:
	@make fresh-seed


# ^ マイグレーションファイルで外部キー制約を設定する際の注意点
# - 外部キー制約のデータ型はunsignedBigInteger()しか受け付けない。
# - また外部キーのデータ型とその紐づけるテーブルの主キーのデータ型は一致しないといけない。
# - よって、リレーションを使う場合は、キーのデータ型をunsignedBigInteger()に揃える必要がある。

# ^ 中間テーブルのマイグレーションファイルをmigrateする際の注意点
# - 中間テーブルが最後にmigarteされないとエラーになる。
# - なぜなら、外部キー制約には存在するテーブルの値しか使えないから。
# - そのため、紐づけ元のテーブルのマイグレーションファイルを中間テーブルのマイグレーションファイルより先に作成する必要がある。
# - マイグレーションの実行はファイルが作られた順


# **** Model関連 ****

# Eloquentチートシート
# https://blog.renatolucena.net/post/eloquent-relationships-cheat-sheet

# Eloquent ORM

# Laravel6以前では、Modelsディレクトリが作成されないので、model=Models/<モデル名>とする。

# mkmodel-<モデル名> : 先頭大文字かつ対応するテーブル名の単数形 ※「/」は使えない
mkmodel-%:
	docker compose exec $(ctr) php artisan make:model $(@:mkmodel-%=%)

# mkmodel model=<ディレクトリ名/モデル名>
mkmodel:
	docker compose exec $(ctr) php artisan make:model $(model)

# マイグレーションファイルも一緒に生成(推奨)
mkmodel-m:
	docker compose exec $(ctr) php artisan make:model $(model) -m

# マイグレーションファイルとコントローラを一緒に生成(推奨)
mkmodel-mc:
	docker compose exec $(ctr) php artisan make:model $(model) -mc

# モデルに紐づいたファイル(コントローラやマイグレーションファイル)を一度に生成(推奨)
mkmodel-all:
	docker compose exec $(ctr) php artisan make:model $(model) -a

# ^ モデルを作る際の注意点
# - 1テーブル : 1モデル
# - 名前はテーブルの単数形
# - モデル名の複数形テーブルに自動的に紐づく
# - 中間テーブルのモデルを作る際は、必ずベースとなるモデルを先に作ってから作る
# - 中間テーブルのモデルの命名は、ベースとなるモデル同士をupper camel caseで結合する

# ? テーブルの単数型を調べる方法
# php artisan tinker // ターミナルでPHPを実行
# echo Str::plural('単語'); // 単数形 → 複数形
# echo Str::singular('単語'); // 複数形 → 単数形


# **** Controller関連 ****

# Laravel 6.x コントローラ
# https://readouble.com/laravel/6.x/ja/controllers.html
# → リソースコントローラ

# Laravel 8.x コントローラ
# https://readouble.com/laravel/8.x/ja/controllers.html
# → リソースコントローラ

# Laravel 6.x Eloquent：コレクション
# https://readouble.com/laravel/6.x/ja/eloquent-collections.html

# Laravel 6.x Eloquent：リレーション
# https://readouble.com/laravel/6.x/ja/eloquent-relationships.html

# Laravel 6.x データベース：クエリビルダ
# https://readouble.com/laravel/6.x/ja/queries.html
# → JOIN

# Laravel 6.x データベース：ペジネーション
# https://readouble.com/laravel/6.x/ja/pagination.html
# → ペジネーション結果の表示
# → ペジネータインスタンスメソッド

# PHP ペジネーション 記事
# https://qiita.com/neustrashimy/items/3932382c267d04413b4e

# コントローラの作成
# mkctrl-<モデル名>
mkctrl-%:
	docker compose exec $(ctr) php artisan make:controller $(@:mkctrl-%=%)Controller
mkctrl:
	docker compose exec $(ctr) php artisan make:controller $(model)Controller

# RESTfulなコントローラの作成
# オプションは、--resource | -r
# 詳細はマニュアルのリソースコントローラを参照
# 実行後はマニュアルのリソースコントローラを参考にルーティングのリソース(URL)を設定
mkctrl-r-%:
	docker compose exec $(ctr) php artisan make:controller $(@:mkctrl-crud-%=%)Controller -r
mkctrl-r:
	docker compose exec $(ctr) php artisan make:controller $(model)Controller -r


# **** Routing関連 ****

# Laravel 6.x ルーティング
# https://readouble.com/laravel/6.x/ja/routing.html

# まとめ
# https://codelikes.com/laravel-routing-summary/#toc6
# https://www.ritolab.com/entry/119

route-list:
	docker compose exec $(ctr) php artisan route:list

route-list-name-%:
	docker compose exec $(ctr) php artisan route:list --name $(@:route-list-name-%=%)

# ------------

#? Laravel 8で前のバージョンのルーティングで、コントローラーの指定する方法

# 参考記事:
# https://qiita.com/M_Ishikawa/items/8527c3193072226f0686

# app/Providers/RouteServiceProvider.php を変更する必要があり、コメントアウトされている。
# protected $namespace = 'App\\Http\\Controllers'; のコメントアウトを外して有効にする。
# Route::get('hoge/fuga', 'Hoge\FugaController@index'); で以前と変わらない書き方ができる。

# Laravel 8の記法:
# api.php
# use App\Http\Controllers\TaskController;
# Route::apiResource('tasks', TaskController::class);


# Laravel 8以前の記法:
# app/Providers/RouteServiceProvider.php
# 29行のnamespaceの部分をコメントアウト
# protected $namespace = 'App\\Http\\Controllers';

# api.php
# Route::apiResource('tasks', 'TaskController');


# **** Seeder & Factory関連 ****

# Laravel 6.x データベース：シーディング
# https://readouble.com/laravel/6.x/ja/seeding.html

# SeederクラスやFactoryクラスを作成・編集した場合、Composerのオートローダを再生成するために、dump-autoloadコマンドを実行する必要がある。
# make dump-autoload

# ------------

#& Seederクラスの作成

# make mkseed-<モデル名>
mkseeder-%:
	docker compose exec $(ctr) php artisan make:seeder $(@:mkseeder-%=%)Seeder
mkseeder:
	docker compose exec $(ctr) php artisan make:seeder $(model)Seeder
# mkseeder:
# 	docker compose exec $(ctr) php artisan make:seeder $(table)TableSeeder

# ------------

#& Seederの実行

seed:
	docker compose exec $(ctr) php artisan db:seed --env=$(env)
# 特定のSeederを指定
seed-class:
	docker compose exec $(ctr) php artisan db:seed --class=$(model)Seeder
# seed-class:
# 	docker compose exec $(ctr) php artisan db:seed --class=$(table)TableSeeder


#^ すでにテーブルにデータが入っている場合は、
# make refresh --seed
# make fresh --seed

# ------------

#& Factoryクラスの作成

# Laravel 6.x データベースのテスト
# https://readouble.com/laravel/6.x/ja/database-testing.html

# seeder単体 = オーダーメイド
# seedr + factory + facker = 大量生産
# factoryでfackerを使ってダミーデータを定義 → factoryをseederにセットし大量のダミーデータを作成

# make mkfactory-<モデル名>
mkfactory-%:
	docker compose exec $(ctr) php artisan make:factory $(@:mkfactory-%=%)Factory
mkfactory:
	docker compose exec $(ctr) php artisan make:factory $(model)Factory

#^ 推奨
# 使用するEloquentモデルを指定してFactoryクラスを作成
# https://e-seventh.com/laravel-modelfactory-faker/
mkfactory-m:
	docker compose exec $(ctr) php artisan make:factory $(model)Factory --model=$(model)
mkf:
	@make mkfactory-m


# ------------

#& Fackerの日本語化

# config/app.php
# 'faker_locale' => 'en_US', →  'faker_locale' => 'ja_JP',

# Facker 公式
# https://github.com/fzaninotto/Faker

# Facker チートシート
# https://qiita.com/kurosuke1117/items/c672405ac24b03af2a90
# https://qiita.com/tosite0345/items/1d47961947a6770053af
# https://cross-accelerate-business-create.com/2021/01/02/laravel7-faker/#i-2

# Faker 記事
# https://shingo-sasaki-0529.hatenablog.com/entry/how_to_use_php_faker
# https://zenn.dev/fuwakani/scraps/a0766eb0bbf49a
# https://codelikes.com/laravel-faker/
# https://ramble.impl.co.jp/762/#toc4
# https://blog.maro.style/post-1543/
# https://zenn.dev/fagai/articles/1ad4a85695c4f9


# **** Request & Validation関連 ****

# Laravel 6.x HTTPリクエスト
# https://readouble.com/laravel/6.x/ja/requests.html

# Laravel 6.x バリデーション
# https://readouble.com/laravel/6.x/ja/validation.html
# → フォームリクエストバリデーション
# → 使用可能なバリデーションルール

# Laravel 8.x バリデーション
# https://readouble.com/laravel/8.x/ja/validation.html
# → @errorディレクティブ

# バリデーションまとめ記事
# https://blog.capilano-fw.com/?p=341
# https://qiita.com/kd9951/items/abd063828e33a61c8c58#accepted
# https://reffect.co.jp/laravel/laravel_validation_understanding

# バリデーションエラー表示 - Laravel公式
# https://qiita.com/kcsan/items/c1c84637944ef6ac3d0b

# バリデーションエラー表示 記事
# https://qiita.com/kcsan/items/c1c84637944ef6ac3d0b
# https://qiita.com/gone0021/items/68f0563ac2852ad96b14
# https://zenn.dev/ichii/articles/f4e4f834d26761
# https://zakkuri.life/laravel-display-validation-errors/
# https://blog.capilano-fw.com/?p=8195

# リクエストファイルの作成
# make mkreq-<モデル名>
mkreq-%:
	docker compose exec $(ctr) php artisan make:request $(@:mkreq-%=%)Request
mkreq:
	docker compose exec $(ctr) php artisan make:request $(model)Request

#^ authorizeメソッドの戻り値をtureにすること忘れずに。

# バリデーションの日本語化
# config/app.php の 'locale' => 'ja', で切り替え
install-ja-lang:
	docker compose exec $(ctr) php -r "copy('https://readouble.com/laravel/$(laravel_version).x/ja/install-ja-lang-files.php', 'install-ja-lang.php');"
	docker compose exec $(ctr) php -f install-ja-lang.php
	docker compose exec $(ctr) php -r "unlink('install-ja-lang.php');"


# ~~~~ 手動方法① ~~~~

# Laravel 8.x auth.php言語ファイル - ReaDouble
# https://readouble.com/laravel/8.x/ja/auth-php.html

# Laravel 8.x validation.php言語ファイル - ReaDouble
# https://readouble.com/laravel/8.x/ja/validation-php.html

# Laravel 8.x pagination.php言語ファイル - ReaDouble
# https://readouble.com/laravel/8.x/ja/pagination-php.html

# Laravel 8.x passwords.php言語ファイル - ReaDouble
# https://readouble.com/laravel/8.x/ja/passwords-php.html

# ⑴ 以下のファイルを作成して、貼り付け。

# resources/lang/ja
# - auth.php
# - pagination.php
# - password.php
# - validation.php


# ⑵ 'attributes' => [], の設定


# ~~~~ 手動方法② ~~~~

# 以下好きな方を選択

# Laravel-Lang/lang
# https://github.com/Laravel-Lang/lang

# laravel-resources-lang-ja
# https://github.com/minoryorg/laravel-resources-lang-ja

# ⑴ zipファイルをダウンロード。

# code → Download ZIP

# ⑵ zipファイルを展開

# ⑶ locales/ja フォルダをコピー

# ⑷ resources/lang/ 以下にペースト

# ⑸ Requstファイルにattributesメソッドを定義


# **** API Resource関連 ****

# Laravel 8.x Eloquent：ＡＰＩリソース
# https://readouble.com/laravel/8.x/ja/eloquent-resources.html

# Laravel の API Resource の使い方（基礎編）
# https://brightful.jp/blog/programming/laravel-resource-collection/

# Laravel の Resource::collection と ResourceCollection の比較
# https://brightful.jp/blog/programming/laravel-resourcecollection/

# LaravelでAPIリソースを使う場合はN+1問題に注意する
# https://zenn.dev/tekihei2317/articles/d788362937eb96

#【Laravel】APIリソースを使う(Json/Resource)
# https://fresh-engineer.hatenablog.com/entry/2018/07/07/001530

# Laravel API Resource についてのあれこれ
# https://qiita.com/mikakane/items/e46617b6960a7e77ca2b


# ------------------------

# リソースの生成
mkresource:
	docker compose exec $(ctr) php artisan make:resource $(model)Resource

# リソースコレクション
mkresource-c:
	docker compose exec $(ctr) php artisan make:resource $(model) --collection

mkcollection:
	docker compose exec $(ctr) php artisan make:resource $(model)Collection


# **** Gate & Policy & Middleware関連 ****

# Laravel 8.x 認可 - ReaDouble
# https://readouble.com/laravel/8.x/ja/authorization.html

#? Laravel 認可の設定方法 参考記事

# https://qiita.com/tomoeine/items/f92de7d035e0fe8e7362#policy
# https://zenn.dev/tokatu/articles/8cc345b1e7a3a7#policy%E3%82%92%E4%BD%BF%E3%81%A3%E3%81%A6%E3%81%BF%E3%82%8B
# https://reffect.co.jp/laravel/laravel-gate-policy-understand#Policy-2
# https://biz.addisteria.com/gate_policy_middleware/
# https://qiita.com/kouki_o9/items/ec6a012db5a9a55bad41#policy%E3%81%A8%E3%81%AF

# Gate
# https://www.rail-c.com/%E3%80%90laravel%E3%80%91%E8%AA%8D%E5%8F%AF-gate%E3%81%AE%E4%BD%BF%E3%81%84%E6%96%B9/
# Policy
# https://www.rail-c.com/%E3%80%90laravel%E3%80%91policy%E3%83%9D%E3%83%AA%E3%82%B7%E3%83%BC%E3%81%AE%E4%BD%BF%E3%81%84%E6%96%B9/


mkpolicy:
	docker compose exec $(ctr) php artisan make:policy $(model)Policy

mkpolicy-model:
	docker compose exec $(ctr) php artisan make:policy $(model)Policy --model=$(model)
mkpolicy-model-%:
	docker compose exec $(ctr) php artisan make:policy $(model)Policy --model=$(@:mkpolicy-model-%=%)


# **** Mail関連 ****

mkmail:
	docker compose exec $(ctr) php artisan make:mail $(class)Mail

mknotification:
	docker compose exec $(ctr) php artisan make:notification $(class)Notification


# --------------------

#? MailHogのセットアップの手順

# ⑴ Laravel Sailのdocker-compose.ymlからmailhogコンテナの箇所を自身のdocker-compose.ymlにコピペ
# ⑵ make up


# --------------------

#? MailHogを利用したパスワードリセットのやり方

# ⑴ MAIL_FROM_ADDRESSの設定
# DBに登録したメールアドレスを指定
# .env
# MAIL_FROM_ADDRESS=no-reply@example.com

# ⑵ 開発中のパスワードリセットのフォームから、指定したメールアドレスにメールを送信

# ⑶ localhost:8025でMailHogにアクセスし、指定したメールアドレスに送信されたメールを確認

# ⑷ Reset Passwordボタンをクリックして、パスワードリセット


#^ パスワードリセットのページのURLの例
# http://localhost:8080/reset-password/a42e5252bfad217ef0899f9da33017ba4376a7647c039793fd8aaa05500b58ef?email=neko%40neko.com
# → トークンが自動生成されて、どこからでもアクセスできる。
# → 一時的にpassword_resetsテーブルにメールアドレスとこのトークンが格納される。
# → リセットが成功すると削除される。
# → config/auth.phpのpassordsのexpireでトークンの有効期限を指定できる。デフォルトは60分。


# --------------------

#? デフォルトの送信メール本文を編集する方法

# 補足
# https://www.sejuku.net/plus/question/detail/3415
# https://qiita.com/usaginooheso/items/9d61361d449a521a5854
# https://chico-shikaku.com/2020/09/delete-laravel-logo-on-send-mail/

# 送信メール本文のソースのパスは以下の通り。
# vendor/laravel/framework/src/Illuminate/Notifications/resources/views/email.blade.php

#^ vendorフォルダ配下のソースは原則直接変更しない。
# 変更したい場合は、以下のコマンドを実行し、resources/vendor配下にソースをコピーし、それを編集する。

# 本文の内容を編集したい場合:
# Copying directory [vendor/laravel/framework/src/Illuminate/Notifications/resources/views] to [resources/views/vendor/notifications]
cpnotifications:
	docker compose exec $(ctr) php artisan vendor:publish --tag=laravel-notifications

# レイアウト等を編集したい場合:
# Copying directory [vendor/laravel/framework/src/Illuminate/Mail/resources/views] to [resources/views/vendor/mail]
cpmail:
	docker compose exec $(ctr) php artisan vendor:publish --tag=laravel-mail


#! インデントが崩れると表示がおかしくなる。
# 対処法1: Format on Saveをoffにしてから保存
# 対処法2: email.blade.phpの言語モードをMarkdownにして保存


# **** Pagination関連 ****

# 【Laravel】独自のページネーションを作成する
# https://zakkuri.life/laravel-original-pagination/

# [vendor/laravel/framework/src/Illuminate/Pagination/resources/views] to [resources/views/vendor/pagination]
cppagination:
	docker compose exec $(ctr) php artisan vendor:publish --tag=laravel-pagination


# --------------------

#~ 設定手順

# 1.Controllerを下記にする

# $books = Book::all();
# ⬇️
# $books = Book::paginate(10);


# .....................

# 2.books.index.blade.phpに書きを追加する

# {{ $books->links() }}


# .....................

# 3.ページネーション用のCSSを当てる

# sail php artisan vendor:publish --tag=laravel-pagination
# ※tailwind.blade.phpがデフォルトで適用される。


# .....................

# 4. 26〜40行目をコメントアウト


# .....................

# 5 .25行目を変更する

# <div class="hidden sm:flex-1 sm:flex sm:items-center sm:justify-center">


# .....................

# 6. ja.jsonを変更する（示すこと → 全 に変更する）

# "Showing": "全"


# .....................

# 7.108行目あたりに下記を追加する

# <div class="mt-4">
#   <p class="text-sm text-gray-700 leading-5">
#     {!! __('Showing') !!}
#     <span class="font-medium">{{ $paginator->total() }}</span>
#     件中
#     @if ($paginator->firstItem())
#       <span class="font-medium">{{ $paginator->firstItem() }}</span>
#       〜
#       <span class="font-medium">{{ $paginator->lastItem() }}</span>
#     @else
#     {{ $paginator->count() }}
#     @endif
#     件
#     </p>
# </div>


# .....................

# 8. navに、flex-colをつける

# <nav role="navigation" aria-label="{{ __('Pagination Navigation') }}" class="flex-col flex items-center justify-between">


# **** Cache関連 ****

optimize:
	docker compose exec $(ctr) php artisan optimize

optimize-clear:
	docker compose exec $(ctr) php artisan optimize:clear

caching:
	docker compose exec $(ctr) composer dump-autoload -o
	@make optimize
	docker compose exec $(ctr) php artisan event:cache
	docker compose exec $(ctr) php artisan view:cache

clearing:
	docker compose exec $(ctr) composer clear-cache
	@make optimize-clear
	docker compose exec $(ctr) php artisan event:clear

# キャッシュのクリア
cache-clear:
	docker compose exec $(ctr) php artisan cache:clear

# bootstrap/cache/config.php生成
config-cache:
	docker compose exec $(ctr) php artisan config:cache

# bootstrap/cache/config.php削除
config-clear:
	docker compose exec $(ctr) php artisan config:clear

route-cache:
	docker compose exec $(ctr) php artisan route:cache

route-clear:
	docker compose exec $(ctr) php artisan route:clear

view-cache:
	docker compose exec $(ctr) php artisan view:cache

view-clear:
	docker compose exec $(ctr) php artisan view:clear


# **** Bladeコンポーネント関連 ****

# Laravel 6.x Bladeテンプレート
# https://readouble.com/laravel/6.x/ja/blade.html

# ディレクティブまとめ
# https://qiita.com/nyax/items/7f949bcb331b7221e593
# https://codelikes.com/laravel-blade/
# https://qiita.com/yumaeda/items/75eb84f19dba787b298d

# Laravel 6.x 多言語化
# https://readouble.com/laravel/6.x/ja/localization.html

# __()の意味
# https://minememo.work/laravel-localization__
# https://prograshi.com/framework/laravel/two-underscores/


# ? レイアウト化に使う命令:
# - @extends('レイアウトファイル名')
# - @yield('埋め込む名前')
# - @section('埋め込みたい場所の名前')

# ? Viewのディレクトリ設計
# - 機能別
# - ページ別
# - 種類別
# etc...

# ? おすすめのディレクトリ構成 (C向けアプリ)
# まず以下の3つに大きく分け、各々で機能別またはページ別などでさらに分ける。
# resources/views/
# + emails → メールテンプレ
# + users → 一般ユーザー用
# + admin → 管理画面系


# ------------

#& コンポーネント

# https://readouble.com/laravel/8.x/ja/blade.html
# → コンポーネント

# 独自のViewコンポーネントを生成
# app/View/Components/
mkcmp-%:
	docker compose exec $(ctr) php artisan make:component $(@:mkcmp-%=%)

mkcmp:
	docker compose exec $(ctr) php artisan make:component $(component)


# ------------

#& View Composer

#^ ビューコンポーザとは、ビュー表示のためのビジネスロジックを記述するところ

# https://readouble.com/laravel/8.x/ja/views.html

# 記事
# https://qiita.com/hitochan/items/ec3ccfe0c051e8565f4a
# https://qiita.com/nyax/items/a197c5c5af69a7aca34e
# https://hara-chan.com/it/programming/laravel-view-viewcompoer/
# https://nogson2.hatenablog.com/entry/2019/08/18/165813
# https://tech.arms-soft.co.jp/entry/2020/07/01/090000
# https://www.petitmonte.com/php/viewcomposers.html
# https://tech.amefure.com/php-laravel-view-composer
# http://vdeep.net/laravel-viewcomposer
# https://qiita.com/makies/items/bdb5ceef645348aef43a
# https://minory.org/laravel-view-share.html

# https://qiita.com/bumptakayuki/items/212ec57ffbfb8e71cb60
# https://qiita.com/youkyll/items/c65af61eb33919b29e97
# https://tech.arms-soft.co.jp/entry/2020/07/01/090000
# https://www.webopixel.net/php/1287.html
# https://biz.addisteria.com/laravel_view_composer/


mkprovider:
	docker compose exec $(ctr) php artisan make:provider $(name)ServiceProvider


# **** CORS対策 ****

# Laravel7以下
# https://qiita.com/kyo-san/items/a507aa0b46037df1b139
# オリジン間リソース共有 (CORS)
# https://developer.mozilla.org/ja/docs/Web/HTTP/CORS

mkcors:
	docker compose exec $(ctr) php artisan make:middleware Cors


# **** Event関連 ****

# Laravel 8.x イベント
# https://readouble.com/laravel/8.x/ja/events.html

eventgen:
	docker compose exec $(ctr) php artisan event:generate

mkevent:
	docker compose exec $(ctr) php artisan make:event $(name)

mklistener:
	docker compose exec $(ctr) php artisan make:listener $(name) --event=$(event)


# --------------------

# これを読めばLaravelのイベントとリスナーが設定できる
# https://reffect.co.jp/laravel/laravel-event-listener

# Laravelでイベントとリスナーを使ってみる
# https://qiita.com/KyuKyu/items/8999d774851261ff0baa

#【随時更新】Laravelのイベント&リスナーを使ってみる
# https://zenn.dev/jordan23/articles/08b1c48cc0ec11

# Laravelのイベントを使ってみる
# https://liginc.co.jp/484117

# Laravel イベント 調べてみた
# https://tech-tech.blog/php/laravel/event/


# **** その他 ****

serve:
	docker compose exec $(ctr) php artisan serve

tinker:
	docker compose exec $(ctr) php artisan tinker


# APP_ENVの現在の設定値を確認
appenv:
	docker compose exec $(ctr) php artisan env

keygen:
	docker compose exec $(ctr) php artisan key:generate

keyenv:
	docker compose exec $(ctr) php artisan key:generate --env=$(env)
keyenv-%:
	docker compose exec $(ctr) php artisan key:generate --env=$(@:keyenv-%=%)

# --showオプションを付けることで、直接.envに値が設定されず、コンソールにキーが表示される。
keyshow:
	docker compose exec $(ctr) php artisan --no-ansi key:generate --show


# **** 単体テスト関連 ****

tests:
	docker compose exec $(ctr) php artisan test

test:
	docker compose exec $(ctr) php artisan test --testsuite=$(name)
test-%:
	docker compose exec $(ctr) php artisan test --testsuite=$(@:test-%=%)

test-f:
	docker compose exec $(ctr) php artisan test --filter $(model)Test

testfu:
	docker compose exec $(ctr) php artisan test tests/$(type)/$(model)Test.php

testfu-f:
	docker compose exec $(ctr) php artisan test tests/$(type)/$(model)Test.php --filter=$(method)

testf:
	docker compose exec $(ctr) php artisan test tests/Feature/$(model)Test.php

testu:
	docker compose exec $(ctr) php artisan test tests/Unit/$(model)Test.php

testf-f:
	docker compose exec $(ctr) php artisan test tests/Feature/$(model)Test.php --filter=$(method)

testu-f:
	docker compose exec $(ctr) php artisan test tests/Unit/$(model)Test.php --filter=$(method)


# ----------------

#& Unitテスト

mktest-u:
	docker compose exec $(ctr) php artisan make:test $(model)Test --unit
mku:
	@make mktest-u


# ----------------

#& Featureテスト

mktest-m:
	docker compose exec $(ctr) php artisan make:test $(model)Test
mktest:
	@make mktest-m
mkm:
	@make mktest-m

mktest-c:
	docker compose exec $(ctr) php artisan make:test $(model)ControllerTest
mkc:
	@make mkfeature

ft-%:
	docker compose exec $(ctr) vendor/bin/phpunit tests/Feature/$(@:test-feature-%=%)ControllerTest

ft:
	docker compose exec $(ctr) vendor/bin/phpunit tests/Feature/$(model)ControllerTest


# ==== PHPUnitコマンド群 ====

#**** ローカルでテストを実行する ****

pu-v:
	cd backend && ./vendor/bin/phpunit --version

# --color はphpunit.xmlで設定している。
phpunit:
	cd backend && ./vendor/bin/phpunit $(path)

pu:
	@make phpunit

pu-d:
	cd backend && ./vendor/bin/phpunit $(path) --debug

# --filter - PHPUnit公式
# https://phpunit.readthedocs.io/ja/latest/textui.html?highlight=--filter
pu-f:
	cd backend && ./vendor/bin/phpunit --filter $(rgx)

pu-t:
	cd backend && ./vendor/bin/phpunit --testsuite $(name)

pu-tf:
	cd backend && ./vendor/bin/phpunit --testsuite $(name) --filter $(rgx)

pu-ls:
	cd backend && ./vendor/bin/phpunit --list-suite


#**** Docker環境でテストを実行する ****

#! コンテナからテストを実行すると、コンテナに渡したDB_DATABASEの環境変数が邪魔をして、phpunit.xmlのDB_DATABASEの方を読み込んでくれない。
#! テストを実行する度にDB_DATABASEを変更するのにmake upするのはめんどくさいので、ローカルで実行した方がいい。
#! また.vscode/settings.jsonの設定も必要。

#^ 環境変数の読み込み優先順位
#^ docker-compose.yml > phpunit.xml > .env.testing

#^ 環境変数を一時的に変更する必要がある場合は、「docker run -e」を使用する。

dpu-v:
	docker compose exec $(ctr) ./vendor/bin/phpunit --version

dpu:
	docker compose run -e DB_DATABASE=$(test) $(ctr) ./vendor/bin/phpunit $(path)

dpu-d:
	docker compose run -e DB_DATABASE=$(test) $(ctr) ./vendor/bin/phpunit --debug

dpu-f:
	docker compose run -e DB_DATABASE=$(test) $(ctr) ./vendor/bin/phpunit --filter $(regex)

dpu-t:
	docker compose run -e DB_DATABASE=$(test) $(ctr) ./vendor/bin/phpunit --testsuite $(name)

dpu-tf:
	docker compose run -e DB_DATABASE=$(test) $(ctr) ./vendor/bin/phpunit --testsuite $(name) --filter $(rgx)

dpu-ls:
	docker compose exec $(ctr) ./vendor/bin/phpunit --list-suite


# ==== PHP_CodeSniffier & PHPStanコマンド群 ====

# 使い方:
# https://qiita.com/atsu_kg/items/571def8d0d2d3d594e58

# Code Snifferのエラー文メモ
# https://gist.github.com/kkkw/d926a930a99485214925f22621d56230
# https://qiita.com/nnmr/items/00f6cb1355c551604d0e
# https://www.ninton.co.jp/archives/6360

# ヘルプを表示
pcs-h:
	docker compose exec $(ctr) ./vendor/bin/phpcs -h

# デフォルトで使用可能なコーディング規約を確認
pcs-i:
	docker compose exec $(ctr) ./vendor/bin/phpcs -i

# 設定したチェックルールの一覧を確認
pcs-e:
	docker compose exec $(ctr) ./vendor/bin/phpcs -e

# 通常の出力(Error数,Warning数+違反したルール)
pcs:
	docker compose exec $(ctr) ./vendor/bin/phpcs --standard=$(psr) $(path)

# Error数,Warning数を出力
pcs-summary:
	docker compose exec $(ctr) ./vendor/bin/phpcs --report=summary --standard=$(psr) $(path)

# 違反したルールを出力
pcs-source:
	docker compose exec $(ctr) ./vendor/bin/phpcs --report=source --standard=$(psr) $(path)

# 結果レポートをファイルとして出力
pcs-checkstyle:
	mkdir -p phpcs
	docker compose exec $(ctr) ./vendor/bin/phpcs --report=checkstyle --report-file=phpcs/$(name)_phpcs.xml $(path)

# コードの自動修正
# ex) psr=PSR2
pcbf:
	docker compose exec $(ctr) ./vendor/bin/phpcbf --standard=$(psr) $(path)

# phpcs.xml
pcs-xml:
	docker compose exec $(ctr) ./vendor/bin/phpcs --standard=phpcs.xml $(path)
pcbf-xml:
	docker compose exec $(ctr) ./vendor/bin/phpcbf --standard=phpcs.xml $(path)

# 静的解析
analyse:
	docker compose exec $(ctr) ./vendor/bin/phpstan analyse --memory-limit=2G


# ==== Composerコマンド群 ====

# コマンド一覧
# https://agohack.com/composer-command-list/
# https://qiita.com/KEINOS/items/86a16b06af6e936a1841
# http://www.y2sunlight.com/ground/doku.php?id=composer:1.9:command-list
# https://tanden.dev/%E3%82%88%E3%81%8F%E4%BD%BF%E3%81%86composer%E3%82%B3%E3%83%9E%E3%83%B3%E3%83%89%E3%81%A8%E3%83%90%E3%83%BC%E3%82%B8%E3%83%A7%E3%83%B3%E6%8C%87%E5%AE%9A%E3%81%AE%E5%82%99%E5%BF%98%E9%8C%B2/

dump-autoload:
	docker compose exec $(ctr) composer dump-autoload

clear-cache:
	docker compose exec $(ctr) composer clear-cache

composer:
	docker compose exec $(ctr) php -d memory_limit=-1 /usr/bin/composer install --prefer-dist

c:
	@make composer

# Composerのバージョン確認
c-v:
	docker compose exec $(ctr) composer --version

# composer.jsonに追記もされる
c-require:
	docker compose exec $(ctr) php -d memory_limit=-1 /usr/bin/composer require $(pkg)

# pkgを指定しない場合、composer.jsonに書いてある全てのパッケージと依存を最新に更新
# composer.jsonに追加するパッケージを記述し、update コマンド実行
# composer.jsonから対象のパッケージの記述を削除し、update コマンド実行
c-update:
	docker compose exec $(ctr) php -d memory_limit=-1 /usr/bin/composer update $(pkg)

# 依存しているパッケージも一緒に更新・削除
c-update-with-deps:
	docker compose exec $(ctr) php -d memory_limit=-1 /usr/bin/composer update --with-dependencies	$(pkg)

# Composer自体をアップデート
# https://qiita.com/onkbear/items/f98d274d38eacfe7a209
c-self-update:
	docker compose exec $(ctr) php -d memory_limit=-1 /usr/bin/composer self-update --$(v)

# ドライラン(アップデート動作の確認で、実際にはアップデートされない)
c-update-dry-run:
	docker compose exec $(ctr) php -d memory_limit=-1 /usr/bin/composer update --dry-run

# 更新可能なパッケージを確認
c-outdated:
	docker compose exec $(ctr) composer outdated

# composer.jsonの修正（パッケージ記述の削除）もされる
c-rm:
	docker compose exec $(ctr) php -d memory_limit=-1 /usr/bin/composer remove $(pkg)


# ----------------

#! In PackageManifest.php line 131: Undefined index: name の対処法

# 記事
# https://monmon.jp/536/in-a-composer-install-of-laravel-in-packagemanifest-php-line-122-undefined-index-name-undefined-index/
# https://qiita.com/fagai/items/15232a3f1a5a640d84a7
# https://qiita.com/saboyutaka/items/7b959a43a45ce03626e6


# 方法①: パッチバージョンを上げる
# composer update

# 方法②: composer を v1 に下げる
# composer self-update --1

#^ 下げたバージョンを戻す場合は
# composer self-update --rollback


# ==== npm & yarnコマンド群 ====

# **** npm ****

npm:
	@make npm-install

npm-install:
	docker compose exec $(npm) npm install

npm-ci:
	docker compose exec $(npm) npm ci

npm-dev:
	docker compose exec $(npm) npm run dev

npm-watch:
	docker compose exec $(npm) npm run watch

npm-watch-poll:
	docker compose exec $(npm) npm run watch-poll

npm-hot:
	docker compose exec $(npm) npm run hot

npm-v:
	docker compose exec $(npm) npm -v

npm-init:
	docker compose exec $(npm) npm init -y

npm-i-D:
	docker compose exec $(npm) npm i -D $(pkg)

npm-run:
	docker compose exec $(npm) npm run $(cmd)

npm-un-D:
	docker compose exec $(npm) npm uninstall -D $(pkg)

npm-audit-fix:
	docker compose exec $(npm) npm audit fix

npm-audit-fix-f:
	docker compose exec $(npm) npm audit fix --force


# **** npx ****

npx-v:
	docker compose exec $(npm) npx -v

npx:
	docker compose exec $(npm) npx $(pkg)


# **** yarn ****

yarn:
	docker compose exec $(yarn) yarn

yarn-install:
	@make yarn

#? npm ciに相当するyarnのコマンド
#? https://techblg.app/articles/npm-ci-in-yarn/
#? yarnのバージョンが2未満の場合
yarn-ci:
	docker compose exec $(yarn) yarn install --frozen-lockfile

yarn-ci-refresh:
	rm -rf $(env)/node_modules
	@make yarn-ci

#? yarnのversionが2以上の場合
yarn-ci-v2:
	docker compose exec $(yarn) yarn install --immutable --immutable-cache --check-cache

yarn-dev:
	docker compose exec $(yarn) yarn dev

yarn-watch:
	docker compose exec $(yarn) yarn watch

yarn-watch-poll:
	docker compose exec $(yarn) yarn watch-poll

yarn-hot:
	docker compose exec $(yarn) yarn hot

yarn-v:
	docker compose exec $(yarn) yarn -v

yarn-init:
	docker compose exec $(yarn) yarn init -y

yarn-add:
	docker compose exec $(yarn) yarn add $(pkg)

yarn-add-%:
	docker compose exec $(yarn) yarn add $(@:yarn-add-%=%)

yarn-add-dev:
	docker compose exec $(yarn) yarn add -D $(pkg)

yarn-add-dev-%:
	docker compose exec $(yarn) yarn add -D $(@:yarn-add-dev-%=%)

yarn-run:
	docker compose exec $(yarn) yarn run $(cmd)

yarn-run-s:
	docker compose exec $(yarn) yarn run $(pkg)

yarn-rm:
	docker compose exec $(yarn) yarn remove $(pkg)


# **** node ****

node:
	docker compose exec $(node) node $(file)


# ==== Git & GitHub関連 ====

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

# ? GitHubから特定のファイルだけを直接ダウンロードする方法

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

# ? GitHubから特定のディレクトリだけを直接ダウンロードする方法

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


# --------------------

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


# ==== Homebrew関連 ====

# コマンド一覧
# https://parashuto.com/rriver/tools/homebrew-most-used-commands
# https://original-game.com/homebrew
# https://qiita.com/vintersnow/items/fca0be79cdc28bd2f5e4
# https://kanamaru.hateblo.jp/entry/2019/05/26/150246


# ==== Volume関連 ====

#link
link:
	ln -s `docker volume inspect $(rep)_db-store | grep "Mountpoint" | awk '{print $$2}' | awk '{print substr($$0, 2, length($$0)-3)}'` .
unlink:
	unlink _data
rep:
	env | grep "rep"
chown-volume:
	sudo chown -R $(USER):$(GNAME) ~/.local/share/docker/volumes
rm-data:
	@make chown-data
	rm -rf data
change-data:
	@make rm-data
	@make link

# docker
volume-ls:
	docker volume ls
volume-inspect:
	docker volume inspect $(rep)_db-store


# ==== 環境の切り替え関連 ====

# **** DB環境の切り替え ****

# webコンテナに.envファイルを持たせる:
# edit.envで環境変数を変更し、コンテナ内に.envを作成(環境変数は.envを優先するので、ビルド時にコンテナに持たせた環境変数を上書きする)
# phpdotenvを使用する際必要
cpenv:
	docker cp ./env/docs/edit.env `docker compose ps -q web`:/work/.env

# DBの環境変更:
# DBの切り替え方法
# ①まずphpMyadminで切り替えるDB名でDBを作成しておき、かつ権限を持たせる
# ②作成したDB名でedit.envで環境変数をmake chenvで変更かつ再upしコンテナの環境変数を更新する
chenv:
	cp ./env/docs/edit.env .env
	@make up


# **** Laravel DBの再作成方法 ****

# ⑴ マイグレート前に戻す
# m rollback

# ⑵ webコンテナ内の環境変数DB_DATABASEの確認
# m web
# env | grep  DB_DATABASE
# → laravel_local

# ⑶ DBの切り替え
# 1. phpMyadminで切り替えるDB名でDBを作成かつ
# 2. 権限を持たせる
# 権限
# ↓
# 新規作成
# ↓
# - ユーザー名:
# ホスト名: % ※すべてのホスト
# パスワード:
# - グローバル権限:
# 選択肢
# ・すべてチェックする
# ・データ(SELECT, INSERTなど)
# ・構造 (CREATE, ALTER, IMDEX, DROPなど)
# ・管理 (GRANTなど)
# ↓
# 実行
# ※ phper	%	グローバル	ALL PRIVILEGES	はい
# 3. 作成したDB名でedit.envで環境変数をmake chenvで変更かつ再upしコンテナの環境変数を更新する
# m chenv
# 4. backend/.env のDB_DATABASEも新しいデータベース名に変更

# ⑷ マイグレートして切り替わったか確認
# m mig

# ⑸ ロールバックで元に戻す
# m rollback

# ⑹ 前のデータベースを削除
# ・ターミナルで削除
# m sql
# drop databse laravel_local;
# or
# ・phpMyAdminで削除


# **** Laravel 環境の切り替え *****

# デフォルト環境: make sw env=example
# ローカル環境: make sw env=local
# 開発環境: make sw env=dev
# テスト環境: make sw env=test
# ステージング環境: make sw env=stage
# 本番環境: make sw env=prod
# Heroke用環境: make sw iaas=heroku
# AWS用環境: make sw iaas=aws
sw:
	cp env/docs/$(iaas).env$(env) backend/.env
	@make keygen


# 環境によって読み込む.envファイル切り替え

# bootstrap/app.php

# switch (App::environment() ?? 'local') {
#     case 'development':
#         $app->loadEnvironmentFrom('.env.dev');
#         break;
#     case 'staging':
#         $app->loadEnvironmentFrom('.env.stage');
#         break;
#     case 'production':
#         $app->loadEnvironmentFrom('.env.prod');
#         break;
#     case 'testing':
#         $app->loadEnvironmentFrom('.env.test');
#         break;
#     default:
#         $app->loadEnvironmentFrom('.env.local');
#         break;
# }


# **** Laravel テスト用にSQLiteの使用 ****

# ※ローカル環境で使用可、仮想環境で使用不可

# 方法①
# ⑴ make touch-sqlite データ保存用ファイルの作成
# ⑵ backend/.envの編集 DB_CONNECTION=sqliteとし、その他のDB_XXXXはコメントアウト
# ⑶ backend/config/database.phpの編集 'database' => env(database_path('database.sqlite'), database_path('database.sqlite')), とする
# ⑷ make mig テーブル作成
# ⑸ DB Browser for SQLite でdatabase.sqliteを開き、確認

# 方法②
# ⑴ make touch-sqlite データ保存用ファイルの作成
# ⑵ backend/.envの編集 DB_CONNECTION=sqliteとし、その他のDB_XXXXはコメントアウト
# ⑶ edit.envを、DB_DATABASE=database/database.sqlite と書き換えて、make chenv
# ⑷ make mig テーブル作成
# ⑸ DB Browser for SQLite でdatabase.sqliteを開き、確認

# 方法③
# ⑴ make touch-sqlite データ保存用ファイルの作成
# ⑵ phpunit.xmlを、DB_CONNECTION=sqlite、DB_DATABASE=database/database.sqlite とする
# ⑶ make mig テーブル作成
# ⑷ DB Browser for SQLite でdatabase.sqliteを開き、確認
# ※ メモリ上のDBを利用する場合は、phpunit.xmlのDB_CONNECTIONとDB_DATABASEをアンコメント

touch-sqlite:
	docker compose exec web touch database/database.sqlite


# **** コンテナに渡した環境変数を後から変更する方法 ****

# 記事
# https://qiita.com/KEINOS/items/518610bc2fdf5999acf2

#? docker-composeで環境変数を渡すいくつかの方法
# https://hawksnowlog.blogspot.com/2019/07/docker-compose-with-env-vals.html


# ==== RDB Tips ====

# MySQL 使い方

# PostgreSQL 使い方
# https://db-study.com/
# https://postgresweb.com/


# MySQL コマンド一覧

# PostgreSQL コマンド一覧
# https://qiita.com/Shitimi_613/items/bcd6a7f4134e6a8f0621
# https://qiita.com/domodomodomo/items/04026157b75324e4ea27


# ------------


# ? MySQL レコード削除後連番を元に戻す方法

# 記事
# https://qiita.com/ramuneru/items/ae1d7230b528c5594d6a
# https://blanche-toile.com/web/mysql-autoincrement-reset
# http://dotnsf.blog.jp/archives/1062661668.html

# 最後のレコードのIDの続きから連番を再開したい:
# ⑴ mysqlに入る(コピペするときは$は除いてください)
# [terminal]
# $ mysql -u root -p
# パスワードは基本的には空のままEnterでOK

# ⑵ データベースを選択
# [mysql]
# mysql> use データベース名

# ⑶ テーブルのidを定義し直す
# [mysql]
# mysql> set @n:=0;
# mysql> update`テーブル名` set id=@n:=@n+1;

# ⑷ 確認
# [mysql]
# mysql> select*from テーブル名;

# ............

# レコードがすべて空の状態からリセットしたい:
# [mysql]
# alter table `テーブル名` auto_increment = 1;

# ............

# レコードが複数存在する状態で最後のIDの次から連番にしたい:
# [mysql]
# alter table `テーブル名` auto_increment = 開始したいid番号;

# ............

# テーブルごといったん削除して再作成することで、連番をリセット:
# [mysql]
# truncate table テーブル名


# ------------

# ? PostgreSQL 全テーブルに権限付与する

# 記事
# https://blog.longkey1.net/2013/02/13/how-to-grant-access-to-all-tables-of-a-database-in-postgres/
# https://yanor.net/wiki/?PostgreSQL/%E3%83%A6%E3%83%BC%E3%82%B6%E7%AE%A1%E7%90%86/%E5%85%A8%E3%83%86%E3%83%BC%E3%83%96%E3%83%AB%E3%82%92GRANT%E3%81%99%E3%82%8B
# https://katsusand.dev/posts/postgresql-auth/
# http://www.cgis.biz/others/postgresql/18/

# GRANT ALL ON ALL TABLES IN SCHEMA public TO username;
# GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO username;
# GRANT ALL ON ALL FUNCTIONS IN SCHEMA public TO username;


# ==== Docker関連 ====

# 記事
# https://zenn.dev/suzuki_hoge/books/2022-03-docker-practice-8ae36c33424b59
# https://zenn.dev/suzuki_hoge/books/2021-04-docker-picture-60fbe950136be9c7ad85

#* Docker コマンドチートシート
# https://qiita.com/wMETAw/items/34ba5c980e2a38e548db

#* Docker一括削除コマンドまとめ
# https://qiita.com/boiyama/items/9972601ffc240553e1f3

#* Docker for Mac におけるディスク使用
# https://docs.docker.jp/docker-for-mac/space.html

# ----------------

#^ DockerでIPアドレスが足りなくなったとき
# docker network inspect $(docker network ls -q) | grep -E "Subnet|Name"
# docker network ls
# docker network rm ネットワーク名
# docker network prune
# https://docs.docker.jp/config/daemon/daemon.html
# daemon.json
# {
#   "experimental": false,
#   "default-address-pools": [
#       {"base":"172.16.0.0/12", "size":24}
#   ],
#   "builder": {
#     "gc": {
#       "enabled": true,
#       "defaultKeepStorage": "20GB"
#     }
#   },
#   "features": {
#     "buildkit": true
#   }
# }

# ----------------

#^ docker networkの削除ができないときの対処方法
# https://qiita.com/shundayo/items/8b24af5239d9162b253c

# ----------------

#^ error while removing network でDocker コンテナを終了できない時の対処方法
# https://sun0range.com/information-technology/docker-error-while-removing-network/#%E3%83%8D%E3%83%83%E3%83%88%E3%83%AF%E3%83%BC%E3%82%AF%E5%89%8A%E9%99%A4%E3%82%92%E8%A9%A6%E3%81%BF%E3%82%8B
# → Docker for Macを再起動後、docker network rm ネットワーク名 で削除

# ネットワーク検証
# docker network inspect ネットワーク名
# # network削除
# docker network rm ネットワーク名
# # 確認
# docker network ls

# ----------------

#^ コンテナが削除できない
# https://engineer-ninaritai.com/docker-rm/

# 方法① コンテナを停止させる
# docker stop [コンテナID]
# docker rm [コンテナID]

# 方法② オプションを付けて強制削除
# docker rm -f [コンテナ]

# ----------------

#! ビルドに次のエラーが出る場合: apt update → GPG error → docker prune
# https://til.toshimaru.net/2021-03-15
# https://qiita.com/yukia3e/items/6e2536dd90d34a8b01cc
# docker image prune -f
# docker container prune -f

# ----------------

#? プロジェクトの階層を変更する方法

# ◆ make launch前
# 普通に移動させてmake laucnhすればいい。

# ◆ make launch後
# ソースコードが残さない場合:
# ⑴ make destoryでソースコード,データ,コンテナ,イメージ,ボリューム,ネットワークを削除
# ⑵ 移動させて、make launch

# ソースコードを残す場合:
# ⑴ make purgeでソースコードとデータ以外(コンテナ,イメージ,ボリューム,ネットワーク)を削除
# ⑵ 移動させて、make init


#! Error response from daemon: failed to mount local volume: ...
# docker volumes ls grep <Voleme名> → docker volumes inspect <Volume名> → docker volumes rm <Volume名>


# ==== Linuxコマンド群 ====

# コマンド一覧
# https://kazmax.zpp.jp/cmd/
# http://taku.adachi-navi.com/sankou/RedHat/command_linux/~mms/unix/linux_com/index.html
# https://tech-blog.rakus.co.jp/entry/20210604/linux
# https://www.sejuku.net/blog/5465
# https://qiita.com/savaniased/items/d2c5c699188a0f1623ef
# https://www.bold.ne.jp/engineer-club/linux-commands-getting-started
# https://linuxfan.info/linux-command-list
# http://www.ritsumei.ac.jp/~tomori/unix.html


# ==== Composerパッケージ関連 ====

# **** PHPUnit ****

comp-add-D-phpunit:
	docker compose exec $(ctr) composer require phpunit/phpunit --dev


# **** DBUnit ****

# {
#     "require-dev": {
#         "phpunit/phpunit": "^5.7|^6.0",
#         "phpunit/dbunit": ">=1.2"
#     }
# }
#
# composer update


# **** phpdotenv ****

comp-add-phpdotenv:
	docker compose exec $(ctr) composer require vlucas/phpdotenv


# **** Monolog ****

# 記事
# https://reffect.co.jp/php/monolog-to-understand

comp-add-monolog:
	docker compose exec $(ctr) composer require monolog/monolog


# **** MongoDB ****

comp-add-mongodb:
	docker compose exec $(ctr) composer require "mongodb/mongodb"


# **** Laravel Collection ****

# https://github.com/illuminate/support

comp-add-laravel-collection:
	docker compose exec $(ctr) composer require illuminate/support


# **** Carbon ****

# PHPの日付ライブラリ

# https://carbon.nesbot.com/
# https://github.com/briannesbitt/carbon

# 記事
# https://coinbaby8.com/carbon-laravel.html
# https://blog.capilano-fw.com/?p=867
# https://technoledge.net/composer-carbon/
# https://qiita.com/mackeyTA/items/e8b5e47a9f020a1902c0
# https://www.wakuwakubank.com/posts/421-php-carbon/
# https://codelikes.com/laravel-carbon/
# https://logical-studio.com/develop/development/laravel/20210709-laravel-carbon/

comp-add-carbon:
	docker compose exec $(ctr) composer require nesbot/carbon

# ※ laravelにはデフォルトでcarbonが入っているので、下記のようにuseで定義するだけで使うことができる。
# use Carbon\Carbon;


# **** PHP_CodeSniffer ****

# https://github.com/squizlabs/PHP_CodeSniffer

# 記事
# https://www.ninton.co.jp/archives/6360#toc2
# https://tadtadya.com/php_codesniffer-should-be-installed/
# https://pointsandlines.jp/server-side/php/php-codesniffer
# https://qiita.com/atsu_kg/items/571def8d0d2d3d594e58

comp-add-D-php_codesniffer:
	docker compose exec $(ctr) composer require "squizlabs/php_codesniffer=*" --dev


# **** PHPCompatibility ****

# https://github.com/PHPCompatibility/PHPCompatibility

# 記事
# https://qiita.com/e__ri/items/ed97da62eb5d5c4b2932

comp-add-D-php-compatibility:
	docker compose exec $(ctr) composer require "phpcompatibility/php-compatibility=*" --dev


# **** PHPStan ****

# https://phpstan.org/user-guide/getting-started

# 記事
# https://blog.shin1x1.com/entry/getting-stated-with-phpstan

comp-add-D-phpsatn:
	docker compose exec $(ctr) composer require phpstan/phpstan --dev


# **** Larastan ****

# https://github.com/nunomaduro/larastan
# https://github.com/nunomaduro/larastan/releases

# 記事
# https://mylevel.site/2022/05/15/laravel-larastan/
# https://qiita.com/MasaKu/items/7ed6636a57fae12231e0
# https://zenn.dev/naoki0722/articles/090bd3309474d9
# https://zenn.dev/bz0/articles/3e7fec1577511b

#^ 一緒に PHPStan もインストールしてくれる
# PHP 8.0+, Laravel 9.0+ → v=:^2.0

comp-add-D-larasatn:
	docker compose exec $(ctr) composer require nunomaduro/larastan$(v) --dev


# **** Mockery ****

# https://docs.mockery.io/en/latest/
# https://github.com/mockery/mockery

# 記事
# https://qiita.com/zaburo/items/b559782179565bb1c538
# http://tech.aainc.co.jp/archives/3918
# https://maasaablog.com/development/laravel/2805/
# https://toyo.hatenablog.jp/entry/2020/08/10/151148

# Laravel Mockery
# https://readouble.com/mockery/1.0/ja/index.html
# https://zenn.dev/hashi8084/articles/16a8cf0b851035

#^ Laravelでは標準で入っている。
comp-add-D-mockery:
	docker compose exec $(ctr) composer require mockery/mockery --dev


# ==== Laravelで使える便利なComposerパッケージ関連 ====

# PHPフレームワークLaravelの使い方
# https://qiita.com/toontoon/items/c4d0371e504c37f6576e

# https://github.com/chiraggude/awesome-laravel#popular-packages
# laravel-awesome-projectのページの「popular-packages」の欄に、便利なパッケージがカテゴリ別で大量に紹介されている。

# 記事
# https://qiita.com/minato-naka/items/4b47a22ba07b2604ce02
# https://yutaro-blog.net/2022/03/30/laravel-composer-package/#index_id1
# https://qiita.com/ChiseiYamaguchi/items/7277aad6be309d0f7ae7

install-recommend-packages:
	docker compose exec $(ctr) composer require doctrine/dbal
	docker compose exec $(ctr) composer require --dev barryvdh/laravel-ide-helper
	docker compose exec $(ctr) composer require --dev beyondcode/laravel-dump-server
	docker compose exec $(ctr) composer require --dev barryvdh/laravel-debugbar
	docker compose exec $(ctr) composer require --dev roave/security-advisories:dev-master
	docker compose exec $(ctr) php artisan vendor:publish --provider="BeyondCode\DumpServer\DumpServerServiceProvider"
	docker compose exec $(ctr) php artisan vendor:publish --provider="Barryvdh\Debugbar\ServiceProvider"

install-preset-packages-v8:
	@make install-dbal
	@make install-debuger
	@make install-ide-helper
	@make ide-helper

install-preset-packages-v6:
	@make install-dbal v:=2.*
	@make install-debuger
	@make install-ide-helper v=:2.8.2
	@make ide-helper


# **** Doctrine DBAL ****

# https://github.com/doctrine/dbal

# マイグレーション後のデーブルの編集に必要
# migrationでカラム定義変更をする場合にインストールしておく必要あり。
# Model のプロパティを補完する際に必要
# リリース情報: https://github.com/doctrine/dbal/releases
# v=:<バージョン指定>
# Laravel 6 -> v=:2.*

install-dbal:
	docker compose exec $(ctr) php -d memory_limit=-1 /usr/bin/composer require --dev doctrine/dbal$(v)


# **** Laravel Debugbar ****

# https://github.com/barryvdh/laravel-debugbar

# リリース情報: https://github.com/barryvdh/laravel-debugbar/releases?page=1
# デバッグ

# ブラウザ下部にデバッグバーを表示する。
# その時にリクエストで発行されたSQL一覧や、今持っているセッション情報一覧など
# デバッグに便利な情報がブラウザ上で確認できるようになる。

install-debuger:
	docker compose exec $(ctr) php -d memory_limit=-1 /usr/bin/composer require --dev barryvdh/laravel-debugbar


# **** コード補完 ****

# Laravel IDE Helper
# # https://github.com/barryvdh/laravel-ide-helper
# 対応バージョン: https://github.com/barryvdh/laravel-ide-helper/releases?page=1
# v2.9.0よりDropped support for Laravel 6 and Laravel 7, as well as support for PHP 7.2
# v=:<バージョン指定>
# Laravel 6 7 → v=:2.8.2  Laravel 5 → v=:2.6.3

# IDEを利用してコーディングする際に、
# コード補完を強化する。
# 変数からアローを書いたときにメソッドやプロパティのサジェスチョンがたくさん表示されたり、
# メソッド定義元へのジャンプできる範囲が増えたり。

install-ide-helper:
	docker compose exec $(ctr) php -d memory_limit=-1 /usr/bin/composer require --dev barryvdh/laravel-ide-helper$(v)


ide-helper:
	docker compose exec $(ctr) php artisan clear-compiled
	@make ide-helper-generate
	@make ide-helper-models
# @make ide-helper-meta

# _ide_helper.php生成
ide-helper-generate:
	docker compose exec $(ctr) php artisan ide-helper:generate

# _ide_helper_models.php生成
ide-helper-models:
	docker compose exec $(ctr) php artisan ide-helper:models --nowrite

ide-helper-model:
	docker compose exec $(ctr) php artisan ide-helper:models "App\Models\$(model)" --nowrite

# .phpstorm.meta.php生成(PHPStorm限定)
ide-helper-meta:
	docker compose exec $(ctr) php artisan ide-helper:meta


# **** Laravel/uiライブラリ関連 ****

# https://readouble.com/laravel/6.x/ja/frontend.html

# v=:<バージョン指定>
# Laravel8 → v=:3.x
# Laravel7 → v=:2.x
# Laravel6 → v=:1.x
install-laravel-ui:
	docker compose exec $(ctr) composer require --dev laravel/ui$(v)


# スキャフォールド
# --auth: ログイン／ユーザー登録スカフォールドを生成

install-bootstrap:
	docker compose exec $(ctr) php artisan ui bootstrap
install-bootstrap-auth:
	docker compose exec $(ctr) php artisan ui bootstrap --auth

install-react:
	docker compose exec $(ctr) php artisan ui react
install-react-auth:
	docker compose exec $(ctr) php artisan ui react --auth

install-vue:
	docker compose exec $(ctr) php artisan ui vue
install-vue-auth:
	docker compose exec $(ctr) php artisan ui vue --auth

# public/js public/css生成
# ※ エラーが出たら、make npm-dev | make yarn-dev
# npm
npm-scaffold:
	@make npm-install
	@make npm-dev

# yarn
yarn-scaffold:
	@make yarn-install
	@make yarn-dev


# **** Laravel-Lang/lang(言語の変更) ****

# config/app.php
# 'locale' => 'ja',


# --------------------

# 方法1: 10系の最新バージョン10.9.5を同様にzipファイルをダウンロードして利用する

# https://github.com/Laravel-Lang/lang/tree/10.9.5


# --------------------

# 方法2: 11系の導入方法を実施する。

# 互換性:
# https://laravel-lang.com/installation/compatibility.html#laravel-lang
# https://publisher.laravel-lang.com/installation/compatibility.html
# 12.0
# for PHP 8.1
# composer require laravel-lang/lang:^12.0 laravel-lang/publisher:^14.0
# 11.0
# for PHP 8.1
# composer require laravel-lang/lang:^11.0 laravel-lang/publisher:^14.0
# 10.0
# for PHP 8.0-8.1
# composer require laravel-lang/lang:^10.0 laravel-lang/publisher:^13.0
# for PHP 7.3-8.1
# composer require laravel-lang/lang:^10.2 laravel-lang/publisher:^12.0

# ⑴ ライブラリをインストールします。
# https://publisher.laravel-lang.com/installation/
# config/lang-publisher.php
install-lang:
	docker compose exec $(ctr) composer require laravel-lang/publisher laravel-lang/lang laravel-lang/attributes --dev
	docker compose exec $(ctr) php artisan vendor:publish --provider="LaravelLang\Publisher\ServiceProvider"

# ⑵ 日本語ファイルを追加します。（日本語の場合なので引数は「ja」です）
# https://publisher.laravel-lang.com/using/add.html#add-locales
#^ ちなみに、lang:addした場合には、追加しているパッケージ「Jetstream、Fortify、Cashier、Breeze、Nova、Spark、UIなど」のインストール状況を見て自動的に必要な言語ファイルを配置してくれます。
langadd:
	docker compose exec $(ctr) php artisan lang:add $(lang)


# ........................

# https://publisher.laravel-lang.com/using/update.html#update-locales
#^ 新しくパッケージを追加した場合は、下記コマンドを実施すれば情報が更新されます。
langupdate:
	docker compose exec $(ctr) php artisan lang:update

# https://publisher.laravel-lang.com/using/reset.html#reset-locales
langreset:
	docker compose exec $(ctr) php artisan lang:reset

# https://publisher.laravel-lang.com/using/remove.html#remove-locales
langrm:
	docker compose exec $(ctr) php artisan lang:rm $(lang)


# ~~~~ マルチログインの実装 ~~~~

# 【Laravel】マルチログイン(ユーザーと管理者など)機能を設定してみた【体験談】
# https://coinbaby8.com/laravel-multi-login.html

# <<公式パッケージ>>

# Laravel 7.x TOC
# https://readouble.com/laravel/7.x/ja/
# laravel 8.x TOC
# https://readouble.com/laravel/8.x/ja/

# Laravel Breeze
# Cashier (Stripe) - 課金システムを作れる
# Cashier (Paddle)
# Dusk
# Envoy
# Fortify
# Homestead
# Horizon
# Jetstream
# Octane
# Passport
# Sail
# Sanctum
# Scout - 全文検索処理
# Socialite - SNSなど外部システム認証を導入
# Telescope
# Valet


# **** Laravel Breeze ****

# https://readouble.com/laravel/8.x/ja/starter-kits.html#laravel-breeze

# Laravel Breeze ※Laravel 8以降
# composerでパッケージをインストール → Laravelアプリに雛形をインストール → Laravel Mixでコンパイル
#^ ※Laravel 9ではViteでコンパイル
install-breeze:
	docker compose exec $(ctr) php -d memory_limit=-1 /usr/bin/composer require --dev laravel/breeze
	docker compose exec $(ctr) php artisan breeze:install
	@make yarn-scaffold


# **** Laravel Cashier ****

# https://github.com/laravel/cashier-stripe
# https://laravel.com/docs/9.x/billing
# Laravel 8.x Laravel Cashier (Stripe)
# https://readouble.com/laravel/8.x/ja/billing.html
# Laravel 8.x Laravel Cashier (Paddle)
# https://readouble.com/laravel/8.x/ja/cashier-paddle.html

# 記事
# https://reffect.co.jp/laravel/cashier
# https://blog.capilano-fw.com/?p=3893
# https://re-engines.com/2020/07/08/laravel-cashier/

# Laravel上で定期支払いを実装させたいときに便利。

# ※ 公式からの注意点:
# サブスクリプションを提供せず、「一回だけ」の支払いを取り扱う場合は、
# Cashierを使用してはいけません。StripeかBraintreeのSDKを直接使用してください。

install-cashier:
	docker compose exec $(ctr) php -d memory_limit=-1 /usr/bin/composer require laravel/cashier


# **** Laravel Dusk ****

# ブラウザーテスト

# https://github.com/laravel/dusk
# https://www.oulub.com/docs/laravel/ja-jp/dusk
# https://laravel.com/docs/9.x/dusk
# Laravel 8.x Laravel Dusk
# https://readouble.com/laravel/8.x/ja/dusk.html

# 記事
# https://re-engines.com/2020/09/28/laravel-dusk/
# https://qiita.com/ryo3110/items/9a67267871d291d0e2a7
# https://qiita.com/t_kanno/items/55252cfa06ca51c1036e

install-dusk:
	docker compose exec $(ctr) php -d memory_limit=-1 /usr/bin/composer require --dev laravel/dusk


# **** Fortify ****

# 記事
# https://zenn.dev/fagai/articles/ac283da2335e0467bb0f
# https://reffect.co.jp/laravel/laravel8-fortify


# **** Laravel Passport ****

# API認証をするときに便利

# https://laravel.com/docs/9.x/passport
# https://www.oulub.com/docs/laravel/ja-jp/passport
# Laravel 8.x Laravel Passport
# https://readouble.com/laravel/8.x/ja/passport.html

# 記事
# https://qiita.com/zaburo/items/65de44194a2e67b59061
# https://reffect.co.jp/laravel/laravel-passport-understand

install-passport:
	docker compose exec $(ctr) php -d memory_limit=-1 /usr/bin/composer require laravel/passport


# **** Laravel Sail ****

#& インストールの手順

# Laravel & Docker
# https://laravel.com/docs/9.x/installation#laravel-and-docker

# curl -s "https://laravel.build/<アプリ名>" | bash
# cd <アプリ名>
# ./vendor/bin/sail up

install-sail:
	curl -s "https://laravel.build/$(app)" | bash
	cd $(app) && ./vendor/bin/sail up


# **** Laravel Sanctum ****

# Laravel 8.x Laravel Sanctum
# https://readouble.com/laravel/8.x/ja/sanctum.html
# https://laravel.com/docs/8.x/sanctum

# 記事
# https://qiita.com/ucan-lab/items/3e7045e49658763a9566
# https://yutaro-blog.net/2021/08/18/laravel-sanctum/
# https://reffect.co.jp/laravel/laravel-sanctum-token
# https://codelikes.com/use-laravel-sanctum/

# リリース情報
# ※Laravel8.6以降からLaravel Sanctumが標準でインストールされるので不要
# https://github.com/laravel/sanctum/releases


# ?--- SPA認証の実装 ---

# https://yutaro-blog.net/2021/09/07/nextjs-laravel-sanctum-spa/

# ①インストールとファイルの生成
# v=:<バージョン指定>
# Laravel9 → v=:3.x
# Laravel8 → v=:2.x
install-sanctum:
	docker compose exec $(ctr) php -d memory_limit=-1 /usr/bin/composer require laravel/sanctum$(v)
	docker compose exec $(ctr) php artisan vendor:publish --provider="Laravel\Sanctum\SanctumServiceProvider"

# Copied Directory [/vendor/laravel/sanctum/database/migrations] To [/database/migrations]
# Copied File [/vendor/laravel/sanctum/config/sanctum.php] To [/config/sanctum.php]


# ②APIトークンを使用する場合は、この後マイグレートする。
# make mig
# ※ APIトークンを使用しない場合、2019_12_14_000001_create_personal_access_tokens_table.phpを削除


# ③カーネルミドルウェアの設定 - １行目をコメントアウト
# app/Http/Kernel.php
# 'api' => [
#     \Laravel\Sanctum\Http\Middleware\EnsureFrontendRequestsAreStateful::class,
#     'throttle:api',
#     \Illuminate\Routing\Middleware\SubstituteBindings::class,
# ],


# ④config/sanctum.php の編集
# localhostのポートを8080に変更


# ?--- ユーザー認証設定 ----

# Authentication
# https://laravel.com/docs/8.x/authentication

# Manually Authenticating Users
# https://laravel.com/docs/8.x/authentication#authenticating-users

# Logging Out
# https://laravel.com/docs/8.x/authentication#logging-out

# ログイン用APIの作成
# ⑴ LoginController.phpの作成。
# ⑵ Manually Authenticating Users からLoginController.phpにペースト。
# ⑶ APIの場合、returnの部分がレスポンスになるよう、リダイレクトから修正。
# ログイン成功時は、ログインユーザー情報を返す。
# return response()->json(Auth::user());
# 失敗時は、401ステータスを返す。
# return response()->json([], 401);
# ⑷ PHPDocの修正
# ⑸ メソッド名をauthenticateからloginに変更

# ログアウト用APIの作成
# ⑴ Logging Out からLoginController.phpにペースト
# ⑵ APIの場合、returnの部分がレスポンスになるよう、リダイレクトから修正。
# ログアウトに成功したら、trueを返す。
# return response()->json(true);
# ⑶ PHPDocを修正


# **** Laravel Scout + Algolia | Elasticsearch ****

# Laravel 8.x Laravel Scout
# https://readouble.com/laravel/8.x/ja/scout.html
# https://www.oulub.com/docs/laravel/ja-jp/scout#installation
# https://github.com/laravel/scout

# Eloquentモデルに対し、全文検索を提供するパッケージ。
# Algoliaのドライバも用意されているため、とても便利。

install-scout:
	docker compose exec $(ctr) php -d memory_limit=-1 /usr/bin/composer require laravel/scout

# 記事
# https://www.algolia.com/
# https://qiita.com/avosalmon/items/b7b90c734709093fb927
# https://blog.capilano-fw.com/?p=3843
# https://reffect.co.jp/laravel/laravel-scout
install-algolia:
	docker compose exec $(ctr) php -d memory_limit=-1 /usr/bin/composer require algolia/algoliasearch-client-php

# 記事
# https://public-constructor.com/laravel-scout-with-elasticsearch/#toc2
# https://qiita.com/sola-msr/items/64d57d3970b715c795f5
# https://liginc.co.jp/472808
install-elasticsearch:
	docker compose exec $(ctr) php -d memory_limit=-1 /usr/bin/composer require elasticsearch/elasticsearch


# **** Laravel Socialite ****

# Laravel 8.x Laravel Socialite
# https://readouble.com/laravel/8.x/ja/socialite.html

# メモリ不足の場合: Fatal error: Allowed memory size of 1610612736 bytes exhaustedの対処方法
# https://feeld-uni.com/entry/2021/01/19/194546
# https://codesapuri.com/articles/1

# リリース情報: https://github.com/laravel/socialite/releases
# v=:<バージョン指定>
# Laravel8 -> v=:5.0.0以上
# Laravel6 → v=:4.2.0以上

install-socialite:
	docker compose exec $(ctr) php -d memory_limit=-1 /usr/bin/composer require laravel/socialite$(v)


# **** Laravel Telescope ****

# Laravelで使う公式デバックアシスタント

# https://laravel.com/docs/9.x/telescope
# Laravel 8.x Laravel Telescope
# https://readouble.com/laravel/8.x/ja/telescope.html

# 記事
# https://blog.capilano-fw.com/?p=2435
# https://www.searchlight8.com/laravel-telescope-use/
# https://kekaku.addisteria.com/wp/20191001092424
# https://biz.addisteria.com/laravel_telescope/

install-telescope:
	docker compose exec $(ctr) php -d memory_limit=-1 /usr/bin/composer require --dev laravel/telescope


# **** Laravel Queue ****

# 非同期処理で何かしたいときに便利

# https://laravel.com/docs/9.x/queues
# Laravel 8.x キュー
# https://readouble.com/laravel/8.x/ja/queues.html

# 記事
# https://qiita.com/naoki0531/items/f9b8545b77c643a3fa44
# https://qiita.com/toontoon/items/0c9291c9b6be2eb1816d
# https://masa-engineer-blog.com/laravel-job-queue-asynchronous-process/

# https://reffect.co.jp/laravel/laravel-queue-setting-manuplate
# https://reffect.co.jp/laravel/laravel-job-queue-easy-setup


# <<サードパーティ製パッケージ>>

# **** nunomaduro/larastan ****

# https://github.com/nunomaduro/larastan
# https://phpstan.org/user-guide/rule-levels

# 記事
# https://qiita.com/MasaKu/items/7ed6636a57fae12231e0
# https://zenn.dev/naoki0722/articles/090bd3309474d9
# https://tech-tech.blog/php/laravel/larastan/

# v=:<バージョン指定>
# php8.0以上, laravel9.0以上 → v=:^2.0
# それ以下 → v=:^1.0

comp-add-D-larastan:
	docker compose exec $(ctr) php -d memory_limit=-1 /usr/bin/composer require --dev nunomaduro/larastan$(v)


# **** itsgoingd/clockwork ****

# https://underground.works/clockwork/#documentation
# https://github.com/itsgoingd/clockwork

# 記事
# https://qiita.com/tommy0218/items/3fbd8b45808cee748010
# https://qiita.com/gungungggun/items/6ecd0e62ff2ae4cb0aee
# https://www.webopixel.net/php/1526.html

comp-add-D-clockwork:
	docker compose exec $(ctr) php -d memory_limit=-1 /usr/bin/composer require itsgoingd/clockwork


# **** laravelcollective/html ****

# LaravelCollective公式サイト
# https://laravelcollective.com/
# https://github.com/LaravelCollective/docs
# https://github.com/LaravelCollective/html

# Formファサードまとめ
# http://program-memo.com/archives/653
# https://monmon.jp/1049/i-want-to-use-the-larvase-collective-html-in-larva8-for-installation/
# https://laraweb.net/practice/7965/
# https://blog.motikan2010.com/entry/2017/01/28/%E3%80%8ELaravel_Collective%E3%80%8F%E3%81%A7%E3%81%AEHTML%E7%94%9F%E6%88%90%E3%82%92%E7%B0%A1%E5%8D%98%E3%81%AB%E3%81%BE%E3%81%A8%E3%82%81%E3%81%A6%E3%81%BF%E3%82%8B
# https://zenn.dev/snail_tanishi/articles/laravel_form
# https://qiita.com/zushi0905/items/a21212a205b755cff2db
# https://www.wakuwakubank.com/posts/455-laravel-forms-html/

# bladeファイルでフォームを書くときに便利なメソッドを提供する。
# CSRFトークンを自動で埋め込んでくれたり、
# モデルとフォームを紐づけて自動で初期値を入れてくれたり。

# v=:<バージョン指定>
# ※Laravel5.8なら、laravelcollective/htmlの5.8を選ぶ。 v:=5.8

comp-add-laravelcollective-html:
	docker compose exec $(ctr) php -d memory_limit=-1 /usr/bin/composer require laravelcollective/html$(v)


# **** wildside/userstamps ****

# https://github.com/WildSideUK/Laravel-Userstamps

# データを作成、更新した際に
# created_by、updated_byのカラムを
# ログイン中ユーザIDで自動更新してくれる。

comp-add-userstamps:
	docker compose exec $(ctr) php -d memory_limit=-1 /usr/bin/composer require wildside/userstamps


# **** guzzlehttp/guzzle ****

# https://github.com/guzzle/guzzle

# 記事
# https://reffect.co.jp/php/php-http-client-guzzle
# https://qiita.com/yousan/items/2a4d9eac82c77be8ba8b
# https://qiita.com/clustfe/items/f9ff2b12da7a501197f8
# https://webplus8.com/laravel-guzzle-http-client/

# Laravel 9.x HTTPクライアント
# https://readouble.com/laravel/9.x/ja/http-client.html

# 簡単にHTTPリクエストを送信するコードが書ける。
# 外部サービスのAPIにリクエストするときや
# フロントエンドからajaxでAPIリクエストするときに利用。

comp-add-guzzle:
	docker compose exec $(ctr) php -d memory_limit=-1 /usr/bin/composer require guzzlehttp/guzzle


# **** laracasts/flash ****

# https://github.com/laracasts/flash
# https://laravel10.wordpress.com/2015/03/18/laracastsflash/

# フラッシュメッセージを簡単に表示できる。
# データ登録完了時や削除完了時に
# 画面上部に「登録完了しました。」みたいなメッセージ表示をする。

comp-add-flash:
	docker compose exec $(ctr) php -d memory_limit=-1 /usr/bin/composer require laracasts/flash


# **** kyslik/column-sortable ****

# https://github.com/Kyslik/column-sortable

# 記事
# https://qiita.com/anomeme/items/5475c5e8ba9136e73b4e
# https://qiita.com/haserror/items/e7daeae404b675f739e1
# https://note.com/telluru052/n/nf4139126d556
# https://webru.info/laravel/column-sortable/

# 一覧系画面で簡単にソート機能を実装できる。
# 一覧テーブルのヘッダー行をクリックするだけで
# 昇順、降順ソートを切り替えられる。

comp-add-column-sortable:
	docker compose exec $(ctr) php -d memory_limit=-1 /usr/bin/composer require kyslik/column-sortable


# **** league/flysystem-aws-s3-v3 ****

# https://github.com/thephpleague/flysystem-aws-s3-v3

# 記事
# https://qiita.com/ucan-lab/items/61903ce10a186e78f15f
# https://tech-tech.blog/php/laravel/s3/

# Laravel 8.x ファイルストレージ
# https://readouble.com/laravel/8.x/ja/filesystem.html#composer-packages

# S3にファイルアップロード、ダウンロードをする場合に利用。

# thephpleague/flysystem-aws-s3-v3のv2系を利用する場合、thephpleague/flysystemの2系をインストールする必要がある。v:=^2.0
#リリース情報: https://github.com/thephpleague/flysystem/releases
# v=:<バージョン指定>
# Laravelフレームワークがleague/flysystemの1系を参照している → thephpleague/flysystem-aws-s3-v3の1系をインストール v:=^1.0
# ※ Laravel9.xからleague/flysystemのv2がサポートなので、9系以降はv1。

comp-add-flysystem-aws-s3-v3:
	docker compose exec $(ctr) php -d memory_limit=-1 /usr/bin/composer require -W league/flysystem-aws-s3-v3:^$(v).0


# **** aws/aws-sdk-php-laravel ****

# https://github.com/aws/aws-sdk-php-laravel
# https://github.com/aws/aws-sdk-php-laravel/blob/master/README.md

# 記事
# https://px-wing.hatenablog.com/entry/2020/11/02/084742
# https://qiita.com/nemui_yo/items/14ffacbad02ff786a993

# その他AWSサービス利用時に必要。
# SESでメール送信など。

# composer.json
# {
#     "require": {
#         "aws/aws-sdk-php-laravel": "~3.0"
#     }
# }

# composer update


# **** orangehill/iseed ****

# https://github.com/orangehill/iseed

# 記事
# https://qiita.com/imunew/items/3973658bdcae9ab77b8a
# https://www.out48.com/archives/5103/
# https://daybydaypg.com/2020/10/18/post-1625/

# 実際にDBに入っているデータからseederファイルを逆生成する。

comp-add-D-iseed:
	docker compose exec $(ctr) php -d memory_limit=-1 /usr/bin/composer require --dev "orangehill/iseed"


# **** Enum ****

# LaravelでEnumを実装したいときに利用。
# 似たようなパッケージがいくつかあり、どれがベストかはまだわからない。

# ※ PHP8.1からEnumが標準に
# https://www.php.net/manual/ja/language.types.enumerations.php
# https://www.php.net/manual/ja/language.enumerations.methods.php

# 記事
# https://blog.capilano-fw.com/?p=9829
# https://qiita.com/ucan-lab/items/e9f53aa024ca3cc5ea1b
# https://qiita.com/rana_kualu/items/bdfa6c844125c1d0f4d4

# marc-mabe/php-enum
# https://github.com/marc-mabe/php-enum

# myclabs/php-enum
# https://github.com/myclabs/php-enum

comp-add-php-enum-myclabs:
	docker compose exec $(ctr) php -d memory_limit=-1 /usr/bin/composer require myclabs/php-enum

# bensampo/laravel-enum
# https://github.com/BenSampo/laravel-enum

comp-add-laravel-enum:
	docker compose exec $(ctr) php -d memory_limit=-1 /usr/bin/composer require bensampo/laravel-enum


# **** spatie/laravel-menu ****

# https://github.com/spatie/laravel-menu

# 階層になっているメニューを生成できる。

comp-add-laravel-menu:
	docker compose exec $(ctr) php -d memory_limit=-1 /usr/bin/composer require spatie/laravel-menu


# **** spatie/laravel-permission ****

# https://github.com/spatie/laravel-permission

# 記事
# https://reffect.co.jp/laravel/spatie-laravel-permission-package-to-use
# https://qiita.com/sh-ogawa/items/09b7097b5721dcdbe566

# https://e-seventh.com/laravel-permission-summary/
# https://e-seventh.com/laravel-permission-basic-usage/

# ユーザ、ロール、権限
# の制御を簡単にできる。
# ユーザ、ロール、権限を
# 多対多対多で管理するようなアプリでは非常に便利。

# ユーザへのロール・権限の付与、はく奪の処理や
# ユーザのロール・権限によるアクセス制御などが簡単。

comp-add-laravel-permission:
	docker compose exec $(ctr) php -d memory_limit=-1 /usr/bin/composer require spatie/laravel-permission


# **** encore/laravel-admin ****

# お手軽に管理画面を作れる

# https://enjoyworks.jp/tech-blog/7298

# 記事
# https://qiita.com/Dev-kenta/items/25ac692befe6f26f11cf
# https://zenn.dev/eri_agri/articles/e7c6f1690ab9d9

comp-add-laravel-admin:
	docker compose exec $(ctr) php -d memory_limit=-1 /usr/bin/composer require encore/laravel-admin


# **** davejamesmiller/laravel-breadcrumbs ****

# https://github.com/d13r/laravel-breadcrumbs

# 記事
# https://poppotennis.com/posts/laravel-breadcrumbs
# https://prograshi.com/framework/laravel/laravel-breadcrumbs-structured-markup/
# https://kojirooooocks.hatenablog.com/entry/2018/01/11/005638
# https://pgmemo.tokyo/data/archives/1302.html

# パンくずリストの表示や管理がしやすくなる。

comp-add-laravel-laravel-breadcrumbs:
	docker compose exec $(ctr) php -d memory_limit=-1 /usr/bin/composer require diglactic/laravel-breadcrumbs


# **** league/csv ****

# https://csv.thephpleague.com/9.0/
# https://github.com/thephpleague/csv

# 記事
# https://tech.griphone.co.jp/2018/12/12/advent-calendar-20181212/
# https://blitzgate.co.jp/blog/1884/
# https://blog.ttskch.com/php-league-csv/

# CSVのインポート・エクスポート処理を簡単にしてくれる。

comp-add-csv:
	docker compose exec $(ctr) php -d memory_limit=-1 /usr/bin/composer require league/csv:^9.0


# **** barryvdh/laravel-dompdf ****

# https://github.com/barryvdh/laravel-dompdf

# 記事
# https://codelikes.com/laravel-dompdf/
# https://blog.capilano-fw.com/?p=182
# https://syuntech.net/php/laravel/laravel-dompdf/
# https://zakkuri.life/laravel-pdf-ja/
# https://biz.addisteria.com/laravel_dompdf/

# https://reffect.co.jp/laravel/how_to_create_pdf_in_laravel
# https://reffect.co.jp/laravel/laravel-dompdf70-japanese

# PDF出力処理を簡単にできる。

# 日本語化
# https://github.com/dompdf/utils

comp-add-laravel-dompdf:
	docker compose exec $(ctr) php -d memory_limit=-1 /usr/bin/composer require barryvdh/laravel-dompdf


# **** barryvdh/laravel-snappy ****

# https://github.com/barryvdh/laravel-snappy

# 記事
# https://reffect.co.jp/laravel/how_to_create_pdf_in_laravel_snappy
# https://qiita.com/naga3/items/3b65a39e235b8bd26f4a

# https://biz.addisteria.com/laravel_snappy_pdf/

# PDF出力処理を簡単にできる。

# Wkhtmltopdfのインストール
# https://github.com/KnpLabs/snappy#wkhtmltopdf-binary-as-composer-dependencies
# ※ Laravel-Snappyのパッケージをインストールする前にWhtmltopdfをインストールする必要がある。
# https://github.com/barryvdh/laravel-snappy/blob/master/readme.md
# $ composer require h4cc/wkhtmltopdf-amd64 0.12.x
# $ composer require h4cc/wkhtmltoimage-amd64 0.12.x

# 【補足】MACにWKhtmltopdfをインストールする場合
# MAC環境で、Laravel-SnappyのInstallationに沿って設定を行っていくとPDFの作成を行った際にエラーが発生します。
# 実行権限の問題かと判断し、権限を変更しても同じエラーが発生します。
# https://reffect.co.jp/laravel/how_to_create_pdf_in_laravel_snappy#MACWKhtmltopdf

comp-add-laravel-snappy:
	docker compose exec $(ctr) php -d memory_limit=-1 /usr/bin/composer require barryvdh/laravel-snappy


# **** jenssegers/agent ****

# https://github.com/jenssegers/agent

# 記事
# https://qiita.com/kazuhei/items/08e3d88c2b8bf8a6b0ab
# https://qiita.com/Syoitu/items/08cefa675c0e289df6e5
# https://leben.mobi/blog/laravel_useragent_check/php/

# ユーザエージェントの取得、判定処理をできる

comp-add-agent:
	docker compose exec $(ctr) php -d memory_limit=-1 /usr/bin/composer require jenssegers/agent


# ==== Laravel Mix ====

# laravel-mix
# https://laravel-mix.com/docs/4.0/installation
# https://qiita.com/tokimeki40/items/2c9112272a8b92bbaef9


#* v6:
# Development
# npx mix
# Production
# npm mix --production
# watch
# npx mix watch
# Hot Module Replacemen
# npx mix watch --hot


#* v5:
# –progress:ビルドの進捗状況を表示させるオプション
# –hide-modules:モジュールについての情報を非表示にするオプション
# –config:Laravel Mixで利用するwebpack.config.jsの読み込み
# cross-env:環境依存を解消するためにインストールしたパッケージ


# package.json
# "scripts": {
#     "dev": "npm run development",
#     "development": "cross-env NODE_ENV=development node_modules/webpack/bin/webpack.js --progress --config=node_modules/laravel-mix/setup/webpack.config.js",
#     "watch": "npm run development -- --watch",
#     "hot": "cross-env NODE_ENV=development node_modules/webpack-dev-server/bin/webpack-dev-server.js --inline --hot --config=node_modules/laravel-mix/setup/webpack.config.js",
#     "prod": "npm run production",
#     "production": "cross-env NODE_ENV=production node_modules/webpack/bin/webpack.js --config=node_modules/laravel-mix/setup/webpack.config.js"
# }


yarn-add-D-mix:
	docker compose exec web yarn add -D laravel-mix glob cross-env rimraf

# webpack.mix.js
touch-mix:
	docker compose exec web touch webpack.mix.js

# laravel-mix-polyfill
# https://laravel-mix.com/extensions/polyfill
# IE11対応
yarn-add-D-mix-polyfill:
	docker compose exec web add yarn -D laravel-mix-polyfill

# laravel-mix-pug
# https://laravel-mix.com/extensions/pug-recursive
yarn-add-D-mix-pug:
	docker compose exec web yarn add -D laravel-mix-pug-recursive

# laravel-mix-ejs
# https://laravel-mix.com/extensions/ejs
yarn-add-D-mix-ejs:
	docker compose exec web yarn add -D laravel-mix-ejs


# ----------------

#! 【Laravel】npm run devを実行したら –hide-modulesエラーが出た時の対処法

# 記事
# https://saunabouya.com/2021/06/15/laravel-npm-run-dev-hide-modules/
# https://qiita.com/Yado_Tarou/items/e00a05b4d84ed40dc444
# https://www.petadocs.com/laravel/article/11
# https://www.sejuku.net/plus/question/detail/4960

# laravel-mixの5系で使えていた–hide-modulesオプションが、6系では使えなくなったエラー


# ==== Laravel Vite ====

# Laravel 9.x アセットの構築（Vite）
# https://readouble.com/laravel/9.x/ja/vite.html

# Vite
# https://ja.vitejs.dev/
# https://ja.vitejs.dev/guide/backend-integration.html

# 記事
# https://blog.capilano-fw.com/?p=10168
# https://qiita.com/pop-culture-studio/items/027e612fa7e7b11cafa0
# https://zenn.dev/yamabiko/articles/laravel-jetstream-vite
# https://zakkuri.life/laravel-vite/

# 環境構築
# https://saunabouya.com/2022/07/25/laravel9-sail-react-typescript-vite/


# ------------------

#? 【Laravel】に【Vite】が採用された
# https://coinbaby8.com/laravel-vite.html


# ------------------

#? laravelでViteからLaraevel-mixに戻す手順
# https://github.com/laravel/vite-plugin/blob/main/UPGRADE.md#migrating-from-vite-to-laravel-mix
# https://biz.addisteria.com/remove_vite/


#* LaravelからViteをアンインストールする手順:

# ①Vite削除コマンドを実行

# npm remove vite
# npm remove laravel-vite-plugin

# .....................

# ②Vite設定ファイル（vite.config.js) 削除


# .....................

# ③ テンプレートファイルのリンクを無効にする

# resources/views/layouts/app.balde.php と resources/views/layouts/guest.blade.phpに

# 自動で入っている下記のコードを無効にします。

#         @vite([‘resources/css/app.css’, ‘resources/js/app.js’])


# .....................

# ④ package.jsonの変更

# package.jsonのscriptsで、下記を削除します。

# "dev": "vite",
# "build": "vite build"


# .....................

# ⑤  jsファイルの修正

# resources/views/js/app.jsを書き替えます。

# importをrequireにします。

# // import './bootstrap';
# require('./bootstrap');


# resources/views/js/bootstrap.jsを書き替えます。

# // import _ from 'lodash';
# window._ = require('lodash');

# // import axios from 'axios';
# window.axios = require('axios');

# window.axios.defaults.headers.common['X-Requested-With'] = 'XMLHttpRequest';


# .....................

# ⑥ .envの修正

# Vite用の設定を削除し、Laravel Mix用の設定を追加します。

# 削除

# VITE_PUSHER_APP_KEY="${PUSHER_APP_KEY}"
# VITE_PUSHER_HOST="${PUSHER_HOST}"
# VITE_PUSHER_PORT="${PUSHER_PORT}"
# VITE_PUSHER_SCHEME="${PUSHER_SCHEME}"
# VITE_PUSHER_APP_CLUSTER="${PUSHER_APP_CLUSTER}"

# 追加

# MIX_PUSHER_APP_KEY="${PUSHER_APP_KEY}"
# MIX_PUSHER_APP_CLUSTER="${PUSHER_APP_CLUSTER}"


# .....................

#* LaravelにLaravel Mixを入れる方法:

# ① Laravel Mixインストール

# npm install laravel-mix --save-dev


# .....................

# ② webpack.mixファイル作成

# 下記コードを入れます。

# const mix = require('laravel-mix');

# /*
#  |--------------------------------------------------------------------------
#  | Mix Asset Management
#  |--------------------------------------------------------------------------
#  |
#  | Mix provides a clean, fluent API for defining some Webpack build steps
#  | for your Laravel applications. By default, we are compiling the CSS
#  | file for the application as well as bundling up all the JS files.
#  |
#  */

# mix.js('resources/js/app.js', 'public/js').postCss('resources/css/app.css', 'public/css', [
#     require('postcss-import'),
#     require('tailwindcss'),
#     require('autoprefixer'),
# ]);


# .....................

# ③ app.blade.phpにリンクを追加する

# resources/views/layouts/app.balde.php と resources/views/layouts/guest.blade.phpの<head></head>内に、下記を追加します。


        # <!-- Styles -->
        # <link rel="stylesheet" href="{{ asset('css/app.css') }}">

        # <!-- Scripts -->
        # <script src="{{ asset('js/app.js') }}" defer></script>


# .....................

# ④ package.jsonの変更

# package.jsonのscriptに、下記を追加します。

        # "dev": "npm run development",
        # "development": "mix",
        # "watch": "mix watch",
        # "watch-poll": "mix watch -- --watch-options-poll=1000",
        # "hot": "mix watch --hot",
        # "prod": "npm run production",
        # "production": "mix --production"


# .....................

# ⑤  jsファイルの修正

# Viteをアンインストールする項目に書いたので、省略します。

# ⑥ .envの修正

# Viteをアンインストールする項目に書いたので、省略します。


# .....................

# 準備は以上となります。npm run devを実行すると、Laravel Mixでコンパイルが行われます。

# なおプロジェクト作成後、npm run devを行った時に

#! WARNINGS in child compilations とエラーが出たりしますが、これはまたViteと違う問題です。対策は下記にあります。

# https://biz.addisteria.com/error_child_compilations/


# ==== gulp関連 ====

yarn-add-D-gulp:
	docker compose exec web yarn add -D gulp browser-sync

mkgulp:
	cp env/gulpfile.js backend/


# ===== webpack関連 =====

# webpack5 + TS + React
yarn-add-D-webpack5-env:
	docker compose exec web yarn add -D \
	webpack webpack-cli \
	sass sass-loader css-loader style-loader \
	postcss postcss-loader autoprefixer \
	babel-loader @babel/core @babel/runtime @babel/plugin-transform-runtime @babel/preset-env core-js@3 regenerator-runtime babel-preset-minify\
	mini-css-extract-plugin html-webpack-plugin html-loader css-minimizer-webpack-plugin terser-webpack-plugin copy-webpack-plugin \
	webpack-dev-server \
	browser-sync-webpack-plugin browser-sync \
	dotenv-webpack \
	react react-dom @babel/preset-react @types/react @types/react-dom \
	react-router-dom@5.3.0 @types/react-router-dom history@4.10.1 \
	react-helmet-async \
	typescript@3 ts-loader fork-ts-checker-webpack-plugin \
	eslint@7.32.0 eslint-config-prettier@7.2.0 prettier@2.5.1 @typescript-eslint/parser@4.33.0 @typescript-eslint/eslint-plugin@4.33.0 husky@4.3.8 lint-staged@10.5.3 \
	eslint-plugin-react eslint-plugin-react-hooks eslint-config-airbnb eslint-plugin-import eslint-plugin-jsx-a11y \
	stylelint stylelint-config-standard stylelint-scss stylelint-config-standard-scss stylelint-config-prettier stylelint-config-recess-order postcss-scss \
	glob lodash rimraf npm-run-all axios \
	redux react-redux @types/redux @types/react-redux @reduxjs/toolkit @types/node \
	redux-actions redux-logger @types/redux-logger redux-thunk connected-react-router reselect typescript-fsa typescript-fsa-reducers immer normalizr \
	jest jsdom eslint-plugin-jest @types/jest @types/jsdom ts-jest \
	@testing-library/react @testing-library/jest-dom \
	@emotion/react @emotion/styled @emotion/babel-plugin \
	styled-components \
	tailwindcss@2.2.19 @types/tailwindcss eslint-plugin-tailwindcss \
	@material-ui/core @material-ui/icons @material-ui/styles @material-ui/system @types/material-ui \
	@chakra-ui/react @emotion/react@^11 @emotion/styled@^11 framer-motion@^6 @chakra-ui/icons focus-visible \
	yup react-hook-form @hookform/resolvers @hookform/error-message


# webpackの導入
yarn-add-D-webpack:
	docker compose exec web yarn add -D webpack webpack-cli
yarn-add-D-webpack-v4:
	docker compose exec web yarn add -D webpack@4.46.0 webpack-cli

# webpackの実行
yarn-webpack:
	docker compose exec web yarn webpack
webpack:
	@make yarn-webpack
wp:
	@make yarn-webpack
yarn-webpack-config:
	docker compose exec web yarn webpack --config $(path)
# modeを省略すると商用環境モードになる
yarn-run-webpack:
	docker compose exec web yarn webpack --mode $(mode)
yarn-run-webpack-dev:
	docker compose exec web yarn webpack --mode development
	docker compose exec web yarn webpack --mode development
# eval無効化
yarn-run-webpack-dev-none:
	docker compose exec web yarn webpack --mode development --devtool none

# webpack.config.js生成
touch-webpack:
	docker compose exec web touch webpack.config.js

# sass-loader
# sass ↔︎ css
yarn-add-D-loader-sass:
	docker compose exec web yarn add -D sass sass-loader css-loader style-loader

# postcss-loader
# ベンダープレフィックスを自動付与
yarn-add-D-loader-postcss:
	docker compose exec web yarn add -D postcss postcss-loader autoprefixer

# postcss-preset-env
# https://zenn.dev/lollipop_onl/articles/ac21-future-css-with-postcss
# https://levelup.gitconnected.com/setup-tailwind-css-with-webpack-3458be3eb547
yarn-add-D-postcss-preset-env:
	docker compose exec web yarn add -D postcss-preset-env

# postcss.config.js生成
touch-postcss:
	docker compose exec web touch postcss.config.js

# .browserslistrc生成(ベンダープレフィックス付与確認用)
# Chrome 4-25
touch-browserslist:
	docker compose exec web touch .browserslistrc

# file-loader
# CSSファイル内で読み込んだ画像ファイルの出力先での配置
# webpack5から不要
yarn-add-D-loader-file:
	docker compose exec web yarn add -D file-loader

# mini-css-extract-plugin
# ※webpack 4.x | mini-css-extract-plugin 1.x
# 1.6.2
# style-loaderの変わりに使う。
# これでビルドすると、CSSが別ファイルとして生成される。
# version選択できます。
yarn-add-D-plugin-minicssextract:
	docker compose exec web yarn add -D mini-css-extract-plugin@$(@)

# babel-loader
# JSX、ECMAScriptのファイルをバンドルするためのloader
# webpack 4.x | babel-loader 8.x | babel 7.x
yarn-add-D-loader-babel:
	docker compose exec web yarn add -D babel-loader @babel/core @babel/preset-env
# https://zenn.dev/sa2knight/articles/5a033a0288703c
yarn-add-D-loader-babel-full:
	docker compose exec web yarn add -D @babel/core @babel/runtime @babel/plugin-transform-runtime @babel/preset-env babel-loader

# babelでトランスパイルを行う際に、古いブラウザが持っていない機能を補ってくれるモジュール群
# regenerator-runtimeはES7で導入されたasync/awaitを補完するために使われる。
# core-js@3は色々な機能を補完
yarn-add-D-complement-babel:
	docker compose exec web yarn add -D core-js@3 regenerator-runtime

# babel-preset-minify
# https://www.npmjs.com/package/babel-preset-minify
# https://chaika.hatenablog.com/entry/2021/01/06/083000
yarn-add-D-babel-preset-minify:
	docker compose exec web yarn add -D babel-preset-minify

yarn-add-D-babel-option:
	docker compose exec web yarn add -D @babel/plugin-external-helpers @babel/plugin-proposal-class-properties @babel/plugin-proposal-object-rest-spread

# .babelrc生成
# JSON形式で記載
touch-babelrc:
	docker compose exec web touch .babelrc

# babel.config.js
touch-babel:
	docker compose exec web touch babel.config.js

# eslint-loader
# ※eslint-loader@4: minimum supported eslint version is 6
# ESlintを使うためにeslint
# ESlintとwebpackを連携するためにeslint-loader
# ESlint上でbabelと連携するためにbabel-eslint
# 8系はエラーが出る
# eslint-loaderは非推奨になった
yarn-add-D-loader-eslint:
	docker compose exec web yarn add -D eslint@6 eslint-loader babel-eslint

# eslint-webpack-plugin

# .eslintrc生成
# JSON形式で記載
touch-eslintrc:
	docker compose exec web touch .eslintrc

# 対話形式で.eslintrc生成
yarn-eslint-init:
	docker compose exec web yarn run eslint --init

# html-webpack-plugin
# 指定したhtmlに自動的にscriptタグを注入する。
# ファイル名をhashにした時に、手動でhtmlに読み込ませる必要がなくなる。
#※Drop support for webpack 4 and node <= 10 - For older webpack or node versions please use html-webpack-plugin 4.x
# 4.5.2
yarn-add-D-plugin-htmlwebpack:
	docker compose exec web yarn add -D html-webpack-plugin@$(@)

# html-loader
# htmlファイル内で読み込んだ画像をJSファイルに自動的バンドルする
# HTMLファイル内で読み込んだ画像ファイルの出力先での配置
# 1.3.2
# ※html-webpack-pluginで対象となるhtmlファイルを読み込んでいないと、html-loaderだけ記入してもimgタグはバンドルされない。
# html-loaderとhtml-webpack-pluginは一緒に使う。
yarn-add-D-loader-html:
	docker compose exec web yarn add -D html-loader@$(@)

# 商用と開発でwebpack.config.jsを分割
touch-webpack-separation:
	docker compose exec web touch webpack.common.js webpack.dev.js webpack.prod.js

# webpack-merge
# webpackの設定ファイルをmergeする
yarn-add-D-webpackmerge:
	docker compose exec web yarn add -D webpack-merge

# 商用にminify設定
# JS版: terser-webpack-plugin
# ※webpack4 4.x 4.2.3
# CSS版: optimize-css-assets-webpack-plugin(webpack4の場合)
# HTML版: html-webpack-plugin https://github.com/jantimon/html-webpack-plugin
# ※webpack5以上は、css-minimizer-webpack-plugin
yarn-add-D-minify-v4:
	docker compose exec web yarn add -D optimize-css-assets-webpack-plugin terser-webpack-plugin@4.2.3 html-webpack-plugin@4.5.2
yarn-add-D-minify-v5:
	docker compose exec web yarn add -D css-minimizer-webpack-plugin terser-webpack-plugin html-webpack-plugin

# webpack-dev-server
# 開発用のサーバが自動に立ち上がるようにする
yarn-add-D-webpackdevserver:
	docker compose exec web yarn add -D webpack-dev-server

# ejs-html-loader
# ejs-compiled-loader
# ejs-plain-loader
yarn-add-D-loader-ejs-plain:
	docker compose exec web yarn add -D ejs ejs-plain-loader

# raw-loader
# txtファイルをバンドルするためのloader
# webpack5から不要
yarn-add-D-loader-raw:
	docker compose exec web yarn add -D raw-loader

# extract-text-webpack-plugin
# webpack4以降は mini-css-extract-pluginがあるので不要
yarn-add-D-plugin-extracttextwebpack:
	docker compose exec web yarn add -D extract-text-webpack-plugin

# resolve-url-loader
yarn-add-D-loader-resolveurl:
	docker compose exec web yarn add -D resolve-url-loader

# browser-sync
yarn-add-D-plugin-browsersync:
	docker compose exec web yarn add -D browser-sync-webpack-plugin browser-sync

# copy-webpack-plugin
# copy-webpack-pluginは、指定したファイルをそのままコピーして出力します。これも、出力元と先を合わせるのに役立ちます。
# https://webpack.js.org/plugins/copy-webpack-plugin/
yarn-add-D-plugin-copy:
	docker compose exec web yarn add -D copy-webpack-plugin

# imagemin-webpack-plugin
# ファイルを圧縮します。
# 各ファイル形式に対応したパッケージもインストールします。
# png imagemin-pngquant
# jpg imagemin-mozjpeg
# gif imagemin-gifsicle
# svg imagemin-svgo
yarn-add-D-plugin-imagemin:
	docker compose exec web yarn add -D imagemin-webpack-plugin imagemin-pngquant imagemin-mozjpeg imagemin-gifsicle imagemin-svgo


# webpack-watched-glob-entries-plugin
# globの代わり
# https://shuu1104.com/2021/11/4388/
yarn-add-D-plugin-watched-glob-entries:
	docker compose exec web yarn add -D webpack-watched-glob-entries-plugin

# clean-webpack-plugin
# https://shuu1104.com/2021/12/4406/
yarn-add-D-plugin-clean:
	docker compose exec web yarn add -D clean-webpack-plugin

# webpack-stats-plugin
# mix-manifest.jsonを、laravel-mixを使わずに自作する
# https://qiita.com/kokky/items/02063edf3252e147940a
yarn-add-D-plugin-webpack-stats:
	docker compose exec web yarn add -D webpack-stats-plugin


# source-map-loader
# webpack-hot-middleware

# dotenv-webpack
# ※webpack5からそのままではprocess.envで環境変数を読み込めない
# https://forsmile.jp/javascript/1054/

yarn-add-D-dotenv-webpack:
	docker compose exec web yarn add -D dotenv-webpack

# ---- PWA化 ----

# https://www.npmjs.com/package/workbox-sw
# https://www.npmjs.com/package/workbox-webpack-plugin
# https://www.npmjs.com/package/webpack-pwa-manifest
# https://github.com/webdeveric/webpack-assets-manifest

# https://www.hivelocity.co.jp/blog/46013/
# https://qiita.com/umashiba/items/1157e7e520f668417cf0

yarn-add-D-pwa:
	docker compose exec web yarn add -D workbox-sw workbox-webpack-plugin webpack-pwa-manifest webpack-assets-manifest

# ==== ESLint プラグイン ====

# https://eslint.org/

# ESLintルール一覧
# https://garafu.blogspot.com/2017/02/eslint-rules-jp.html
# https://zenn.dev/yhay81/articles/def73cf8a02864

# ベストプラクティス
# https://qiita.com/khsk/items/0f200fc3a4a3542efa90
# https://t-cr.jp/memo/1df17a37ac927d37
# https://kk-web.link/blog/20211025

# ESLint(Next.js)
# https://nextjs.org/docs/basic-features/eslint#eslint-plugin
# 記事:
# https://zenn.dev/thiragi/articles/555a644b35ebc1
# https://qiita.com/kewpie134134/items/0298e5b7a88a06804cd8
# https://qiita.com/ganja_tuber/items/95507e658ecfef7e9457
# https://maku.blog/p/dexgg8o/
# https://qiita.com/madono/items/a134e904e891c5cb1d20

# **** extends ****

# eslint:recommended のルール一覧:
# https://eslint.org/docs/latest/rules/

# plugin:@typescript-eslint/recommended のルール一覧:
# https://github.com/typescript-eslint/typescript-eslint/blob/main/packages/eslint-plugin/src/configs/recommended.ts
# 型を必要としない基本ルールを詰め込んだもの

# plugin:@typescript-eslint/recommended-requiring-type-checking のルール一覧:
# https://github.com/typescript-eslint/typescript-eslint/blob/main/packages/eslint-plugin/src/configs/recommended-requiring-type-checking.ts
# 型情報が必要な基本ルールを詰め込んだもの
# TypeScriptのビルド時間分が増えるので、パフォーマンスが気になる場合は外す

# plugin:@typescript-eslint/eslint-recommended
# TypeScriptでチェックされる項目を除外する設定
# recommendedとrecommended-requiring-type-checkingに含まれているので、どちらかを使うなら記述する必要は無い

# **** 必要最低限 ****

# eslint
# https://github.com/eslint/eslint

# eslint-config-prettier
# https://github.com/prettier/eslint-config-prettier
# prettierと競合するルールをオフにするやつ おすすめ度５

# eslint-plugin-prettier
# https://github.com/prettier/eslint-plugin-prettier
# prettierをeslintから起動するのではなく、別にprettierコマンドを打つ派閥が存在する。おすすめ度３

# ---- TypeScript ESLint ----

# https://github.com/typescript-eslint/typescript-eslint
# 記事:
# https://maku.blog/p/xz9iry9/

# @typescript-eslint/eslint-plugin
# https://www.npmjs.com/package/@typescript-eslint/eslint-plugin
# TypeScript 専用のセット おすすめ度５

# @typescript-eslint/parser
# https://www.npmjs.com/package/@typescript-eslint/parser
# TypeScript 対応するのに絶対必要なやつ おすすめ度５

# **** 入れると便利 ****

# eslint-plugin-react
# https://github.com/jsx-eslint/eslint-plugin-react
# react のやつ。おすすめ度５

# eslint-plugin-react-hooks
# https://www.npmjs.com/package/eslint-plugin-react-hooks
# react-hooks のやつ。おすすめ度４

# eslint-plugin-jsx-a11y
# https://github.com/jsx-eslint/eslint-plugin-jsx-a11y
# アクセシビリティ守ろうセット。おすすめ度３

# eslint-config-next
# https://nextjs.org/docs/basic-features/eslint
# 記事:
# https://zenn.dev/thiragi/articles/555a644b35ebc1
# https://zenn.dev/unreact/articles/nextjs-basic-features-eslint-jp#eslint-%E3%81%AE%E8%A8%AD%E5%AE%9A
# https://qiita.com/kewpie134134/items/0298e5b7a88a06804cd8
# ※ eslint-plugin-react, eslint-plugin-react-hooks, eslint-plugin-jsx-a11yはデフォルトで入っている
# ソース:
# https://github.com/vercel/next.js/blob/canary/packages/eslint-config-next/index.js

# ---- importのorder指定 ----

# eslint-plugin-import
# https://github.com/import-js/eslint-plugin-import
# 記事:
# https://qiita.com/P-man_Brown/items/8e84c2d44843f2a0b363
# https://zenn.dev/sqer/articles/35d56d9850efb2
# https://zenn.dev/hungry_goat/articles/b7ea123eeaaa44
# import時のルール おすすめ度３

# ---- importのaliasを追加 ----

# ? Next Create Appの場合:
# - TS使用
# https://nextjs-ja-translation-docs.vercel.app/docs/advanced-features/module-path-aliases
# https://github.com/vercel/next.js/tree/deprecated-main/examples/with-absolute-imports
# https://qiita.com/tatane616/items/e3ee99a181662ad6824b
# https://t-cr.jp/memo/3cc17944875d1463
# https://fwywd.com/tech/next-base-url
# https://maku.blog/p/qgvamzc/
# https://yamatooo.blog/entry/2021/06/23/083000
# https://tamalog.szmd.jp/storybook-absolute-imports/

# ! TypeScriptの開発を行う場合にはsettingsでimport/resolverの設定をしないとTypeScriptのモジュールのimportでエラーが出てしまう
# https://miyahara.hikaru.dev/posts/20200501/

# - TS無使用
# https://github.com/import-js/eslint-plugin-import/issues/1286#issuecomment-468342946
# https://dev.to/luis_sserrano/configure-eslint-prettier-and-path-aliases-with-nextjs-37do

# eslint-import-resolver-typescript
# next.config.js + elintrc.js + tsconfig.paths.json
# https://github.com/import-js/eslint-import-resolver-typescript
# https://www.npmjs.com/package/eslint-import-resolver-typescript
# 記事:
# https://zenn.dev/sqer/articles/35d56d9850efb2
# https://qiita.com/282Haniwa/items/76d56a6a7e9d0db95a33
# https://zenn.dev/longbridge/articles/5e33ff1a625158
# https://xecua.hatenablog.com/entry/2021/02/26/155221
# https://qiita.com/kterui9019/items/a8096493199e958f97b0

# ! eslint-import-resolver-typescriptを使用しないと、eslintでimport/no-unresolvedと怒られる
# https://qiita.com/kterui9019/items/a8096493199e958f97b0
# https://qiita.com/kterui9019/items/398e8222f5a432ad7864
# https://numb86-tech.hatenablog.com/entry/2019/05/09/221954

# ? React Create APPの場合
# eslint-import-resolver-alias
# craco.config.js + elintrc.js + tsconfig.paths.json
# https://github.com/johvin/eslint-import-resolver-alias
# https://www.npmjs.com/package/react-app-rewire-alias
# 記事:
# https://zenn.dev/hisho/scraps/9dac35debee820
# https://zukucode.com/2021/06/react-create-app-eslint-vscode.html

# ? Webpackで環境構築する場合
# eslint-import-resolver-webpack
# webpack.config.js + elintrc.js + tsconfig.paths.json
# https://www.npmjs.com/package/eslint-import-resolver-webpack
# https://github.com/import-js/eslint-plugin-import/tree/main/resolvers/webpack
# 記事:
# https://nametake.github.io/posts/2019/10/07/typescript-absolute-imports/
# https://qiita.com/282Haniwa/items/76d56a6a7e9d0db95a33s
# https://qiita.com/Statham/items/8a1161c7816e360590f3

# **** 必要に応じて ****

# eslint-plugin-ava
# https://github.com/avajs/eslint-plugin-ava
# よく知らないけど、いっぱい盛りセット。嫌いじゃないけどあんまり使われてない。おすすめ度２

# eslint-plugin-eslint-comments
# https://github.com/mysticatea/eslint-plugin-eslint-comments
# コメントの書き方セット。別にいらん？おすすめ度２

# eslint-plugin-simple-import-sort
# https://github.com/lydell/eslint-plugin-simple-import-sort
# インポート・エクスポート順だけ。"eslint-plugin-import"はエクスポートないからそのためだけに仕方なく。おすすめ度 2

# eslint-plugin-sonarjs
# https://github.com/SonarSource/eslint-plugin-sonarjs
# sonarqubeっていう言語によらない汎用リンターがあって、そこのルール。おすすめ度３

# eslint-plugin-unicorn
# https://github.com/sindresorhus/eslint-plugin-unicorn
# よく知らないけど、いっぱい盛りセット。若干癖つよ感。おすすめ度２

# @herp-inc/eslint-config
# https://github.com/herp-inc/eslint-config

# eslint-config-airbnb-typescript
# https://github.com/iamturns/eslint-config-airbnb-typescript

# eslint-config-google
# https://github.com/google/eslint-config-google

# eslint-plugin-css-modules
# https://www.npmjs.com/package/eslint-plugin-css-modules

# eslint-plugin-filenames
# https://github.com/selaux/eslint-plugin-filenames

# eslint-plugin-sort-destructure-keys
# https://github.com/mthadley/eslint-plugin-sort-destructure-keys

# eslint-plugin-sort-keys-shorthand
# https://github.com/fxOne/eslint-plugin-sort-keys-shorthand/blob/master/docs/rules/sort-keys-shorthand.md

# eslint-plugin-typescript-sort-keys
# https://github.com/infctr/eslint-plugin-typescript-sort-keys

# eslint-import-resolver-webpack
# https://www.npmjs.com/package/eslint-import-resolver-webpack
# https://github.com/import-js/eslint-plugin-import/tree/main/resolvers/webpack
# 記事:
# https://nametake.github.io/posts/2019/10/07/typescript-absolute-imports/
# https://qiita.com/282Haniwa/items/76d56a6a7e9d0db95a33s

# ==== StyleLint プラグイン ====

# https://stylelint.io/

# **** 必要最低限 ****

# stylelint
# https://github.com/stylelint/stylelint

# stylelint-config-prettier
# https://github.com/prettier/stylelint-config-prettier#stylelint-config-prettier
# コードフォーマッター Prettier と設定がコンフリクトしないようにする設定

# stylelint-config-prettier-scss
# https://www.npmjs.com/package/stylelint-config-prettier-scss

# **** 入れると便利 ****

# stylelint-config-recess-order
# https://github.com/stormwarning/stylelint-config-recess-order
# プロパティの順番

# stylelint-scss
# https://github.com/stylelint-scss/stylelint-scss
# SCSS 用の設定

# ※ recommended or standard ?
# - standardの方が厳格
# - stylelint-config-standard-scssがメンテナンスされていない

# stylelint-config-standard
# https://github.com/stylelint/stylelint-config-standard
# 基本的な記述設定

# stylelint-config-standard-scss
# 旧: https://github.com/moeriki/stylelint-config-standard-scss
# 新: https://github.com/stylelint-scss/stylelint-config-standard-scss

# stylelint-config-recommended
# https://github.com/stylelint/stylelint-config-recommended
# https://github.com/stylelint-scss/stylelint-config-recommended-scss

# stylelint-config-recommended-scss
# https://github.com/stylelint-scss/stylelint-config-recommended-scss

# **** 必要に応じて ****

# stylelint-order
# https://github.com/hudochenkov/stylelint-order

# stylelint-config-idiomatic-order
# https://github.com/ream88/stylelint-config-idiomatic-order

# @stylelint/postcss-css-in-js
# https://github.com/stylelint/postcss-css-in-js

# stylelint-config-css-modules
# https://github.com/pascalduez/stylelint-config-css-modules

# stylelint-config-sass-guidelines
# https://github.com/bjankord/stylelint-config-sass-guidelines

# ==== Prettier ====

# https://prettier.io/

# prettier
# https://github.com/prettier/prettier

# 設定項目一覧
# https://prettier.io/docs/en/options.html

# ? VSCodeでの初期設定
# Prettier - Code formatter という拡張機能をインストール
# 設定 → require config と検索 → Prettier:Require Config にチェック
# on save と検索 → Edditor:Format On Save にチェック

# **** PHPでの設定手順 ****

# 記事
# https://maasaablog.com/tools/visual-studio-code/2095/
# https://qiita.com/AkiraTameto/items/4cefe2608b03f396c7cd

# 設定項目一覧
# https://prettier.io/docs/en/options.html

# ⑴ Prettierのインストール

# https://github.com/prettier/plugin-php

# global
yarn-global-add-prettier-plugin-php:
	docker compose exec web yarn global add prettier @prettier/plugin-php

# local
yarn-add-D-prettier-plugin-php:
	docker compose exec web  yarn add -D prettier @prettier/plugin-php

# npm install --global prettier @prettier/plugin-php
# npm install --save-dev prettier @prettier/plugin-php


# ⑵ prettier設定ファイルの作成

# プロジェクトのルートディレクリに .prettierrcファイルを作成

# .prettierrc
# {
#   "singleQuote": true, // ダブルクォーテーションは不可
#   "trailingComma": "all"  // 文末のカンマ必須(ex.複数行の配列など)
# }

# ⑶ VsCodeの拡張機能をインストール

# Run on Saveをインストールする。
# https://marketplace.visualstudio.com/items?itemName=emeraldwalk.RunOnSave

# インストール後、setting.jsonに以下を追記
# ※拡張子.phpに対してプラグインを適用するように

# setting.json
# "emeraldwalk.runonsave": {
#   "commands": [
#     {
#       "match": "\\.php$",
#       "cmd": "prettier ${file} --write"
#     }
#   ]
# }

# ※HTMLとPHPを含んだPHPファイルは整形することができないので、注意

# ==== jQuery ====

yarn-add-jquey:
	docker compose exec web yarn add jQuery

# ==== Bootstrap ====

yarn-add-bootstrap-v5:
	docker compose exec web yarn add bootstrap @popperjs/core
yarn-add-bootstrap-v4:
	docker compose exec web yarn add bootstrap@4.6.1

# ==== CSS Reset ====

# https://web-camp.io/magazine/archives/30817

# ---- Eric Meyer’s “Reset CSS” 2.0 ----

# https://meyerweb.com/eric/tools/css/reset/

# 非推奨: 一部のタグがHTML5に非対応

# ---- HTML5 Doctor CSS Reset ----

# http://html5doctor.com/html-5-reset-stylesheet/

# 推奨: まっさらな状態から、全て自分でデザインを調整したい場合

# ---- Yahoo! (YUI 3) Reset CSS ----

# https://yuilibrary.com/yui/docs/cssreset/

# 非推奨: 一部のタグがHTML5に非対応, 過去5年間更新無し

# ---- Universal Selector ‘*’ Reset ----

# * {
#   margin: 0;
#   padding: 0;
# }

# 非推奨: Webページの読み込み速度が遅くなる

# ---- Normalize.css ----

# https://github.com/necolas/normalize.css/blob/master/normalize.css

# 全てを自分でデザインしなくても、デフォルトの状態でそれなりに整ったデザインをすることが可能

# ---- ress ----

# https://github.com/filipelinhares/ress

# normalize.cssの後継:
# 変更点:すべての要素のpaddingとmarginをリセットすること、<input>要素の標準スタイルを打ち消すことなど

# ---- sanitize.css ----

# https://csstools.github.io/sanitize.css/
# https://github.com/csstools/sanitize.css

# npm install sanitize.css --save

# Import sanitize.css in CSS:
# @import '~sanitize.css';
# @import '~sanitize.css/forms.css';
# @import '~sanitize.css/typography.css';

# 推奨:
# normalize.cssの共同開発者が開発したこともあり、normalize.cssの思想を受け継ぐ
# こちらのほうが少し余白の幅が広い
# スマホなどのモバイルに対応

# ==== Tailwind CSS 関連 ====

# Tailwind CHEAT SHEET
# https://nerdcave.com/tailwind-cheat-sheet

# Tailwind CSS IntelliSense
# 有効にすると補完が効く。

# https://zenn.dev/otanu/articles/f0a0b2bd0d9c44

# https://tailwindcss.jp/docs/installation
# https://gsc13.medium.com/how-to-configure-webpack-5-to-work-with-tailwindcss-and-postcss-905f335aac2
# https://qiita.com/hirogw/items/518a0143aee2160eb2d8
# https://qiita.com/maru401/items/eb4c7160b19127a76457

# インストールパッケージ
# https://github.com/tailwindlabs/tailwindcss-from-zero-to-production/tree/main/01-setting-up-tailwindcss

# entrypointに import "tailwind.css"
# webpackと一緒に使う場合は、src/css/tailwind.css -o public/css/dist.css は不要
# tailwind.css
# @tailwind base;
# @tailwind components;
# @tailwind utilities;

# package.json
# "scripts": {
#     "dev": "TAILWIND_MODE=watch postcss src/css/tailwind.css -o public/css/dist.css -w",
#     "prod": "NODE_ENV=production postcss src/css/tailwind.css -o public/css/dist.css"
#   }

yarn-add-D-tailwind-postcss-cli:
	docker compose exec web yarn add -D tailwindcss postcss postcss-cli autoprefixer cssnano
yarn-add-D-tailwind-v2-postcss-cli:
	docker compose exec web yarn add -D tailwindcss@2.2.19 postcss
	postcss-cli autoprefixer cssnano

# https://qiita.com/hironomiu/items/eac89ca4801534862fed#tailwind-install--initialize
# ホットリロードの併用すると、勝手にビルドされ続ける
yarn-add-D-tailwind-v3-webpack:
	docker compose exec web yarn add -D tailwindcss @types/tailwindcss eslint-plugin-tailwindcss
# 推奨
yarn-add-D-tailwind-v2-webpack:
	docker compose exec web yarn add -D tailwindcss@2.2.19 @types/tailwindcss eslint-plugin-tailwindcss



# postcss.config.js
# module.exports = (ctx) => {
#     return {
#         map: ctx.options.map,
#         plugins: {
#             tailwindcss: {},
#             autoprefixer: {},
#             cssnano: ctx.env === "production" ? {} : false,
#         },
#     }
# };
#
# module.exports = (ctx) => {
#     return {
#         map: ctx.options.map,
#         plugins: [
#             require('tailwindcss'),
#             require('autoprefixer'),
#             ctx.env === "production && require('cssnano')
#         ].filter(Boolean),
#     }
# };

# tailwind.config.js
# module.exports = {
#   mode: "jit",
#   purge: ["./public/index.html"],

# tailwind.config.jsとpostcss.config.js生成
yarn-tailwind-init-p:
	docker compose exec web yarn tailwindcss init -p

# tailwind.config.js生成
yarn-tailwind-init:
	docker compose exec web yarn tailwindcss init

# ==== React関連 ====

# https://zenn.dev/shohigashi/scraps/15f0eb42e97d5c

# Snippets:
# rafc: React Arrow Function Component
# rafce: React Arrow Function Export Component

yarn-add-D-react-full:
	docker compose exec web yarn add -D react react-dom react-router-dom @babel/preset-react @types/react @types/react-dom @types/react-router-dom react-helmet-async history

yarn-add-D-react:
	docker compose exec web yarn add -D react react-dom @babel/preset-react @types/react @types/react-dom

# https://issueoverflow.com/2018/08/02/use-react-easily-with-react-scripts/
yarn-add-D-react-scripts:
	docker compose exec web yarn add -D react-scripts


# ---- react-router ----

# https://qiita.com/koja1234/items/486f7396ed9c2568b235
yarn-add-D-react-router:
	docker compose exec web yarn add -D react-router history

# 推奨
# https://zenn.dev/h_yoshikawa0724/articles/2020-09-22-react-router
# react-router も必要になりますが、react-router-dom の依存関係にあるので、一緒に追加されます。
# v6
# https://reactrouter.com/docs/en/v6
yarn-add-D-react-router-dom-v6:
	docker compose exec web yarn add -D react-router-dom @types/react-router-dom history

# v5
# https://v5.reactrouter.com/
# Reduxと一緒に使う場合は、react-routerは5系、historyは4系推奨
yarn-add-D-react-router-dom:
	docker compose exec web yarn add -D react-router-dom@5.3.0 @types/react-router-dom@ history@4.10.1

# ---- react-helmet ----

# https://github.com/nfl/react-helmet
# https://www.npmjs.com/package/@types/react-helmet
yarn-add-D-react-helmet:
	docker compose exec web yarn add -D react-helmet @types/react-helmet

# 推奨
# https://github.com/staylor/react-helmet-async
# 記事
# https://yumegori.com/react_helmet_async_method
yarn-add-D-react-helmet-async:
	docker compose exec web yarn add -D react-helmet-async

# index.tsx
# import React from 'react';
# import ReactDOM from 'react-dom';
# import { Helmet, HelmetProvider } from 'react-helmet-async';
# import App from './App';

# ReactDOM.render(
#   <React.StrictMode>
#     <HelmetProvider>
#       <Helmet>
#         <title>サイトのタイトルです</title>
#         <meta name="description" content="サイトの説明文です" />
#       </Helmet>
#       <App />
#     </HelmetProvider>
#   </React.StrictMode>,
#   document.getElementById('root')
# );

# ---- react-spinners ----

yarn-add-D-react-spinners:
	docker compose exec web yarn add -D react-spinners

# ---- html-react-parser ----

yarn-add-D-html-react-parser:
	docker compose exec web yarn add -D html-react-parser

# ---- react-paginate ----

# https://www.npmjs.com/package/react-paginate
yarn-add-D-react-paginate:
	docker compose exec web yarn add -D react-paginate @types/react-paginate

# ---- react-countup ----

# https://www.npmjs.com/package/react-countup
yarn-add-D-react-countup:
	docker compose exec web yarn add -D react-countup

# ---- react-tag-input ----

# https://www.npmjs.com/package/react-tag-input
# https://github.com/pathofdev/react-tag-input
# https://www.npmjs.com/package/@types/react-tag-input

yarn-add-D-react-tag-input:
	docker compose exec web yarn add -D react-tag-input @types/react-tag-input

# ---- react toastify ----

# https://github.com/fkhadra/react-toastify
# https://fkhadra.github.io/react-toastify/introduction/

yarn-add-D-toastify:
	docker compose exec web yarn add -D react-toastify


# ==== アイコン関連 ====

# ---- react-icons ----

yarn-add-D-react-icons:
	docker compose exec web yarn add -D react-icons


# ---- tabler-icons-react ----

# https://tabler-icons-react.vercel.app/
# https://github.com/konradkalemba/tabler-icons-react
# https://www.npmjs.com/package/tabler-icons-react

yarn-add-D-tabler-icons:
	docker compose exec web yarn add -D tabler-icons-react


# ---- heroicons ----

# https://heroicons.com/
# https://www.npmjs.com/package/@heroicons/react
# https://github.com/tailwindlabs/heroicons

yarn-add-D-heroicons:
	docker compose exec web yarn add -D @heroicons/react


# ---- Font Awesome ----

# https://fontawesome.com/

# CDN
# https://notes-de-design.com/website/tool/use-cdn-download-fontawesome/#CDN
# https://cdnjs.com/libraries/font-awesome


# ==== Create React App ====

# ---- create-react-app ----

yarn-create-react-app:
	docker compose exec web yarn create react-app .

yarn-create-react-app-npm:
	docker compose exec web yarn create react-app . --use-npm

yarn-create-react-app-ts:
	docker compose exec web yarn create react-app . --template typescript

# https://kic-yuuki.hatenablog.com/entry/2019/09/08/111817
yarn-add-eslint-config-react-app:
	docker compose exec web yarn add eslint-config-react-app

yarn-start:
	docker compose exec web yarn start

# ---- reduxjs/cra-template-redux-typescript ----

# https://github.com/reduxjs/cra-template-redux-typescript

# npx create-react-app my-app --template redux-typescript

yarn-create-react-app-redux-ts:
	docker compose exec web yarn create react-app --template redux-typescript .

# ---- PWA化 ----

# https://qiita.com/suzuki0430/items/9c2bd2b8839c164cfb28
# npx create-react-app [プロジェクト名] --template cra-template-pwa
# npx create-react-app [プロジェクト名] --template cra-template-pwa-typescript

yarn-create-react-app-ts-pwa:
	docker compose exec web yarn create react-app --template cra-template-pwa-typescript .

# ---- CRACO -----

# https://github.com/gsoft-inc/craco/blob/master/packages/craco/README.md

# カスタマイズ
# importのalias設定
# https://zukucode.com/2021/06/react-create-app-import-alias.html
yarn-add-D-craco:
	docker compose exec web yarn add -D @craco/craco eslint-import-resolver-alias

# craco.config.js
# const path = require('path');
#
# module.exports = {
#   webpack: {
#     alias: {
#       '@src': path.resolve(__dirname, 'src/'),
#     },
#   },
# };

# "scripts": {
#   "start": "craco start",
#   "build": "craco build",
#   "test": "craco test",
#   "eject": "craco eject"
# },

# tsconfig.paths.json
# {
#   "compilerOptions": {
#     "baseUrl": ".",
#     "paths": {
#       "@src/*": [
#         "./src/*"
#       ],
#     }
#   }
# }

# eslintrc.js
# module.exports = {
#   settings: {
#     'import/resolver': {
#       alias: {
#         map: [['@src', './src']],
#         extensions: ['.js', '.jsx', '.ts', '.tsx'],
#       },
#     },
#   },
# };

# tsconfig.json
# {
# 	"extends": "./tsconfig.paths.json",
# }

# Tailwind CSS for create-react-app
# https://v2.tailwindcss.com/docs/guides/create-react-app
# https://ramble.impl.co.jp/1681/#toc8
yarn-add-D-tailwind-v2-react:
	docker compose exec web yarn add -D tailwindcss@npm:@tailwindcss/postcss7-compat postcss@^7 autoprefixer@^9 @craco/craco

# "scripts": {
#     "start": "craco start",
#     "build": "craco build",
#     "test": "craco test",
#     "eject": "react-scripts eject"
#   },

# craco.config.js
# module.exports = {
#     style: {
#         postcss: {
#             plugins: [
#                 require('tailwindcss'),
#                 require('autoprefixer')
#             ]
#         }
#     }
# };
touch-caraco:
	docker compose exec web touch craco.config.js

# tailwind.config.js
# purge: [
#         './src/**/*.{js,jsx,ts,tsx}',
#         './public/index.html'
# ],
# yarn-tailwind-init:
	docker compose exec web yarn tailwind init

# ==== CSS in JSX ====

# **** styled-jsx ****

# https://github.com/vercel/styled-jsx

yarn-add-D-styledjsx:
	docker compose exec web yarn add -D styled-jsx

# **** styled-components ****

# https://styled-components.com/
# https://github.com/styled-components/styled-components

yarn-add-D-styledcomponents:
	docker compose exec web yarn add -D styled-components

# **** Emotion ****

# https://emotion.sh/docs/introduction
# https://emotion.sh/docs/@emotion/react
# https://github.com/iwakin999/next-emotion-typescript-example
# https://emotion.sh/docs/@emotion/babel-preset-css-prop
# https://www.npmjs.com/package/@emotion/babel-plugin

# 記事
# https://zenn.dev/iwakin999/articles/7a5e11e62ba668
# https://qiita.com/cheez921/items/1d13545f8a0ea46beb51
# https://qiita.com/xrxoxcxox/items/17e0762d8e69c1ef208f
#
# React v17以上
yarn-add-D-emotion-v11:
	docker compose exec web yarn add -D @emotion/react @emotion/styled @emotion/babel-plugin

# React v17以下
yarn-add-D-emotion-v10:
	docker compose exec web yarn add -D @emotion/core @emotion/styled @emotion/babel-preset-css-prop

# 非推奨
yarn-add-D-emotion-css:
	docker compose web yarn add -D @emotion/css

# **** Linaria ****

# https://github.com/callstack/linaria
# https://www.webopixel.net/javascript/1722.html

yarn-add-D-linaria:
	docker compose exec web yarn add -D @linaria/core @linaria/react @linaria/babel-preset @linaria/shaker @linaria/webpack-loader

# ==== Storybook ====

# 公式
# https://storybook.js.org/docs/react/get-started/introduction
# https://storybook.js.org/tutorials/intro-to-storybook/react/ja/get-started/
# https://storybook.js.org/tutorials/intro-to-storybook/angular/ja/get-started/

# Configure Storybook
# https://storybook.js.org/docs/react/configure/overview

# How to write stories
# https://storybook.js.org/docs/react/writing-stories/introduction

# ArgTypes
# https://storybook.js.org/docs/react/api/argtypes

# Args
# https://storybook.js.org/docs/react/writing-stories/args

# Actions
# https://storybook.js.org/docs/react/essentials/actions

# PropTypes(JS)
# https://ja.reactjs.org/docs/typechecking-with-proptypes.html
# https://www.npmjs.com/package/prop-types
# https://qiita.com/h-yoshikawa44/items/bab6845472e4d428732c
# https://zenn.dev/syu/articles/95eabfa766c358

# Interactions
# import { userEvent, within } from "@storybook/testing-library";
# import { expect } from "@storybook/jest";

# TypeScript
# https://storybook.js.org/docs/react/configure/typescript
# https://github.com/kiiiyo/learn-storybook/tree/fix/setup-storybook
# https://zenn.dev/kolife01/articles/nextjs-typescript-storybook-tailwind
# https://zenn.dev/otanu/articles/f0a0b2bd0d9c44

# Storybookのアップデート情報
# https://mokajima.com/updating-storybook/
# ※ Storybook 6.0 から TypeScript がビルトインサポートされたため、TypeScript 関連の設定が不要となった。
# https://github.com/storybookjs/storybook/blob/next/MIGRATION.md#zero-config-typescript

# 記事
# https://reffect.co.jp/html/storybook
# https://www.techpit.jp/courses/109/curriculums/112/sections/841/parts/3119
# https://blog.microcms.io/storybook-react-use/
# https://zenn.dev/otanu/articles/f0a0b2bd0d9c44
# https://tech-mr-myself.hatenablog.com/entry/2020/02/05/214226
# https://qiita.com/masakinihirota/items/ac552b8b492d2b962818
# https://panda-program.com/posts/nextjs-storybook-typescript-errors
# https://tech-mr-myself.hatenablog.com/entry/2020/02/05/214226
# https://zenn.dev/yukishinonome/articles/6bc6e33d579276
# https://zenn.dev/tomon9086/articles/a0f3e549b4e848627e3c

# **** Storybookのセットアップ ****

# https://storybook.js.org/docs/react/get-started/install

# ⑴ StoryBookのインストール(.storybook, src/stories)
sb-init:
	docker compose exec web npx storybook init

# ⑵ ビルドとブラウザ表示
sb:
	docker compose exec web yarn storybook

# **** addons ****

# Supercharge Storybook
# https://storybook.js.org/addons

# Essential addons
# https://storybook.js.org/docs/react/essentials/introduction

# まとめ
# https://qiita.com/kichion/items/93ffe1ba773d26c20ff6
# https://blog.spacemarket.com/code/storybook-addon/
# https://tech.stmn.co.jp/entry/2021/05/17/155842
# https://iwb.jp/storybook-for-html-css-js-style-guide-tool-addons/

# @storybook/jest
# https://storybook.js.org/addons/@storybook/addon-jest
sb-add-jest:
	docker compose exec web yarn add -D @storybook/jest

# @storybook/addon-storysource
# https://storybook.js.org/addons/@storybook/addon-storysource
sb-add-storysource:
	docker compose exec web yarn add -D @storybook/addon-storysource

# @storybook/addon-console
# https://storybook.js.org/addons/@storybook/addon-console
sb-add-console:
	docker compose exec web yarn add -D @storybook/addon-console

# @storybook/addon-contexts
# https://storybook.js.org/addons/@storybook/addon-contexts
# https://kakehashi-dev.hatenablog.com/entry/2022/02/04/103000
sb-add-contexts:
	docker compose exec web yarn add -D @storybook/addon-contexts

# @storybook/addon-a11y
# https://storybook.js.org/addons/@storybook/addon-a11y
sb-add-a11y:
	docker compose exec web yarn add -D @storybook/addon-a11y

# @storybook/addon-google-analytics
# https://storybook.js.org/addons/@storybook/addon-google-analytics
sb-add-google-analytics:
	docker compose exec web yarn add -D @storybook/addon-google-analytics

# @whitespace/storybook-addon-html
# https://storybook.js.org/addons/@whitespace/storybook-addon-html
# https://zenn.dev/mym/articles/69badd52494031
yarn-add-D-storybook-addon-html:
	docker compose exec web yarn add -D @whitespace/storybook-addon-html

# @pickra/copy-code-block
# https://github.com/Pickra/copy-code-block
yarn-add-D-copy-code-block:
	docker compose exec web yarn add -D @pickra/copy-code-block

# @storybook/addon-info
# ※ @storybook/addon-infoの後継が@storybook/addon-docsとなり不要に
# Storybook 6.0 で非推奨
sb-add-info:
	docker compose exec web yarn add -D @storybook/addon-info @types/storybook__addon-info

# @storybook/addon-knobs
# ※ @storybook/addon-knobsの後継が@storybook/addon-controlsとなり不用に
# Storybook 7.0 より後で非推奨となる可能性
sb-add-knobs:
	docker compose exec web yarn add -D @storybook/addon-knobs

# react-docgen-typescript-loader
# https://github.com/styleguidist/react-docgen-typescript
# ※ Storybook 6.0以降より不要に
yarn-add-D-react-docgen-typescript-loader:
	docker compose exec web yarn add -D react-docgen-typescript-loader

# gh-pages
yarn-add-D-gh-pages:
	docker compose exec web yarn add -D gh-pages

# storybook-addon-material-ui
# https://storybook.js.org/addons/storybook-addon-material-ui/
sb-add-material:
	docker compose exec web yarn add -D storybook-addon-material-ui

# @chakra-ui/storybook-addon
# https://storybook.js.org/addons/@chakra-ui/storybook-addon/
sb-add-chakra:
	docker compose exec web yarn add -D @chakra-ui/storybook-addon

# storybook-addon-mantine
# https://storybook.js.org/addons/storybook-addon-mantine/
sb-add-mantine:
	docker compose exec web yarn add -D storybook-addon-mantine

# ==== 状態管理ライブラリ ====

# 記事
# https://zenn.dev/tell_y/articles/d714f9c16c1d3a

# **** Redux ****

# https://qiita.com/hironomiu/items/eac89ca4801534862fed
# https://redux.js.org/introduction/installation
# https://react-redux.js.org/tutorials/connect
# https://github.com/paularmstrong/normalizr

yarn-add-redux:
	docker-compos exec web yarn add redux react-redux @types/redux @types/react-redux @types/node redux-thunk connected-react-router reselect immer normalizr

yarn-add-redux-full:
	docker compose exec web yarn add redux react-redux @types/redux @types/react-redux @reduxjs/toolkit @types/node redux-actions redux-logger @types/redux-logger redux-thunk connected-react-router reselect typescript-fsa typescript-fsa-reducers immer normalizr

yarn-add-line-liff:
	docker compose exec web yarn add @line/liff

# ---- thunk -----

# https://github.com/reduxjs/redux-thunk

yarn-add-redux-thunk:
	docker compose exec web yarn add redux-thunk

# ---- saga ----

# https://redux-saga.js.org/

yarn-add-redux-saga:
	docker compose exec web yarn add redux-saga

# ---- class-transformer ----

# https://github.com/typestack/class-transformer

yarn-add-class-transformer:
	docker compose exec web yarn add class-transformer reflect-metadata

# ---- class-validator ----

# https://github.com/typestack/class-validator

yarn-add-class-validator:
	docker compose exec web yarn add class-validator

# **** Redux Toolkit ****

# https://redux-toolkit.js.org/
# https://redux-toolkit.js.org/tutorials/typescript
# https://github.com/reduxjs/redux-toolkit

# 記事
# https://dev.classmethod.jp/articles/rtk-my-memorandum/
# https://akfm.dev/blog/2020-06-26/redux-toolkit.html

# ^ immer,redux-thunk,reselectはデフォルトで入っている。

yarn-add-reduxjs-toolkit:
	docker compose exec web yarn add @reduxjs/toolkit redux-logger@^3.0.6 @types/redux-logger@^3.0.9 connected-react-router@^6.9.2 history@4.10.1

# **** Recoil ****

# https://recoiljs.org/docs/introduction/getting-started/
# https://github.com/polemius/recoil-persist
# https://zenn.dev/eitarok/articles/7ee50e2f91f939

# 記事
# https://maasaablog.com/development/react/3226/
# https://developer-souta.com/blog/loqm_otx71i8
# https://qiita.com/takusan64/items/bdb61b46d46395e913df
# https://qiita.com/takusan64/items/b59458ca48df8e888458

yarn-add-recoil:
	docker compose exec web yarn add recoil recoil-persist

# **** Zustand	****

# https://github.com/pmndrs/zustand

# 記事
# https://qiita.com/daishi/items/deb20d951f532b86f029
# https://reffect.co.jp/react/zustand
# https://zenn.dev/dai_shi/articles/f848fb75650753
# https://dev.classmethod.jp/articles/zustand/

yarn-add-zustand:
	docker compose exec web yarn add zustand

# **** Jotai ****

# https://jotai.org/
# https://github.com/pmndrs/jotai

# 記事
# https://qiita.com/ItsukiN32/items/c87b06dcab1b1383300c
# https://zenn.dev/tell_y/articles/a200a3dec620cc
# https://zenn.dev/dai_shi/articles/369dc2a6b0877c

yarn-add-jotai:
	docker compose exec web yarn add jotai

# ==== キャッシュ管理ライブラリ ====

# **** useSWR ****

# https://swr.vercel.app/docs/getting-started
# https://swr.vercel.app/ja

# Client-side data fetching (Next.jsの場合、推奨)
# https://nextjs.org/docs/basic-features/data-fetching/client-side

# Usage with Next.js
# https://swr.vercel.app/docs/with-nextjs
# → getStaticPropsとuseSWRを組み合わせたPre-renderingの手法について
# → SEO対策(Pre-rendering)をしつつ、Client-side-fetchingによってDynamic(非同期)にリアルタイムでデータを取得できる

# 記事
# https://zenn.dev/uttk/articles/b3bcbedbc1fd00
# https://zenn.dev/mast1ff/articles/40b3ea4e221c36

yarn-add-swr:
	docker compose exec web yarn add swr

# useSWR Options
# https://swr.vercel.app/docs/options
#
# ・fallbackData: initial data to be returned (note: This is per-hook)
# → SWRはClient SideでFetchingを行うので、非同期の処理としてデータを取得するまでに、多少時間がかかる。
# この場合に事前にfallbackDataのところに初期値を設定することができる。
# 最新のデータを取得できるまでは古いデータをブラウザに表示させることもできる。
# Next.jsでは、getStaticPropsでbuild時に取得したデータをこのfallbackDataに予め入れておくことがよくやられる。
#
# ・revalidateOnMount: enable or disable automatic revalidation when component is mounted
# → Reactのコンポーネントまたはページがマウントされたとき、例えばページがリロードされたとき、自動的にServer Sideから最新のデータを取ってくるかどうかの設定。
# こちらの条件としては、fallbackDataを設定しない場合は、defaultでマウントされた時に最新のデータを取って来る。
# fallbackDataを設定している場合は、明示的にtrueにしてあげることでマウントされたときに、最新のデータを取ってくるという設定にすることができる。
#
# ・refreshInterval
# - Disabled by default: refreshInterval = 0
# - If set to a number, polling interval in milliseconds
# - If set to a function, the function will receive the latest data and should return the interval in milliseconds
# → defaultが0。polling intervalということでmillisecondsに単位で数字を設定することができる。
# 例えば、1000とすると1秒前にServer Sideにアクセスして最新のデータを取得してくれる形になる。
# Server Sideにある程度負荷がかかってしまう。しかし、例えばリアルタイムダッシュボードような頻繁にServer Sideのデータが更新されるような、金融のデータなどをダッシュボードに表示させたい場合は定期的にデータを更新することができる。
#
# ・dedupingInterval = 2000: dedupe requests with the same key in this time span in milliseconds
# → defaultが2000。2秒間に複数回のリクエストがあった場合は、初回の1回だけ実行される。
# 過剰なServer Sideへのリクエストを防ぐためのインターバル。
# 例えば2秒間に1000回リクエストがあったとしても、そのうちの最初の1回だけがちゃんと実行されて、他は無視されるようになって、Server Sideへの負荷を低減してくれるようなコンセプトになっている。
#
# そしてuseSWRは取得した値を常にキャッシュの方に保存してくれるので、このdedupingIntervalをすごく長くした場合は、その間はキャッシュの値を使ってくれるので、キャッシュをより活用したい場合はこの時間を長くする。
#
# テストを実行する場合は、dedupingIntervalを0にすることが推奨されている。

# **** React Query ****

# https://react-query.tanstack.com/
# https://github.com/tannerlinsley/react-query

# 記事
# https://reffect.co.jp/react/react-use-query

# ! 4系はreact-query@4.0.0-beta.10ではないと宣言ファイルエラーが発生しimportされない

yarn-add-react-query:
	docker compose exec web yarn add react-query@4.0.0-beta.10

# **** TanStack Query ****

# https://tanstack.com/query/v4
# https://tanstack.com/query/v4/?from=reactQueryV3&original=https://react-query-v3.tanstack.com/
# https://github.com/TanStack/query

# TanStack
# https://tanstack.com/
# https://github.com/TanStack

# 記事
# https://zenn.dev/himorishige/articles/76e903bc5a1aa2
# https://uit-inside.linecorp.com/episode/112
# https://blog.shahednasser.com/react-query-tutorial-for-beginners/

yarn-add-tanstack-query:
	docker compose exec web yarn add @tanstack/react-query @tanstack/react-query-devtools

# ==== DIコンテナ ====

# https://github.com/rbuckton/reflect-metadata

# Decorators
# https://mae.chab.in/archives/59845
# https://qiita.com/taqm/items/4bfd26dfa1f9610128bc


# ---- tsyringe ----

# https://github.com/microsoft/tsyringe

# tsconfig.json
# {
#   "compilerOptions": {
#     "experimentalDecorators": true,
#     "emitDecoratorMetadata": true
#   }
# }

yarn-add-D-tsyringe:
	docker compose exec web yarn add -D tsyringe reflect-metadata


# babel.config.js
# plugins: [
#             'babel-plugin-transform-typescript-metadata',
#             /* ...the rest of your config... */
#          ]

yarn-add-D-babel-plugin-transform-typescript-metadata:
	docker compose exec web yarn add -D babel-plugin-transform-typescript-metadata

# ---- inversify ----

# https://inversify.io/
# https://github.com/inversify/InversifyJS


# tsconfig.json
# {
#     "compilerOptions": {
#         "target": "es5",
#         "lib": ["es6"],
#         "types": ["reflect-metadata"],
#         "module": "commonjs",
#         "moduleResolution": "node",
#         "experimentalDecorators": true,
#         "emitDecoratorMetadata": true
#     }
# }

yarn-add-D-inversify:
	docker compose exec web yarn add -D inversify reflect-metadata

# ---- typedi ----

# https://github.com/typestack/typedi

# tsconfig.json
# {
#   "compilerOptions": {
#     "experimentalDecorators": true,
#     "emitDecoratorMetadata": true
#   }
# }

yarn-add-D-typedi:
	docker compose exec web yarn add -D typedi reflect-metadata

# ==== Next.js ====

# https://nextjs.org/docs
# https://nextjs.org/docs/getting-started
# https://nextjs-ja-translation-docs.vercel.app/docs/getting-started
# https://zenn.dev/otanu/articles/f0a0b2bd0d9c44
# https://dev-yakuza.posstree.com/react/nextjs/start/

# tutorial
# https://nextjs.org/learn/basics/create-nextjs-app
# npx create-next-app nextjs-blog --use-npm --example "https://github.com/vercel/next-learn/tree/master/basics/learn-starter"

# Tips:
# Next.jsでは"NEXT_PUBLIC_"で始まる環境変数を定義することで、Applicationの中で"process.env."という形で呼び出すことができる。

# 記事
# https://reffect.co.jp/react/next-js

# ベストプラクティス
# https://qiita.com/syuji-higa/items/931e44046c17f53b432b
# https://zenn.dev/higa/articles/d7bf3460dafb1734ef43

# TypeSript
# https://nextjs.org/learn/excel/typescript/nextjs-types
# https://zenn.dev/catnose99/articles/7201a6c56d3c88
# https://zenn.dev/ryo_kawamata/scraps/5d3e40c0fc1b21
# https://www.gaji.jp/blog/2021/11/08/8476/
# https://zenn.dev/eitches/articles/2021-0424-getstaticprops-type

# Layouts
# https://nextjs.org/docs/basic-features/layouts#per-page-layouts
# https://zenn.dev/hisho/articles/fe9f4ec4a8e691
# https://kk-web.link/blog/20210922

# Environment
# https://nextjs.org/docs/basic-features/environment-variables
# https://zenn.dev/jj/articles/next-js-env-best-practice
# https://zenn.dev/aktriver/articles/2022-04-nextjs-env
# https://blog.shinki.net/posts/nextjs-jest-environment-variable
# https://maku.blog/p/gbpeyov/
# https://blog.kimizuy.dev/posts/nextjs-env
# https://qiita.com/ktanoooo/items/64cad61096cf45f18c24

# ディレクトリ構成
# https://zenn.dev/mongolyy/articles/01f0a4375edb2e
# https://dev-k.hatenablog.com/entry/nextjs-directory-structure-dev-k
# https://zenn.dev/yodaka/articles/eca2d4bf552aeb
# https://zenn.dev/always_kakedash/scraps/4ea68ef01fc062
# https://qiita.com/kentt/items/c86782b481ec175a57e2
# https://maku.blog/p/4is2ahp/
# http://www.code-magagine.com/?p=16411

# Next.js + React Query + React Hook Form + Redux Toolkit
# https://zenn.dev/nrikiji/articles/92c222efbad3da

# **** next.config.jsの設定 ****

# https://nextjs.org/docs/api-reference/next.config.js/introduction
# https://nextjs-ja-translation-docs.vercel.app/docs/api-reference/next.config.js/introduction

# プラグイン:
# https://zenn.dev/aiji42/articles/1de8f9ea7b8a10

# 多言語化:
# https://qiita.com/ekzemplaro/items/2243a05bc07268460c46
# https://qiita.com/ekzemplaro/items/e60440f0827d117ed55d

# ---- Automatic Setup ----

# JS
yarn-create-next-app:
	docker compose exec web yarn create next-app .

npx-create-next-app:
	docker compose exec web npx create-next-app .

npx-create-next-app-use-npm:
	docker compose exec web npx create-next-app . --use-npm

# TS
yarn-create-next-app-ts:
	docker compose exec web yarn create next-app --typescript .

npx-create-next-app-ts:
	docker compose exec web npx create-next-app --ts .

npx-create-next-app-ts-use-npm:
	docker compose exec web npx create-next-app --ts . --use-npm

# ---- Manual Setup ----

# package.json
# "scripts": {
#   "dev": "next dev -p 3001",
#   "build": "next build",
#   "start": "next start",
#   "lint": "next lint"
# }
yarn-add-D-next:
	yarn add -D next react react-dom

# **** おすすめ環境 ****

# ---- Next.js + Supabase + Mantine + React Query + Zustand etc ----

yarn-add-D-next-env:
	docker compose exec web yarn add -D dayjs @mantine/core @mantine/hooks @mantine/form @mantine/dates @mantine/next tabler-icons-react @supabase/supabase-js react-query@4.0.0-beta.10 @heroicons/react date-fns yup axios zustand @mantine/notifications

# **** 便利なライブラリ ****

# ---- Tailwind CSS & Prettier ----

# 以下のマニュアルに従いsetting
# https://tailwindcss.com/docs/guides/nextjs

# [CSSTree] Unknown at-rule `@tailwind` の解消方法
# https://qiita.com/masakinihirota/items/bd8c07aa54efad307588
# https://qiita.com/P-man_Brown/items/bf05437afecde268ec15
# https://it-blue-collar-dairy.com/deferi_at-rule-no-unknown_for_stylelint/
# https://zenn.dev/k_neko3/articles/1189846d6340ef

yarn-add-D-next-tailwind-prettier:
	docker compose exec web yarn add -D tailwindcss postcss autoprefixer prettier prettier-plugin-tailwindcss

# npx tailwindcss init -p

# tailwind.config.js
# /** @type {import('tailwindcss').Config} */
# module.exports = {
#   content: [
#     './src/**/*.{js,ts,jsx,tsx}',
#   ],
#   theme: {
#     extend: {},
#   },
#   plugins: [],
#   corePlugins: {
#     preflight: true,
#   },
# }

# ! 2022年現在、Mantine UI と Tailwind CSS を同時に使用した場合に、コンポーネントが上手く表示されないという問題に対処するために、tailwind.config.js に下記を追記
# corePlugins: {
#     preflight: false,
# },
# → これをfalseにすると、aタグのtext-decorationがunderline、border-{side}系のスタイルが効かない

# styles/global.css
# @import "tailwindcss/base";
# @import "tailwindcss/components";
# @import "tailwindcss/utilities";

# .prettierrc
# {
#   "singleQuote": true ,
#   "semi": false
# }

# ---- NextAuth.js + Prisma ----

# NextAuth.js
# https://next-auth.js.org/
# https://github.com/nextauthjs/next-auth

# Prisma
# https://www.prisma.io/

# 記事: NextAuth.js
# https://cloudcoders.xyz/blog/nextauth-credentials-provider-with-external-api-and-login-page/
# https://yuyao.me/posts/next-prisma-auth-tutorial
# https://tech.stmn.co.jp/entry/2021/06/30/181017
# https://reffect.co.jp/react/next-auth
# https://zenn.dev/furai_mountain/articles/b54c83f3dd4558
# https://qiita.com/kage1020/items/bdefabcd09d86e78d474

# 記事: Prisma
# https://zenn.dev/smish0000/articles/f1a6f463417b65
# https://zenn.dev/oubakiou/books/181b750dfb6838/viewer/838514
# https://reffect.co.jp/node-js/prisma-basic
# https://numb86-tech.hatenablog.com/entry/2022/03/26/180052
# https://omkz.net/next-js-prisma/
# https://qiita.com/dkawabata/items/cafa3dc53921db520360
# https://qiita.com/gwappa/items/34cdab09a69d38c3fb07

yarn-add-D-next-auth:
	docker compose exec web yarn add -D next-auth

yarn-add-prisma-client:
	docker compose exec web yarn add prisma @prisma/client @next-auth/prisma-adapter

# ---- Emotion ----

# 記事:
# https://zenn.dev/iwakin999/articles/7a5e11e62ba668
# https://tamalog.szmd.jp/next-emotion/
# https://zenn.dev/rabbit/articles/e7376c9fce90db
# https://nishinatoshiharu.com/install-emotion-next-ts/

# React v17以上
# yarn add @emotion/react @emotion/styled @emotion/babel-plugin

# React v17以下
# yarn add @emotion/core @emotion/styled @emotion/babel-preset-css-prop

# JSXのコンパイルを調整する方法:
# ! Emotionはタグやコンポーネントにcss propを使うため、JSX→JavaScriptのコンパイル設定を調整する必要がある。
# ① JSXプラグマと言われるディレクティブを書く方法:

# /** @jsxImportSource @emotion/react */
# import { css } from "@emotion/react"

# ② BabelのConfigを設定する方法（おすすめ）

# ⑴ babelの設定
# babel.config.js
# module.exports = {
#   presets: [
#     [
#       'next/babel',
#       {
#         'preset-react': {
#           runtime: 'automatic',
#           importSource: '@emotion/react',
#         },
#       },
#     ],
#   ],
#   plugins: ['@emotion/babel-plugin'],
# };


# ⑵ TypeScript用にEmotionの型定義ファイルを読み込む
# tsconfig.extends.json
# {
#   "compilerOptions": {
#     "types": ["@emotion/react/types/css-prop"],
#     or
#     "jsxImportSource": "@emotion/react"
#   }
# }

# ! css propに対応させるため、Linkコンポーネントが正しく動作しなくなる
# https://nextjs.org/docs/api-reference/next/link#if-the-child-is-a-custom-component-that-wraps-an-a-tag

# 対処法①:  Linkコンポーネントに毎回passHrefを追加

# <Link href="/hoge" passHref>
#   <a css={foo}>リンクボタン</a>
# </Link>

# 対処法②: Linkコンポーネントをラップしたコンポーネントを用意

# import Link from "next/link"

# type Props = {
#   children: React.ReactNode
#   href: string | URL
#   as?: string
# }

# export default function MyLink(props: Props) {
#   return (
#     <Link href={props.href} as={props.as} passHref>
#       {props.children}
#     </Link>
#   )
# }

# ---- マークダウン用のライブラリ ----

# https://nextjs.org/learn/basics/data-fetching/blog-data

# gray-matter
# https://github.com/jonschlinkert/gray-matter
# npm install --save gray-matter
yarn-add-D-gray-matter:
	docker compose exec web yarn add -D gray-matter

# remark
# https://github.com/remarkjs/remark
# npm install --save remark remark-html
yarn-add-D-remark:
	docker compose exec web yarn add -D remark remark-html

# date-fns
# https://date-fns.org/
# npm install --save date-fns
yarn-add-D-date-fns:
	docker compose exec web yarn add -D date-fns

# **** Testing 環境構築 ****

# Testing
# https://nextjs.org/docs/testing

# テストの書き方
# https://qiita.com/suzu1997/items/e4ee2fc1f52fbf505481
# https://zenn.dev/t_keshi/articles/react-test-practice
# https://blog.engineer.adways.net/entry/2020/06/12/150000

# エラー対策集
# https://www.asobou.co.jp/blog/web/rtl

# ----------------

# Next11の場合:

# 参考記事:
# https://github.com/GomaGoma676/nextjs-testing
# https://github.com/GomaGoma676/nextjs-testing-blog
# https://dev.to/maciekgrzybek/setup-next-js-with-typescript-jest-and-react-testing-library-28g5
# https://zenn.dev/tiwu_dev/scraps/c677089abcca4b

# ⑴ ライブラリのインストール

# axios + swr
# yarn add axios@0.21.1 swr

# React17, Next11に変更
# yarn add react@17.0.2 react-dom@17.0.2 next@11.1.2
# yarn add -D @types/react@17.0.41

# jest + react testing library
# yarn add -D jest@26.6.3 @testing-library/react@11.2.3 @types/jest@26.0.20 @testing-library/jest-dom@5.11.8 @testing-library/dom@7.29.2 babel-jest@26.6.3 @testing-library/user-event@12.6.0 jest-css-modules@2.1.0 msw@0.35.0 next-page-tester@0.30.0

# ⑵ babel.config.jsの設定

# ※ これはbabel-jestに対してNext.jsのプロジェクトに対してテストを実行するということを伝える役目。

# babel.config.js
# module.exports = {
#   presets: ["next/babel"]
# };

# ⑶ jest.config.jsの設定

# module.exports = {
#   testPathIgnorePatterns: ['<rootDir>/.next/', '<rootDir>/node_modules/'],
#   moduleNameMapper: {
#     '\\.(css)$': '<rootDir>/node_modules/jest-css-modules',
#     '^@/(.*)$': '<rootDir>/src/$1',
#   },
# };

# ※ .nextとnode_modulesはテストを実行するプロジェクトのコードの内容とは関係ないフォルダなので、テストの対象外にしている。
# ※※ プロジェクトの中にCSSのファイルが存在した場合は、jest-css-modulesを使って、そのファイルをmockingする設定。

# ⑷ package.jsonにtest scriptを追記

# "scripts": {
#     "test": "jest --env=jsdom --verbose"
# },

# ※ テスト内容は確認しておきたいからその設定
# → デフォルトの状態だと、テストファイルに対してそのファイルがpassしたかfailしたかの出力しかしない。実際にはそのテストファイルに含まれている複数のテスト形式ひとつひとつ対してpassしたかfailしたか出力させたいので、このオプションを追加している。

# ----------------

# Next12の場合:

# 変更点:
# https://zenn.dev/miruoon_892/articles/e42e64fbb55137
# 従来の方法では babel を使ってきましたが、next/jest プラグインでは使用しないため、インストール不要です。
# また TS で Jest を使用する際は、ts-jest や @types/jest のインストールが必要になりますが、next/jest プラグインを介す場合はこれらのインストールは不要です。

# Next.js with Jest and React Testing Library
# https://github.com/vercel/next.js/tree/canary/examples/with-jest
# https://nextjs.org/docs/testing#jest-and-react-testing-library

# 参考記事:
# https://github.com/GomaGoma676/nextjs-testing-latest
# https://github.com/GomaGoma676/nextjs-testing-blog-latest
# https://qiita.com/kewpie134134/items/4ed8373dd55f3758df60
# https://nishinatoshiharu.com/install-jest-in-next/
# https://zenn.dev/a_da_chi/articles/f5341235cbc9b5
# https://qiita.com/P-man_Brown/items/16f33133a52443850f11

# ⑴ ライブラリのインストール

# axios + swr
# yarn add axios swr

# jest + react testing library
# yarn add -D jest@27.5.1 jest-environment-jsdom @testing-library/react @testing-library/jest-dom jest-css-modules msw@0.39.2 next-page-tester@0.32.0 @types/node-fetch

# ⑵ jest.config.jsの設定

# jest.config.js
# const nextJest = require('next/jest')

# const createJestConfig = nextJest({
# // next.config.jsとテスト環境用の.envファイルが配置されたディレクトリをセット。基本は"./"で良い。
#   dir: './',
# })

# // Jestのカスタム設定を設置する場所。従来のプロパティはここで定義。
# const customJestConfig = {
#   // jest.setup.jsを作成する場合のみ定義。
#   // setupFilesAfterEnv: ["<rootDir>/jest.setup.js"],
#   // if using TypeScript with a baseUrl set to the root directory then you need the below for alias' to work
#   moduleDirectories: ['node_modules', '<rootDir>/'],
#   testEnvironment: 'jest-environment-jsdom',
#   moduleNameMapper: {
#     // aliasを定義 （tsconfig.jsonのcompilerOptions>pathsの定義に合わせる）
#     "^@/(.*)$": "<rootDir>/src/$1",
#   },
# }

# // createJestConfigを定義することによって、本ファイルで定義された設定がNext.jsの設定に反映されます
# module.exports = createJestConfig(customJestConfig)

# ⑶ package.jsonに test scriptを追記

# "scripts": {
#     "test": "jest --watch"
# },

# ----------------

# 動作確認:

# pagesのテスト: src/pages/__tests__/
# componentsのテスト: src/components/__tests__/
# libのテスト: src/lib/__tests__/

# src/pages/index.tsx
# const Home: React.FC = () => {
#   return (
#     <div className="flex justify-center items-center flex-col min-h-screen font-mono">
#       Hello Nextjs
#     </div>
#   )
# }
# export default Home

# src/pages/__tests__/Home.test.tsx
# import { render, screen } from '@testing-library/react'
# import '@testing-library/jest-dom/extend-expect'
# import Home from '@/pages/index'

# it('Should render hello text', () => {
#   render(<Home />)
#   // screen.debug()
#   expect(screen.getByText('Hello Nextjs')).toBeInTheDocument()
# })

# yarn test

# ----------------

# ? 推奨:
# Next11 + fetch API + msw + jest
# → axiosだと以下のエラーが出てしまう。
# TypeError: Cannot read property 'userAgent' of undefined
# https://github.com/next-page-tester/next-page-tester/issues/243
# → Next12でもテストで解決できないエラーが出てしまう

# ----------------

# ? fetcherの定義(fetchの型付け):

# 参考記事
# https://qiita.com/markey/items/62f08105ae98139e731f
# https://github.com/masaki-koide/my-portfolio/blob/master/src/app/api/fetcher.ts
# https://serip39.hatenablog.com/entry/2020/09/10/070000

# isomorphic-unfetch
# https://www.npmjs.com/package/isomorphic-unfetch

# yarn add isomorphic-unfetch

# src/lib/fetcher.ts
# import fetch from 'isomorphic-unfetch';

# const defaultTimeoutMs = 10 * 1000;

# // catchした際にタイムアウトによるエラーかそれ以外のエラーか判別するため
# export class TimeoutError extends Error {}

# const timeout = <T>(task: Promise<T>, ms?: number) => {
#   const timeoutMs = ms || defaultTimeoutMs;
#   // eslint-disable-next-line @typescript-eslint/no-unused-vars
#   const timeoutTask = new Promise((resolve, _) => {
#     setTimeout(resolve, timeoutMs);
#   }).then(() => Promise.reject(new TimeoutError(`Operation timed out after ${timeoutMs} ms`)));

#   return Promise.race([task, timeoutTask]);
# };

# const wrap = <T>(task: Promise<Response>): Promise<T> => {
#   return new Promise((resolve, reject) => {
#     task
#       .then((response) => {
#         if (response.ok) {
#           response
#             .json()
#             .then((json: Promise<T>) => {
#               resolve(json);
#             })
#             .catch((error) => {
#               reject(error);
#             });
#         } else {
#           reject(response);
#         }
#       })
#       .catch((error) => {
#         reject(error);
#       });
#   });
# };

# // eslint-disable-next-line @typescript-eslint/no-explicit-any
# const fetcher = <T = any>(input: RequestInfo | URL, init?: RequestInit | undefined): Promise<T> => {
#   return wrap<T>(timeout(fetch(input, init)));
# };

# export default fetcher;

# ----------------

# ? モックサーバーの定義

# https://mswjs.io/docs/
# https://github.com/mswjs/msw
# https://www.wakuwakubank.com/posts/765-react-mock-api/

# 参考記事:
# https://www.wakuwakubank.com/posts/765-react-mock-api/
# https://zenn.dev/midorimici/articles/msw-storybook

# 書き方:
# https://github.com/soarflat-sandbox/msw

# yarn add -D msw

# src/mocks/handlers.ts
# https://mswjs.io/docs/getting-started/mocks/rest-api

# import { rest } from 'msw';

# export const handlers = [
# ...
# ];

# ++++++++++++

# src/mocks/server.ts
# https://mswjs.io/docs/getting-started/integrate/node

# import { setupServer } from 'msw/node';
# import { handlers } from './handlers';

# export const server = setupServer(...handlers);

# ++++++++++++

# jest.setup.js
# https://mswjs.io/docs/getting-started/integrate/node

# import { server } from './src/mocks/server';
# import { cleanup } from '@testing-library/react';

# beforeAll(() => {
#   server.listen();
# });

# afterEach(() => {
#   server.resetHandlers();
#   cleanup();
# });

# afterAll(() => {
#   server.close();
# });

# ----------------

# ^ ReferenceError: window is not defined 対処法

# 解決策:
# https://stackoverflow.com/questions/46274889/jest-test-fails-with-window-is-not-defined

# jest.config.js
# "globals": {
#     "window": {},
#     "document": {}
# }

# ^ ReferenceError: document is not defined 対処法

# https://jestjs.io/docs/configuration#testenvironment-string
# https://www.udemy.com/course/nextjs-react-testing-library-react/learn/lecture/26995546#overview
# https://qiita.com/Seo-4d696b75/items/5ac4333cadd3c50af8e3

# /**
# * @jest-environment jsdom
# */

# → これらの2つエラーはコードを修正してからyarn testするとよく発生するが、エラーが出ても再度yarn testすると、passが通るようになるので、必須ではない。

# ----------------

# ^ ReferenceError: setImmediate is not defined 対処法

# https://www.udemy.com/course/nextjs-react-testing-library-react/learn/lecture/26813286#overview

# 1. setimmdiate パッケージのnpmインストール
# npm i setimmediate

# 2. 各テストファイルのimport部に下記importを追加
# import "setimmediate"

# ----------------

# ^ ReferenceError: fetch is not defined 対処法 (上手くいかなった)

# 解決策:
# https://blog.unresolved.xyz/jest-fetch-is-not-defined
# https://uga-box.hatenablog.com/entry/2022/01/27/000000
# https://qiita.com/shibukawa/items/4d431ee4f98c80b682ec

# whatwg-fetch
# https://www.npmjs.com/package/whatwg-fetch
# https://github.com/whatwg/fetch
# https://github.com/github/fetch
# https://miyamizu.hatenadiary.jp/entry/js/whatwg-fetch
# yarn add -D whatwg-fetch

# jest.setup.js
# const fetchPolifill = require('whatwg-fetch')

# global.fetch = fetchPolifill.fetch
# global.Request = fetchPolifill.Request
# global.Headers = fetchPolifill.Headers
# global.Response = fetchPolifill.Response

# ----------------

# ^ [MSW] Found a redundant usage of query parameters in the request handler 対処法

# https://www.udemy.com/course/nextjs-react-testing-library-react/learn/lecture/25729338#questions

# ----------------

# ! TypeError: Cannot read property 'userAgent' of undefined 未解決
# → このせいで、テストでaxios, whatwg-fetchが使えない

# ----------------

# ~ Visual Studio CodeでJestの入力補完（インテリセンス）が効かない時の対応方法
# https://trialanderror.jp/jest-intellisense-not-working/
# https://zenn.dev/fagai/articles/719e449cf31c0b

# tsconfig.json
# "typeAcquisition": {
#   "include": [
#     "jest"
#   ]
# },

# ----------------

# ~ monorepo環境でvscode-jestを機能させる方法

# 方法①
# frontend/でVSCodeを開く

# 方法② (未解決)
# workspaceを設定する

# ベストプラクティス
# https://qiita.com/suzukalight/items/0b22f11ad05308f638a6
# https://github.com/mattphillips/jest-workspace-projects
# https://suzukalight.com/blog/posts/2019-09-03-monorepo-jest-storyshots
# https://github.com/martpie/monorepo-typescript-next-the-sane-way
# https://qiita.com/suzukalight/items/682757fb9e6ee173c432#srcclientjestconfigjs

# 参考記事:
# https://qiita.com/taijusanagi/items/6358933465f5e7ab6b7c
# https://qiita.com/uenok0108/items/0c2865e5540046a120fa
# https://tonisives.com/blog/2022/05/04/vscode-jest-doesnt-work-for-a-react-app-in-a-yarn-workspace-monorepo/
# https://numb86-tech.hatenablog.com/entry/2020/07/21/155343
# https://nju33.com/notes/jest/articles/vscode-jest
# https://zenn.dev/nus3/scraps/edfd4e0227006e

# workspace(Lerna or Yarn Workspaces)
# https://classic.yarnpkg.com/lang/en/docs/workspaces/
# https://blog.cybozu.io/entry/2020/04/21/080000

# ts-jest
# https://github.com/kulshekhar/ts-jest
# https://www.npmjs.com/package/ts-jest
# https://typescript-jp.gitbook.io/deep-dive/intro-1/jest
# https://jestjs.io/ja/docs/getting-started
# https://zenn.dev/kohski/articles/typescript_jest
# https://blog.ojisan.io/ts-jest/
# https://zenn.dev/mkpoli/articles/1d11ee2edd5bee

# Next11の場合:

# ⑴ rootにpackage.jsonとjest.config.jsを作成

# package.json
# {
#   "name": "root",
#   "version": "1.0.0",
#   "main": "index.js",
#   "license": "MIT",
#   "private": true,
#   "workspaces": [
#     "frontend"
#   ],
#   "nohoist": [
#     "**/jest"
#   ]
# }

# jest.config.js
# module.exports = {
#   projects: ["<rootDir>/frontend/*"],
# };

# ⑵ Next.jsのプロジェクトをworkspace(frontend)に生成
# yarn create next-app --typescript frontend

# ⑶ モジュールのインストール

# 共用モジュールとしてインストール: Lint系, Testing系
# →yarn add -W <モジュール名>

# yarn add -DW eslint @typescript-eslint/eslint-plugin @typescript-eslint/parser eslint-config-prettier prettier npm-run-all husky lint-staged eslint-plugin-import

# yarn add -DW stylelint stylelint-config-prettier stylelint-config-recess-order stylelint-config-standard stylelint-config-standard-scss stylelint-scss

# yarn add -DW jest@26.6.3 @types/jest@26.0.20 ts-jest

# 個別モジュール: Style系, Library系
# → yarn workspace [workspace名] add <モジュール名>

# yarn workspace frontend add -D tailwindcss postcss autoprefixer prettier-plugin-tailwindcss

# yarn workspace frontend add axios@0.21.1 swr
# yarn workspace frontend add react@17.0.2 react-dom@17.0.2 next@11.1.2
# yarn workspace frontend add -D @types/react@17.0.41

# yarn workspace frontend add -D @testing-library/react@11.2.3 @testing-library/jest-dom@5.11.8 @testing-library/dom@7.29.2 babel-jest@26.6.3 @testing-library/user-event@12.6.0 jest-css-modules@2.1.0 msw@0.35.0 next-page-tester@0.30.0

# ⑷ rootで個別のworkspaceのnpm-scriptが実行できるように、rootのpackage.jsonを編集

# ※ 個別のworkspaceに記述したnpm-scriptは、下記のコマンドで起動できる。
# yarn workspace [workspace名] [script名] コマンド

# 例)
  # "scripts": {
  #   "f:dev": "yarn workspace frontend dev"
  # }

# ----------------

# ? TDD

# https://zenn.dev/higa/articles/34439dc279c55dd2ab95

# **** Storybook ****

# Storybook Addon Next
# https://storybook.js.org/addons/storybook-addon-next

# 参考記事
# https://qiita.com/suzu1997/items/2afcfc2d13f4bdd12841
# https://reffect.co.jp/react/next-js-12-storybook
# https://zenn.dev/minguu42/articles/20211226-nextjs-storybook
# https://kiyobl.com/storybook-install/

# ~ Storybookの導入

# ⑴ Storybookのインストール
# Next11:
# npx sb init
# ※ 指定しない場合はwebpack4がインストールされる

# Next12:
# npx sb init --builder webpack5

# ------------

# ⑵ Storybook用リンター設定:
# "Do you want to run the 'eslintPlugin' fix on your project?"
# y → ”eslint-plugin-storybook”がインストールされる
# eslintrc.jsのextendsに追記

# 手動の場合
# yarn add -D eslint-plugin-storybook

# ------------

# ⑶ Storybookのmain.js設定

# stories ...storiesファイル(コンポーネント登録用ファイル)までのファイルパスを指定。
# addons ...導入したいアドオン(拡張機能)を指定

# module.exports = {
#   stories: ["../src/**/*.stories.@(js|jsx|ts|tsx)"], // storiesファイルまでのファイルパス
#   addons: [
#     "@storybook/addon-links",  // デフォルトで設定済み
#     "@storybook/addon-essentials", // デフォルトで設定済み
#     "@storybook/addon-postcss",   // ⇦ 追加
#   ],
#   framework: "@storybook/react",
# };

# ------------

# ⑷ Storybook 環境へのグローバル CSS の適用
# .storybook/preview.js
# import "../styles/globals.css";

# ------------

# ⑸ Storybook で next/image を扱うための設定の追加

# .storybook/main.js
# module.exports = {
#   staticDirs: ["../public"],
# };

# .storybook/preview.js
# import * as NextImage from "next/image";

# const OriginalNextImage = NextImage.default;

# Object.defineProperty(NextImage, 'default', {
#   configurable: true,
#   value: (props) => <OriginalNextImage {...props} unoptimized />,
# });

# ------------

# ⑹ モジュールパスエイリアスを対応づける

# .storybook/main.js
# const path = require("path");

# module.exports = {
#   ...
#   webpackFinal: async (config) => {
#     return {
#       ...config,
#       resolve: {
#         ...config.resolve,
#         alias: {
#           ...config.resolve.alias,
#           "@/components": path.resolve(__dirname, "../src/components"),
#           "@/lib": path.resolve(__dirname, "../src/lib"),
#           "@/models": path.resolve(__dirname, "../src/models"),
#           "@/pages": path.resolve(__dirname, "../src/pages"),
#           "@/styles": path.resolve(__dirname, "../src/styles"),
#         },
#       },
#     };
#   },
# };

# ------------

# ⑺ UIを反映させる

# Chakra UI をストーリーに反映させる
# .storybook/preview.js

# const chakraProvider = (StoryFn) => {
#   return (
#     <ChakraProvider>
#       <StoryFn />
#     </ChakraProvider>
#   )
# }

# export const decorators = [chakraProvider]

# ------------

# ⑻ 動作確認
# yarn storybook

# **** PWA ****

# 参考記事
# https://zenn.dev/tns_00/articles/next-pwa-install

# **** Vercelにデプロイ ****

# https://vercel.com/login

# ⑴ mainブランチに切り替えて、ビルドする
# ⑵ GitHubにプロジェクトをpush
# ⑶ VercelにGitHubでログイン
# ⑷ New Project をクリック
# ⑸ デプロイするリポジトリをpublicにする
# ⑹ Missing Git repository? Adjust GitHub App Permissions をクリック
# ⑺ デプロイするリポジトリをsave
# ⑻ import をクリック
# ⑼ Configure Project
# - FRAMEWORK PRESET: Next.js
# - ROOT DIRECTORY: frontend(デプロイするディレクトリを選択)
# - Environment Variables: 本番環境で使用する環境変数を登録
# ⑽ Deploy をクリック
# - 外部APIと連携している場合:
# + 新しく生成されたfrontend側のAppのURLをbackend側の設定で、CORSのホワイトリストに追加する
# → これにより、あるオリジンで動いているWebアプリケーションに対して、異なるオリジンのサーバーへのアクセスをオリジン間HTTPリクエストによって許可する

# CORSについて:
# https://www.youtube.com/watch?v=ryztmcFf01Y
# https://www.youtube.com/watch?v=yBcnonX8Eak
# https://developer.mozilla.org/ja/docs/Web/HTTP/CORS
# https://qiita.com/att55/items/2154a8aad8bf1409db2b
# https://javascript.keicode.com/newjs/what-is-cors.php
# https://coliss.com/articles/build-websites/operation/work/cs-visualized-cors.html
# https://www.tohoho-web.com/ex/cors.html
# https://zenn.dev/qnighy/articles/6ff23c47018380
# https://kojimanotech.com/2021/07/09/330/

# Automatic Deploy
# コード修正し、commit → pushすると自動で再度デプロイが走る

# CI/CD
# ⑴ Settings → General → BUILD COMMAND override オン
# ⑵ yarn test && yarn build
# ⑶ Save
# → この設定をしておくことで、コードの変更を加えてpushしたときに、まずyarn testを実行してくれて、そのテストがpassしたときだけビルドしてデプロイしてくれるようになる。

# ==== NestJS ====

# https://docs.nestjs.com/
# https://github.com/nestjs/nest
# https://zenn.dev/kisihara_c/books/nest-officialdoc-jp

# 記事
# https://zenn.dev/higuchimakoto/articles/21c8420c4a612a
# https://zenn.dev/waddy/books/graphql-nestjs-nextjs-bootcamp
# https://zenn.dev/naonao70/articles/a91d8835f1832b

# ==== Prisma ====

# Prisma
# https://www.prisma.io/

# 記事: Prisma
# https://zenn.dev/smish0000/articles/f1a6f463417b65
# https://zenn.dev/oubakiou/books/181b750dfb6838/viewer/838514
# https://reffect.co.jp/node-js/prisma-basic
# https://numb86-tech.hatenablog.com/entry/2022/03/26/180052
# https://omkz.net/next-js-prisma/
# https://qiita.com/dkawabata/items/cafa3dc53921db520360
# https://qiita.com/gwappa/items/34cdab09a69d38c3fb07
# https://zenn.dev/oubakiou/books/181b750dfb6838

yarn-add-D-prisma:
	docker compose exec web yarn add -D prisma

# ==== GraphQL ====

# https://graphql.org/
# https://github.com/graphql

# yarn add graphql

# **** GraphQL codegen ****

# https://www.graphql-code-generator.com/
# https://github.com/dotansimha/graphql-code-generator

# 記事
# https://github.com/GomaGoma676/nextjs-hasura-basic-lesson

# 1. install modules + init:
# yarn add -D @graphql-codegen/cli
# yarn graphql-codegen init

# - What type of application are you building?: Application built with React
# - Where is your schema?: GraphQLサーバーのURLパスを指定
# → Hasuraを使用する場合: プロジェクトのLaunch Console → API → POSTのURLを貼り付け
# Where are your operations and fragments?: 読みに行くクエリの階層を指定
# → src/queries/**/*.ts
# Pick plugins: デフォルト
# Where to write the output: 自動生成した型の出力先の指定
# → src/types/generated/graphql.tsx
# Do you want to generate an introspection file?: n
# How to name the config file?: codegen.yml
# What script in package.json should run the codegen?: gen-types

# yarn
# yarn add -D @graphql-codegen/typescript

# 2. add queries in queries/queries.ts file:
# mkdir src/queries && touch src/queries/queries.ts

# 3. generate types automatically:
# yarn gen-types
# ※ 同じ名前のクエリが存在すると、型を自動生成する時にエラーになる。その場合は一方をコメントアウトしてから、型を自動生成し、生成後にアンコメントする。

# **** Apollo Client ****

# https://www.apollographql.com/docs/react/
# https://github.com/apollographql/apollo-client

# yarn add @apollo/client @apollo/react-hooks cross-fetch

# **** Hasura ****

# https://hasura.io/

# & プロジェクトの作成:
# New Project
# - Free Tier
# - US West | Los
# Create Free Project
# ※ renameする場合はユニークな名前
# ⬇️
# Env vars
# HASURA_GRAPHQL_ADMIN_SECRETが自動で生成されている場合は削除する
# ⬇️
# Launch Console
# Data
# Create Heroku Database Free
# Heroku: 自動的に連携

# & テーブルの作成
# Data → public
# Create Table: これで新しくDBを作成できる
# (例)
# Table Name: users
# Columns:
# - id UUID gen_random_uuid()
# - name Text
# - created_at Timestamp now()
# Primary Key: id
# Add Table

# & データの挿入
# Data → public → テーブル指定
# Insert Row
# name: user 1
# Save
# name: user 2
# Insert Again
# ⬇️
# Browse Rows: 確認

# & データの編集
# Data → public → テーブル指定
# Browse Rows
# 各アイコン

# & リレーション
# Data → public → テーブル指定
# ※ Many to Manyの場合は中間テーブルを作成する
# Modify
# Add a new column: 外部キーとなるカラムを追加
# ※ One to Oneで紐付けたい場合は、uniqueにチェック
# Add a foreign key
# (例)
# - Reference Table: groups
# - From: group_id
# - To: id
# Save
# ⬇️
# Relationships
# Suggested Object Relationships:
# Add → Save
# ⬇️
# 対応するターブルを指定
# Relationships
# Suggested Array Relationships:
# ※ uniqueにチェックした場合、Suggested Object Relationshipsが提案される
# Add → Save

# & クエリ操作
# API: 作成したテーブルに対するqueryやmutationが自動生成されている
# Add New: Query | Mutation | Subscription
# → Create,Update,Deleteのコマンドを使いたい場合は、Mutationを選択し+ボタンをクリック

# ==== UI ====

# **** Material UI ****

# https://mui.com/getting-started/installation/
# https://next--material-ui.netlify.app/ja/guides/typescript/
# https://zenn.dev/h_yoshikawa0724/articles/2021-09-26-material-ui-v5
# https://zuma-lab.com/posts/next-mui-emotion-settings
# https://cloudpack.media/59677

# v4
yarn-add-D-ui-material-v4:
	dockert-compose exec web yarn add -D @material-ui/core @material-ui/icons @material-ui/styles @material-ui/system @types/material-ui

yarn-add-D-ui-mui-v4-webpack:
	docker compose exec web yarn add -D @material-ui/core @material-ui/icons @material-ui/system

# v5
yarn-add-D-ui-mui-emotion:
	docker compose exec web yarn add @mui/material @emotion/react @emotion/styled @mui/icons-material @mui/system @mui/styles @mui/lab

yarn-add-D-ui-mui-styled-components:
	docker compose exec web yarn add @mui/material @mui/styled-engine-sc styled-components @mui/icons-material @mui/system @mui/styles @mui/lab

# 推奨
yarn-add-D-ui-mui-v5-webpack:
	docker compose exec web yarn add -D @mui/material @mui/icons-material @mui/system @mui/styles @mui/lab


# **** Chakra UI ****

# https://chakra-ui.com/docs/getting-started

yarn-add-D-ui-chakra:
	docker compose exec web yarn add -D @chakra-ui/react @emotion/react@^11 @emotion/styled@^11 framer-motion@^6 @chakra-ui/icons focus-visible

# **** Mantine UI ****

# https://ui.mantine.dev/
# https://mantine.dev/pages/getting-started/
# https://github.com/mantinedev/ui.mantine.dev

# xs,sm,md,lg,xlのデフォルト値一覧
# https://github.com/mantinedev/mantine/blob/master/src/mantine-styles/src/theme/default-theme.ts

# Shared props (すべてのMantineコンポーネントで共通するprops一覧)
# https://mantine.dev/pages/basics/#shared-props

# Responsive styles (breakpoints)
# https://mantine.dev/theming/responsive/#configure-breakpoints

# ------------

# ! 2022年現在、Mantine UI と Tailwind CSS を同時に使用した場合に、コンポーネントが上手く表示されないという問題に対処するために、tailwind.config.js に下記を追記
# corePlugins: {
#     preflight: false,
# },
# → これをfalseにすると、aタグのtext-decorationがunderline、border-{side}系のスタイルが効かない

# ------------

# ? Next.jsでの設定の仕方:

# Usage with Next.js
# https://mantine.dev/guides/next/

# ⑴ Add to existing Next.js project
# ※ 必要なpackageを選択すれば、依存するpackageも含めたコマンドを生成してくれる。

yarn-add-ui-mantine:
	docker compose exec web yarn add @mantine/core @mantine/hooks @mantine/dates dayjs @mantine/notifications @mantine/form @mantine/next @emotion/server @emotion/react

yarn-add-ui-mantine-v4:
	docker compose exec web yarn add @mantine/core@4.2.5 @mantine/hooks@4.2.5 @mantine/dates@4.2.5 dayjs @mantine/notifications@4.2.5 @mantine/form@4.2.5 @mantine/next@4.2.5

# ※ @mantine/dates は dayjs に依存する

# ------------

# ⑵ Create pages/_document.tsx file:
# - コピーして貼り付け
# - Next.jsでのサーバーサイドレンダリングに対応するために必要な設定

# import { createGetInitialProps } from '@mantine/next';
# import Document, { Head, Html, Main, NextScript } from 'next/document';

# const getInitialProps = createGetInitialProps();

# export default class _Document extends Document {
#   static getInitialProps = getInitialProps;

#   render() {
#     return (
#       <Html>
#         <Head />
#         <body>
#           <Main />
#           <NextScript />
#         </body>
#       </Html>
#     );
#   }
# }

# ------------

# ⑶ (Optional) Replace your pages/_app.tsx with

# - Mantineのプロバイダーをimport

# import { MantineProvider } from '@mantine/core';

# ------------

# ~ React Queryを使用する場合:

# pages/_app.tsx with

# import { QueryClient, QueryClientProvider } from 'react-query'
# import { ReactQueryDevtools } from 'react-query/devtools'

# - プロジェクト全体に適応されるグローバルな設定
# const queryClient = new QueryClient({
#   defaultOptions: {
#     queries: {
#       retry: false,
#       refetchOnWindowFocus: false,
#     },
#   },
# })

# ! 4系はreact-query@4.0.0-beta.10ではないと宣言ファイルエラーが発生し読み込めない

# ※ retry: false → React QueryはデフォルトでAPIのfetchに失敗した場合、3回までそのfetchを繰り返すという仕様になっている。この機能を無効化。
# ※ refetchOnWindowFocus: false → ユーザーがブラウザにフォーカスをあてた時に、再度APIんへのfetchが走るというもの。この機能を無効化。

# ------------

# ⑷ コンポーネントをプロバイダーでラップする。

# pages/_app.tsx with

# function MyApp({ Component, pageProps }: AppProps) {
#   return (
#     <QueryClientProvider client={queryClient}>
#       <MantineProvider
#         withGlobalStyles
#         withNormalizeCSS
#         theme={{
#           colorScheme: 'dark',
#           fontFamily: 'Verdana, sans-self',
#         }}
#       >
#         <Component {...pageProps} />
#       </MantineProvider>
#       <ReactQueryDevtools initialIsOpen={false} />
#     </QueryClientProvider>
#   )
# }

# ^ themeの箇所でプロジェクト全体に適応させたいスタイリングを設定できる。

# ------------

# & Notification System の設定

# https://mantine.dev/others/notifications/

# yarn add @mantine/notifications

# pages/_app.tsx
# import { NotificationsProvider } from '@mantine/notifications'

  # //* JSX
  # return (
  #  <NotificationsProvider limit={2}>
  #    <Component {...pageProps} />
  #  </NotificationsProvider>
  # )

# ※ Notificationは、ブラウザの右下に表示される。
# ※ 表示される最大の数をlimitで制限できる。

# ------------

# & Mantine Hooks

# yarn add @mantine/hooks

# use-disclosure
# https://mantine.dev/hooks/use-disclosure/

# use-toggle
# https://mantine.dev/hooks/use-toggle/

# use-interval
# https://mantine.dev/hooks/use-interval/

# use-hover
# https://mantine.dev/hooks/use-hover/

# use-idle
# https://mantine.dev/hooks/use-idle/

# use-move
# https://mantine.dev/hooks/use-move/

# **** Headless UI ****

# https://headlessui.dev/
# https://github.com/tailwindlabs/headlessui/tree/main/packages/%40headlessui-react

yarn-add-ui-headless:
	docker compose exec web yarn add @headlessui/react @heroicons/react

# **** Tailwind UI ****

# Documentation
# https://tailwindui.com/documentation#getting-set-up

# Tailwind UI for React depends on Headless UI and Heroicons.
# npm install @headlessui/react @heroicons/react

# Components
# https://tailwindui.com/components
# → Application UI → Forms

# ※ ソースコードを貼り付ける際の注意点:
#・依存するライブラリをインストール
#・検証ツールのConsole画面でエラーを特定し解消
# - class → className
# - <img > → <img />
# - fill-rule → fillRule
# - autocomplete → autoComplete

# Templates
# https://tailwindui.com/templates

# ---- Tailwind UI用の拡張ライブラリ ----

# @tailwindcss/forms
# https://github.com/tailwindlabs/tailwindcss-forms
# https://www.npmjs.com/package/@tailwindcss/forms

# **** react bootstrap ****

# https://react-bootstrap.github.io/
# https://github.com/react-bootstrap/react-bootstrap

yarn-add-D-react-bootstrap:
	docker compose exec web yarn add -D react-bootstrap bootstrap


# **** React Hook Form & Yup | Zod ****

# https://react-hook-form.com/
# https://qiita.com/NozomuTsuruta/items/60d15d97eeef71993f06
# https://qiita.com/NozomuTsuruta/items/0140acaee87b7c4ed856
# https://zenn.dev/you_5805/articles/ad49926e7ad2d9
# https://www.npmjs.com/package/@hookform/error-message
# https://www.npmjs.com/package/yup
# https://www.npmjs.com/package/zod
# https://codezine.jp/article/detail/13518
# https://zenn.dev/nbstsh/scraps/beb64e72170d3c

yarn-add-react-hook-form-yup:
	docker compose exec web yarn add yup react-hook-form @hookform/resolvers @hookform/error-message

yarn-add-react-hook-form-zod:
	docker compose exec web yarn add zod react-hook-form @hookform/resolvers @hookform/error-message

# 例)
# /** schema */
# const schema = yup.object().shape({
#   email: yup.string()
#     .lowercase()
#     .email('メールアドレスの形式が正しくありません')
#     .required('メールアドレスを入力してください'),
#   password: yup.string()
#     .matches(/(?=.*?[a-z])/, '小文字を含めてください')
#     .matches(/(?=.*?[A-Z])/, '大文字を含めてください')
#     .matches(/(?=.*?[0-9])/, '数字を含めてください')
#     .matches(/(?!.*?(.)\1{4,})/, '5文字以上の連続した文字を含まないでください')
#     .matches(/^[0-9a-zA-Z]{8,}$/, '8文字以上の大小英数字で入力してください')
#     .required('パスワードを入力してください'),
# })

# **** Formik ****

yarn-add-D-formik-yup:
	docker compose web yarn add -D yup @types/yup formik

# ==== TypeScript =====

# https://github.com/microsoft/TypeScript/tree/main/lib
# https://qiita.com/ryokkkke/items/390647a7c26933940470
# https://zenn.dev/chida/articles/bdbcd59c90e2e1
# https://www.typescriptlang.org/ja/tsconfig
# https://typescriptbook.jp/reference/tsconfig/tsconfig.json-settings
yarn-add-D-loader-ts:
	docker compose exec web yarn add -D typescript@3.9.9 ts-loader

yarn-add-D-babel-ts:
	docker compose exec web yarn add -D typescript@3.9.9 babel-loader @babel/preset-typescript

yarn-add-D-loader-ts-full:
	docker compose exec web yarn add -D typescript@3.9.9 ts-loader @babel/preset-typescript @types/react @types/react-dom

# https://qiita.com/yamadashy/items/225f287a25cd3f6ec151
yarn-add-D-ts-option:
	docker compose exec web yarn add -D @types/webpack @types/webpack-dev-server ts-node @types/node typesync

# fork-ts-checker-webpack-plugin
# https://www.npmjs.com/package/fork-ts-checker-webpack-plugin
# https://github.com/TypeStrong/fork-ts-checker-webpack-plugin
yarn-add-D-plugin-forktschecker:
	docker compose exec web yarn add -D fork-ts-checker-webpack-plugin

# **** ESLint & Stylelint & Prettier(TypeScript用) ****

# eslint-config-prettier:
# ESLintとPrettierを併用する際に

# @typescript-eslint/eslint-plugin:
# ESLintでTypeScriptのチェックを行うプラグイン

# @typescript-eslint/parser:
# ESLintでTypeScriptを解析できるようにする

# husky:
# https://typicode.github.io/husky/#/
# https://typicode.github.io/husky/#/?id=automatic-recommended
# Gitコマンドをフックに別のコマンドを呼び出せる
# 6系から設定方法が変更

# lint-staged:
# https://github.com/okonet/lint-staged
# commitしたファイル(stagingにあるファイル)にlintを実行することができる

# ※ eslint-config-prettierの8系からeslintrcのextendsの設定は変更
# https://github.com/prettier/eslint-config-prettier/blob/main/CHANGELOG.md#version-800-2021-02-21

yarn-add-D-ts-eslint-prettier:
	docker compose exec web yarn add -D eslint@7.32.0 eslint-config-prettier@7.2.0 prettier@2.5.1 @typescript-eslint/parser@4.33.0 @typescript-eslint/eslint-plugin@4.33.0 husky@4.3.8 lint-staged@10.5.3

# https://github.com/yannickcr/eslint-plugin-react
# https://qiita.com/Captain_Blue/items/5d6969643148174e70b3
# https://zenn.dev/yhay81/articles/def73cf8a02864
# https://qiita.com/ro-komatsuna/items/bbfe5304c78ce4a10f1a
# https://zenn.dev/ro_komatsuna/articles/eslint_setup
yarn-add-D-eslint-react:
	docker compose exec web yarn add -D eslint-plugin-react eslint-plugin-react-hooks eslint-config-airbnb eslint-plugin-import eslint-plugin-jsx-a11y

yarn-add-D-eslint-option:
	docker compose exec web yarn add -D eslint-plugin-babel flowtype-plugin relay-plugin eslint-plugin-ava eslint-plugin-eslint-comments eslint-plugin-simple-import-sort eslint-plugin-sonarjs eslint-plugin-unicorn

# .eslintrc.js
# module.exports = {
#     env: {
#         browser: true,
#         es6: true
#     },
#     extends: [
#         "eslint:recommended",
#         "plugin:@typescript-eslint/recommended",
#         "prettier",
#         "prettier/@typescript-eslint"
#     ],
#     plugins: ["@typescript-eslint"],
#     parser: "@typescript-eslint/parser",
#     parserOptions: {
#         "sourceType": "module",
#         "project": "./tsconfig.json"
#     },
#     root: true,
#     rules: {}
# }
touch-eslintrcjs:
	docker compose exec web touch .eslintrc.js

# stylelint-recommended版
# https://qiita.com/y-w/items/bd7f11013fe34b69f0df
yarn-add-D-stylelint-recommended:
	docker compose exec web yarn add -D stylelint stylelint-config-recommended stylelint-scss stylelint-config-recommended-scss stylelint-config-prettier stylelint-config-recess-order postcss-scss

# stylelint-standard版
# https://rinoguchi.net/2021/12/prettier-eslint-stylelint.html
# https://lab.astamuse.co.jp/entry/stylelint
# stylelintのorderモジュール選定
# https://qiita.com/nabepon/items/4168eae542861cfd69f7
# postcss-scss
# https://qiita.com/ariariasria/items/8d33943e34d94bbaa9bf
yarn-add-D-stylelint-standard:
	docker compose exec web yarn add -D stylelint stylelint-config-standard stylelint-scss stylelint-config-standard-scss stylelint-config-prettier stylelint-config-recess-order postcss-scss


# .stylelintrc.js
# module.exports = {
#   extends: ['stylelint-config-recommended'],
#   rules: {
#     'at-rule-no-unknown': [
#       true,
#       {
#         ignoreAtRules: ['extends', 'tailwind'],
#       },
#     ],
#     'block-no-empty': null,
#     'unit-whitelist': ['em', 'rem', 's'],
#   },
# }
touch-stylelintrcjs:
		docker compose exec web touch .stylelintrc.js
# https://scottspence.com/posts/stylelint-configuration-for-tailwindcss
# {
#   "extends": [
#     "stylelint-config-standard"
#   ],
#   "rules": {
#     "at-rule-no-unknown": [
#       true,
#       {
#         "ignoreAtRules": [
#           "apply",
#           "layer",
#           "responsive",
#           "screen",
#           "tailwind"
#         ]
#       }
#     ]
#   }
# }
touch-stylelintrc:
	docker compose exec web touch .stylelintrc

# .prettierrc
# {
#     "printWidth": 120,
#     "singleQuote": true,
#     "semi": false
# }
touch-prettierrc:
	docker compose exec web touch .prettierrc


# ==== テスト関連 ====

# Testing
# https://nextjs.org/docs/testing

# **** Jest & React Testing Library ****

# Next.js with Jest and React Testing Library
# https://github.com/vercel/next.js/tree/canary/examples/with-jest

# ---- jest ----

# https://jestjs.io/ja/
# https://jestjs.io/

# https://zenn.dev/otanu/articles/f0a0b2bd0d9c44
# https://qiita.com/hironomiu/items/eac89ca4801534862fed
# https://qiita.com/cheez921/items/a5168e4e5057c8faa897

# package.json
# "scripts": {
#     "test": "jest",
# },

yarn-add-D-jest:
	docker compose exec web yarn add -D jest ts-jest @types/jest ts-node

# https://qiita.com/suzu1997/items/e4ee2fc1f52fbf505481
# https://zenn.dev/t_keshi/articles/react-test-practice

yarn-add-D-jest-full:
	docker compose exec web yarn add -D jest jsdom eslint-plugin-jest @types/jest @types/jsdom ts-jest

# https://jestjs.io/ja/docs/tutorial-react

yarn-add-D-jest-babel-react:
	docker compose exec web yarn add -D jest babel-jest react-test-renderer

# jest.config.js生成
# roots: [
#   "<rootDir>/src"
# ],

# transform: {
#   "^.+\\.(ts|tsx)$": "ts-jest"
# },

# ? Would you like to use Jest when running "test" script in "package.json"?	n
# ? Would you like to use Typescript for the configuration file?	y
# ? Choose the test environment that will be used for testing	jsdom
# ? Do you want Jest to add coverage reports?	n
# Which provider should be used to instrument code for coverage?	babel
# https://jestjs.io/docs/cli#--coverageproviderprovider
# ? Automatically clear mock calls, instances and results before every test?	n

jest-init:
	docker compose exec web yarn jest --init

ts-jest-init:
	docker compose exec web yarn ts-jest config:init

# ---- React Testing Library ----

# https://testing-library.com/docs/react-testing-library/intro/
# https://qiita.com/ossan-engineer/items/4757d7457fafd44d2d2f

yarn-add-D-rtl:
	docker compose exec web yarn add -D @testing-library/react @testing-library/jest-dom

# https://testing-library.com/docs/ecosystem-user-event/
# https://www.npmjs.com/package/@testing-library/user-event
# https://github.com/testing-library/user-event

yarn-add-D-rtl-user-event:
	docker compose web yarn add -D @testing-library/user-event

# https://github.com/testing-library/react-hooks-testing-library
# https://www.npmjs.com/package/@testing-library/react-hooks
# https://qiita.com/cheez921/items/cd7d1d47287a35aa6723

yarn-add-D-rtl-react-hooks:
	docker compose web yarn add -D @testing-library/react-hooks

yarn-add-D-eslint-rtl:
	docker compose exec web yarn add -D eslint-plugin-testing-library eslint-plugin-jest-dom

# ---- react-test-renderer ----

# https://ja.reactjs.org/docs/test-renderer.html
# https://www.npmjs.com/package/react-test-renderer
# https://www.npmjs.com/package/@types/react-test-renderer

yarn-add-D-react-test-renderer:
	docker compose exec web yarn add -D react-test-renderer @types/react-test-renderer

# ---- Mock Service Worker ----

# https://mswjs.io/docs/
# https://github.com/mswjs/msw
# https://www.wakuwakubank.com/posts/765-react-mock-api/

# 参考記事:
# https://www.wakuwakubank.com/posts/765-react-mock-api/
# https://zenn.dev/midorimici/articles/msw-storybook

yarn-add-D-msw:
	docker compose exec web yarn add -D msw

# ---- jest-fetch-mock ----

# https://www.npmjs.com/package/jest-fetch-mock

yarn-add-D-jest-fetch-mock:
	docker compose exec web yarn add -D jest-fetch-mock

# ---- jest-css-modules ----

# https://www.npmjs.com/package/jest-css-modules
# https://github.com/justinsisley/Jest-CSS-Modules

# ※ テストを実行する際に、CSSモジュールが何も悪さをしないようにmock化する必要があるが、それを自動でやってくれるモジュール。

# 記事:
# https://qiita.com/github0013@github/items/303a32d3037d322e67c0

yarn-jest-css-modules:
	docker compose exec web yarn add -D jest-css-modules

# ---- next-page-tester ----

# ※ Next.jsのpageコンポーネントをテストするためのモジュール
# → ページ遷移のテスト

# https://www.npmjs.com/package/next-page-tester
# https://github.com/next-page-tester/next-page-tester

# 記事:
# https://zenn.dev/k_matsumoto/articles/25946b297fabea
# https://qiita.com/suzu1997/items/e4ee2fc1f52fbf505481
# http://www.code-magagine.com/?p=16669

# **** Cypress ****

# https://docs.cypress.io/
# https://qiita.com/eyuta/items/a2454719c2d82c8bacd5

# Next.js with Cypress
# https://github.com/vercel/next.js/tree/canary/examples/with-cypress

yarn-add-D-cypress:
	docker compose exec web yarn add -D cypress

# **** Vitest ****

# Next.js with Vitest
# https://github.com/vercel/next.js/tree/canary/examples/with-vitest

# **** Playwright ****

# Next.js with Playwright
# https://github.com/vercel/next.js/tree/canary/examples/with-playwright

# ==== Vue ====

# https://github.com/vuejs/vue-class-component
# https://github.com/kaorun343/vue-property-decorator

yarn-add-D-vue:
	docker compose exec web yarn add -D vue vue-class-component vue-property-decorator

# ---- Vue CLI ----

# https://cli.vuejs.org/guide/installation.html

yarn-g-add-vue-cli:
	docker compose exec web yarn global add @vue/cli

# Vue CLI のコマンド操作
# https://knooto.info/vue-cli-command-operations/

# プロジェクトの生成
# 現在地にプロジェクトを生成する
# vue create .
# 「foo」フォルダを作ってプロジェクトを生成する
# vue create foo

# Manually select features で TypeScriptなどの設定方法
# https://qiita.com/hisayuki/items/8cf2396f122ca6e452ee


# プロジェクトの実行
# npm run serve
# yarn serve

# UI 管理画面の起動
# vue ui

# Vue Router
# vue add vue-router

# Vuetify
# vue add vuetify

# ==== Nuxt ====



# ==== Chart.js ====

# chart.js
yarn-add-D-chartjs:
	docker compose exec web yarn add -D chart.js

# react-chartjs2
yarn-add-react-chartjs-2:
	docker compose exec web yarn add -D react-chartjs-2 chart.js

# ==== Swiper.js ====

# https://swiperjs.com/
# https://swiperjs.com/react

yarn-add-D-swiper:
	docker compose exec web yarn add -D swiper

# https://www.npmjs.com/package/react-id-swiper

yarn-add-D-swiper-better:
	docker compose exec web yarn add -D swiper@5.4.2 react-id-swiper@3.0.0

# ==== Three.js ====

# https://threejs.org/

yarn-add-D-three:
	docker compose exec web yarn add -D three @types/three @react-three/fiber

# ==== Framer Motion ====

# https://www.framer.com/motion/
# https://www.framer.com/docs/
# https://www.npmjs.com/package/framer-motion
# https://yarnpkg.com/package/framer-motion
# https://github.com/framer/motion

# Chakra UI + Framer Motion
# https://chakra-ui.com/guides/integrations/with-framer

yarn-add-D-framer-motion:
	docker compose exec web yarn add -D framer-motion

# ==== Firebase ====

yarn-add-firebase:
	docker compose exec web yarn add firebase react-firebase-hooks

yarn-g-add-firebase-tools:
	docker compose exec web yarn global add firebase-tools

# ==== Amplify ====

# https://aws.amazon.com/jp/amplify/

# ==== Supabase ====

# https://supabase.com/

# 記事
# https://zenn.dev/gens/articles/c8e4a32ff13019

yarn-add-D-supabase:
	docker compose exec web yarn add -D @supabase/supabase-js

# **** Supabaseのプロジェクト作成 ****

# ⑴ New project → New organization
# - Name:
# - Database Password:
# - Region: Northeast Asia(Tokyo)
# - Pricing Plan: Free tier

# ⑵ Create new project
# ※ pauseの場合は、restore projectをクリック

# **** Supabaseの設定 ****

# ⑴ .env.localの作成
# SupabaseのAPI KEYを環境変数に追加
# NEXT_PUBLIC_SUPABASE_URL=
# NEXT_PUBLIC_SUPABASE_ANON_KEY=

# ⑵ Supabaseのダッシュボードで設定
#・設定 → API → Project URL
#・URLをコピーし、環境変数NEXT_PUBLIC_SUPABASE_URLに代入

#・設定 → API → Project API keys
#・anon publicの箇所をコピーし、環境変数NEXT_PUBLIC_SUPABASE_ANON_KEYに代入

# ⑶ ダミーのEmailを使う場合:
#・設定 → Authentication → Auth Providers → Email
#・Confirm email を無効

# ⑷ 設定した環境変数をプロジェクトに反映させる
# yarn run dev

# ⑸ utils/supabase.tsを作成
# 指定した環境変数からSupabaseのClientを作成しexport

# import { createClient } from '@supabase/supabase-js';
#
# const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL!;
# const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!;
#
# export const supabase = createClient(supabaseUrl, supabaseAnonKey);

# **** Table ****

# tableの作成
# Table → New table
# - Name:
# - Columns:
# Add columnをクリックしてカラムを追加
# Save

# ※ 外部キーを設定する場合:
# リンクアイコンをクリック
# - Select a table to reference to:
# - Select a column from <table名> to reference to：

# データを挿入
# Table → データを挿入するtable → Insert row
# Save

# **** Storage ****

# bucketの作成:
# Storage → Create new a bucket
# - Name of bucket:
# - Public bucket: 有効化
# Create bucket

# Permissonの設定:
# Storage → Policies → 設定するbucketのNew policy → For full customization

# ※ 画像をinsertできるようにする
# - Policy name: Enable insert for authorized users
# - Allowed operation: INSERTにチェック
# - Policy definition:
# bucket_id = '<bucket名>' AND auth.role() = 'authenticated'
# → auth.role() = 'authenticated': ログインしているユーザーだけが画像を追加できるよう指定
# Review → Save policy

# **** Database ****

# Subscriptionの設定(テーブルに変化があった場合にフロント側に通知を送る):
# Databse → Replication → 0 tables
# - Subscriptionを有効化したいテーブルにチェックを入れる
# 戻る

# ==== 便利なモジュール群 =====

# **** モックサーバ ****

# json-server
# package.json
# {
#   "scripts": {
#     "start": "npx json-server --watch db.json --port 3001"
# }

yarn-add-D-jsonserver:
	docker compose yarn add -D json-server

# http-server
# https://www.npmjs.com/package/http-server

yarn-add-D-http-server:
	docker compose exec web yarn add -D http-server

# serve
# https://www.npmjs.com/package/serve

yarn-add-D-serve:
	docker compose exec web yarn add -D serve

# Servør
# https://www.npmjs.com/package/servor

yarn-add-D-servor:
	docker compose exec web yarn add -D servor

# **** 便利なモジュール ****

# glob
# sass ファイル内で @import するときに*（アスタリスク）を使用できるようにするため

yarn-add-D-loader-importglob:
	docker compose add -D import-glob-loader

yarn-add-D-glob:
	docker compose exec web yarn add -D glob

# ----------------

# lodash
# https://qiita.com/soso_15315/items/a08e28def541c28458a0
# import _ from 'lodash';

yarn-add-D-lodash:
	docker compose exec web yarn add -D lodash @types/lodash

# ----------------

# https://www.nxworld.net/support-modules-for-npm-scripts-task.html
# publicフォルダを自動でクリーンにするコマンドも追加

# 削除
# Linuxのrmコマンドと似たrimrafコマンドが使えるようになる
yarn-add-D-rimraf:
	docker compose exec web yarn add -D rimraf

yarn-cleanup:
	docker compose exec web yarn -D cleanup

# コピー
yarn-add-D-cpx:
	docker compose exec web yarn add -D cpx

# ディレクトリ作成
yarn-add-D-mkdirp:
	docker compose exec web yarn add -D mkdirp

# ディレクトリ・ファイル名を変更
yarn-add-D-rename:
	docker compose exec web yarn add -D rename-cli

# まとめて実行・直列/並列実行
yarn-add-D-npm-run-all:
	docker compose exec web yarn add -D npm-run-all

# 監視
yarn-add-D-onchange:
	docker compose exec web yarn add -D onchange

# 環境変数を設定・使用する
yarn-add-D-cross-env:
	docker compose exec web yarn add -D cross-env

# ブラウザ確認をサポート
yarn-add-D-browser-sync:
	docker compose exec web yarn add -D browser-sync

# ----------------

# axios
# https://github.com/axios/axios
# https://axios-http.com/docs/intro

# 記事
# https://qiita.com/ksh-fthr/items/2daaaf3a15c4c11956e9
# https://www.willstyle.co.jp/blog/2751/
# https://reffect.co.jp/react/react-axios
# https://zenn.dev/tsuboi/articles/345b2c996c2f29eb5db9

# wrap
# https://sagatto.com/20201229_nuxt_axios_ts_repository
# https://qiita.com/itouuuuuuuuu/items/4132e3b7ddf2cbf02442

yarn-add-axios:
	docker compose exec web yarn add axios

# lib/axios.ts
# import Axios from 'axios';

# const axios = (baseURL: string) =>
#   Axios.create({
#     baseURL,
#     headers: {
#       'Content-Type': 'application/json',
#       'X-Requested-With': 'XMLHttpRequest',
#     },
#     withCredentials: true,
#   });

# const axios = Axios.create({
#   baseURL: process.env.NEXT_PUBLIC_RESTAPI_URL,
#   headers: {
#     'Content-Type': 'application/json',
#     'X-Requested-With': 'XMLHttpRequest',
#   },
#   withCredentials: true,
# });

# export default axios;

# ----------------

# sort-package-json
# package.json を綺麗にしてくれる

yarn-add-D-sort-package-json:
	docker compose exec web yarn add -D sort-package-json

# ----------------

# node-sass typed-scss-modules
# CSS Modulesを使用する際に必要
# https://www.npmjs.com/package/typed-scss-modules
# https://github.com/skovy/typed-scss-modules
# https://zenn.dev/noonworks/scraps/61091d5a367487

yarn-add-D-nodesass:
	docker compose exec web yarn add -D node-sass typed-scss-modules

# ----------------
# dayjs
# https://day.js.org/
# https://github.com/iamkun/dayjs/
# https://www.npmjs.com/package/dayjs

# まとめ
# https://qiita.com/tobita0000/items/0f9d0067398efdc2931e
# https://zenn.dev/biwa/articles/8d6d1030302484

yarn-add-D-dayjs:
	docker compose exec web yarn add -D dayjs

# ----------------

# universal-cookie
# https://www.npmjs.com/package/universal-cookie
# https://github.com/reactivestack/cookies/tree/master/packages/universal-cookie

# Cookieを使用する

# npm install universal-cookie
yarn-add-universal-cookie:
	docker compose exec web yarn add universal-cookie

# **** Node.js ****

# Express
# https://www.npmjs.com/package/@types/express

yarn-add-D-express:
	docker compose exec web yarn add -D express @types/express

# ----------------

# proxy中継
# https://github.com/chimurai/http-proxy-middleware
# https://www.npmjs.com/package/http-proxy-middleware
# https://www.twilio.com/blog/node-js-proxy-server-jp
# https://zenn.dev/daisukesasaki/articles/d67dfa0d75fdf77de4ad

yarn-add-D-proxy:
	docker compose exec web yarn add -D http-proxy-middleware

# ----------------

# ログ出力
# https://www.npmjs.com/package/morgan
# https://www.npmjs.com/package/@types/morgan
# https://qiita.com/mt_middle/items/543f83393c357ad3ab12

yarn-add-D-morgan:
		docker compose exec web yarn add -D morgan @types/morgan

# ----------------

# Sqlite3
yarn-add-D-sqlite3:
	docker compose exec web yarn add -D sqlite3

# ----------------

# body-parser
yarn-add-D-bodyparser:
	docker compose exec web yarn add -D body-parser

# ----------------

# node-dev
# package.json
# {
#   "scripts": {
#     "start": "npx node-dev app/app.js"
# }

yarn-add-D-nodedev:
	docker compose exec web yarn add -D node-dev

# ----------------

# node-fetch
# サーバーサイドでfetchメソッドが使える

yarn-add-node-fetch:
	docker compose exec web yarn add node-fetch

# ----------------

# js-base64
# APIで取得したデータをデコードできる

yarn-add-D-js-base64:
	docker compose exec web yarn add -D js-base64


# ==== Husky & lint-staged ====

# husky:
# https://typicode.github.io/husky/#/
# https://typicode.github.io/husky/#/?id=automatic-recommended
# Gitコマンドをフックに別のコマンドを呼び出せる
# 6系から設定方法が変更

# lint-staged:
# https://github.com/okonet/lint-staged
# commitしたファイル(stagingにあるファイル)にlintを実行することができる


# **** v4系 ****

yarn-add-D-husky-v4:
	docker compose exec web yarn add -D  husky@4.3.8 lint-staged@10.5.3

# package.json

#   "scripts": {
#     "lint:es": "npx eslint --fix './src/**/*.{js,jsx,ts,tsx}'",
#     "lint:style": "npx stylelint --fix './src/**/*.{css,scss}'",
#     "lint": "npm-run-all lint:{es,style}",
#     "format": "npx prettier --write './src/**/*.{js,jsx,ts,tsx,css,scss}'",
#     "lint-fix": "npm run lint && npm rum format"
#   },

# "husky": {
#     "hooks": {
#       "pre-commit": "lint-staged"
#     }
#   },

#   "lint-staged": {
#     "./src/**/*.{js,jsx,ts,tsx}": [
#       "npm run lint-fix"
#     ]
#   }


# **** v5系以上 ****

# 記事
# https://blog.gaji.jp/2021/12/16/8810/
# https://blog.gaji.jp/2021/09/22/8132/
# https://rinoguchi.net/2021/12/husky-and-lint-staged.html
# https://qiita.com/mu-suke08/items/43a492fda5cd71a31506

yarn-add-D-husky:
	docker compose exec web yarn add -D husky lint-staged
# npx husky-init && yarn


# --------------------

# ! .git と package.json が同一ディレクトリにいないプロジェクトで husky をつかう場合

# https://github.com/okonet/lint-staged/issues/961
# https://qiita.com/les-r-pan/items/c03f12bc1693983daa70

# ⑴ frondend配下に.huskyファイルを作成
# npx husky-init → package.jsonを以下のように修正 → yarn

# {
#   "scripts": {
#     "prepare": "cd .. && husky install frontend/.husky"
#   },
# }

# ※ workspaceを使う場合↓
# "prepare": "cd .. && cd .. && husky install packages/frontend/.husky"

# ⑵ .husky/pre-commitファイルの作成
# npx husky add .husky/pre-commit "cd frontend && yarn lint-staged"

# ※ workspaceを使う場合↓
# npx husky add .husky/pre-commit "cd packages/frontend && yarn lint-staged"

# ⑶ package.jsonに以下を追記

# 例)
# {
#   "lint-staged": {
#     "src/**/*.{ts,tsx}": [
#       "npm run {任意のコマンド}"
#    ]
#   },
# }

# "lint-staged": {
#     "*.{js,jsx,ts,tsx}": "npm run lint-format"
#   }

# "lint-staged": {
#   "*.{js,jsx,ts,tsx}": "eslint --cache --fix",
#   "*.{css,scss}": "stylelint --fix",
#   "*.{js,jsx,ts,tsx,css,md}": "prettier --write"
# }


# --------------------

# ? 特定のファイルをlint-stagedの対象から除外する

# https://github.com/okonet/lint-staged#how-can-i-ignore-files-from-eslintignore
# https://qiita.com/mu-suke08/items/be6a6d37f443b73cfd58

# ⑴ .lintstagedrc.jsを作成

# ESLint >= 7

# const { ESLint } = require('eslint')

# const removeIgnoredFiles = async files => {
#   const eslint = new ESLint()
#   const isIgnored = await Promise.all(
#     files.map(file => {
#       return eslint.isPathIgnored(file)
#     })
#   )
#   const filteredFiles = files.filter((_, i) => !isIgnored[i])
#   return filteredFiles.join(' ')
# }

# module.exports = {
#   '**/*.{ts,tsx,js,jsx}': async files => {
#     const filesToLint = await removeIgnoredFiles(files)
#     return [`eslint --max-warnings=0 ${filesToLint}`]
#   },
# }

# ⑵ .husky/pre-commitのコマンドを変更

# #!/bin/sh
# . "$(dirname "$0")/_/husky.sh"

# cd frontend && yarn lint-staged --config .lintstagedrc.js

# ※ workspaceを使う場合↓
# cd packages/frontend && yarn lint-staged --config .lintstagedrc.js

# ⑶ .eslintignoreを作成し、対象から除外したいパスを指定

# node_modules/
# .eslintrc.js
# stylelint.config.js
# postcss.config.js
# tailwind.config.js
# next.config.js
# babel.config.js
# jest.config.js


# --------------------

# ? next lint を lint-stagedと組み合わせる場合
# https://nextjs.org/docs/basic-features/eslint#linting-custom-directories-and-files
# https://qiita.com/manak1/items/900e10742f8e0714a901


# --------------------

# ! error  Parsing error: "parserOptions.project" has been set for @typescript-eslint/parser.の対処法
# https://wonwon-eater.com/ts-eslint-import-error/
# https://k5-n.com/parser-options-project-has-been-set-for-typescript-eslint-parser/
# https://knmts.com/as-a-engineer-50/

# → 主にファイルがどこからもimportされていない場合に表示されるエラー。
# → .eslintrc.js, stylelint.config.js, next.config.jsなどの設定ファイルはそもそもどこからもimportされない。
# → .eslintignoreにすべての設定ファイルのパスを指定

# 4つの解決策:
# 1. tsconfig の include にそのファイルを指定し、対象に含めるようにしてください。
# 2. 対象のファイルが他のソースコードと別のディレクトリにあるために tsconfig に含まれていないという場合は、別の tsconfig を作成して、そこの include に指定し、対象に含めるようにしてください。
# 3. エラーの原因となっているファイルについてはリンティングを行わないように eslintrc の設定を変更してください。
# 4. エラーの原因となっているファイルを eslintignore に記載し、リンティングの対象外となるようにしてください。

# 対応例:

# リンティング対象外として良い場合
# 例えば babel.config.js や jest.config.js といった設定ファイルに対して今回のエラーが出ているのであれば、それらはリンティングの対象に含めなくても良いと思うので、4 番の対応（eslintignore する）にしましょう。

# リンティング対象にしたいがビルド対象外にしたい場合
# 例えばテストファイルの類のような、リンティングは行いたいが、アプリとしてのビルド対象には含めないものであれば、2 番の対応（別の tsconfig を作成）にしましょう。tsconfig.eslint.json のような名称で作るのが良いです。

# リンティング対象およびビルド対象にしたい場合
# 1 番の対応（tsconfig の include にそのファイルを指定）しましょう。


# --------------------

# ^ hint: The 'frontend/.husky/pre-commit' hook was ignored because it's not set as executable.
# ^ hint: You can disable this warning with `git config advice.ignoredHook false`.

# https://qiita.com/mako0104/items/ad498b6f7bdcdb010b80

# .husky/pre-commitに実行権限を与える
# chmod +x .husky/pre-commit


# --------------------

#? git commit時にCodeSnifferを実行する方法


# 設定手順:
# https://typicode.github.io/husky/#/?id=automatic-recommended


# ⑴ huskyのインストール
husky-init:
	docker compose exec $(ctr) npx husky-init


# ⑵ .huskyを生成
# npx husky-init → package.jsonを以下のように修正 → yarn | m x

# {
#   "scripts": {
#     "prepare": "cd .. && husky install backend/.husky"
#   },
# }


# ⑶ .husky/pre-commitファイルの編集
husky-add:
	docker compose exec $(ctr) npx husky add .husky/pre-commit

# #!/usr/bin/env sh
# . "$(dirname -- "$0")/_/husky.sh"

# docker compose exec web composer phpcbf
# docker compose exec web php artisan test


# ⑷ composer.jsonのscriptsの編集

# "phpcs": [
#     "./vendor/bin/phpcs --standard=phpcs.xml ./"
# ],
# "phpcbf": [
#     "./vendor/bin/phpcbf --standard=phpcs.xml ./"
# ]


# ==== Create React App 設定手順 ====

# *** ⑴ テンプレ生成 ****

# ---- CRA ----

# yarn create react-app --template redux-typescript .

# ? React17, Next11に変更
# yarn add react@17.0.2 react-dom@17.0.2 @types/react@17.0.41

# "resolutions": {
#     "@types/react": "17.0.2",
#     "@types/react-dom": "18.0.2"
# },

# ! React 18 double rendering
# https://www.udemy.com/course/high-performance-react-web-django/learn/lecture/31895900#overview
# https://reactjs.org/blog/2022/03/29/react-v18.html#new-strict-mode-behaviors
# → React18では、Strict mode有効時に Bugを検出しやすくするために、開発モード時のみReactのコンポーネントを初回に2回マウントする仕様に変更になった

# ---- CRACO ----

# yarn add -D @craco/craco eslint-import-resolver-alias

# ---- Lint ----

# eslint + prettier
# yarn add -D @typescript-eslint/eslint-plugin @typescript-eslint/parser eslint-config-prettier prettier npm-run-all

# import order
# yarn add -D eslint-plugin-import

# stylelint
# yarn add -D stylelint stylelint-config-prettier stylelint-config-recess-order stylelint-config-standard stylelint-config-standard-scss stylelint-scss

# husky
# yarn add -D husky lint-staged

# ---- Styles ----

# scss
# yarn add -D node-sass typed-scss-modules

# tailwind + postcss ((設定方法はNext.jsのTailwind CSSを参照))
# yarn add -D tailwindcss postcss autoprefixer prettier-plugin-tailwindcss
# npx tailwindcss init -p

# emotion (設定方法はNext.jsのEmotionを参照)
# yarn add @emotion/react @emotion/styled @emotion/babel-plugin

# icons
# yarn add tabler-icons-react @heroicons/react

# ---- Library ----

# toolkit + react-query + axios
# yarn add @reduxjs/toolkit @tanstack/react-query@4.0.10 @tanstack/react-query-devtools@4.0.10 axios

# zustand + react-query + axios
# yarn add zustand @tanstack/react-query@4.0.10 @tanstack/react-query-devtools@4.0.10 axios

# recoil + react-query + axios
# yarn add recoil recoil-persist @tanstack/react-query@4.0.10 @tanstack/react-query-devtools@4.0.10 axios

# jotai + react-query + axios
# yarn add jotai @tanstack/react-query@4.0.10 @tanstack/react-query-devtools@4.0.10 axios

# react-router-dom + react-helmet-async
# yarn add react-router-dom @types/react-router-dom react-helmet-async

# react-hook-form & yup
# yarn add yup react-hook-form @hookform/resolvers @hookform/error-message

# graphql + apollp client
# yarn add graphql @apollo/client @apollo/react-hooks cross-fetch

# その他
# yarn add date-fns universal-cookie

# ---- Testing ----

# yarn add -D jest-css-modules msw

# **** ⑵ package.json修正 ****

# "devDependencies": {
#     "@craco/craco": "^6.4.3",
#     "@typescript-eslint/eslint-plugin": "^5.19.0",
#     "@typescript-eslint/parser": "^5.19.0",
#     "eslint": "^8.13.0",
#     "eslint-config-prettier": "^8.5.0",
#     "eslint-import-resolver-alias": "^1.1.2",
#     "history": "4.10.1",
#     "lint-staged": "10.5.3",
#     "node-sass": "^7.0.1",
#     "npm-run-all": "^4.1.5",
#     "prettier": "^2.6.2",
#     "stylelint": "^14.5.1",
#     "stylelint-config-prettier": "^9.0.3",
#     "stylelint-config-recess-order": "^3.0.0",
#     "stylelint-config-standard": "^25.0.0",
#     "stylelint-config-standard-scss": "^3.0.0",
#     "stylelint-scss": "^4.1.0",
#     "typed-scss-modules": "^6.3.0"
#   },

#   "resolutions": {
#     "@types/react": "17.0.14",
#     "@types/react-dom": "17.0.14"
#   },

#   "scripts": {
#     "start": "npm run lint-fix && craco start",
#     "build": "npm run lint-fix && craco build",
#     "test": "craco test",
#     "eject": "craco eject",
#     "lint:es": "npx eslint --fix './src/**/*.{js,jsx,ts,tsx}'",
#     "lint:style": "npx stylelint --fix './src/**/*.{css,scss}'",
#     "lint": "npm-run-all lint:{es,style}",
#     "format": "npx prettier --write './src/**/*.{js,jsx,ts,tsx,css,scss}'",
#     "lint-fix": "npm run lint && npm rum format",
#     "tsm": "npx typed-scss-modules src --implementation node-sass --nameFormat none --exportType default",
#     "tsmw": "npx typed-scss-modules src --watch --implementation node-sass --nameFormat none --exportType default"
#   },

# "husky": {
#     "hooks": {
#       "pre-commit": "lint-staged"
#     }
#   },

#   "lint-staged": {
#     "./src/**/*.{js,jsx,ts,tsx}": [
#       "npm run lint-fix"
#     ]
#   }

# **** ⑶ 各種設定ファイルの編集 ****

# eslintrc.js

# module.exports = {
#   settings: {
#     "import/resolver": {
#       alias: {
#         map: [["@src", "./src"]],
#         extensions: [".js", ".jsx", ".ts", ".tsx"],
#       },
#     },
#   },
#   extends: [
#     "eslint:recommended",
#     "plugin:@typescript-eslint/recommended",
#     "prettier",
#     // "prettier/@typescript-eslint"
#   ],
#   plugins: ["@typescript-eslint"],
#   parser: "@typescript-eslint/parser",
#   parserOptions: {
#     sourceType: "module",
#   },
#   env: {
#     browser: true,
#     node: true,
#     es6: true,
#   },
#   rules: {
#     // 適当なルール
#     "@typescript-eslint/ban-types": "warn",
#   },
# };

# ----------------

# stylelint.config.js

# module.exports = {
#   extends: ['stylelint-config-standard', 'stylelint-config-recess-order', 'stylelint-config-prettier'],
#   plugins: ['stylelint-scss'],
#   customSyntax: 'postcss-scss',
#   ignoreFiles: ['**/node_modules/**', '/public/'],
#   root: true,
#   rules: {
#     'at-rule-no-unknown': [
#       true,
#       {
#         ignoreAtRules: ['tailwind', 'apply', 'variants', 'responsive', 'screen', 'use'],
#       },
#     ],
#     'scss/at-rule-no-unknown': [
#       true,
#       {
#         ignoreAtRules: ['tailwind', 'apply', 'variants', 'responsive', 'screen'],
#       },
#     ],
#     'declaration-block-trailing-semicolon': null,
#     'no-descending-specificity': null,
#     // https://github.com/humanmade/coding-standards/issues/193
#     'selector-class-pattern': '^[a-zA-Z][a-zA-Z0-9_-]+$',
#     'keyframes-name-pattern': '^[a-zA-Z][a-zA-Z0-9_-]+$',
#     'selector-id-pattern': '^[a-z][a-zA-Z0-9_-]+$',
#     'property-no-unknown': [
#       true,
#       {
#         ignoreProperties: ['composes'],
#       },
#     ],
#   },
# };

# ----------------

# .prettierrc

# {
#   "printWidth": 120,
#   "singleQuote": true,
#   "semi": true
# }

# ----------------

# craco.config.js

# const path = require("path");
# module.exports = {
#   webpack: {
#     alias: {
#       "@src": path.resolve(__dirname, "src/"),
#     },
#   },
# };

# ------------

# tsconfig.json

# {
#   "compilerOptions": {
#     "target": "es5",
#     "lib": [
#       "dom",
#       "dom.iterable",
#       "esnext"
#     ],
#     "allowJs": true,
#     "skipLibCheck": true,
#     "esModuleInterop": true,
#     "allowSyntheticDefaultImports": true,
#     "strict": true,
#     "forceConsistentCasingInFileNames": true,
#     "noFallthroughCasesInSwitch": true,
#     "module": "esnext",
#     "moduleResolution": "node",
#     "resolveJsonModule": true,
#     "isolatedModules": true,
#     "noEmit": true,
#     "jsx": "react-jsx"
#   },
#   "include": [
#     "src"
#   ],
#   "extends": "./tsconfig.paths.json"
# }

# ----------------

# tsconfig.paths.json

# {
#   "compilerOptions": {
#     "baseUrl": ".",
#     "paths": {
#       "@src/*": [
#         "./src/*"
#       ],
#     }
#   }
# }

# **** ⑷ React 17に修正 ****

# index.tsx
# App.tsx

# **** ⑸ 追加ライブラリ ****

# API ：

# "@types/axios": "^0.14.0",
# "axios": "^0.27.2",

# ----------------

# ルーティング：

# "@types/react-router-dom": "^5.3.3",

# "connected-react-router": "^6.9.2",
# "history": "4.10.1",

# "react-router-dom": "5.3.0",

# ----------------

# ロガー：

# "@types/redux-logger": "^3.0.9",

# "redux-logger": "^3.0.6",

# ----------------

# フォームバリデーション：

# "@hookform/error-message": "^2.0.0",
# "@hookform/resolvers": "^2.8.8",

# "react-hook-form": "^7.29.0",

# "yup": "^0.32.11"

# ----------------

# MUI：

# "@material-ui/core": "^4.12.4",
# "@material-ui/icons": "^4.11.3",
# "@material-ui/styles": "^4.11.5",
# "@material-ui/system": "^4.12.2",

# "@types/material-ui": "^0.21.12",

# ----------------

# Chart.js ：

# "chart.js": "^2.9.3",
# "react-chartjs-2": "^2.9.0",

# ----------------

# "firebase": "^9.6.11",

# ----------------

# "node-sass": "^7.0.1",

# ----------------

# "react-countup": "^6.2.0",

# "typed-scss-modules": "^6.4.0"

# ----------------

# "react-icons": "^4.3.1",

# ==== Create Next App 設定手順 ====

# Next.js + TypeScript + React Query + Recoil + Tailwind CSS + Mantine UI + Prettier + ESLint + StyleLint + Husky + Jest + React Testing Library 環境

# 参考記事
# https://zenn.dev/hungry_goat/articles/b7ea123eeaaa44
# https://blog.gaji.jp/2021/12/16/8810/
# https://zenn.dev/lemonadern/articles/nextjs-starter-template
# https://qiita.com/mizozobu/items/27901ddf2d735cb24fb4
# https://zenn.dev/akino/articles/96ae4136447433

# ベストプラクティス
# https://qiita.com/syuji-higa/items/931e44046c17f53b432b
# https://zenn.dev/higa/articles/d7bf3460dafb1734ef43

# **** ⑴ テンプレの生成 ****

# yarn create next-app --typescript .

# pagesをsrc/に移動させる
# 不要なファイルの削除
# 必要な設定ファイルの作成

# ---- Lint ----

lint-install:
	yarn add -D --cwd ./frontend \
		@typescript-eslint/eslint-plugin @typescript-eslint/parser eslint-config-prettier prettier npm-run-all \
		husky lint-staged \
		eslint-plugin-import \
		stylelint stylelint-config-prettier stylelint-config-recess-order stylelint-config-standard stylelint-config-standard-scss stylelint-scss

# prettier + eslint (必須)
# yarn add -D @typescript-eslint/eslint-plugin @typescript-eslint/parser eslint-config-prettier prettier npm-run-all

# husky + lint-staged (設定方法はHusky & lint-stagedを参照)
# yarn add -D husky lint-staged
# npx husky-init && yarn

# import order
# yarn add -D eslint-plugin-import

# import alias(不要)
# yarn add -D webpack eslint-import-resolver-typescript

# stylelint (CSS Modulesを書く場合必要)
# yarn add -D stylelint stylelint-config-prettier stylelint-config-recess-order stylelint-config-standard stylelint-config-standard-scss stylelint-scss

# ---- Style ----

style-install:
	yarn add -D --cwd ./frontend \
		node-sass typed-scss-modules \
		tailwindcss postcss autoprefixer prettier-plugin-tailwindcss
		yarn add --cwd ./frontend \
		dayjs @mantine/core @mantine/hooks @mantine/form @mantine/dates @mantine/next @mantine/notifications \
		@emotion/react @emotion/styled @emotion/babel-plugin \
		tabler-icons-react @heroicons/react

# scss
# yarn add -D node-sass typed-scss-modules

# tailwind + postcss ((設定方法はNext.jsのTailwind CSSを参照))
# yarn add -D tailwindcss postcss autoprefixer prettier-plugin-tailwindcss
# npx tailwindcss init -p

# mantine (設定方法はMantine UIを参照)
# yarn add dayjs @mantine/core @mantine/hooks @mantine/form @mantine/dates @mantine/next @mantine/notifications

# emotion (設定方法はNext.jsのEmotionを参照)
# yarn add @emotion/react @emotion/styled @emotion/babel-plugin

# icons
# yarn add tabler-icons-react @heroicons/react

# ---- Library ----

library-install:
	yarn add --cwd ./frontend \
		zustand @tanstack/react-query@4.0.10 @tanstack/react-query-devtools@4.0.10 axios \
		date-fns yup universal-cookie

# toolkit + react-query + axios
# yarn add @reduxjs/toolkit @tanstack/react-query@4.0.10 @tanstack/react-query-devtools@4.0.10 axios

# zustand + react-query + axios
# yarn add zustand @tanstack/react-query@4.0.10 @tanstack/react-query-devtools@4.0.10 axios

# recoil + react-query + axios
# yarn add recoil recoil-persist @tanstack/react-query@4.0.10 @tanstack/react-query-devtools@4.0.10 axios

# jotai + react-query + axios
# yarn add jotai @tanstack/react-query@4.0.10 @tanstack/react-query-devtools@4.0.10 axios

# react-hook-form & yup
# yarn add yup react-hook-form @hookform/resolvers @hookform/error-message

# graphql + apollp client
# yarn add graphql @apollo/client @apollo/react-hooks cross-fetch

# その他
# yarn add date-fns universal-cookie

# ---- Testing ----

# node-fetchエラー対策
# → Next.jsでは、node-fetchモジュールのインストールせずとも使用できるが、明示的にimportしなければテストがpassしない問題が起きる。
# yarn add -D @types/node-fetch

# ReferenceError: setImmediate is not defined 対処法
# https://www.udemy.com/course/nextjs-react-testing-library-react/learn/lecture/26813286#questions
# → fetchを使用してテストを行うと発生する
# yarn add setimmediate

# ReferenceError: fetch is not defined 対策
# yarn add isomorphic-unfetch

# Next11の場合:

testing-install-11:
	yarn add --cwd ./frontend \
		axios@0.21.1 swr \
		react@17.0.2 react-dom@17.0.2 next@11.1.2 \
		setimmediate isomorphic-unfetch
	yarn add -D --cwd ./frontend \
		@types/react@17.0.41 \
		jest@26.6.3 @types/jest@26.0.20 babel-jest@26.6.3 \
		@testing-library/react@11.2.3 @testing-library/jest-dom@5.11.8 @testing-library/dom@7.29.2 @testing-library/user-event@12.6.0 \
		jest-css-modules@2.1.0 msw@0.35.0 next-page-tester@0.30.0 \
		@types/node-fetch

# axios + swr
# yarn add axios@0.21.1 swr

# React17, Next11に変更
# yarn add react@17.0.2 react-dom@17.0.2 next@11.1.2
# yarn add -D @types/react@17.0.41

# jest + react testing library (設定方法はNext.jsのTestingを参照)
# yarn add -D jest@26.6.3 @testing-library/react@11.2.3 @types/jest@26.0.20 @testing-library/jest-dom@5.11.8 @testing-library/dom@7.29.2 babel-jest@26.6.3 @testing-library/user-event@12.6.0 jest-css-modules@2.1.0 msw@0.35.0 next-page-tester@0.30.0

# graphql + apollo clientの場合:
# yarn add -D jest@26.6.3 @testing-library/react@11.2.6 @types/jest@26.0.22 @testing-library/jest-dom@5.11.10 @testing-library/dom@7.30.3 babel-jest@26.6.3 @testing-library/user-event@13.1.3 jest-css-modules msw@0.35.0 next-page-tester@0.29.0 @babel/core@7.17.9

# Next12の場合:

testing-install-12:
	yarn add --cwd ./frontend \
		axios swr \
		setimmediate isomorphic-unfetch
	yarn add -D --cwd ./frontend \
		jest@27.5.1 @testing-library/react @testing-library/jest-dom @testing-library/user-event jest-css-modules msw@0.39.2 next-page-tester@0.32.0 @types/node-fetch

# axios + swr
# yarn add axios swr

# jest + react testing library (設定方法はNext.jsのTestingを参照)
# yarn add -D jest@27.5.1 @testing-library/react @testing-library/jest-dom @testing-library/user-event jest-css-modules msw@0.39.2 next-page-tester@0.32.0 @types/node-fetch

# ! jest-environment-jsdomを入れると、testEnvironmentOptionsのエラーが発生する！

# **** ⑵ package.json の修正とyarn install ****

# package.json

# {
#   "name": "frontend",
#   "version": "0.1.0",
#   "private": true,
#   "scripts": {
#     "dev": "npm run lint && next dev",
#     "build": "npm run lint-format && next build",
#     "start": "next start",
#     "lint:next": "next lint --dir src",
#     "lint:es": "npx eslint src --ext .js,.jsx,.ts,.tsx --fix",
#     "lint:style": "npx stylelint './styles/**/*.{css,scss}' --fix",
#     "lint": "npm-run-all lint:{es,style}",
#     "format": "npx prettier --write --ignore-path .gitignore './**/*.{js,jsx,ts,tsx,json,css,scss}'",
#     "lint-format": "npm run lint && npm rum format",
#     "tsm": "npx typed-scss-modules src --implementation node-sass --nameFormat none --exportType default",
#     "tsmw": "npx typed-scss-modules src --watch --implementation node-sass --nameFormat none --exportType default",
#     "prepare": "cd .. && husky install frontend/.husky"
#   },
#   "dependencies": {
#     "@emotion/babel-plugin": "^11.9.2",
#     "@emotion/react": "^11.9.3",
#     "@emotion/styled": "^11.9.3",
#     "@heroicons/react": "^1.0.6",
#     "@mantine/core": "^4.2.12",
#     "@mantine/dates": "^4.2.12",
#     "@mantine/form": "^4.2.12",
#     "@mantine/hooks": "^4.2.12",
#     "@mantine/next": "^4.2.12",
#     "@mantine/notifications": "^4.2.12",
#     "axios": "^0.27.2",
#     "date-fns": "^2.28.0",
#     "dayjs": "^1.11.4",
#     "next": "12.2.2",
#     "npm-run-all": "^4.1.5",
#     "react": "18.2.0",
#     "react-dom": "18.2.0",
#     "react-query": "4.0.0-beta.10",
#     "recoil": "^0.7.4",
#     "recoil-persist": "^4.2.0",
#     "tabler-icons-react": "^1.53.0",
#     "yup": "^0.32.11"
#   },
#   "devDependencies": {
#     "@types/node": "18.0.6",
#     "@types/react": "18.0.15",
#     "@types/react-dom": "18.0.6",
#     "@typescript-eslint/eslint-plugin": "^5.30.7",
#     "@typescript-eslint/parser": "^5.30.7",
#     "autoprefixer": "^10.4.7",
#     "eslint": "8.20.0",
#     "eslint-config-next": "12.2.2",
#     "eslint-config-prettier": "^8.5.0",
#     "eslint-plugin-import": "^2.26.0",
#     "husky": "^8.0.0",
#     "lint-staged": "^13.0.3",
#     "node-sass": "^7.0.1",
#     "postcss": "^8.4.14",
#     "prettier": "^2.7.1",
#     "prettier-plugin-tailwindcss": "^0.1.12",
#     "stylelint": "^14.9.1",
#     "stylelint-config-prettier": "^9.0.3",
#     "stylelint-config-recess-order": "^3.0.0",
#     "stylelint-config-standard": "^26.0.0",
#     "stylelint-config-standard-scss": "^5.0.0",
#     "stylelint-scss": "^4.3.0",
#     "tailwindcss": "^3.1.6",
#     "typed-scss-modules": "^6.5.0",
#     "typescript": "4.7.4"
#   },
#   "lint-staged": {
#     "*.{js,jsx,ts,tsx}": "npm run lint"
#   }
# }

# 参考記事:
# https://zenn.dev/popcorn/scraps/6e7002f56a3451
# https://fwywd.com/tech/next-eslint-prettier
# https://qiita.com/kewpie134134/items/0298e5b7a88a06804cd8

# **** ⑶ 各種設定ファイルの編集

# eslintrc.js

# module.exports = {
#   root: true, // ルートに設定ファイルがある場合はtrue。上位ディレクトリを検索しない）
#   env: {
#     browser: true, // ブラウザのグローバル変数を有効にする。
#     node: true, // Node.jsのグローバル変数やスコープを有効にします。
#     es6: true, // ECMAScript6のモジュールを除いた全ての機能が使用可能になります。
#     // jest: true,
#   },
#   // 追加でまとめられたルールを設定。
#   extends: [
#     'eslint:recommended',
#     'next',
#     'next/core-web-vitals',
#     'plugin:@typescript-eslint/recommended',
#     'plugin:@typescript-eslint/recommended-requiring-type-checking',
#     'plugin:import/recommended',
#     'plugin:import/warnings',
#     'prettier',
#     // "prettier/@typescript-eslint"
#   ],
#   plugins: ['@typescript-eslint'], // サードパーティ用のプラグインを追加
#   parser: '@typescript-eslint/parser',
#   parserOptions: {
#     sourceType: 'module',
#     // envの設定と重複するので不要
#     // ecmaVersion: 12,
#     // eslint-plugin-reactを適応させている場合不要
#     // ecmaFeatures: {
#     //   jsx: true,
#     // },
#     // extends で指定しているplugin:@typescript-eslint/recommended-requiring-type-checkingに対して型情報を提供するため tsconfig.json の場所を指定。
#     project: './tsconfig.json',
#   },
#   settings: {
#     // Reactのバージョンを指定。detectにすることでインストールしているバージョンを参照してくれる。
#     react: {
#       version: 'detect',
#     },
#     // Next.jsの場合不要
#     // 'import/resolver': {
#     //   node: {
#     //     extensions: ['.js', '.jsx', '.ts', '.tsx', 'json'],
#     //   },
#     //   typescript: { project: './' },
#     //   typescript: {
#     //     config: path.join(__dirname, './webpack.config.js'),
#     //     alwaysTryTypes: true,
#     //   },
#     // },
#   },
#   rules: {
#     'import/order': [
#       'error',
#       {
#         // グループごとの並び順
#         groups: [
#           'builtin', // node "builtin" のモジュール
#           'external', // npm install したパッケージ
#           'internal', // パス設定したモジュール
#           ['parent', 'sibling'], // 親階層と子階層のファイル
#           'object', // object-imports
#           'type', // 型だけをインポートする
#           'index', // 同階層のファイル
#         ],
#         // グループごとに改行を入れるか
#         'newlines-between': 'always',
#         // アルファベット順・大文字小文字を区別なし
#         alphabetize: {
#           order: 'asc',
#           caseInsensitive: true,
#         },
#       },
#     ],
#     // 適当なルールを設定
#     'react/display-name': 'off',
#     '@typescript-eslint/ban-types': 'warn',
#   },
# };

# ----------------

# .prettierrc.js

# module.exports = {
#   // trailingComma: 'es5',
#   // trailingComma: 'all', // 末尾のカンマあり
#   // tabWidth: 2, // tab の長さは半角スペース 2 つ
#   semi: true, // セミコロンあり
#   printWidth: 120, // １ 行の最大文字数 120
#   singleQuote: true, // シングルクォーテーションに統一
#   // bracketSameLine: true,
#   // jsxSingleQuote: true, //jsx もシングルクォーテーションに統一
#   // embeddedLanguageFormatting: 'auto',
# };

# ----------------

# .prettierignore

# # next.js build output
# .next
# out
# # dotenv environment variables file (build for Zeit Now)
# .env
# .env.local
# # Dependency directories
# node_modules
# # Logs
# npm-debug.log*
# yarn-debug.log*
# yarn-error.log*

# ----------------

# stylelint.config.js

# module.exports = {
#   extends: ['stylelint-config-standard', 'stylelint-config-recess-order', 'stylelint-config-prettier'],
#   plugins: ['stylelint-scss'],
#   customSyntax: 'postcss-scss',
#   ignoreFiles: ['**/node_modules/**', '/public/', '/.next/'],
#   root: true,
#   rules: {
#     'at-rule-no-unknown': [
#       true,
#       {
#         ignoreAtRules: ['tailwind', 'apply', 'variants', 'responsive', 'screen', 'use'],
#       },
#     ],
#     'scss/at-rule-no-unknown': [
#       true,
#       {
#         ignoreAtRules: ['tailwind', 'apply', 'variants', 'responsive', 'screen'],
#       },
#     ],
#     'declaration-block-trailing-semicolon': null,
#     'no-descending-specificity': null,
#     // https://github.com/humanmade/coding-standards/issues/193
#     'selector-class-pattern': '^[a-zA-Z][a-zA-Z0-9_-]+$',
#     'keyframes-name-pattern': '^[a-zA-Z][a-zA-Z0-9_-]+$',
#     'selector-id-pattern': '^[a-z][a-zA-Z0-9_-]+$',
#     'property-no-unknown': [
#       true,
#       {
#         ignoreProperties: ['composes'],
#       },
#     ],
#   },
# };

# ----------------

# tsconfig.json

# {
#   "compilerOptions": {
#     "target": "es5",
#     "lib": ["dom", "dom.iterable", "esnext"],
#     "allowJs": true,
#     "skipLibCheck": true,
#     "strict": true,
#     "forceConsistentCasingInFileNames": true,
#     "noEmit": true,
#     "esModuleInterop": true,
#     "module": "esnext",
#     "moduleResolution": "node",
#     "resolveJsonModule": true,
#     "isolatedModules": true,
#     "jsx": "preserve",
#     "incremental": true,
#     "allowSyntheticDefaultImports": true,
#     "noFallthroughCasesInSwitch": true,
#   },
#   "include": ["next-env.d.ts", "**/*.ts", "**/*.tsx"],
#   "exclude": ["node_modules"],
#   "extends": "./tsconfig.extends.json"
# }

# ----------------

# tsconfig.extends.json

# {
#   "compilerOptions": {
#     "baseUrl": ".",
#     "paths": {
#       "@/*": [
#         "src/*"
#       ],
#       "@styles/*": [
#         "styles/*"
#       ],
#       "@public/*": [
#         "public/*"
#       ]
#     }
#   }
# }

# ※ importで絶対パスを使用する場合、eslint-import-resolver-typescriptをインストールして.eslintrc.jsやnext.config.jsの設定を修正しなくても上記のように指定するだけで実現できる。
# https://nextjs-ja-translation-docs.vercel.app/docs/advanced-features/module-path-aliases

# ----------------

# next.config.js (基本設定不要)

# https://nextjs.org/docs/api-reference/next.config.js/introduction
# https://nextjs-ja-translation-docs.vercel.app/docs/api-reference/next.config.js/introduction

# Next.js開発時にファイルimportでパスの alias（エイリアス）利用する方法:
# → TypeScriptでの有効化, ESLintでの有効化, Next.jsでの有効化, Storybookでの有効化が必要
# yarn add -D webpack eslint-import-resolver-typescript
# https://t-cr.jp/memo/3cc17944875d1463
# https://tamalog.szmd.jp/storybook-absolute-imports/
# https://qiita.com/282Haniwa/items/76d56a6a7e9d0db95a33

# /** @type {import('next').NextConfig} */
# const path = require('path');
# const webpack = require('webpack');

# const nextConfig = {
#   reactStrictMode: true,
#   swcMinify: true,
# };

# module.exports = {
#   nextConfig,
#   webpack(config, options) {
#     config.resolve.alias = {
#       '@': path.resolve(__dirname, './src/'),
#     };
#     return config;
#   },
# };

# ==== Next.js設定 ====

# API設定
# https://maasaablog.com/development/nextjs/3104/
# https://www.webopixel.net/php/1724.html
# https://zenn.dev/knaka0209/articles/f0082eb105b2c4

# CORS対策
# https://qiita.com/kyo-san/items/a507aa0b46037df1b139
# オリジン間リソース共有 (CORS)
# https://developer.mozilla.org/ja/docs/Web/HTTP/CORS
# https://note.crohaco.net/2019/http-cors-preflight/
# https://qiita.com/kyo-san/items/a507aa0b46037df1b139

# Next.jsの使用法
# https://www.webopixel.net/javascript/1714.html

# create next app
next-install-js:
	docker compose exec client yarn create next-app .

next-install-js-tailwind:
	docker compose exec client yarn create next-app . -e with-tailwindcss

next-install-ts:
	docker compose exec client yarn create next-app . --typescript

next-file-set:
	mkdir frontend/src
	mv frontend/{page,styles} frontend/src

# Next.jsのビルドの出力先をLaravelのpublicディレクトリに変更
# "scripts": {
#     "dev": "next dev",
#     "build": "next build && next export -o ../backend/public",
#     "start": "next start",
#     "lint": "next lint"
# },
#
# Next.js で 静的サイトとしてエクスポートするための設定
# https://pgmemo.tokyo/data/archives/2127.html
# https://qiita.com/toshikisugiyama/items/9d9ada2de0cedb03a21e
# next-laravel-dist-set:
# 	cp backend/public/index.php frontend/public/index.php
# 	cp backend/public/.htaccess frontend/public/.htaccess


# SWCの設定
# https://qiita.com/obr-note/items/acb32dd64a9b614883bb
#
# SWCからbabelを使ったコンパイルに変更:
# next.json.js
# module.exports = {
#   swcMinify: false // 追記
# }
#
# .babelrc
# {
#   "presets": ["next/babel"]
# }
#
# SWCに対応:
# https://zenn.dev/sora_kumo/articles/09a1369e53e5d0
# next@11.1.1-canary.7~10
# ※開発途中
yarn-add-next-swc:
	docker compose exec client yarn add next@11.1.1-canary.7

# 手動でFrontendの環境設定
# https://github.com/taylorotwell/next-example-frontend


# ---- Next.js拡張 ----

next-insatll-full:
	@make next-install-cors
	@make next-install-tailwind

next-install-cors:
	docker compose exec client yarn add -D axios swr

# https://fwywd.com/tech/next-tailwind
# https://tailwindcss.com/docs/guides/nextjs
next-install-tailwind:
	docker compose exec client yarn add -D tailwindcss@latest postcss@latest autoprefixer@latest eslint-plugin-tailwindcss

next-tailwind-set:
	docker compose exec client yarn tailwindcss init -p

# https://zenn.dev/iwakin999/articles/7a5e11e62ba668
next-install-emotion:
	docker compose exec client yarn add -D @emotion/react @emotion/styled @emotion/babel-plugin

# https://qiita.com/yaskitie/items/b1aec0d4f9c1fd598634
# https://t-cr.jp/memo/24517a85fb89591ca
next-install-linaria:
	docker compose exec client yarn add -D linaria@^3.0.0-beta.17 @linaria/core @linaria/react @linaria/babel-preset @linaria/shaker \
	@babel/core \
	next-linaria


# ==== Herokuの設定 ====

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

#todo [API Tips]

# ==== Django REST API 環境設定 ===

# **** Anaconda + Django REST Framework + JWT 環境構築

# 参考記事
# https://qiita.com/TakayukiHatanaka/items/d59d2fd676d17816e40e
# https://zenn.dev/fullfilled_void/articles/article-20210816-01

# condaコマンド一覧
# https://qiita.com/naz_/items/84634fbd134fbcd25296
# https://biotech-lab.org/articles/818
# https://hogelog.com/python/conda-command.html
# https://irohaplat.com/conda-basic-command-list/
# https://miyashinblog.com/anaconda-cmd/
# https://tarovlog.com/2021/01/04/anaconda-cheat-sheet/

# ⑴ 仮想環境の構築
# GUI:
# Anaconda → Environments → Create → Python 3.8選択 → Open Terminal
# CLI:
# conda create -n <仮想環境名> python=<version>
# conda activate <仮想環境名>

# ⑵ 必要なモジュールをインストール

# - pip install django==3.1 django-cors-headers==3.4.0 djangorestframework==3.11.1 djangorestframework-simplejwt==4.6.0 PyJWT==2.0.0 djoser==2.0.3 python-decouple dj-database-url dj-static

# - pip install django==3.1
# - pip install django-cors-headers==3.4.0
# - pip install djangorestframework==3.11.1
# - pip install djangorestframework-simplejwt==4.6.0
# - pip install PyJWT==2.0.0
# - pip install djoser==2.0.3
# - pip install python-decouple
# - pip install dj-database-url
# - pip install dj-static

# ⑶ PyCharm起動
# - New Project
# - Location指定
# - Previously configured interpreterをチェック: /opt/anaconda3/envs/<作成した仮想環境>/bin/python
# - Create a main.py welcome script: チェックを外す
# - Createをクリック

# ⑷ Projectの作成
# django-admin startproject <Project名> . 例) rest_api

# ⑸ Applicationの作成
# django-admin startapp <Application名> 例) api

# ⑹ DjangoのWelcomeページを表示させる。
# manage.pyを右クリック → Run 'manage'を実行 → Edit Configuration → Parameters: runserver → OK → 再生ボタンをクリック → ターミナルに表示されるパスをクリック
# 以後、ここで再生と停止を行う
# CLI: python manage.py runserver

# **** 簡単なAPIを作成 ****

# https://github.com/GomaGoma676/nextjs_restapi

# ++++ <Project名>/setting.py の設定 ++++

# ⑴ <Project名>/setting.py でモジュールを追加import:
# from datetime import timedelta
# from decouple import config
# from dj_database_url import parse as dburl

# ⑵ .envを作成し、<Project名>/setting.pyからSECRET_KEYとDEBUGの値を移す:
# .env
# SECRET_KEY=********************* ※スペースを開けない
# DEBUG=False

# <Project名>/setting.py
# SECRET_KEY = config('SECRET_KEY')
# DEBUG = config('DEBUG')

# ⑶ INSTALED_APPSにApplicationを追加:
# 'rest_framework',
# 'api.apps.ApiConfig', // カスタムで作ったAPIのApplication
# 'corsheaders',
# 'djoser',

# ⑷ corsheadersが使えるように、MIDDLEWAREの先頭に追加:
# 'corsheaders.middleware.CorsMiddleware',
# ※ MIDDLEWAREの読み込みは上から順に読み込まれる。

# ⑸ corsのホワイトリストを作成(以下を貼り付け):

# CORS_ORIGIN_WHITELIST = [
#     "http://localhost:3000", //  Next.jsのローカルサーバのオリジン
# ]

# ※ Next.jsのローカルサーバからのアクセスを許可する。
# ※ Vercelでデプロイし、本番環境のURLが取得できたら、そのURLのオリジンもここに追記する。

# ⑹ <Project名>/setting.pyにsimplejwtの設定(以下を貼り付け):
# SIMPLE_JWT = {
#     'AUTH_HEADER_TYPES': ('JWT',),
#     'ACCESS_TOKEN_LIFETIME': timedelta(minutes=60), // トークンの有効期限60分に指定
# }

# ⑺ REST Framework 全体でデフォルトでJWTトークンの認証を適応させる設定(以下を貼り付け):
# REST_FRAMEWORK = {
#     'DEFAULT_PERMISSION_CLASSES': [
#         'rest_framework.permissions.IsAuthenticated',
#     ],
#     'DEFAULT_AUTHENTICATION_CLASSES': [
#         'rest_framework_simplejwt.authentication.JWTAuthentication',
#     ],
# }

# ※ DEFAULT_PERMISSION_CLASSESでは、デフォルトで認証に通ったユーザーのみViewにアクセスできるように設定している。
# ※ DEFAULT_AUTHENTICATION_CLASSESでは、その認証をどのような方式で行うかを設定する。この場合はJWTに認証を行うよう設定。

# ⑻ DATABASESのデフォルトの内容を書き換える:
# default_dburl = 'sqlite:///' + str(BASE_DIR / "db.sqlite3")
# DATABASES = {
#     'default': config('DATABASE_URL', default=default_dburl, cast=dburl),
# }

# ※ インストールしたdj-database-urlモジュール使うことができて、本番環境のDATABASE_URLがある場合はそっちを使い、無い場合つまりローカル環境の場合はsqlite3を使うように設定している。

# ⑼ TIME_ZONEの設定:
# TIME_ZONE = 'Asia/Tokyo'

# ⑽ STATIC_ROOTを追加(以下を貼り付け):
# STATIC_ROOT = str(BASE_DIR / 'staticfiles')

# ※ Herokuにデプロイするときに、collectstaticが自動で実行されるが、それはProjectの中に散らばっているStaticファイルを1つのフォルダにかき集めてくれるもの。そのときにどのフォルダにまとめるのかを指定している。
# ※ BASE_DIRはProjectのルートディレクトリのこと。なので、その直下にstaticfilesというフォルダを作って、ここにまとめる。

# ++++ <Application名>/models.py の設定 ++++

# ※ Laravelのマイグレーションファイルでのテーブル構造の定義とマイグレートに相当

# migrationsフォルダ生成
# python manage.py makemigrations

# マイグレート
# python manage.py migrate

# ++++ <Application名>/serializers.py の設定 ++++

# ※ Laravelのコントローラに相当

# ++++ <Applicaton名>/admin.py の設定 ++++

# Djangoのadminのダッシュボードで見れるようにモデルを登録する。

# ++++ <Application名>/views.py の設定 ++++

# LaravelのViewに相当

# ++++ <Application名>/urls.py の設定 ++++

# ※ Laravelのルーティングに相当

# <Project名>/urls.py に読み込ませる。

# **** adminのダッシュボードにアクセスしダミーデータを作成 ****

# Djangoのadminのダッシュボードにアクセスできるように、スーパーユーザーを作成する
# python manage.py createsuperuser
# - Username: 適当
# - Email: Enterでskip
# - Password:

# - /admin にアクセスしログイン
# - ダミーデータを作成

# **** Endpointの確認 ****

# PostmanとModHeaderを使用

# ⑴ api/register
# 新規ユーザー作成
# - Username:
# - Password:
# - Post

# ⑵ api/auth/jwt/create
# 作成したユーザーでJWTトークンが取得できるか確認
# - Postman 起動
# - POST http://127.0.0.1:8000/api/auth/jwt/create
# - Headers をクリック → Authorizationを選択
# - Body → form-data → KEY: username, password → VALUE: 作成したユーザーのusernameとpasswordを指定
# - Send

# ⑶ api/list-post
# ⑷ api/detail-post/[id]

# ⑸ api/list-task
# ⑹ api/detail-task/[id]

# ⑺ api/tasks
# このendpointではJWTトークンが必要
# - Postmanで取得したaccessトークンをコピー ※ ""は不要
# - Chromeのmodheaderを起動
# - Request headersをチェック
# - Authorizationを選択
# - JWT <accsessトークン>
# - 再度、api/tasksにアクセス

# 新規作成: POST
# 一覧表示: GET
# 更新: api/tasks/[id] → PUT
# 削除: api/tasks/[id] → DELETE

# 確認が終わったら、modheaderのチェックを外す

# **** Heroku デプロイ ****

# ++++ デプロイ前の設定 ++++

# ⑴ GitHubにCommit & Push

# ⑵ <Project名>/wsgi.py の設定

# ⑶ pip freeze > requirements-dev.txt
# → プロジェクトの仮想環境にインストールされているモジュールの一覧をrequirements-dev.txtに出力
# certifi の箇所を certifi==2020.12.5 に修正

# ⑷ プロジェクト直下に requirements.txt を作成し、以下を記載
# -r requirements-dev.txt
# gunicorn
# psycopg2==2.8.6

# ※ -r requirements-dev.txt で開発時に使っていたモジュールの一覧を読み込む
# ※ 本番環境ではさらにgunicornとpsycopg2も読み込む

# ⑸ プロジェクト直下に Procfile 作成し、以下を記載
# web: gunicorn rest_api.wsgi --log-file -

# ⑹ プロジェクト直下に runtime.txr を作成
# Herokuがサポートするruntimeを指定する。
# https://devcenter.heroku.com/articles/python-support#supported-runtimes
# python-3.8.13

# ++++ Herokuでデプロイ ++++

# ⑴ Herokuにログインし、Herokuのコンソールに移動

# ⑵ New → Create new app
# - App name: ※ユニークな名前
# - Create appをクリック

# ⑶ ターミナルで以下のコマンドを実行する
# Deploy → Deploy using Heroku Git を参考に
# (brew tap heroku/brew && brew install heroku ※ Heroku CLIのインストール)

# heroku login
# heroku plugins:install heroku-config
# heroku git:remote -a <App name>
# heroku config:push

# ⑷ HerokuのコンソールのSettings → Reveal Config Vars
# Django側で設定していたSECRET_KEYとDEBUGのパラメータがHerokuのCongigurationとして認識されているの確認。

# ⑸ Gitコマンドの実行
# git add .
# git commit -m 'initial commit to heroku'
# git push heroku main // ビルド & デプロイ
# ※ 注意: main箇所は<GitHubのリポジトリに存在するブランチ名>。
# ※ requirements.txtで記述したモジュールを自動でインストールしてくれる。

# ⑹ remote:        https://<App name>.herokuapp.com/ deployed to Heroku のURLにアクセス

# ++++ Invalid HTTP_HOST の修正 ++++

# ⑴ 新しいURLをコピー

# ⑵ <Project名>/setting.py を編集
# ALLOWED_HOSTS = ['<新しいURL>']
# ※ 「https://」箇所と最後の「/」は削除

# ⑶ 再度デプロイし、URLにアクセス
# git add .
# git commit -m "added host url"
# git push heroku main
# /adminにアクセス

# **** migrationとsuperuserの生成 ****

# 本番環境では新たにPostgreSQLでDBを作っているので、再度migrationとsuperuserを作る必要がある。

# ⑴ heroku run python3 manage.py migrate

# ⑵ heroku run python3 manage.py createsuperuser
# - Username: bCNJPQc7
# - Email address: Enter
# - Password: nekoneko22

# ※本番環境なので、ある程度複雑なものにする。

# ⑶ /adminでログイン

# **** ダミーデータを作成 ****

# ここからtitleとcontentを拝借
# https://nextjs.org/learn/basics/data-fetching/blog-data

# **** デプロイされた本番環境用のWebアプリケーションとの連携 ****

# ⑴ PyCharmを起動

# ⑵ <Project名>/setting.pyで許可するサイトのオリジンをCORS_ORIGIN_WHITELISTに登録

# CORS_ORIGIN_WHITELIST = [
#     "http://localhost:3000", <CORSを許可するサイトのオリジン>
# ]

# ⑶ 変更をコミットし再デプロイ
# git add .
# git commit -m "added cors white list"
# git push herorku main

# ⑷ Webアプリケーションを開いて挙動を確認

# 例)
#・認証用のトークンが取得できているかどうか
# 検証ツール → Application → Storage → Cookie
#・一覧ページや詳細ページでAPIから取得されたデータがちゃんと表示されるか
#・新規作成, 更新, 削除機能がちゃんと機能するか

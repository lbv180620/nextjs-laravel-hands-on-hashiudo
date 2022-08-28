#todo [初期準備]

# ==== プロジェクト立ち上げ前の設定 ====

#* clientコンテナを起動する場合:
# ・docker-compose.ymlのclient関連をアンコメント
# ・Makefileの@make useradd-clientをアンコメント

#* MySQLのバージョン(5.7⇄8.0)を変更する場合
# ・Dockerfile
# ・my.cnf

#* PHPのバージョン変更を変更する
# ・Dockerfile

#* ファイルのdとfを削除
# ・env.d
# ・Makefile.env.f
# ・.gitignore
# ・Makefile

#* インフラを指定
# ・Makefile.env
# - os, ctr, web, db

#* env.exampleとdocker-compose.envに設定
# ・env.example
# - APP_SERVICE, DB_CONNECTION, DB_PORT
# ・docker-compose.env
# - DB_PORT, UID, UNAME, GID, GNAME

#* Laravelのバージョンを指定
# ・Makefile.env
# - laravel_version

# ------------

# make launch

# ------------

# マイグレーションできたら
# ・プロジェクト側にある.gitignoreファイルを移動
# ・APP_NAMEの変更
# ・Larvelのタイムゾーンなどの日本語化

# 文字コードが対応していない場合これをしないとエラーとなる
# app/Providers/AppServiceProvider.php
# use Illuminate\Support\Facades\Schema;

# public function boot()
# {
#      Schema::defaultStringLength(191);
# }

# ------------

# docker-compose.envの

# DB_HOST=db
# DB_PORT=3306
# DB_DATABASE=laravel_local
# DB_USERNAME=phper
# DB_PASSWORD=secret

# DBを作成したら、make up

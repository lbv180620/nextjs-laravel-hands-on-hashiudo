# App
# https://github.com/shonansurvivors/laravel-fargate-app

# Infra
# https://github.com/shonansurvivors/laravel-fargate-infra

# AWSの予測請求額を通知して想定外の費用発生を防ぐ
# https://blog.shonansurvivors.com/entry/aws-budgets


# ==== 第1章 Laravelアプリケーションの作成 ====

# https://github.com/shonansurvivors/laravel-fargate-app/tree/chapter-1


#~ 環境構築(Laravelのインストールまで)

# 環境構築
# https://github.com/shonansurvivors/docker-laravel

# Use this template
# git clone
# Makefile: laravel-install 8.* に修正
# make create-project

# localhost


# ----------------

#~ 簡単な認証機能の追加(Laravel Breezeのインストール)

# make install-breeze v=1.6.0
# or
# docker compose exec app composer require laravel/breeze --dev
# docker compose exec app php artisan breeze:install
# docker compose exec web npm install
# docker compose exec web npm run dev

# .gitignore 以下を追加
# /public/css
# /public/js
# /public/mix-manifest.json

# localhost

# ....................

#! Problem 1
#!     - laravel/breeze[v1.14.0, ..., 1.x-dev] require illuminate/console ^9.21 -> found illuminate/console[v9.21.0, ..., 9.x-dev] but these were not loaded, likely because it conflicts with another require.

# Can't install laravel breeze
# https://laracasts.com/discuss/channels/laravel/cant-install-laravel-breeze


# ----------------

#~ 既存のGitHubActionsのワークフローの削除

# 以下削除
# .github/workflows/laravel-create-project.yml
# .github/workflows/laravel-git-clone.yml


# ==== 第2章 Terraformのセットアップ ====

#~ tfenvでTerraformをインストール

# brew install terraform
# brew install tfenv


# tfenvでインストール可能なTerraformバージョンの確認
# tfenv list-remote

# tfenvを使ったTerraformのインストール
# tfenv install 1.0.0

# インストール済みおよび使用中のバージョンの確認
# tfenv list

# 使用するバージョンの切り替え
# tfenv use 1.0.0
# tfenv list


# ----------------

#~ AWS CLIのインストール

# aws --version

# brew install awscli


# ----------------

#~ IAMユーザーのアクセスキーIDとシークレットアクセスキーの確認

#^ AWSCLIで、あるIAMユーザーの権限で操作するには、そのIAMユーザーのアクセスキーIDとシークレットアクセスキーが必要です。


# AWSマネージメントコンソール → ログイン → IAM → ユーザー → hashiudo → 認証情報


#? AWSCLIでのアクセスキーIDとシークレットアクセスキーの利用方法について

# 先ほどのアクセスキーIDとシークレットアクセスキーを使えるようにAWSCLIに設定すると、AdministratorAccess権限でターミナルからAWSの操作をおこなうことができます。
# 具体的な設定方法としては、環境変数に設定する方法と、プロファイルに設定する方法があります。

# 環境変数に設定する場合は、ターミナルで以下のようにコマンドを実行します。
# $ export AWS_ACCESS_KEY_ID=XXX...
# $ export AWS_SECRET_ACCESS_KEY=XXX...
# $ export AWS_REGION=apnortheast1


# もうひとつの設定方法であるプロファイルを利用する場合は、上記のような一連の設定に名前を付けて呼び出すことができます。プロファイルを利用した方が管理しやすい。


# ----------------

#~ プロファイルの作成と設定

#* プロフィルの作成:

# $ aws configure profile <プロフィル名>
# 例) terraform, hashiudo

# コマンドを実行すると、最初に以下が表示されます。

# AWS Access Key ID [None]: <アクセスキーID>

# 入力が終わったら、ターミナルでエンターキーを押してください。
# 次に以下が表示されます。

# AWS Secret Access Key [None]: <シークレットアクセスキー>

# 入力が終わったら、ターミナルでエンターキーを押してください。
# 次に以下が表示されます。

# Default region name [None]: <apnortheast1>

#^ ここではapnortheast1(アジアパシフィック東京)と入力してエンターキーを押してください。

# 最後に以下が表示されます。

# Default output format [None]: <json>

#^ ここではjsonと入力してエンターを押してください。

# ここで設定したのは、AWSCLIを実行した結果の出力形式です。他にもtextなどが選択できます。


# ....................

#* プロファイルの確認:

# 以上で、一連の設定をひとまとめにしたプロファイルが新規作成されました。
# この段階ではプロファイルが作成されただけで、まだ使用する状態になっていません。
# 作成したプロファイルを使用するには、環境変数AWS_PROFILEにプロファイル名を設定します。

# 以下コマンドを実行してください。

# $ export AWS_PROFILE=<プロファイル名>

# 次に、以下コマンドを実行してください。

# $ aws configure list

# 現在使用中のプロファイルが、表形式で表示されます。

# profileと書かれた行のValue列の値が、先ほど作成したプロファイルの名前(terraform等)となっていれば問題ありません。


# ----------------

#~ tfstate管理用のS3バケットの作成


# Terraformでは、インフラの最新の状態をtfstateと呼ばれるファイルで管理します。
# このtfstateはデフォルトではローカルに保存されますが、チームでTerraformを扱う場合は、ローカルではなくチーム全員が参照・更新可能な場所に保存する必要があります。


# 読者の方は1人で本書のチュートリアルを進めていくでしょうから、tfstateをローカルに保存して進めることも可能かと思いますが、チーム開発などにも対応できるよう、tfstateをAWSのストレージサービスであるS3に保存していくようにします。
# なお、今回対応は見送りますが、Terraformでは複数人でのtfstateの更新が競合しないよう、DynamoDBを使ってロックをおこなう2こともできます。












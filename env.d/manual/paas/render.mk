#todo [Render Tips]

# Render
# https://render.com/

# docs
# https://render.com/docs


# --------------------

# 記事

# Heroku無料枠廃止で路頭に迷う開発者に捧ぐ、次世代PaaS「Render.com」の使い方
# https://qiita.com/mycndev/items/fc7a8fecd7d0b0d09828

#【誰でも簡単】RailsアプリをRender.comでデプロイする手順まとめ
# https://qiita.com/koki_73/items/60b327a586129d157f38

# 次世代Herokuと噂のRender.comで、Railsアプリをデプロイしてみる
# https://zenn.dev/katsumanarisawa/articles/c9da48652f399d

# 超神速でDjangoをRender.comにデプロイ!!【まさかの5分】ウサインボルトよりも速い！？
# https://django.baby/deploy-django-to-render-com/

# LaravelアプリをPaaSのRenderにデプロイする
# https://nextat.co.jp/staff/archives/286


# --------------------

# !!!! Heroku有料化 !!!!


# Deploy NestJS to Render

# https://www.udemy.com/course/nestjs-nextjs-restapi-react/learn/lecture/33696222#questions

# 2022/11月以降Herokuの無償プランが廃止になるため、2022/11月以降無償で進めたい場合は次のレクチャー20動画の0:00〜7:05の代わりに下記のRenderへのDeploy手順で進めてください。Renderで進める場合は、レクチャー20 0:00〜7:05の内容はスキップしてください。


# 1. NestJSのProjectをGitHubにPush (Lecture 20の 0:35〜1:33)

# 2.  render.comでGitHub認証で新規登録

# Render
# https://render.com/


# 3. renderのdashboardからPostgreSQL新規作成

# 4. 好きなDB名、Regionを選択してCreate
# 生成されるまで少し時間が掛かります.

# 5. 作成したDBのConnectionsのセクションからExternal Database URLの値をコピー

# 6. VS Codeの .envのDATABASE_URLにコピーした値を設定
# DockerのDATABASE_URLはコメントアウト

# 7. DashboardからNew Web Serviceをクリック

# 8. DeployしたいRepositoryをConnect


# 9.  好きなService名、Regionの選択及び、下記のBuild + Start Commandを入力

# Build Command yarn && yarn run build

# Start Command yarn run start:prod


# 10. Advancedで環境変数の追加

# JWT_SECRETは右端のgenerateボタンをクリックすると値が自動生成されます。

# DATABASE_URLは、前回コピーしたExternal Database URLの値


# 11. Create Web ServiceボタンクリックでDeploy開始


# 12. Deployが完了したら生成されたDomainにアクセス


# 13. VS CodeのTerminalでprisma migrateを実行し、Model構造をRenderのPostgresに反映させる。

# $ npx prisma migrate deploy


# 14. Lecture20の7:05に移動して、フロンドエンドのDeployに移ります。

# Renderは、defaultでauto deploy modeになっている為、以降 git pushすると自動的に再deployが実行されます。

# [注意] Lecture20の10:19でCORSにoriginを追加してheroku pushしている作業ですがRenderの場合はコード修正後 VS Code 左上でcommit, ターミナルで git push するだけで再deployが実行されますのでheroku関係の作業はスキップしてください。


# ....................

#! error TS2339: Property does not exist on type

# Typescript で Property does not exist on type などと言われたとき
# https://conocode.com/troubleshooting/typescript-property-does-not-exist-on-type/

# TS2339エラーの対処方法について
# https://qiita.com/shimajiri/items/2834749757292df3d570

# JavaScriptからTypeScriptへ移行した際に Property does not exist on type '{}'. で怒られた話
# https://qiita.com/entaku0818/items/7068cd9c62738d1d3981

# TypeScript Property ‘xxxxx’ does not exist on type T のエラーに対して in を使わない方が良い理由
# https://tamiblog.xyz/2022/03/26/post-3045/

# VueJS with typescriptでしばしば遭遇するProperty 'XXX' does not exist on type 'CombinedVueInstanceの解消法
# https://qiita.com/shunjikonishi/items/3774486d37af80d1ae47


# とりあえずの回避策:
# @ts-ignore


# --------------------

#? monorepo対応

# Monorepo Support
# https://render.com/docs/monorepo-support


# --------------------

#? Deploy a PHP Web App with Laravel and Docker

# Deploy a PHP Web App with Laravel and Docker
# https://render.com/docs/deploy-php-laravel-docker


# --------------------

#? MySQLを使用する方法

# Deploy MySQL
# https://render.com/docs/deploy-mysql


# --------------------

#? Redisを使用する方法


# --------------------

#? 無料の独自ドメイン SSL

# Configuring Cloudflare DNS
# https://render.com/docs/configure-cloudflare-dns

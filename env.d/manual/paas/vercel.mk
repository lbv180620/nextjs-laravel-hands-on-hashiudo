# **** Vercelにデプロイ ****

# https://vercel.com/login

# ⑴ mainブランチに切り替えて、ビルドする
# ⑵ GitHubにプロジェクトをpush
# ⑶ VercelにGitHubでログイン
# ⑷ New Project をクリック
# ⑸ デプロイするリポジトリをpublicにする
# ⑹ Add GitHub Accountをクリック → Repository access > Only select repositories > Select repositories → 追加するリポジトリを検索
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


# **** Tips ****

#? vercel ブランチ変更

#【Next.js】vercelでブランチ変更してデプロイする手順
# https://qiita.com/at_sushi/items/7c0ced5986aae42c20a5

# Settings → Git → Production Branch

# Vercelで指定のブランチのみデプロイを実行する
# https://sunday-morning.app/posts/2021-09-26-vercel-target-branch-deployment

# コンテンツの更新時にVercelでデプロイを行う
# https://www.newt.so/docs/tutorials/deploy-to-vercel-with-webhooks

# Vercel: 特定のブランチのみや、特定のディレクトリに変化があった場合のみビルドする (Ignored Build Step)
# https://zenn.dev/takeharu/scraps/943a9cb48b2c42

# Vercelのプレビューデプロイで特定のブランチ以外を無視する
# https://zenn.dev/catnose99/articles/b37104fc7ef214


# ........................

# 1. プロジェクトにシェルスクリプトを配置

# frontend/vercel-ignore-build-step.sh
# #!/bin/bash

# echo "VERCEL_GIT_COMMIT_REF: $VERCEL_GIT_COMMIT_REF"

# if [[ "$VERCEL_GIT_COMMIT_REF" == "product" || "$VERCEL_GIT_COMMIT_REF" == "main" ]] ; then
#   # Proceed with the build
#   echo "✅ - Build can proceed"
#   exit 1;

# else
#   # Don't build
#   echo "🛑 - Build cancelled"
#   exit 0;
# fi


# 2. VercelのダッシュボードでIgnored Build Stepを設定

# Settings → Git → Ignored Build Step

# bash vercel-ignore-build-step.sh


# --------------------

#? 独自ドメインに変更

# Vercelにデプロイしたアプリに独自ドメインを紐づけてみた
# https://www.miracleave.co.jp/contents/1279/post-1279/

# Vercel のサイトに独自ドメインのサブドメインを割り当てる
# https://crieit.net/posts/vercel-setting-subdmain-20210829

# Vercelでデプロイしたサイトに独自ドメインのサブドメインを設定する
# https://blog.okaryo.io/20220320-vercel-deploy-with-custom-domain

#? Domains

# herokuapp.com

# vercel.app

# onrender.com

# fly.dev

# railway.app


# ----------------

#? デプロイする際の注意

# APIとSPAを同じGitHubリポジトリで管理し、同じPaaSを使ってデプロイする場合、pushする際にいちいち、
# git remote rm heroku
# heroku git:remote -a <Herokuアプリ名>
# で切り替えないといけない。


# ----------------

#? 環境変数

#* nextjs-laravel-hands-on

# API(Heroku)

# APP_BASE=backend
# APP_DEBUG=false
# APP_ENV=production
# APP_KEY=base64:Q4+6AUlDcZCOL+i3AzUl5TPFKxf2umD+hJlreX5n7gU=
# APP_URL=https://nextjs-laravel-hands-on.herokuapp.com
# CLEARDB_DATABASE_URL=mysql://bc9cc1e5ea3f13:2ed4a549@us-cdbr-east-06.cleardb.net/heroku_44e3acdada217bc?reconnect=true
# DATABASE_URL=mysql://bc9cc1e5ea3f13:2ed4a549@us-cdbr-east-06.cleardb.net/heroku_44e3acdada217bc?reconnect=true
# DB_CONNECTION=cleardb
# DB_HOSTNAME=us-cdbr-east-06.cleardb.net
# DB_NAME=heroku_44e3acdada217bc
# DB_PASSWORD=2ed4a549
# DB_PORT=3306
# DB_USERNAME=bc9cc1e5ea3f13
# LOG_CHANNEL=errorlog
# REDIS_TLS_URL=rediss://:pdd12b9bcfbb6e428fd521d160ade3c028281411bcb20a8606e5946d7372a1127@ec2-54-243-193-150.compute-1.amazonaws.com:12760
# REDIS_URL=redis://:pdd12b9bcfbb6e428fd521d160ade3c028281411bcb20a8606e5946d7372a1127@ec2-54-243-193-150.compute-1.amazonaws.com:12759
# SANCTUM_STATEFUL_DOMAINS=nextjs-laravel-hands-on-hashiudo.vercel.app
# SESSION_DOMAIN=.vercel.app
# SESSION_DRIVER=redis
# SESSION_LIFETIME=120


# SPA(Heroku|Vercel)

# APP_BASE=frontend
# NEXT_PUBLIC_API_URL=<APIのURL>

# ----------------

# お金をかけないでプロダクトを開発していく
# https://zenn.dev/shimakaze_soft/scraps/dfffadd8f4a2fb

# Node-RED実行環境としてHerokuの代替え先について検討してみた
# https://qiita.com/kitazaki/items/970a10cbd1059c89aca5

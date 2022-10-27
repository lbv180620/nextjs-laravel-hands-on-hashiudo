#! テーブルを永続化できない問題
# npx prisma db push

# Next.js, Prisma, PostgreSQL, Dockerによるフルスタックアプリケーションの環境構築
# https://qiita.com/higemegane1992/items/f933209de3015ccb888e

# DATABASE_URL="postgresql://phper:secret@localhost:5432/nestjs?schema=public"
# ⬇️
# DATABASE_URL="postgresql://phper:secret@db:5432/nestjs?schema=public"

#^ DATABASE_URLのdbは、docker-compose.ymlで指定したPostgreSQLのサービス名と統一してください。


# --------------------

#! Error: P1001: Can't reach database server at `db`:`5432`

# DockerでPrismaのマイグレーションが実行できない
# https://qiita.com/Ryo9597/questions/17fbcac39569b580e677

# Dockerを利用してNestJS＋Prisma+MySQLの環境構築をしてテーブル作成をしてみる
# https://qiita.com/Yosuke_Narumi/items/5dd9225bb71d30b1890f

# 推測:
# hostをdbとしたい場合は、webコンテナも立ち上げる必要があり、docker compose exec app npx prisma db pushとする。
# そうでないなら、localhostとするしかないが、その場合はvolumeが使えないので、データが永続化されない。

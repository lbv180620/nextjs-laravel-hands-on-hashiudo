# ==== laravel-sns ====

# table users {
#   id "bigint unsigned" [not null, pk, increment, note:'pk:ユーザーを識別するID']
#   name string [not null, unique, note:'ユーザー名']
#   email striing [not null, unique, note:'メールアドレス']
#   password string [null, note:'パスワード']
#   remember_token string [null, note:'このカラムに値があると時間が経っても自動的にログアウトされない']
#   created_at timestamp [not null, default:`CURRENT_TIMESTAMP`, note:'作成日時']
#   updated_at timestamp [not null, default:`CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP`, note:'更新日時']
# }

# table articles {
#   id "bigint unsigned" [not null, pk, increment, note:'pk:記事を識別するID']
#   user_id "bigint unsigned" [not null, note:'fk:記事を投稿したユーザーのID']
#   title string [not null, note:'記事のタイトル']
#   body string [not null, note:'記事の本文']
#   created_at timestamp [not null, default:`CURRENT_TIMESTAMP`, note:'作成日時']
#   updated_at timestamp [not null, default:`CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP`, note:'更新日時']
# }

# table likes {
#   id "bigint unsigned" [not null, pk, increment, note:'pk:いいねを識別するID'] // 無くてもいい
#   user_id "bigint unsigned" [not null, note:'fk:いいねしたユーザーのID']
#   article_id "bigint unsigned" [not null, note:'fk:いいねされた記事のID']
#   created_at timestamp [not null, default:`CURRENT_TIMESTAMP`, note:'作成日時'] // 無くてもいい
#   updated_at timestamp [not null, default:`CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP`, note:'更新日時'] // 無くてもいい
# }

# table tags {
#   id "bigint unsigned" [not null, pk, increment, note:'pk:タグを識別するID']
#   name string [not null, unique, note:'タグ名']
#   created_at timestamp [not null, default:`CURRENT_TIMESTAMP`, note:'作成日時']
#   updated_at timestamp [not null, default:`CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP`, note:'更新日時'] // 無くてもいい
# }

# table article_tags {
#   id "bigint unsigned" [not null, pk, increment, note:'pkタグの紐付けを識別するID'] // 無くてもいい
#   article_id "bigint unsigned" [not null, note:'fk:タグが付けられた記事のID']
#   tag_id "bigint unsigned" [not null, note:'記事に付けられたタグのID']
#   created_at timestamp [not null, default:`CURRENT_TIMESTAMP`, note:'作成日時'] // 無くてもいい
#   updated_at timestamp [not null, default:`CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP`, note:'更新日時'] // 無くてもいい
# }

# table follows {
#   id "bigint unsigned" [not null, pk, increment, note:'pk:フォロワー・被フォローの紐付けを識別するID']
#   follower_id "bigint unsigned" [not null, note:'fk:フォロワーのユーザーID']
#   followee_id "bigint unsigned" [not null, note:'fk:フォローされている側のユーザーID']
#   created_at timestamp [not null, default:`CURRENT_TIMESTAMP`, note:'作成日時']
#   updated_at timestamp [not null, default:`CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP`, note:'更新日時']
# }


# Ref: "users"."id" < "articles"."user_id"

# Ref: "users"."id" < "likes"."user_id"

# Ref: "articles"."id" < "likes"."article_id"

# Ref: "articles"."id" < "article_tags"."article_id"

# Ref: "tags"."id" < "article_tags"."tag_id"

# Ref: "users"."id" < "follows"."follower_id"

# Ref: "users"."id" < "follows"."followee_id"

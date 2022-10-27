# DBML
# https://www.dbml.org/docs/#project-definition

# users(id) 1 : n posts(user_id)

# posts側から見ると、ある記事を投稿したユーザーはuser_idを見れば一意に特定できる → 相手は1
# Post.php $this->belongsTo() → 1:n

# users側から見ると、あるユーザーが投稿した記事は多数ある可能がある → 相手はn
# User.php $this->hasMany() → n:1


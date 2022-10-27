#todo 7. AWS CLI 導入

# pip3 install awscli

# aws --version

# -------------------

# mkdir ~/.aws
# cd ~/.aws
# sudo vim config


#^ --- 書式 ---
#^ [profile <プロファイル名>]
#^ region=<リージョン>
#^ output=<出力形式>

#^ 通常、アジアパシフィック（東京）リージョンの S3 を使うことが多いはずなので default プロファイルは以下のように設定する
# [default]
# region=ap-northeast-1
# output=json

#^ 別リージョン・出力形式のプロファイルが必要な場合は以下のように記述
#^ ※以下のプロファイルを指定して aws cli を実行する場合は
#^ $ aws <command> --profile example
# [profile example]
# region=us-east-1
# output=text

# -------------------

# sudo vim credentials

#^ --- 書式 ---
#^ [<プロファイル名>]
#^ aws_access_key_id=<IAM アクセスキー>
#^ aws_secret_access_key=<IAM シークレットアクセスキー>

#^ default プロファイルの例
#^ アクセスキーは自分の IAM アクセスキーを記述すること
# [default]
# aws_access_key_id=AKIAIOSFODNN7EXAMPLE
# aws_secret_access_key=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY

#^ example プロファイルを定義する場合
#^ ※リージョン・出力形式の設定と違い、接頭辞 profile は不要のため注意
#^ ※以下のプロファイルを指定して aws cli を実行する場合は
#^ $ aws <command> --profile example
# [example]
# aws_access_key_id=AKIAI44QH8DHBEXAMPLE
# aws_secret_access_key=je7MtGbClwBF/2Zp9Utk/h3yCo8nvbEXAMPLEKEY

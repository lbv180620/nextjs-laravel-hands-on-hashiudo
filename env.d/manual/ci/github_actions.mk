#todo [CI/CDパイプライン Tips]

# **** Github Actions ****

# https://docs.github.com/ja/actions

# 記事
# https://zenn.dev/nus3/articles/44977a5ea4d6cd
# https://zenn.dev/hashito/articles/7c292f966c0b59
# https://selfnote.work/20220109/programming/begginer-github-actions/
# https://qiita.com/bigwheel/items/2ab7deb237122db2fb8d
# https://qiita.com/zomaphone/items/7e6c3db6b3670f10e23d
# https://zenn.dev/panyoriokome/scraps/dbf23d2327a8cc

# ----------------

# ? CircleCIとGithub Actionsの比較
# https://zenn.dev/nus3/articles/44977a5ea4d6cd


# ----------------

#? monorepoに対応する方法

# https://zenn.dev/panyoriokome/scraps/dbf23d2327a8cc
# https://blog.takuchalle.dev/post/2020/02/20/github_actions_change_directory/
# https://www.bioerrorlog.work/entry/github-actions-default-workspace
# https://www.bioerrorlog.work/entry/github-actions-default-workspace
# https://gist.github.com/yuya-takeyama/47fb261625e67c8efabadcf8c6f237ef
# https://sunday-morning.app/posts/2021-09-07-monorepo-github-actions
# https://qiita.com/watta10/items/e9b3e03f304f6ba5ff9b
# https://tech-blog.homura10059.dev/posts/2022-06-25-1


# ----------------

#? GitHub Actionsにおけるpathsとpaths-ignore

# https://qiita.com/nacam403/items/3e2a5df5e88ba20aa76a


# ==== エラー集 ====

#! apt-get updateでthe public key is not available: NO_PUBKEY の対処法

# 記事
# https://isgs-lab.com/340/
# https://www.omgubuntu.co.uk/2017/08/fix-google-gpg-key-linux-repository-error
# https://hibiki-press.tech/dev-env/apt-update-gpg/1976
# https://qiita.com/ReoNagai/items/777885f8e704028f3ab9
# https://level69.net/archives/31292
# https://zenn.dev/gomo/articles/7f6c28d002837c
# https://pyopyopyo.hatenablog.com/entry/20180514/p1

# wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
# sudo apt-get update


# ----------------

#! Unexpected environment preparation error の対処法

# 記事
# https://qiita.com/shuhei_m/items/70549a64617eee47f9fb

#^ Docker Desktopのバージョンによってこのエラーが発生してしまい、4.2.0までグレードダウンさせればエラーは発生しなくなる

# Docker Desktop 4.5.0 (74594)

# Docker Engine
# v20.10.12
# {
#   "default-address-pools": [
#     {
#       "base": "172.16.0.0/12",
#       "size": 24
#     }
#   ],
#   "features": {
#     "buildkit": true
#   },
#   "experimental": false,
#   "builder": {
#     "gc": {
#       "enabled": true,
#       "defaultKeepStorage": "20GB"
#     }
#   }
# }

# Docker for Macの旧バージョンをインストールする
# https://qiita.com/A-Kira/items/8ae66838b019683704d1


# ==== GitHub Actions CI ====

# **** GitHub Actions 自動テスト ****

# https://qiita.com/blue32a/items/0661d70216051ad6552d
# https://qiita.com/ucan-lab/items/237d2058eb46ab657ae3
# https://qiita.com/dosukoi_android/items/a3464548b3aa293c62dd
# https://www.techpit.jp/courses/200/curriculums/203/sections/1344/parts/5412
# https://zenn.dev/tokku5552/articles/laravel-github-actions
# https://maasaablog.com/development/git/github/github-actions/2054/
# https://www.google.com/amp/s/iret.media/56258/amp
# https://zenn.dev/tokku5552/articles/create-php-env-with-cfn
# https://docs.github.com/ja/actions/using-workflows/workflow-syntax-for-github-actions
# https://qiita.com/HeRo/items/935d5e268208d411ab5a
# https://zenn.dev/snowcait/scraps/9d9c47dc4d0414
# https://gkzz.dev/posts/github-actions-tips/
# https://techracho.bpsinc.jp/wingdoor/2020_07_03/93868
# https://qiita.com/kai_kou/items/c9dc50a4967d746c145a
# https://www.seeds-std.co.jp/blog/creators/2020-08-19-233031/

# **** GitHub Actions 静的解析ツール ****

# https://www.ritolab.com/entry/213
# https://r-tech14.com/reviewdog/
# https://techblog.roxx.co.jp/?page=1600354001


# **** GitHub Actions Laravel Dusk ****

# 記事
# https://laravel-news.com/laravel-dusk-github-actions


# ==== GitHub Actions CD ====

# **** Github Actions + Heroku ****

# 記事
# https://qiita.com/ProjectEuropa/items/33b1054674f117f27bdf


# **** Github Actions + AWS ****

# 記事
# https://zenn.dev/tokku5552/articles/laravel-github-actions
# https://qiita.com/kai_kou/items/1e61572e8f432bfd6579


# **** Github Actions + AWS Fargate + Terraform ****

# https://github.com/shonansurvivors/laravel-fargate-app
# https://github.com/shonansurvivors/laravel-fargate-infra

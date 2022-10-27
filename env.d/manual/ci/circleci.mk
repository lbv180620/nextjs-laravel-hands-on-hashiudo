#todo [CI/CDパイプライン Tips]

# **** CircleCI ****

# https://circleci.com/docs/ja

# 認証画面
# https://circleci.com/ja/vcs-authorize/

# Orbs
# https://circleci.com/developer/ja/orbs

# version - Circle公式ドキュメント
# https://circleci.com/docs/ja/configuration-reference#version

# jobs - Circle公式ドキュメント
# https://circleci.com/docs/ja/configuration-reference#jobs

# docker - Circle公式ドキュメント
# https://circleci.com/docs/ja/configuration-reference#docker


# 記事
# https://qiita.com/kodokunadancer/items/cda4747a10924af476a2
# https://qiita.com/gold-kou/items/4c7e62434af455e977c2


# ----------------

#? CircleCIのconfig.ymlのエラー対処方法

# 記事
# https://snowsystem.net/cloud/circleci/circleci-error-1


# ----------------

#? ディレクトリ階層深めのアプリケーションでのCircleCIの設定方法

# 参考記事
# https://qiita.com/youdie/items/195cb6eabe1e0cf31142
# https://qiita.com/tegnike/items/431f8ce77fc565b75fb3
# https://panda-program.com/posts/how-to-introduce-circle-ci-to-laravel
# https://github.com/lbv180620/rails-docker-hashiudo/blob/main/.circleci/config.yml
# https://qiita.com/wasnot/items/b2543faa4b8ed6082936
# https://zenn.dev/taiga248/articles/monorepo_circleci
# https://blog.recruit.co.jp/rmp/dev-tools/post-14868/
# https://zenn.dev/hibriiiiidge/books/49ee4063b10cec1df1a2/viewer/9de6444f6d1e5d1d9857

# working_directory
# https://www.engilaboo.com/circleci-working-directory/

# working_directoryにソースコードを配置する
# working_directoryはデフォルトでは~/project名に設定されている


# ----------------

#? CI用の環境内に.envファイルを生成する方法

# https://circleci.com/docs/ja/env-vars
# https://zenn.dev/tmasuyama1114/articles/circleci-first-config
# https://qiita.com/godan09/items/ce4f982109fd82b0596b
# https://teratail.com/questions/233024
# https://sunday-morning.app/posts/2019-12-07-nuxt-dotenv-module-circleci
# https://casualdevelopers.com/tech-tips/how-to-use-dotenv-with-base64-on-circleci/
# https://dev.classmethod.jp/articles/retrieve-circleci-env/
# https://betit0919.hatenablog.com/entry/2020/01/21/173210


# ----------------

#? circleciでgithubのブランチ毎にfirebaseへのデプロイ先を切り替える方法
# https://snowsystem.net/cloud/firebase/circleci-github-deploy/#


# ----------------

# ? CircleCIとGithub Actionsの比較
# https://zenn.dev/nus3/articles/44977a5ea4d6cd


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


# ==== CircleCI CI ====

# **** CircleCI Hello World ****

# 元記事
# https://www.techpit.jp/courses/78/curriculums/81/sections/615/parts/2084

# ⑴ CircleCIにGitHubアカウントでログイン

# ⑵ 指定のリポジトリ横の「Set Up Project」をクリック

# ⑶ Select your config.yml file
# 以下のいずれかにチェックし、「Set Up Project」をクリック
# - 手動で.circleci/config.ymlを作成した場合 → Fastest
# - ??? → Faster
# - config.ymlのテンプレを作成する場合 → Fast

# Fastにチェックした場合:
# ⑷ テンプレを選択: PHP

# ⑸ テンプレを編集:

# .circleci/config.yml
# version: 2.1
# jobs:
#   build:
#     docker:
#       - image: circleci/php:7.3-node-browsers
#     steps:
#       - run: echo "Hello World"

# ⑹ 「Commit and Run」をクリック

# GitHubリポジトリにcircleci-project-setupという名前のブランチが作られ、CircleCIの処理が開始される。
# circleci-project-setupブランチに.circleci/config.ymlが生成される。

# ⑺ Pipelinesメニューの画面が表示

# ※ 初回は自動で「Add .circleci/config.yml」というコミットメッセージのコミットが自動でGitHubリポジトリのcircleci-project-setupブランチにpushされる。
# → なので、Pipelineが2つ表示される。

# ⑻ CircleCIの実行結果を確認

# 以下の2つのstepが自動で実行される。
# Spin Up Environment: Dockerコンテナの起動
# Preparing Environment Variables: 環境変数の準備

# ⑼ GitHubからCircleCIの処理結果を確認
# circleci-project-setupからの「Compare & pull request」をクリック

# ⑽ mainブランチにマージし、git pullでローカルリポジトリに反映


# **** CircleCI 自動テスト ****

# 元記事
# https://www.techpit.jp/courses/78/curriculums/81/sections/617/parts/2098
# https://github.com/shonansurvivors/laravel-ci/tree/chapter-3

# ⑴ .circleci/config.ymlを編集

# .circleci/config.yml
# version: 2.1
# jobs:
#   build:
#     docker:
#       - image: circleci/php:7.3-node-browsers
#     steps:
#       - checkout
#       - run: sudo composer self-update --1
#       - run: composer install -n --prefer-dist
#       - run: npm ci
#       - run: npm run dev
#       - run:
#           name: php test
#           command: vendor/bin/phpunit


# ................

#~ checkout

# steps:
#   - checkout

# checkoutは、GitHubからCircleCIの環境にソースコードをコピー(git clone)してきます。

# checkout - Circle公式ドキュメント
# https://circleci.com/docs/ja/configuration-reference#checkout


# ................

#~ sudo composer self-update --1

# 2020年10月下旬よりCircleCIでは条件によってはPHP関連パッケージのインストール(この次のステップで実施)がエラーになり始めました。

# そうしたエラーを回避するための処理となります。


# circleciでLaravelのプロジェクトのCIが落ちるようになった - Qiita
# https://qiita.com/tabtt3/items/996e512e7002e9f26b0a


# ................

#~ PHP関連パッケージのインストール

# - run: composer install -n --prefer-dist


# ここでは、PCの開発環境を構築した時と同様に、Composerを使用してPHP関連パッケージをインストールします。

# ひとつ前のステップでは、CircleCIの環境にはGitHubからソースコードをコピーしてきただけなので、LaravelのフレームワークのコードなどPHP関連パッケージが存在しません。

# CircleCIで実施するテストでは、あなたのPCのローカル環境で実施するテストとは違って、このように必要なパッケージを毎回インストールしなければならないということを覚えておいてください。


# ................

#~ JavaScriptの各種パッケージのインストール

# - run: npm ci

# このステップでは、PCの開発環境を構築した時と同様に、npmを使用してJavaScript関連パッケージをインストールします。


# ................

#~ JavaScriptのトランスパイル

# - run: npm run dev


# このステップでは、PCの開発環境を構築した時と同様に、JavaScriptのトランスパイルを行なっています。


# ................

#~ テストの実行ステップの追加

# - run:
#     name: php test
#     command: ./vendor/bin/phpunit


# テストを実行します。


# 省略形でない記法では、runの後にnameやcommandを定義します。
# nameは、CircleCIの画面に表示されるステップ名となります。省略すると、commandの内容がそのままステップ名として表示されます。
# commandには、実行するシェルのコマンドを定義します。


# run - Circle公式ドキュメント
# https://circleci.com/docs/ja/configuration-reference#run


# ----------------

#? CircleCIでの環境変数について

#! このままではCircleCIでのテストは失敗します。CircleCI上でのPHPUnitの処理で以下のエラーが発生するからです。

#! RuntimeException: No application encryption key has been specified.

# これは、環境変数APP_KEYが存在しないことで発生するエラーです。
# なぜ、このエラーが発生してしまうかというと、PCの開発環境には用意していた.envは、CircleCIの実行環境では存在しないからです。
# → .gitignoreで、.envファイルを管理から外しているから。

# そのため、あなたが作ったGitHubのリポジトリにも.envは存在しません。

# CircleCIは、GitHubのリポジトリからソースコードをコピーしてくるので、CircleCIの実行環境上には.envが存在しないということになるわけです。

# この問題を解消する方法として、以下の2つがあります。

#& ①CircleCIの管理画面で、環境変数(APP_KEY)を設定する
#& ②自動テスト用の環境変数ファイル(.env.testing)を用意し、.gitignoreから外してソースと一緒にpushする


# APP_KEYは、Laravelでの暗号化等の処理に使用されるものなので、ファイルとしてGitHub上に存在させずに、CircleCIの管理画面で設定した方が一般に安全です。

# ただし、テスト用に用意したAPP_KEYが、本番環境やその他の環境で使用しないテスト専用なのであれば、ファイル化してGitHub上で存在させても危険性は無いと考えられます。


# ----------------

# ⑵ テスト用の環境変数ファイルの作成

# 1. env/docsから.env.testingをコピーして、ソースルート直下に配置

# 2. APP_KEYにキーを生成

# 方法①: make keyenv env=testing
keyenv:
	docker compose exec $(ctr) php artisan key:generate --env=$(env)

# 方法②: make keyshow → コンソールに表示されたキーをコピーして貼り付け
keyshow:
	docker compose exec $(ctr) php artisan --no-ansi key:generate --show


# PHPUnitは、Laravelインストール後のデフォルトの設定では、.env.testingというファイルが存在すると、そちらを.envの代わりに環境変数ファイルとして使用するようになっています。
# 今後、あなたのPCや、CircleCIで実行するテストでは、この.env.testingが環境変数ファイルとして使用されるようになります。


# ................

#~ phpunit.xmlについて

#^ PHPUnitの設定では、.env.testing内の環境変数のうちデータベース関連の環境変数は、phpunit.xmlの内容が優先される。
#^ 優先順: docker-compose.yml > phpunit.xml > .env.testing


# **** CirclecCI キャッシュ ****

# https://www.techpit.jp/courses/78/curriculums/81/sections/617/parts/2100


# ----------------

#& PHP関連のパッケージのキャッシュ


# .circleci/config.yml
# version: 2.1
# jobs:
#   build:
#     docker:
#       - image: circleci/php:7.3-node-browsers
#     steps:
#       - checkout
#       - run: sudo composer self-update --1
#       - restore_cache:
#           key: composer-v1-{{ checksum "composer.lock" }}
#       - run: composer install -n --prefer-dist
#       - save_cache:
#           key: composer-v1-{{ checksum "composer.lock" }}
#           paths:
#             - vendor
#       - run: npm ci
#       - run: npm run dev
#       - run:
#           name: php test
#           command: vendor/bin/phpunit


# ................

#~ restore_cache

# - restore_cache:
#     key: composer-v1-{{ checksum "composer.lock" }}

# restore_cacheでは、保存されたキャッシュを復元します。

# keyには、復元するキャッシュの名前を指定します。

# その名前のキャッシュが存在すれば、以下のようにFound a cache...(キャッシュが見つかった)となり、キャッシュが復元されます。


# Found a cache from build 43 at composer-v1-Ll2iLt7gIJrDlzkiVJ5VLPoRVCfsXdodzAHiljMy+VM=
# Size: 9.5 MiB
# Cached paths:
#   * /home/circleci/project/vendor

# Downloading cache archive...
# Validating cache...

# Unarchiving cache...


# その名前のキャッシュが存在しなければ、以下のようにNo cache is found...(キャッシュは見つからなかった)となり、何も処理はされません。


# No cache is found for key: composer-v1-Ll2iLt7gIJrDlzkiVJ5VLPoRVCfsXdodzAHiljMy+VM=


# restore_cache - CircleCI公式
# https://circleci.com/docs/ja/configuration-reference#restore_cache


# ................

#~ キャッシュが復元された場合のcomposer install

# restore_cacheのステップの次は、ComposerによってPHP関連パッケージのインストールを行うステップがあります。

# - run: composer install -n --prefer-dist


# その手前のrestore_cacheステップで、もしキャッシュが見つかれば、vendorディレクトリにPHP関連のパッケージが復元されます。

# この場合、composer installコマンドの実行結果は以下のようになります。


# Loading composer repositories with package information
# Installing dependencies (including require-dev) from lock file
# Nothing to install or update
# Generating optimized autoload files
# > Illuminate\Foundation\ComposerScripts::postAutoloadDump
# > @php artisan package:discover --ansi
# Discovered Package: barryvdh/laravel-debugbar
# Discovered Package: facade/ignition
# Discovered Package: fideloper/proxy
# Discovered Package: laravel/socialite
# Discovered Package: laravel/tinker
# Discovered Package: nesbot/carbon
# Discovered Package: nunomaduro/collision
# Package manifest generated successfully.
# CircleCI received exit code 0


# Nothing to install or update(インストールや更新はしなかった)とあり、PHP関連のパッケージのインストール処理は行われません。

# その分だけ、このステップの処理時間は短縮されます。


# ................

#~ save_cache


# - save_cache:
#     key: composer-v1-{{ checksum "composer.lock" }}
#     paths:
#       - vendor


# save_cacheでは、keyに指定した名前でキャッシュを保存します。

# 保存するディレクトリ名やファイル名はpathsに指定します。

# ここでは、ComposerによってPHP関連のパッケージがインストールされるディレクトリであるvendorを指定しています。


# ................

#~ save_cacheのkey

# keyに指定する名前はどんな名前でも良いのですが、Composerによってインストールしたパッケージのキャッシュであることがわかるよう先頭にcomposerを付けました。

# その後にはv1と付けています。

# CircleCIでは、キャッシュを約1ヶ月保存してくれますが、意図的にキャッシュをクリアする方法はありません。

# 既に保存済みのキャッシュを無視して、新たにキャッシュを保存し直したい時はkeyに指定する名前を変える必要があります。

# そんな時のために名前を変更できるよう、あらかじめv1といった部分を名前に含めています。

# そして、もしキャッシュを保存し直したい時はv2, v3と名前を変えていけるようにしています。


# ................

#~ checksum

# {{ checksum "composer.lock" }}という部分は、CircleCIのテンプレート機能を使用しています。

# {{ checksum "ファイル名" }}とすることで、ファイルをハッシュ化した値を算出しています。

# 一例として、その算出結果は以下のような値になります。


# Ll2iLt7gIJrDlzkiVJ5VLPoRVCfsXdodzAHiljMy+VM=


# composer.lockでは、Composerによってインストールされた各パッケージのバージョンが、依存パッケージも含め管理されています。

# そこで、composer.lockファイルのハッシュ値を、キャッシュのkeyに含めています。

# もし、composer.lockに変更があれば、算出されるハッシュ値も異なったものとなり、キャッシュのkeyとして違った名前になります。

# その結果、restore_cacheでは、保存済みのキャッシュ(vendorディレクトリ)が復元されることはありません。

# そして、次のステップのcomposer instalでvendorディレクトリが作成されるとともにPHP関連のパッケージがインストールされます。


# 言い換えると、

#^ - composer.lockに変更が無い限りは、restore_chacheでは「前回以前のCircleCI実行時のsave_cacheで保存されたキャッシュ」を復元する
#^ - composer.lockに何か変更があれば、restore_chacheではキャッシュを復元せず、save_cacheで新しいkeyにてキャッシュを保存し直す

# といった動きになります。


# ................

#~ save_cacheのpaths

# - save_cache:
#     key: composer-v1-{{ checksum "composer.lock" }}
#     paths:
#       - vendor


# save_cacheでは、pathsに指定したディレクトリやファイルをキャッシュとして保存します。

# 2つ前のrestore_cacheステップでキャッシュが見つからなかった場合は、1つ前のcomposer installのステップでvendorディレクトリが作成され、そこにPHP関連のパッケージがインストールされます。

# そして、save_cacheのステップでは、そのvendorディレクトリをキャッシュとして保存します。

# 以下は、キャッシュが保存された場合のCircleCIの処理結果の例です。

# Stored Cache to...(キャッシュを保存)とある通り、キャッシュの保存処理が行われたことがわかります。


# Creating cache archive...
# Uploading cache archive...
# Stored Cache to composer-v1-Ll2iLt7gIJrDlzkiVJ5VLPoRVCfsXdodzAHiljMy+VM=
#   * /home/circleci/project/vendor


# なお、save_cacheステップのkeyで指定した名前と同じキャッシュが既に存在する場合、つまりrestore_cacheステップでキャッシュが見つかった場合はキャッシュの上書き保存などは行われません。

# 以下は、その実行例です。

# Skipping cache generation, cache already exists...(キャッシュが既に存在するので、キャッシュの作成はスキップします)とある通り、キャッシュの保存処理が行われなかったことがわかります。


# Skipping cache generation, cache already exists for key: composer-v1-Ll2iLt7gIJrDlzkiVJ5VLPoRVCfsXdodzAHiljMy+VM=
# Found one created at 2020-03-28 04:22:47 +0000 UTC


# ----------------

#& JavaScript関連のパッケージのキャッシュ

# https://www.techpit.jp/courses/78/curriculums/81/sections/617/parts/2101


# version: 2.1
# jobs:
#   build:
#     docker:
#       - image: circleci/php:7.3-node-browsers
#     steps:
#       - checkout
#       - run: sudo composer self-update --1
#       - restore_cache:
#           key: composer-v1-{{ checksum "composer.lock" }}
#       - run: composer install -n --prefer-dist
#       - save_cache:
#           key: composer-v1-{{ checksum "composer.lock" }}
#           paths:
#             - vendor
#       - restore_cache:
#           key: npm-v1-{{ checksum "package-lock.json" }}
#       - run:
#           name: npm ci
#           command: |
#             if [ ! -d node_modules ]; then
#               npm ci
#             fi
#       - save_cache:
#           key: npm-v1-{{ checksum "package-lock.json" }}
#           paths:
#             - node_modules
#       - run: npm run dev
#       - run:
#           name: php test
#           command: vendor/bin/phpunit


# ................

#~ restore_cacheとsave_cache


# - restore_cache:
#     key: npm-v1-{{ checksum "package-lock.json" }}

# - save_cache:
#     key: npm-v1-{{ checksum "package-lock.json" }}
#     paths:
#       - node_modules


# restore_cacheにより、保存されたキャッシュを復元します。
# save_cacheにより、pathsに指定したnode_modulesをキャッシュに保存します。

# keyについては、npmによってインストールされたパッケージのキャッシュであることがわかるようにするため、先頭にnpmと付けることにしました。

# package-lock.jsonでは、npmによってインストールされた各パッケージのバージョンが、依存パッケージも含め管理されています。


# もし、package-lock.jsonに変更があれば、{{ checksum "package-lock.json" }}によって算出されるハッシュ値も異なったものとなり、キャッシュのkeyとして違った名前になります。

# その結果、

#^ - package-lock.jsonに変更が無い限りは、restore_chacheでは「前回以前のCircleCI実行時のsave_cacheで保存されたキャッシュ」を復元する
#^ - package-lock.jsonに何か変更があれば、restore_chacheではキャッシュを復元せず、save_cacheで新しいkeyにてキャッシュを保存し直す

# といった動きになります。


# ................

#~ シェルスクリプトのif文の利用

# - restore_cache:
#     key: npm-v1-{{ checksum "package-lock.json" }}
# - run:
#     name: npm ci
#     command: |
#       if [ ! -d node_modules ]; then
#         npm ci
#       fi


# command: |

# CircleCIのcommandに複数行に渡ってコマンドを記述する時は、まず最初に|を記述し、次の行からコマンドを記述します。


# if 条件式; then
#   条件式がtrueの時に実行する処理
# fi


# if [ ! -d node_modules ]; then
#   npm ci
# fi

# node_modulesというディレクトリが存在しない場合のみ、npm ciが実行されます。

#^ なぜ、このような条件を付けているかというと、npm ciコマンドでは、パッケージをインストールする前にいったんnode_modulesディレクトリを削除してしまうからです。


# もし、何も条件を付けずに、

# - restore_cache:
#     key: npm-v1-{{ checksum "package-lock.json" }}
# - run: npm ci

# といったようにnpm ciを実行すると、restore_cacheでnode_modulesをキャッシュから復元できたとしても、直後にnpm ciで削除されてしまい、キャッシュを使っている意味が無くなってしまいます。

# そのため、if文による条件を追加しています。


# if 文と test コマンド
# https://shellscript.sunone.me/if_and_test.html#if-%E6%96%87%E3%81%A8-test-%E3%82%B3%E3%83%9E%E3%83%B3%E3%83%89


# ................

#~ npm ciのキャッシュの補足

# npm ciをキャッシュする場合、node_modulesディレクトリでは無く、ホームディレクトリの.npmディレクトリ($HOME/.npm)をキャッシュすることが推奨されているようです。

# 以下は、Travis CI(CircleCIと同じくCIツール)での例ですが、$HOME/.npmをキャッシュしています。


# npm-ci | npm Documentation
# https://docs.npmjs.com/cli/ci.html/#example


# ................

#~ 【補足】npm run devのキャッシュについて

# npm run devの結果もキャッシュすることは可能ですが、以下の点がこれまでのキャッシュ対象と比べ、複雑になります。

# - npm run devを実行せずにキャッシュを使う場合と、そうでない場合の条件判定
# - キャッシュ対象のディレクトリやファイルの指定


# ==== CirclecCI 失敗時マージ不可設定 ====

#& テスト失敗時にmasterブランチへマージ不可にする


# 方法① GitHub側から設定する

# 旧
# https://www.techpit.jp/courses/78/curriculums/81/sections/617/parts/2102
# 新
# https://www.techpit.jp/courses/200/curriculums/203/sections/1344/parts/5415
# https://docs.github.com/ja/repositories/configuring-branches-and-merges-in-your-repository/defining-the-mergeability-of-pull-requests/about-protected-branches

#! GitHubの無料プランの場合、この機能を使えるのはパブリックリポジトリのみです。プライベートリポジトリで使うには有料プランに移行する必要があります。


# 1. Settings画面のBranchesメニューの選択
# GiHubのリポジトリ画面 → Settingsタブ → Branchesメニューを選択

# ⬇️

# 2. Add Ruleの選択
# Branch protection rules: Add ruleボタンをクリック

# ⬇️

# 3. Protect matching branches(ブランチ保護ルールの設定)
# + Branch name pattern: 保護するブランチ名のパターンを入力 [main]

# + Require status checks to pass before merging: チェックボックスにチェック
# → マージ前に何らかのチェックを必要とするかどうかを設定
# → 上記のチェックを入れると、ci/circleci: buildという欄が表示されます。このCircleCIのbuildジョブが正常終了していることをマージ可否の条件にするので、チェックボックスにチェックを入れます。
# ++ 上記のチェックを入れると、検索欄が表示される: job名(build)を入力 → ci/circleci: build

# + Include administrators: チェックボックスにチェック
# → 作ったルールをリポジトリの管理者にも適用するかどうかを設定
# → ここにチェックをしない場合、テストが失敗してもこのリポジトリの管理者であるあなたのGitHubアカウントを使えばmasterへのマージは出来てしまいます。

#^ Include administratorsの項目が無い?
# https://github.blog/changelog/2022-08-18-bypass-branch-protections-with-a-new-permission/
# Do not allow bypassing the above settings よいう項目に変わった?
# The above settings will apply to admins and custom roles with the "bypass branch protections" permission.

# ⬇️

# Createボタンをクリック

# 以上で、テスト失敗時(CircleCIのbuildジョブ失敗時)にmasterブランチへのマージが不可となりました。


# ................

# 方法② .circleci/config.yml側から設定する

# workflows:
#   version: 2
# 略
#     filters:
#       branches:
#           only: main


# **** CircleCI テストDB設定 ****

#& CircleCIでPostgreSQLを使用する

# ⑴ config.ymlの編集

# version: 2.1
# jobs:
#   build:
#     docker:
#       - image: circleci/php:7.3-node-browsers
#       - image: circleci/postgres:11.6-alpine
#         environment:
#           POSTGRES_DB: larasns
#           POSTGRES_USER: default
#           POSTGRES_PASSWORD: secret
#     environment:
#       APP_ENV: testing
#       DB_CONNECTION: pgsql
#       DB_HOST: localhost
#       DB_PORT: 5432
#       DB_DATABASE: larasns
#       DB_USERNAME: default
#       DB_PASSWORD: secret
#     steps:
#       # 略
#       - run: npm run dev
#       - run:
#           name: get ready for postgres
#           command: |
#             sudo apt-get update
#             sudo apt-get install libpq-dev
#             sudo docker-php-ext-install pdo_pgsql
#             dockerize -wait tcp://localhost:5432 -timeout 1m
#       - run:
#           name: php test
#           command: vendor/bin/phpunit


# ................

#~ imageの追加

# docker:
#   - image: circleci/php:7.3-node-browsers
#   - image: circleci/postgres:11.6-alpine
#     environment:
#       POSTGRES_DB: larasns
#       POSTGRES_USER: default
#       POSTGRES_PASSWORD: secret


# ................

#~ dockerとimage

# imageには、CircleCIが提供しているPostgres 11.6のDockerイメージを指定しています。

# なお、このような、DockerイメージはDocker Hubで公開されています。

# CircleCIのリポジトリ一覧 - Docker Hub
# https://hub.docker.com/u/circleci


# Postgresのイメージであれば、以下になります。

# circleci/postgres Tags - Docker Hub
# https://hub.docker.com/r/circleci/postgres/tags


# CircleCI公式ページでのDockerイメージに関する解説ページは以下になります。

# Pre-Built CircleCI Docker Images - CircleCI公式(英語)
# https://circleci.com/docs/circleci-images


# ................

#~ imageと並ぶenvironment

# - image: circleci/postgres:11.6-alpine
#   environment:
#     POSTGRES_DB: larasns
#     POSTGRES_USER: default
#     POSTGRES_PASSWORD: secret

# ここで記述するenvironmentは、PostgreSQLのコンテナに対する環境変数となります。
# ここではlarasnsというデータベースがPostgreSQLに作成されるように指定しています。
#^ つまり、docker-compose.envに相当


# dockerのenvironment- CircleCI公式
# https://circleci.com/docs/ja/configuration-reference#docker


# ................

#~ ジョブ名の配下のenvironment

# version: 2.1
# jobs:
#   build:
#     docker:
#       # 略
#     environment:
#       APP_ENV: testing
#       DB_CONNECTION: pgsql
#       DB_HOST: localhost
#       DB_PORT: 5432
#       DB_DATABASE: larasns
#       DB_USERNAME: default
#       DB_PASSWORD: secret

# こちらのenvironmentは、buildジョブ全体に適用される環境変数となります。
# LaravelがPostgreSQLのDockerコンテナに接続できるよう設定しています。
#^ つまり、.env.exampleに相当

# environment- CircleCI公式
# https://circleci.com/docs/ja/configuration-reference#environment


# ................

#~ PHPからPostgreSQLへ接続するための準備

# - run:
#     name: get ready for postgres
#     command: |
#       sudo apt-get update
#       sudo apt-get install libpq-dev
#       sudo docker-php-ext-install pdo_pgsql
#       dockerize -wait tcp://localhost:5432 -timeout 1m

# ここでは、LaravelがPostgreSQLに接続するのに必要なソフトウェアのインストールなどを行なっています。
#^ PHP用のDockerfileのRUNに相当


# aptは、Debian系のLinuxのパッケージ管理システムです。

# apt-get updateでパッケージの一覧情報を最新化しています。

# sudoは、ルート権限で実行するために追加しています。

# sudo apt-get install libpq-devで、libpq-devをインストールしています。これは次のpdo_pgsqlをインストールするのに必要です。

# sudo docker-php-ext-install pdo_pgsqlでは、circleci/php:7.3-node-browsersのイメージに圧縮されて入っているpdo_pgsqlをインストールします。

# LaravelでPostgeSQLと接続するためには、このpdo_pgsqlが必要です。

# dockerize -wait tcp://localhost:5432 -timeout 1mは、circleci/php:7.3-node-browsersのコンテナからPostgreSQLのコンテナに通信できるかの確認をしています。

# -timeout 1mのオプションがあるので、通信が成功するまで最大1分待ちます。

# PostgreSQLのコンテナの起動が完了するより前に次のPHPUnitのステップが開始することの無いように、こうしたコマンドを実行するようにしています。


# **** CircleCI 静的解析ツール ****

#& PHP_CodeSniffer & reviewdog

# PHP_CodeSniffer
# https://github.com/squizlabs/PHP_CodeSniffer

# 記事
# https://qiita.com/piotzkhider/items/eb22af7245f5cf126769
# https://engineers.weddingpark.co.jp/github-circleci/
# https://qiita.com/noboru_i/items/23827b655ac854ba04b


# reviewdog
# https://github.com/reviewdog/reviewdog
# https://circleci.com/developer/ja/orbs/orb/yasuhiroki/reviewdog
# https://circleci.com/developer/ja/orbs/orb/timakin/reviewdog

# 記事
# https://qiita.com/piotzkhider/items/eb22af7245f5cf126769
# https://r-tech14.com/reviewdog/
# https://patorash.hatenablog.com/entry/2019/03/12/010145
# https://blog.toshimaru.net/reviewdog-rubocop/


# 設定手順:

# ⑴ プロジェクトにPHP_CodeSnifferのインストール
# composer require --dev squizlabs/php_codesniffer


# ................

# ⑵ CircleCIの設定

# version: 2
# jobs:
#   build:
#     docker:
#       - image: circleci/php:7.1-browsers
#         environment:
#           REVIEWDOG_VERSION: "0.9.11"

#     working_directory: ~/repo

#     steps:
#       - checkout

#       - restore_cache:
#           keys:
#             - v1-dependencies-{{ checksum "composer.json" }}
#             - v1-dependencies-

#       - run: composer install -n --prefer-dist

#       - save_cache:
#           paths:
#             - ./vendor
#           key: v1-dependencies-{{ checksum "composer.json" }}

#       - run: curl -fSL https://github.com/haya14busa/reviewdog/releases/download/$REVIEWDOG_VERSION/reviewdog_linux_amd64 -o reviewdog && chmod +x ./reviewdog
#       - run: ./vendor/bin/phpcs --warning-severity=0 --standard=PSR2 --report=code --report-width=120 ./src
#       - run: |
#           ./vendor/bin/phpcs --error-severity=0 --runtime-set ignore_warnings_on_exit 1 --standard=PSR2 --report=emacs ./src | ./reviewdog -efm="%f:%l:%c: %m" -reporter=github-pr-review


# ................

# ⑶ Githubアクセストークンの設定

#^ reviewdogにコメントさせるためには権限を持ったGithubアクセストークンを発行する必要があります。

# New personal access token → public_repo権限をつけたトークンを発行

# CircleCI → WORKFLOWS → 対象のブランチの歯車アイコン → Environment Variables > Add Variables
# REVIEWDOG_GITHUB_API_TOKENの値に先ほど作成したトークンを設定


# ................

# ⑷ ビルドするタイミングの設定

# デフォルトではPRの有無にかかわらずプッシュ毎にビルドが動いてしまいますが、
# reviewdogはPRに対してコメントをつけるツールであるため、PRが存在していないとコメントをつけることが出来ません。

# PRが存在するブランチのみビルドする設定へと変更します。


# CircleCI → WORKFLOWS → 対象のブランチの歯車アイコン → Advanced Settings → Only build pull requests
# をOnに設定


#? CircleCIのOnly build pull requestsをoffにしてもプルリクエストを作ったらJobを実行したい
# https://qiita.com/yasuhiroki/items/bddb3f51bf3439652c0c


# ................

# ⑸ ブランチの保護設定

# ⑹ ./vendor/bin/phpcbf --standard=PSR2 ./src


# ................

#! Fatal error: Allowed memory size of 134217728 bytes exhausted (tried to allocate 16 bytes) in ・・・

# 記事
# https://qiita.com/pinekta/items/4ece0c88402610f874d0
# https://deep-blog.jp/engineer/1887/
# https://qiita.com/P2eFR6RU/items/9370011fe6cdb884769f
# https://notepad-blog.com/content/211/
# https://yyengine.jp/2014/09/03/fatal-error-allowed-memory-size/
# https://1-notes.com/php-error-allowed-memory-size-of/


# --------------------

#& Larastan & reviewdog

# 記事
# https://scrapbox.io/kadoyau/Larastan_+_reviewdog_+_CircleCI


# --------------------

#& ESLint

# https://github.com/eslint/eslint

# 記事
# https://y-nakahira.hatenablog.com/entry/2017/02/11/035542


# ==== CircleCI CD ====

# **** CircleCI + Heroku ****

# 記事
# https://qiita.com/kazumakishimoto/items/6aac32725ebea25acf35
# https://zenn.dev/ttskch/articles/2598d4acbf342c
# https://qiita.com/seiya0429/items/83e3f5d53a01d6fbd8d0
# https://circleci.com/blog/deploy-laravel-heroku/
# https://blog.nakamu.me/posts/laravel-circleci-github-heroku
# https://zenn.dev/nagi125/articles/ea1d314c94409341a3b0
# https://qiita.com/maru401/items/d3f1c0ce3da9cd32770c

# **** CircleCI + AWS① (CircleCIからAWSのEC2にSSHログインしてデプロイ) ****

# https://www.techpit.jp/courses/78/curriculums/81/sections/619/parts/2119
# https://github.com/shonansurvivors/laravel-sns/tree/master
# https://github.com/shonansurvivors/laravel-ci


# **** CircleCI + AWS② (CircleCI + CodeDeployを使ってEC2にデプロイ) ****

# https://www.techpit.jp/courses/78/curriculums/81/sections/620/parts/2127
# https://github.com/shonansurvivors/laravel-sns/tree/master
# https://github.com/shonansurvivors/laravel-ci

# **** CircleCI + AWS③ (CircleCI + CodeCommit + CodeBuild + CodeDeploy + CodePipelineを使ってEC2にデプロイ) ****

# https://www.techpit.jp/courses/78/curriculums/81/sections/621/parts/2140
# https://github.com/shonansurvivors/laravel-sns/tree/master
# https://github.com/shonansurvivors/laravel-ci


# **** CircleCI + AWS Fargate + Terraform ****

# 記事
# https://zenn.dev/hibriiiiidge/books/49ee4063b10cec1df1a2
# https://zenn.dev/endo/books/6c9c8e9e74a3d30bcf08
# https://www.akashixi-tech.com/laravel/ci-cd

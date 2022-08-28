#todo [Laravel テスト Tips]

# ==== テスト用DBの設定 ====

#^ デフォルトではSQLiteが使用される。

# phpunit.xml
#     <php>
#         <server name="APP_ENV" value="testing"/>
#         <server name="BCRYPT_ROUNDS" value="4"/>
#         <server name="CACHE_DRIVER" value="array"/>
#         <server name="DB_CONNECTION" value="sqlite"/>
#         <server name="DB_DATABASE" value=":memory:"/>
#         <server name="MAIL_DRIVER" value="array"/>
#         <server name="QUEUE_CONNECTION" value="sync"/>
#         <server name="SESSION_DRIVER" value="array"/>
#     </php>


# <server name="DB_CONNECTION" value="sqlite"/>
# → テストでは軽量なSQLiteが使用される。

# <server name="DB_DATABASE" value=":memory:"/>
# → データベースの保存先としてストレージ(SSDなど)ではなく読み書きが高速なインメモリが使用される。

#^ ※ インメモリであるので永続的にデータを保存できないが、テストではデータを残し続ける必要性がない。
#^ テストは実行の都度、
#^ - 空のデータベースにテーブルを作り、
#^ - 必要であればそれらテーブルに初期データを投入し、
#^ - 各テストを実行する(テストの内容次第では、さらにデータを新規作成することもありうる)
#^ という流れを取ることが一般的。

#^ ※ テストで作成されたデータがデータベースに残っていると、次のテスト実行時に悪影響を及ぼす可能性がある。
#^ そのため、データを永続的に残さないインメモリを使用しても問題にはならない。


# 運用方針例:
#・ブラウザなどを通して開発環境のサンプルアプリケーション触っている時には.envに設定しているDBが使用される
#・テストではphpunit.xmlに設定しているSQLiteが使用される

# --------------------

#& テスト用にSQLiteを使用

# ※ローカル環境で使用可、仮想環境で使用不可

# 方法①
# ⑴ make touch-sqlite データ保存用ファイルの作成
# ⑵ backend/.envの編集 DB_CONNECTION=sqliteとし、その他のDB_はコメントアウト
# ⑶ backend/config/database.phpの編集 'database' => env(database_path('database.sqlite'), database_path('database.sqlite')), とする
# ⑷ make mig テーブル作成
# ⑸ DB Browser for SQLite でdatabase.sqliteを開き、確認

# 方法②
# ⑴ make touch-sqlite データ保存用ファイルの作成
# ⑵ backend/.envの編集 DB_CONNECTION=sqliteとし、その他のDB_はコメントアウト
# ⑶ edit.envを、DB_DATABASE=database/database.sqlite と書き換えて、make chenv
# ⑷ make mig テーブル作成
# ⑸ DB Browser for SQLite でdatabase.sqliteを開き、確認

# 方法③
# ⑴ make touch-sqlite データ保存用ファイルの作成
# ⑵ phpunit.xmlを、DB_CONNECTION=sqlite、DB_DATABASE=database/database.sqlite とする
# ⑶ make mig テーブル作成
# ⑷ DB Browser for SQLite でdatabase.sqliteを開き、確認
# ※ メモリ上のDBを利用する場合は、phpunit.xmlのDB_CONNECTIONとDB_DATABASEをアンコメント

touch-sqlite:
	docker compose exec web touch database/database.sqlite

# --------------------

#? Laravel DBの再作成方法

# ⑴ マイグレート前に戻す
# m rollback

# ⑵ webコンテナ内の環境変数DB_DATABASEの確認
# m web
# env | grep  DB_DATABASE
# → laravel_local

# ⑶ DBの切り替え
# 1. phpMyadminで切り替えるDB名でDBを作成かつ
# 2. 権限を持たせる
# 権限
# ↓
# 新規作成
# ↓
# - ユーザー名:
# ホスト名: % ※すべてのホスト
# パスワード:
# - グローバル権限:
# 選択肢
# ・すべてチェックする
# ・データ(SELECT, INSERTなど)
# ・構造 (CREATE, ALTER, IMDEX, DROPなど)
# ・管理 (GRANTなど)
# ↓
# 実行
# ※ phper	%	グローバル	ALL PRIVILEGES	はい
# 3. 作成したDB名でedit.envで環境変数をmake chenvで変更かつ再upしコンテナの環境変数を更新する
# m chenv
# 4. backend/.env のDB_DATABASEも新しいデータベース名に変更

# ⑷ マイグレートして切り替わったか確認
# m mig

# ⑸ ロールバックで元に戻す
# m rollback

# ⑹ 前のデータベースを削除
# ・ターミナルで削除
# m sql
# drop databse laravel_local;
# or
# ・phpMyAdminで削除


# ==== コマンド群 ====

# **** 単体テスト関連 ****

tests:
	docker compose exec $(ctr) php artisan test

test:
	docker compose exec $(ctr) php artisan test --testsuite=$(name)
test-%:
	docker compose exec $(ctr) php artisan test --testsuite=$(@:test-%=%)

test-f:
	docker compose exec $(ctr) php artisan test --filter $(model)Test

test-model:
	docker compose exec $(ctr) php artisan test tests/$(type)/$(model)Test.php

test-method:
	docker compose exec $(ctr) php artisan test tests/$(type)/$(model)Test.php --filter=$(method)


# ----------------

#& Unitテスト

mktest-u:
	docker compose exec $(ctr) php artisan make:test $(model)Test --unit
mku:
	@make mkunit


# ----------------

#& Featureテスト

mktest-m:
	docker compose exec $(ctr) php artisan make:test $(model)Test
mktest:
	@make mktest-m
mkm:
	@make mktest-m

mktest-c:
	docker compose exec $(ctr) php artisan make:test $(model)ControllerTest
mkc:
	@make mkfeature

ft-%:
	docker compose exec $(ctr) vendor/bin/phpunit tests/Feature/$(@:test-feature-%=%)ControllerTest

ft:
	docker compose exec $(ctr) vendor/bin/phpunit tests/Feature/$(model)ControllerTest


# **** PHPUnitコマンド群 ****

#& ローカルでテストを実行する

pu-v:
	cd backend && ./vendor/bin/phpunit --version

# --color はphpunit.xmlで設定している。
phpunit:
	cd backend && ./vendor/bin/phpunit $(path)

pu:
	@make phpunit

pu-d:
	cd backend && ./vendor/bin/phpunit $(path) --debug

# --filter - PHPUnit公式
# https://phpunit.readthedocs.io/ja/latest/textui.html?highlight=--filter
pu-f:
	cd backend && ./vendor/bin/phpunit --filter $(rgx)

pu-t:
	cd backend && ./vendor/bin/phpunit --testsuite $(name)

pu-tf:
	cd backend && ./vendor/bin/phpunit --testsuite $(name) --filter $(rgx)

pu-ls:
	cd backend && ./vendor/bin/phpunit --list-suite


# ----------------

#& Docker環境でテストを実行する

#! コンテナからテストを実行すると、コンテナに渡したDB_DATABASEの環境変数が邪魔をして、phpunit.xmlのDB_DATABASEの方を読み込んでくれない。
#! テストを実行する度にDB_DATABASEを変更するのにmake upするのはめんどくさいので、ローカルで実行した方がいい。
#! また.vscode/settings.jsonの設定も必要。

#^ 環境変数の読み込み優先順位
#^ docker-compose.yml > phpunit.xml > .env.testing

#^ 環境変数を変更する必要がある場合は、「docker run -e」を使用する。

dpu-v:
	docker compose exec $(ctr) ./vendor/bin/phpunit --version

dpu:
	docker compose run -e DB_DATABASE=$(test) $(ctr) ./vendor/bin/phpunit $(path)

dpu-d:
	docker compose run -e DB_DATABASE=$(test) $(ctr) ./vendor/bin/phpunit --debug

dpu-f:
	docker compose run -e DB_DATABASE=$(test) $(ctr) ./vendor/bin/phpunit --filter $(regex)

dpu-t:
	docker compose run -e DB_DATABASE=$(test) $(ctr) ./vendor/bin/phpunit --testsuite $(name)

dpu-tf:
	docker compose run -e DB_DATABASE=$(test) $(ctr) ./vendor/bin/phpunit --testsuite $(name) --filter $(rgx)

dpu-ls:
	docker compose exec $(ctr) ./vendor/bin/phpunit --list-suite


# **** Seeder & Factory関連 ****

# Laravel 6.x データベース：シーディング
# https://readouble.com/laravel/6.x/ja/seeding.html

# SeederクラスやFactoryクラスを作成・編集した場合、Composerのオートローダを再生成するために、dump-autoloadコマンドを実行する必要がある。
# make dump-autoload


# ------------

#& Seederクラスの作成

# make mkseed-<モデル名>
mkseeder-%:
	docker compose exec $(ctr) php artisan make:seeder $(@:mkseeder-%=%)Seeder
mkseeder:
	docker compose exec $(ctr) php artisan make:seeder $(model)Seeder
# mkseeder:
# 	docker compose exec $(ctr) php artisan make:seeder $(table)TableSeeder

# ------------

#& Seederの実行

seed:
	docker compose exec $(ctr) php artisan db:seed
# 特定のSeederを指定
seed-class:
	docker compose exec $(ctr) php artisan db:seed --class=$(model)Seeder
# seed-class:
# 	docker compose exec $(ctr) php artisan db:seed --class=$(table)TableSeeder


#^ すでにテーブルにデータが入っている場合は、
# make refresh --seed
# make fresh --seed

# ------------

#& Factoryクラスの作成

# Laravel 6.x データベースのテスト
# https://readouble.com/laravel/6.x/ja/database-testing.html

# seeder単体 = オーダーメイド
# seedr + factory + facker = 大量生産
# factoryでfackerを使ってダミーデータを定義 → factoryをseederにセットし大量のダミーデータを作成

# make mkfactory-<モデル名>
mkfactory-%:
	docker compose exec $(ctr) php artisan make:factory $(@:mkfactory-%=%)Factory
mkfactory:
	docker compose exec $(ctr) php artisan make:factory $(model)Factory

#^ 推奨
# 使用するEloquentモデルを指定してFactoryクラスを作成
# https://e-seventh.com/laravel-modelfactory-faker/
mkfactory-m:
	docker compose exec $(ctr) php artisan make:factory $(model)Factory --model=$(model)
mkf:
	@make mkfactory-m


# ------------

#& Fackerの日本語化

# config/app.php
# 'faker_locale' => 'en_US', →  'faker_locale' => 'ja_JP',

# Facker 公式
# https://github.com/fzaninotto/Faker

# Facker チートシート
# https://qiita.com/kurosuke1117/items/c672405ac24b03af2a90
# https://qiita.com/tosite0345/items/1d47961947a6770053af
# https://cross-accelerate-business-create.com/2021/01/02/laravel7-faker/#i-2

# Faker 記事
# https://shingo-sasaki-0529.hatenablog.com/entry/how_to_use_php_faker
# https://zenn.dev/fuwakani/scraps/a0766eb0bbf49a
# https://codelikes.com/laravel-faker/
# https://ramble.impl.co.jp/762/#toc4
# https://blog.maro.style/post-1543/
# https://zenn.dev/fagai/articles/1ad4a85695c4f9


# ==== お役立ち情報 ====

#? テスト用のデータベースに新たにコンテナを用意する場合

# [Laravel]ユニットテストをする(phpunit設定など)
# https://codelikes.com/laravel-tests/

# Laravelでテストをする前の準備、設定の事(テスト用データベースとか)
# https://tenrakatsuno.com/programing-note/laravel-test-database/


# ----------------

#? VSCodeからDockerコンテナ内のPHPUnitを実行する方法

# 記事
# https://www.webopixel.net/php/1740.html


# .vscode/settings.json
# {
#   "makefile.extensionOutputFolder": "./.vscode",
#   "phpunit.command": "docker compose exec <コンテナ名>",
#   "phpunit.phpunit": "vendor/bin/phpunit",
#   "phpunit.paths": {
#     "/backend": "work/backend",
#     "${workspaceFolder}": "/"
#   }
# }



# 拡張機能の設定:
# 通常は必要ありませんが、コンテナ内を実行しようとすると拡張機能の設定が必要になります。
# phpunit.commandはdockerのコマンドを記述します。PHPはコンテナ名なので環境によって書き換えてください。
# phpunit.phpunitはPHPUnitのパス。
# phpunit.pathsでホストのパスをコンテナのパスに書き換えます。


# ----------------

# ? LaravelのUnitTestでテスト時はデータベースを切り替える

# 記事
# https://www.webopixel.net/php/1430.html


# ==== PHPUnit テストのやり方 ====

# **** テスト実施手順 ****

# ⑴ テストのひな形を生成
# make mktest model=<モデル名>


# ----------------

# ⑵ テストの編集
# tests/Feature/<モデル名>ControllerTest.php


# ----------------

# ⑶ テストの実行
# make pu path=<テストまでのパス>
# make pu-f rgx=<テスト名の一部>

# 例)
# PHPUnit 8.5.2 by Sebastian Bergmann and contributors.

# Warning:       Invocation with class name is deprecated

# .                                                                   1 / 1 (100%)

# Time: 908 ms, Memory: 22.00 MB

# OK (1 test, 2 assertions)

# ...........

#~ .                                                                   1 / 1 (100%)

# 上記は全部で1つのテストを実行し、うち1つのテストが正常に終了したことを表している。

# .とある部分は、テストの数です。テストが3つであれば、...といったように表示される。


# ...........

#~ OK (1 test, 2 assertions)

# 上記はテストの数と、assertの数を表している。

# ...........

#! Warning:       Invocation with class name is deprecated

# クラス名での呼び出しを廃止予定、と書かれています。
# 今回、テストクラス名を指定してPHPUnitを実行しましたが、将来的にはこの方法は使えなくなる。


# ----------------

# ⑷ ファクトリの作成
# make mkfactory-m model=<モデル名>


# 例: /database/factories/ArticleFactory.php
# <?php

# /** @var \Illuminate\Database\Eloquent\Factory $factory */

# use App\Article;
# use App\User;
# use Faker\Generator as Faker;

# $factory->define(Article::class, function (Faker $faker) {
#     return [
#         'title' => $faker->text(50),
#         'body' => $faker->text(500),
#         'user_id' => function () {
#             return factory(User::class);
#         }
#     ];
# });


# Articleモデルの元となるarticlesテーブルは、以下のカラムを持っています。

# カラム名 | 属性 | 役割
# id | 整数 | 記事を識別するID
# title | 最大255文字の文字列 | 記事のタイトル
# body | 制限無しの文字列 | 記事の本文
# user_id | 整数 | 記事を投稿したユーザーのID
# created_at | 日付と時刻 | 作成日時
# updated_at | 日付と時刻 | 更新日時


# このうち、id, created_at, updated_atはテーブルに保存する際に自動で値が決まるので、残りのカラム(プロパティ)をファクトリでは定義しています。


# ...........

#~ Faker

# 'title' => $faker->text(50),
# 'body' => $faker->text(500),

# ここでは、Fakerのtextメソッドを使用してランダムな文章を生成しています。
# $faker->text(500)と指定すると、最大500文字の文章が生成されます(デフォルトはラテン語のようです)。


# Fakerとは文章だけでなく、人名や住所、メールアドレスなどをランダムに生成してくれる、テストデータを作る時に便利なPHPのライブラリです。

# fzaninotto/Faker - GitHub
# https://github.com/fzaninotto/Faker


# ...........

#~ 外部キー制約のあるカラム

# articlesテーブルのuser_idカラムは、その記事を投稿したユーザーのIDを持つことを想定したカラムです。

# そのため、サンプルアプリケーションではarticlesテーブルのuser_idカラムに、Userモデルの元となるusersテーブルのidカラムに対する外部キー制約を持たせています。

# articlesテーブルを作成するためのマイグレーションファイルを確認すると、以下の通りとなっています。


# $table->foreign('user_id')->references('id')->on('users');`
# は、articlesテーブルのuser_idカラムは、usersテーブルのidカラムを参照するという制約になります。
# ですので、user_idカラムは、usersテーブルに存在しないidを持つことができません。

# つまり、「記事は存在するけれど、それを投稿したユーザーが存在しない」という状態を作れないようにしてあります。

# ファクトリでこのようなカラムを取り扱う時は、値として以下のように「参照先のモデルを生成するfactory関数」を返すクロージャ(無名関数)をセットするようにします。

#         'user_id' => function() {
#             return factory(User::class);
#         }

# これにより、Articleモデルをファクトリで生成した時に併せてUserモデルがファクトリで生成され、そのUserモデルのidがArticleモデルのuser_idカラムにセットされるようになります。


# **** テストコードの例 ****


#? Arrange-Act-Assertについて

# Arrange-Act-Assert
# http://wiki.c2.com/?ArrangeActAssert

# テストの書き方のパターンとして、AAA(Arrange-Act-Assert)というものがある。
# 日本語で言うと、準備・実行・検証。

# public function testAuthCreate()
# {
#     // テストに必要なUserモデルを「準備」
#     $user = factory(User::class)->create();

#     // ログインして記事投稿画面にアクセスすることを「実行」
#     $response = $this->actingAs($user)
#         ->get(route('articles.create'));

#     // レスポンスを「検証」
#     $response->assertStatus(200)
#         ->assertViewIs('articles.create');
# }


# ----------------

# 例1

# 元記事
# https://www.techpit.jp/courses/78/curriculums/81/sections/616/parts/2092
# https://www.techpit.jp/courses/78/curriculums/81/sections/616/parts/2094

# <?php

# namespace Tests\Feature;

# use App\User;
# use Illuminate\Foundation\Testing\RefreshDatabase;
# use Illuminate\Foundation\Testing\WithFaker;
# use Tests\TestCase;

# class ArticleControllerTest extends TestCase
# {
#     use RefreshDatabase;

#     public function testIndex()
#     {
#         $response = $this->get(route('articles.index'));

#         $response->assertStatus(200)
#             ->assertViewIs('articles.index');
#     }

#     // 未ログイン状態であれば、ログイン画面にリダイレクトされるはず
#     public function testGuestCreate()
#     {
#         $response = $this->get(route('articles.create'));

#         $response->assertRedirect(route('login'));
#     }


#     // ログイン済み状態であれば、記事投稿画面が表示されるはず
#     public function testAuthCreate()
#     {
#         $user = factory(User::class)->create();

#         $response = $this->actingAs($user)
#             ->get(route('articles.create'));

#         $response->assertStatus(200)
#             ->assertViewIs('articles.create');
#     }
# }


# ................

#~ RefreshDatabase:

# TestCaseクラスを継承したクラスでRefreshDatabaseトレイトを使用すると、データベースをリセットする。

# リセットするとはどういうことかというと、データベースの全テーブルを削除(DROP)した上で、マイグレーションを実施し全テーブルを作成する。

# なお、RefreshDatabaseトレイトを使用すると、上記に加えて、テスト中にデータベースに実行したトランザクション(レコードの新規作成・更新・削除など)は、テスト終了後に無かったことになる。

# 各テスト後のデータベースリセット - Laravel公式
# https://readouble.com/laravel/6.x/ja/database-testing.html#resetting-the-database-after-each-test


# ................

#~ テストのメソッド名

# public function testIndex()

#^ PHPUnitでは、テストのメソッド名の先頭にtestを付ける必要がある！

# なお、メソッド名をtest始まりにしたくない場合は、以下の例のようにメソッドのドキュメントに@testと記述する。

# /**
#  * @test
#  */
# public function initialBalanceShouldBe0()
# {
#     $this->assertSame(0, $this->ba->getBalance());
# }


# @test - PHPUnit公式
# https://phpunit.readthedocs.io/ja/latest/annotations.html#test


# ................

#~ getメソッド

# $response = $this->get(route('articles.index'));

# ここでの$thisは、TestCaseクラスを継承した<モデル名>ControllerTestクラスを指す。

# このgetメソッドは、引数に指定されたURLへGETリクエストを行い、そのレスポンス(Illuminate\Foundation\Testing\TestResponseクラス)を返す。


# HTTPテスト - Laravel公式
# https://readouble.com/laravel/6.x/ja/http-tests.html


# ................

#~ assertStatusメソッド

# $response->assertStatus(200)
#     ->assertViewIs('articles.index');

# getメソッドによって変数$responseには、Illuminate\Foundation\Testing\TestResponseクラスのインスタンスが代入されている。

# TestResponseクラスは、assertStatusメソッドが使える。

# assertStatusメソッドの引数には、HTTPレスポンスのステータスコードを渡す。

# ここでは、正常レスポンスを示す200を渡している。
# これにより、$responseのステータスコードが
# - 200であればテストに合格
# - 200以外であればテストに不合格
# となる。

# もしここでテスト不合格になれば、それは画面表示に何らかのバグが生じていると考えられる。


# assertStatus - Laravel公式
# https://readouble.com/laravel/6.x/ja/http-tests.html#assert-status


# $response->assertStatus(200)
# $response->assertOK()

# assertOK - Laravel公式
# https://readouble.com/laravel/6.x/ja/http-tests.html#assert-ok


# ................

#~ メソッドチェーンとassertViewIsメソッド

# assertStatusは、TestResponseクラスのインスタンス自身を返す。
# なので、->で連結させて、そのままTestResponseクラスのメソッドを使用できる。


# assertViewIsの引数には、ビューファイル名を渡す。
# それにより、$responseに格納されている取得して来たビューが、ソースに存在するビューファイルであるかどうかをテストする。

#^ ステータスコードが200かどうかをテストするだけでは、画面が表示されているかどうかをテストできていない。
#^ そのため、ビューについてもテストを行うことにしている。


# assertViewIs - Laravel公式
# https://readouble.com/laravel/6.x/ja/http-tests.html#assert-view-is


# ................

#~ assertRedirect

# assertRedirectメソッドでは、引数として渡したURLにリダイレクトされたかどうかをテストする。


# assertRedirect - Laravel公式
# https://readouble.com/laravel/6.x/ja/http-tests.html#assert-redirect


# ................

#~ factory関数とcreateメソッド

# $user = factory(User::class)->create();


# factory関数を使用することで、テストに必要なモデルのインスタンスを、ファクトリというものを利用して生成できる。

# factory(User::class)->create()とすることで、ファクトリによって生成されたUserモデルがデータベースに保存される。

# また、createメソッドは保存したモデルのインスタンスを返すので、これが変数$userに代入される。


# モデルの保存 - Laravel公式
# https://readouble.com/laravel/6.x/ja/database-testing.html#persisting-models


# factory関数を使用するには、あらかじめそのモデルのファクトリが存在する必要があある。

# Userモデルのファクトリは以下のとおり。
# .
# └── database
#     └── factories
#         └── Userfactory.php

# Laravelではインストールした時点からUserfactoryが存在するので、これを利用している。


# ................

#~ actingAsメソッド

# $response = $this->actingAs($user)
#     ->get(route('articles.create'));


# actingAsメソッドは、引数として渡したUserモデルにてログインした状態を作り出せる。
# その上で、get(route('articles.create'))を行うことで、ログイン済みの状態で記事投稿画面へアクセスしたことになり、そのレスポンスは変数$responseに代入されます。


# セッション／認証 - Laravel公式
# https://readouble.com/laravel/6.x/ja/http-tests.html#session-and-authentication


# $response->assertStatus(200)
#     ->assertViewIs('articles.create');

# 今変数$responseには、ログイン済みの状態で記事投稿画面へアクセスしたレスポンスが代入されている。

# 今度はログイン画面などへリダイレクトはされず、HTTPのステータスコードとしては200が返ってくるはずですので、assertStatus(200)でこれをテストする。

# （なお、リダイレクトの場合は、302が返ってくる。）

# また、assertViewIs('articles.create')で、記事投稿画面のビューが使用されているかをテストする。


# ----------------

# 例2

# 元記事
# https://www.techpit.jp/courses/78/curriculums/81/sections/616/parts/2096
# https://www.techpit.jp/courses/78/curriculums/81/sections/616/parts/2097

# <?php

# namespace Tests\Feature;

# use App\Article;
# use App\User;
# use Illuminate\Foundation\Testing\RefreshDatabase;
# use Illuminate\Foundation\Testing\WithFaker;
# use Tests\TestCase;

# class ArticleTest extends TestCase
# {
#     use RefreshDatabase;

#     // 引数としてnullを渡した時、falseが返ってくるはず
#     public function testLikedByNull()
#     {
#         $article = factory(Article::class)->create();

#         $result = $article->isLikedBy(null);

#         $this->assertFalse($result);
#     }

#     // その記事をいいねしているUserモデルのインスタンスを引数として渡した時、trueが返ってくるはず
#     public function testIsLikedByTheUser()
#     {
#         $article = factory(Article::class)->create();
#         $user = factory(User::class)->create();
#         $article->likes()->attach($user);

#         $result = $article->isLikedBy($user);

#         $this->assertTrue($result);
#     }

#     // その記事をいいねしていないUserモデルのインスタンスを引数として渡した時、falseが返ってくるはず
#     public function testIsLikedByAnother()
#     {
#         $article = factory(Article::class)->create();
#         $user = factory(User::class)->create();
#         $another = factory(User::class)->create();

#         $article->likes()->attach($another);

#         $result = $article->isLikedBy($user);

#         $this->assertFalse($result);
#     }
# }


# ................

#~ assertFalse

# $this->assertFalse($result);

# ここでの$thisは、TestCaseクラスを継承したArtcleTestクラスを指します。
# TestCaseクラスは、assertFalseメソッドを持っています。
# assertFalseメソッドは、引数がfalseかどうかをテストします。


# assertFalse - PHPUnit公式
# https://phpunit.readthedocs.io/ja/latest/assertions.html#assertfalse


#^ HTTPテストでは、getメソッドなどを使うことでTestResponseクラスのインスタンスが返り、さらにTestResponseクラスが持つassertStatusメソッドを使って検証を行いました。
#^ 一方、今回のテストでの変数$resultにはisLikedByメソッドの戻り値が代入されており、この戻り値はassert...のようなメソッドは持っていません。
#^ ですので、$result->assert...といった書き方にはなりません。


# ................

#~ 記事に「いいね」をする

# $article->likes()->attach($user);

# 上記のコードでは、記事に「いいね」をしていることになります。

# likesメソッドの内容は以下になります。

# Article.php
# public function likes(): BelongsToMany
# {
#     return $this->belongsToMany('App\User', 'likes')->withTimestamps();
# }

# belongsToManyメソッドを用いて、ArticleモデルとUserモデルを、likesテーブルを通じた多対多の関係で結び付けています。


# likesテーブルの構造は以下の通りです。

# カラム名 | 属性 | 役割
# id | 整数 | いいねを識別するID
# user_id	整数	いいねしたユーザーのid
# article_id | 整数 |いいねされた記事のid
# created_at | 日付と時刻 | 作成日時
# updated_at | 日付と時刻 | 更新日時


# likesテーブルは、usersテーブルとarticlesテーブルを紐付ける中間テーブルとなっており、「誰が」「どの記事を」いいねしているかを管理します。

# このlikesテーブルにレコードを新規登録すると、いいねをしている状態を作ったことになります。


# 例えば、user_idカラムが1、article_idが2のレコードを新規登録すると、「idが1であるユーザーが」「idが2である記事を」いいねしている状態、ということになります。

# このようにレコードを新規登録するために以下を行います。

# まず、$article->likes()とすることで、多対多のリレーション(BelongsToManyクラスのインスタンス)が返ります。

# この多対多のリレーションでは、attachメソッドが使用できます。

# $article->likes()->attach($user)とすることで、

# likesテーブルのuser_idには、$userのidの値
# likesテーブルのarticle_idには、$articleのidの値
# を持った、likesテーブルのレコードが新規登録されます。


# attach/detach - Laravel公式
# https://readouble.com/laravel/6.x/ja/eloquent-relationships.html#updating-many-to-many-relationships


# これは、つまり、

# 「ファクトリで生成された$userが」「ファクトリで生成された$articleを」いいねしている
# 状態となります。


# ................

#~ assertTrue

# $this->assertTrue($result);

# assertTrueメソッドは、引数がtrueかどうかをテストします。

# assertTrue - PHPUnit公式
# https://phpunit.readthedocs.io/ja/latest/assertions.html#assertfalse


# **** モックを使ったAPIテスト ****

# 記事
# https://qiita.com/rope19181/items/fdae4fc8952d5d21a962
# https://maasaablog.com/development/laravel/2805/
# https://zenn.dev/shun57/articles/1fd956346c4381
# https://awesome-linus.com/2020/01/22/laravel-mockery-api-mock-test/
# https://phpunit.readthedocs.io/ja/latest/test-doubles.html
# https://www-ritolab-com.cdn.ampproject.org/v/s/www.ritolab.com/entry/186.amp?amp_gsa=1&amp_js_v=a9&usqp=mq331AQKKAFQArABIIACAw%3D%3D#amp_tf=%251%24s%20%E3%82%88%E3%82%8A&aoh=16614661323995&referrer=https%3A%2F%2Fwww.google.com&ampshare=https%3A%2F%2Fwww.ritolab.com%2Fentry%2F186
# https://readouble.com/laravel/8.x/ja/mocking.html
# https://www.twilio.com/blog/unit-testing-laravel-api-phpunit-jp
# https://tenshoku-miti.com/takahiro/laravel-phpunit/
# https://symfony.com/doc/current/the-fast-track/ja/17-tests.html
# https://www.oulub.com/docs/laravel/ja-jp/mocking
# https://www.pnkts.net/2022/05/23/mock-static-method

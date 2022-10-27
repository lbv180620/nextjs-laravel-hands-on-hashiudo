#todo [Laravel テスト Tips]


# PHPUnitでテストするときのちょっとしたTips5選
# https://www.wantedly.com/companies/noschool/post_articles/321036

#【Laravel】Laravel組み込みのテスト用便利trait集
# https://cpoint-lab.co.jp/article/202003/14256/


# ==== Laravelのテストについて ====

#* 1. ソフトウェアテストとは

# プログラムが意図した動作をするかを検証する作業の事。

# 目的:
# ・バグの検出
# ・品質の保証
# ・プログラマの安心感


# --------------------

#* 2. Laravelのテストについて

# Unitテスト
# → Laravelを通さないテスト

# Featureテスト (Httpテスト)
# → ルーティングに対して行うテスト

# ブラウザテスト (E2Eテスト)
# → 実際に画面を操作させるテスト


# --------------------

#* 3-1. Unitテストの特徴

# 特徴:
# ・Laravelを通さないテスト
# ・デデーベースを扱えない
# ・メソッド単位でテストする

# 個人的な意見:
# ・パターンが多い場合に利用すると安心感がある
# ・基本使わなくて良い


# ....................

#* 3-2. Featureテスト (Httpテスト)

# 特徴:
# ・Laravelを通すテスト
# ・データベースが扱える
# ・ルーティングに対して行うテスト

# 個人的な意見:
# ⑴ テストケースを網羅しようとしない (必要な箇所のみ)
# ⑵ 不必要にMockを使わない (基本実際のDBを使う)
# ⑶ 異常系のテストに強い (E2Eと比較して)


# ....................

#* 3-3 ブラウザテスト (E2Eテスト)

# 特徴:
# ・実際に画面を操作させるテスト
# ・シナリオテストが行える (複雑なパターンのテスト)

# 個人的な意見:
# ⑴ 正常系のテストに強い (異常系のテストがやりにくい)
# ⑵ 壊れやすい (変更に弱い。すぐ動かなくなる)
# ⑶ あまり難しいパターンをやるべきではない (最低限やる)

# Laravel Dusk
# Cypress (推奨)
# Selenium


# --------------------

#* 4. テストで大事な事

# 個人的な意見:
# ・別のレイヤー(e2eとrequestテストなど)で同じ事を証明しない(手動も含む)
# ・無理に網羅しようとしない(手動も含む)
# ・テスト用のDBを用意する(テスト用のDBコンテナを用意するのが良い)
# ・繰り返し実施できるようにする(DBの値とかは初期化、後始末をする)
# ・環境に依存しな事が大事(AさんはOK、BさんはNGはダメ)
# ・1つのテストケースで1つの観点を検証する(複雑になるとメンテが大変)
# ・目的確認を入れない。(必ずassertを通す)
# ・テストコードは、テスト内容がわかる名前にする
# ・テストしずらいと感じたら、思い切ってりファクタする(実装側を直す)
# ・バグが起きるのは、テスト観点が抜けている場合が多い(テスト観点の見直し)
# ・実装者以外がテストするとバグが見つかりやすい(数人でテストすると良い)
# ・TDD的であれ(レッド → グレーン → リファクター)


# --------------------

#* 5. まとめ

# テストはめんどくさい！
# とは思わずに、自身(チーム)の安心感を得るために出来る限り無理のない形で実施してみるとよい。


# ==== Laravelのテストの実行方法について ====

# https://imanaka.me/laravel/create-books-app-test/


# ------------------------

#? Laravelのテストクラスの作成

# sail php artisan make:test UserTest

# make mktest model=Book


# ------------------------

#? Laravelのテストケースの作成方法

# 検証したいことを、まずは書き出す

# 1.ログインユーザがbook.indexにアクセスできるか？
# 2.ログインしてないユーザがbook.indexにアクセスできないか？

# 3.book.detailにアクセスできるか？
# 4.存在しない値でbook.detailにアクセス出来ないことを確認する

# 5.book.editにアクセスできるか？
# 6.存在しない値でbook.editにアクセス出来ないことを確認する

# 7.book.editで正常系のテストを実施する
# 8.book.editで異常系のテストを実施する

# 9.book.newで正常系のテストを実施する
# 10.book.newで異常系のテストを実施する

# 11.removeで正常系のテストを実施する
# 12.removeで異常系のテストを実施する

# 13.検索機能が正常にテスト出来ること


# ........................

#^ テストパターン

# ページごと(ルーティングごと)にテストケースを考える。

# アクセステスト
# - ログインユーザー
# - ゲストユーザー

# パラメーターアクセステスト

# 正常系テスト(更新処理成功時のテスト)
# 異常系テスト(更新処理失敗時のテスト)


# ------------------------

#? Laravelのテスト名について

# LaravelのUnitTestのテスト名は下記のいずれかになります。

# ・「test_」から始める
# ・コメントに「@test」をつける（この場合は「test_」から始める必要はなし）
# ・日本語でテスト名をつけれる

# また、テスト名は、事前に自身でルールを決めておいたほうがいいです。そうしないと、あとあとテストケースを探すのに苦労します。


# (例)
# test_<url>_<証明する内容>

# ------------------------

#? Laravelのテストの実行

# sail test

# make tests


# ------------------------

#? Laravelで特定のクラスをテストする方法

# sail test tests/Feature/BookTest.php

# make testf model=Book


# ------------------------

#? Laravelで特定のメソッドをテストする方法

# sail test --filter test_book_index_ng tests/Feature/BookTest.php

# make testf-f model=Book method=test_book_index_ng


# ------------------------

#? Laravelでユーザをログインさせてテストする方法

# actingAsにUserモデルを入れるとログインした形でget、post、patch、put、deleteが出来ます。
# その際には、factoryでユーザを作成する必要があります。

# use App\Models\User;
# $user = User::factory()->create();

# use App\Models\Book;
# $response = $this->actingAs($user)->get('/book');
# $response = $this->actingAs($user)->get("/book/detail/$book->id");
# $response = $this->actingAs($user)->get("/book/edit/$book->id");
# $response = $this->actingAs($user)->post('/book/create', $params);
# $response = $this->actingAs($user)->patch('/book/update', $params);
# $response = $this->actingAs($user)->put('/book/create', $params);
# $response = $this->actingAs($user)->delete('/book/remove', $params);


# ------------------------

#? Laravelテストでエラーになったコードのバグ修正の方法

# 500(Attempt to read property "id" on null)対策
# $book = Book::findOrFail($id);


# ........................

# Laravelのfind()とfindOrFail()の違い、使い分け方。初心者もよく分かる！
# https://nebikatsu.com/8589.html/

#^ find()は、一致するidが見つからなかった場合は、nullを返します。
# → find()を使ってても、.envファイルを開いて、APP_DEBUGをtrueからfalseに書き換えれば、同じように、404 | Not Foundが表示されるようになる。

#^ findOrFail()は、一致するidが見つからなかった場合は、エラー(404 | Not Found)を返します。

#^ first() と firstOrFail() も同じ。見つからなかった時に、nullかエラーか、どっちを出したいかで使い分ける。


# ........................

#^ 500 → 404
# find() → findOrFail()

#^ 302 → 404
# redirect()をコメントアウト

#^ 200 → 404
# abort(404)


# ........................

#【Laravel】findOrFailを主キー以外でやるにはどうすればいい？
# https://tektektech.com/laravel-find-or-fail-other-key/

# $model = App\Hoge::where('other_id', 1)->firstOrFail();
# → other_idが1のモデルが存在しない場合は404のexceptionが返される


#【Laravel】find()とfindOrFail()の違い
# https://qiita.com/moutoonm342/items/995f11de4275b43d7f4c


# ------------------------

#? Laravelで更新処理のテストをする方法

# httpステータス、セッション、DBの値をテストしてます。

# public function test_book_update_ok(){
#   $user = User::factory()->create();
#   $book = Book::factory()->create();
#   $params = [
#   'id' => $book->id,
#   'name' => 'test',
#   'status' => 1,
#   'author'=> 'test',
#   'publication'=> 'test',
#   'read_at'=> '2022-10-01',
#   'note'=> 'test',
#   ];
#   $response = $this->actingAs($user)->patch('/book/update', $params);
#   $response->assertStatus(302); // httpステータスが302を返すこと
#   $response->assertSessionHas('status', '本を更新しました。'); // セッションにstatusが含まれていて、値が「本を更新しました。」となっていること
#   $this->assertDatabaseHas('books', $params); // dbの値が更新されたこと
# }


# ------------------------

#? Laravelで更新処理のバリデーションをテストする方法

# 更新処理は、update
# 追加処理は、create
# 削除処理は、remove
# に変えてテストします。

# create時は、bookのfactoryのcreateは不要です。


# public function test_book_update_status_ng_all()
# {
#   $user = User::factory()->create();
#   $book = Book::factory()->create();

#   $params = [
#     'id' => $book->id,
#     'name' => $this->faker->realText(256), // 不正な値
#     'status' => 9, // 不正な値
#     'author'=> $this->faker->realText(256), // 不正な値
#     'publication'=> $this->faker->realText(256), // 不正な値
#     'read_at'=> '2022-10-01xxxx', // 不正な値
#     'note'=> $this->faker->realText(1001), // 不正な値
#   ];

#   $response = $this->actingAs($user)->patch('/book/update', $params);
#   $response->assertStatus(302);
#   $this->assertDatabaseMissing('books', $params); // dbの値が更新されてないこと
#   $response->assertInvalid(['name' => '名前は、255文字以下にしてください。']);
#   $response->assertInvalid(['status' => '選択されたステータスは、有効ではありません。']);
#   $response->assertInvalid(['author' => '著者は、255文字以下にしてください。']);
#   $response->assertInvalid(['publication' => '出版は、255文字以下にしてください。']);
#   $response->assertInvalid(['read_at' => '読破日は、正しい日付ではありません。']);
#   $response->assertInvalid(['note' => 'メモは、1000文字以下にしてください。']);
# }



# remvoeのテストコードです。

# // book.removeで更新処理が正常に行えること
# public function test_book_remove_ok()
# {
#   $user = User::factory()->create();
#   $book = Book::factory()->create();

#   $response = $this->actingAs($user)->delete("/book/remove/$book->id");
#   $response->assertStatus(302); // httpステータスが302を返すこと
#   $response->assertSessionHas('status', '本を削除しました。'); // セッションにstatusが含まれていて、値が「本を削除しました。」となっていること

#   $book = Book::find($book->id);
#   $this->assertEmpty($book); // NOTE: $thisはUnitTestの関数
# }

# // 不正な値でbook.removeで更新処理がエラーになること
# public function test_book_remove_ng()
# {
#   $user = User::factory()->create();
#   Book::factory()->create();

#   $response = $this->actingAs($user)->delete("/book/remove/99999");

#   $response->assertStatus(404);
# }


# ------------------------

#? Laravelでテストを実行する際に、Fakerを使用する方法

# use WithFaker;


# ------------------------

#? Laravelでテストを実行する際に、DBのデータを消す方法


# Laravelでテストを実施する際は、必ずDBのデータを毎回クリアするのをおすすめします。そうしないとテストが失敗する事があります。

# use RefreshDatabase;


# ------------------------

#? Laravel PHPUnit テストの中でseederを利用する方法

# 方法①: テスト関数内で指定

# $this->seed(MstBookStatusSeeder::class);
# ^ 関数テストを行う場合はここに書く。


# 方法②: プロパティとして指定

# protected $seeder = MstBookStatusSeeder::class;

#^ setUp()内で、$this->seed(MstBookStatusSeeder::class); としていするのと同義
#^ クラステストを行う場合はここに書く。


# 方法③: TestCase.phpに指定

# protected $seed = MstBookStatusSeeder::class;

#^ protected $seed = true; とするとDatabseSeederが実行される。
#^ 全体を通したテストを行う場合はここに書かないと、テストが通らなくなる。


# ....................

# Laravel 9.x データベーステスト
# https://readouble.com/laravel/9.x/ja/database-testing.html


#^ seedメソッドはデフォルトで、DatabaseSeederを実行します。これにより、他のすべてのシーダが実行されます。または、特定のシーダクラス名をseedメソッドに渡します。

#     public function test_orders_can_be_created()
#     {
#         // DatabaseSeederを実行
#         $this->seed();

#         // 特定のシーダを実行
#         $this->seed(OrderStatusSeeder::class);

#         // ...

#         // 配列中に指定してあるシーダを実行
#         $this->seed([
#             OrderStatusSeeder::class,
#             TransactionStatusSeeder::class,
#             // ...
#         ]);
#     }



#^ あるいは、RefreshDatabaseトレイトを使用する各テストの前に、自動的にデータベースをシードするようにLaravelに指示することもできます。これを実現するには、テストの基本クラスに$seedプロパティを定義します。

# abstract class TestCase extends BaseTestCase
# {
#     use CreatesApplication;

#     /**
#      * デフォルトのシーダーが各テストの前に実行するかを示す
#      *
#      * @var bool
#      */
#     protected $seed = true;
# }


#^ $seedプロパティが true の場合、RefreshDatabaseトレイトを使用する各テストの前にDatabase\Seeders\DatabaseSeederクラスを実行します。ただし，テストクラスに$seederプロパティを定義し，実行したい特定のシーダーを指定できます。

# use Database\Seeders\OrderStatusSeeder;

# /**
#  * 各テストの前に特定のシーダーを実行
#  *
#  * @var string
#  */
# protected $seeder = OrderStatusSeeder::class;


# .......................

# Laravel PHPUnit テストの中でseederを利用する
# https://www.yuulinux.tokyo/14874/

# Laravel テスト用のシーダーを初回のみ実行する
# https://qiita.com/ucan-lab/items/0e31a1a7447934674a0f


# ------------------------

#* テストコード例

# class BookTest extends TestCase
# {
#     use RefreshDatabase;
#     use WithFaker;

#     private $user;
#     // シーダーの実行
#     // protected $seeder = MstBookStatusSeeder::class;


#     public function setUp(): void
#     {
#         parent::setUp();

#         // ログインさせる場合は、factoryでダミーのユーザーを1件作り、actingAs()でリクエストする。
#         $this->user = User::factory()->create();
#     }

#     // ログインしていないユーザーがbook.indexにアクセスできないかどうか(302リヂレクトされるかどうか)
#     public function test_book_index_access_ng()
#     {
#         $response = $this->get('/book');

#         $response->assertStatus(302);
#     }

#     // ログインユーザーがbook.indexにアクセスできるかどうか(200)
#     public function test_book_index_access_ok()
#     {
#         // ログイン状態でアクセス
#         $response = $this->actingAs($this->user)->get('/book');

#         $response->assertOk();
#     }

#     // 存在するIDでbook.detailにアクセスできるかどうか(200)
#     public function test_book_detail_id_exist()
#     {
#         // $this->seed(MstBookStatusSeeder::class);
#         $book = Book::factory()->create();

#         $response = $this->actingAs($this->user)->get("/book/detail/$book->id");

#         $response->assertOk();
#     }

#     // 存在しないIDでbook.detailにアクセスできないかどうか(404)
#     public function test_book_detail_id_not_exist()
#     {
#         $response = $this->actingAs($this->user)->get("/book/detail/9999");

#         $response->assertStatus(404);

#         # 500エラーとなった。
#         # → 本来なら404になって欲しいのでソースを修正
#         # Attempt to read property "id" on null を修正
#     }

#     // 存在するIDでbook.editにアクセスできるかどうか(200)
#     public function test_book_edit_id_exist()
#     {
#         $book = Book::factory()->create();

#         $response = $this->actingAs($this->user)->get("/book/edit/$book->id");

#         $response->assertOk();
#     }

#     // 存在しないIDでbook.editにアクセスできないかどうか(404)
#     public function test_book_edit_id_not_exist()
#     {
#         $response = $this->actingAs($this->user)->get("/book/edit/9999");

#         $response->assertStatus(404);
#     }

#     // book.editで更新処理が正常に行えるかどうか
#     public function test_book_update_ok()
#     {
#         $book = Book::factory()->create();

#         $params = [
#             'id' => $book->id,
#             'name' => 'test',
#             'status' => '1',
#             'mst_book_status_id' => '1',
#             'author' => 'test',
#             'publication' => 'test',
#             'read_at' => '2022-09-24',
#             'note' => 'test',
#         ];

#         $response = $this->actingAs($this->user)->patch('/book/update', $params);

#         // 更新に成功したら、302リダイレクト
#         $response->assertRedirect();

#         // セッションにstatusが含まれていて、値が「本を更新しました。」となっているはず
#         $response->assertSessionHas('status', '本を更新しました。');

#         // DBの値が更新されたかどうか
#         $this->assertDatabaseHas('books', $params);
#     }

#     // 不正な値でbook.editで更新処理がエラーになるかどうか
#     public function test_book_update_status_ng_all()
#     {
#         $book = Book::factory()->create();

#         $params = [
#             'id' => $book->id,
#             'name' => $this->faker()->realText(256), // 255文字超え
#             'status' => '9', // [1,2,3,4]以外の値
#             'mst_book_status_id' => '9', // [1,2,3,4]以外の値
#             'author' => $this->faker()->realText(256), // 255文字超え
#             'publication' => $this->faker()->realText(256), // 255文字超え
#             'read_at' => '2022-09-24xxxx', // date型に合わない
#             'note' => $this->faker()->realText(1001), // 1000文字超え
#         ];

#         $response = $this->actingAs($this->user)->patch('/book/update', $params);

#         // 更新に失敗したら、302リダイレクト
#         $response->assertRedirect();

#         // エラーセッションに値が含まれているかどうか
#         $response->assertSessionHasErrors(['status' => '選択されたステータスは、有効ではありません。']);

#         // DBの値が更新されていないかどうか
#         $this->assertDatabaseMissing('books', $params);

#         /**
#          * エラーメッセージ
#          * name: 書籍名の文字数は、255文字以下でなければいけません。
#          * status: 選択されたステータスは、有効ではありません。
#          * author: 著者の文字数は、255文字以下でなければいけません。
#          * publication: 出版の文字数は、255文字以下でなければいけません。
#          * read_at: 読了日は、正しい日付ではありません。
#          * note: 備考の文字数は、1000文字以下でなければいけません。
#          */
#         $response->assertInvalid(['name' => '書籍名の文字数は、255文字以下でなければいけません。']);
#         $response->assertInvalid(['status' => '選択されたステータスは、有効ではありません。']);
#         $response->assertInvalid(['author' => '著者の文字数は、255文字以下でなければいけません。']);
#         $response->assertInvalid(['publication' => '出版の文字数は、255文字以下でなければいけません。']);
#         $response->assertInvalid(['read_at' => '読了日は、正しい日付ではありません。']);
#         $response->assertInvalid(['note' => '備考の文字数は、1000文字以下でなければいけません。']);
#     }

#     // book.editで更新処理が正常に行えるかどうか
#     public function test_book_create_ok()
#     {
#         $book = Book::factory()->create();

#         $params = [
#             'name' => 'test',
#             'status' => '1',
#             'mst_book_status_id' => '1',
#             'author' => 'test',
#             'publication' => 'test',
#             'read_at' => '2022-09-24',
#             'note' => 'test',
#         ];

#         $response = $this->actingAs($this->user)->post('/book/create', $params);

#         // 更新に成功したら、302リダイレクト
#         $response->assertRedirect();

#         // セッションにstatusが含まれていて、値が「本を新規登録しました。」となっているはず
#         $response->assertSessionHas('status', '本を新規登録しました。');

#         // DBの値が更新されたかどうか
#         $this->assertDatabaseHas('books', $params);
#     }


#     // 不正な値でbook.newで更新処理がエラーになるかどうか
#     public function test_book_create_status_ng_all()
#     {
#         $book = Book::factory()->create();

#         $params = [
#             'name' => $this->faker()->realText(256), // 255文字超え
#             'status' => '9', // [1,2,3,4]以外の値
#             'mst_book_status_id' => '9', // [1,2,3,4]以外の値
#             'author' => $this->faker()->realText(256), // 255文字超え
#             'publication' => $this->faker()->realText(256), // 255文字超え
#             'read_at' => '2022-09-24xxxx', // date型に合わない
#             'note' => $this->faker()->realText(1001), // 1000文字超え
#         ];

#         $response = $this->actingAs($this->user)->post('/book/create', $params);

#         // 更新に失敗したら、302リダイレクト
#         $response->assertRedirect();

#         // エラーセッションに値が含まれているかどうか
#         $response->assertSessionHasErrors(['status' => '選択されたステータスは、有効ではありません。']);

#         // DBの値が更新されていないかどうか
#         $this->assertDatabaseMissing('books', $params);

#         /**
#          * エラーメッセージ
#          * name: 書籍名の文字数は、255文字以下でなければいけません。
#          * status: 選択されたステータスは、有効ではありません。
#          * author: 著者の文字数は、255文字以下でなければいけません。
#          * publication: 出版の文字数は、255文字以下でなければいけません。
#          * read_at: 読了日は、正しい日付ではありません。
#          * note: 備考の文字数は、1000文字以下でなければいけません。
#          */
#         $response->assertInvalid(['name' => '書籍名の文字数は、255文字以下でなければいけません。']);
#         $response->assertInvalid(['status' => '選択されたステータスは、有効ではありません。']);
#         $response->assertInvalid(['author' => '著者の文字数は、255文字以下でなければいけません。']);
#         $response->assertInvalid(['publication' => '出版の文字数は、255文字以下でなければいけません。']);
#         $response->assertInvalid(['read_at' => '読了日は、正しい日付ではありません。']);
#         $response->assertInvalid(['note' => '備考の文字数は、1000文字以下でなければいけません。']);
#     }

#     // book.removeで更新処理が正常に行えるかどうか
#     public function test_book_remove_ok()
#     {
#         $book = Book::factory()->create();

#         $response = $this->actingAs($this->user)->delete("/book/remove/$book->id");

#         // 更新に成功したら、302リダイレクト
#         $response->assertRedirect();

#         // セッションにstatusが含まれていて、値が「本を物理削除しました。」となっているはず
#         $response->assertSessionHas('status', '本を物理削除しました。');

#         // 削除された確認
#         // $thisはPHPUnitTestの関数
#         $deleted_book = Book::find($book->id); // nullのはず
#         $this->assertEmpty($deleted_book);
#     }

#     // 不正な値でbook.removeで更新処理がエラーになるかどうか
#     public function test_book_remove_ng()
#     {
#         $response = $this->actingAs($this->user)->delete('/book/remove/9999');

#         $response->assertStatus(404);
#     }

#     // book.deleteで更新処理が正常に行えるかどうか
#     public function test_book_delete_ok()
#     {
#         $book = Book::factory()->create();

#         $params = [
#             "deleted_at" => date("Y-m-d H:i:s", time()),
#         ];

#         $response = $this->actingAs($this->user)->patch("/book/delete/$book->id", $params);

#         // 更新に成功したら、302リダイレクト
#         $response->assertRedirect();

#         // セッションにstatusが含まれていて、値が「本を論理削除しました。」となっているはず
#         $response->assertSessionHas('status', '本を論理削除しました。');

#         // 削除された確認
#         $soft_deleted_book = Book::find($book->id);
#         $this->assertNotEmpty($soft_deleted_book->deleted_at);
#     }

#     // 不正な値でbook.deleteで更新処理がエラーになるかどうか
#     public function test_book_delete_ng()
#     {
#         $params = [
#             "deleted_at" => date("Y-m-d H:i:s", time()),
#         ];

#         $response = $this->actingAs($this->user)->patch('/book/delete/9999', $params);

#         $response->assertStatus(404);
#     }
# }


# ------------------------

#* APIの場合のテストコード

# https://github.com/lbv180620/Laravel-TodoApp/blob/main/backend/tests/Feature/TaskTest.php


# class TaskTest extends TestCase
# {
#     use RefreshDatabase; // テスト実行時にデータベースがリセットされる。

#     private $user;

#     /**
#      * テストを実行した時に最初に実行されるメソッド
#      */
#     public function setUp(): void
#     {
#         parent::setUp();

#         // ここでログインした状態を作れば、テストをパスできるはず。

#         // ユーザーデータを1件作成
#         // $user = User::factory()->create();

#         // これでログインした状態になる
#         // $this->actingAs($user);

#         // ユーザーデータを1件作成
#         $this->user = User::factory()->create();
#     }

#     /**
#      * @test
#      */
#     public function 一覧を取得できる()
#     {
#         // ログイン状態
#         $this->actingAs($this->user);

#         // ダミーデータを10件登録
#         $tasks = Task::factory()->count(10)->create();
#         // 登録できたか確認
#         // dd($tasks->toArray());

#         // 登録したデータをAPIから取得
#         $response = $this->getJson('api/tasks');
#         // 取得できたか確認
#         // dd($response->json());


#         // 登録したデータの数と取得したデータの数が同じであるかテスト
#         $response
#             ->assertOk()
#             ->assertJsonCount($tasks->count());
#     }

#     /**
#      * @test
#      */
#     public function 登録することができる()
#     {
#         // ログイン状態
#         $this->actingAs($this->user);

#         // 登録するデータの作成
#         $data = [
#             'title' => 'テスト投稿',
#         ];

#         // storeメソッドはPOSTで受け取るので、postJson()を使用
#         // 第二引数に渡すデータを指定
#         $response = $this->postJson('api/tasks', $data);
#         // レスポンスの確認
#         // dd($response->json());


#         // アサーション
#         $response
#             // ステータスコードが正常に新規登録された時の201かどうか
#             // ->assertStatus(201)
#             ->assertCreated()
#             // 登録したデータが正しいか
#             // レスポンスのJSONに登録したデータが「どこかに」含まれているか確認したいので、assertJsonFragment()を使用する。
#             // 引数に渡した連想配列の値が含まれいるかアサートする。
#             ->assertJsonFragment($data);
#     }

#     /**
#      * @test
#      */
#     public function タイトルが空の場合は登録できない()
#     {
#         // ログイン状態
#         $this->actingAs($this->user);

#         // 登録するデータの作成
#         $data = [
#             'title' => '',
#         ];

#         // storeメソッドはPOSTで受け取るので、postJson()を使用
#         // 第二引数に渡すデータを指定
#         $response = $this->postJson('api/tasks', $data);
#         // レスポンスの確認
#         // dd($response->json());


#         // アサーション
#         $response
#             // バリデーションエラーのステータスコード422かどうか
#             ->assertStatus(422)
#             // バリデーションの文字列を確認するには、assertJsonValidationErrors()を使用する。
#             // 引数には、期待値を連想配列で指定する。
#             ->assertJsonValidationErrors([
#                 'title' => 'タイトルは、必ず指定してください。'
#             ]);
#     }

#     /**
#      * @test
#      */
#     public function タイトルが255文字以上の場合は登録できない()
#     {
#         // ログイン状態
#         $this->actingAs($this->user);

#         // 登録するデータの作成
#         $data = [
#             'title' => str_repeat('あ', 256),
#         ];

#         // storeメソッドはPOSTで受け取るので、postJson()を使用
#         // 第二引数に渡すデータを指定
#         $response = $this->postJson('api/tasks', $data);
#         // dd($response->json());


#         // アサーション
#         $response
#             // バリデーションエラーのステータスコード422かどうか
#             ->assertStatus(422)
#             // バリデーションの文字列を確認するには、assertJsonValidationErrors()を使用する。
#             // 引数には、期待値を連想配列で指定する。
#             ->assertJsonValidationErrors([
#                 'title' => 'タイトルは、255文字以下にしてください。'
#             ]);
#     }

#     /**
#      * @test
#      */
#     public function 更新することができる()
#     {
#         // ログイン状態
#         $this->actingAs($this->user);

#         // 更新は予め登録されたデータを書き換えるため、ファクトリでデータを1件登録しておく
#         $task = Task::factory()->create();
#         // dd($task->toArray());

#         // 登録したデータを置き換える
#         $task->title = '書き換え';
#         // dd($task->toArray());


#         // リクエスト送信
#         // 更新リクエストはpatchJsonを使う
#         // パスにtaskのidを入れる。
#         // 更新データを引数に渡す。
#         // $taskはモデルなので、toArrayで配列に変換。
#         $response = $this->patchJson(
#             "api/tasks/{$task->id}",
#             $task->toArray()
#         );
#         // is_doneが文字列になっている。
#         // is_doneはbooleanで使いたいので、モデルを編集する。
#         // dd($response->json());

#         // アサーション処理
#         $response
#             ->assertOk()
#             ->assertJsonFragment($task->toArray());
#     }

#     /**
#      * @test
#      */
#     public function 削除することができる()
#     {
#         // ログイン状態
#         $this->actingAs($this->user);

#         // 予め10件データを登録する
#         $tasks = Task::factory()->count(10)->create();
#         // dd($tasks->toArray());

#         // リクエスト送信
#         // idが1のレコードを削除する
#         // 削除したレコードが返る
#         $response = $this->deleteJson("api/tasks/1");
#         // dd($response->json());
#         $response->assertOk();

#         // 一覧を取得し、合計の数が減っているか確認する
#         $response = $this->getJson("api/tasks");
#         // dd($response->json());
#         // 引数に期待する数を指定
#         $response->assertJsonCount($tasks->count() - 1);
#     }
# }



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

#* テスト用DBにSQLiteを使用

# ※ローカル環境で使用可、仮想環境で使用不可

# 方法①
# ⑴ make touch-sqlite データ保存用ファイルの作成
# ⑵ backend/.envの編集 DB_CONNECTION=sqliteとし、その他のDB_XXXXはコメントアウト
# ⑶ backend/config/database.phpの編集 'database' => env(database_path('database.sqlite'), database_path('database.sqlite')), とする
# ⑷ make mig テーブル作成
# ⑸ DB Browser for SQLite でdatabase.sqliteを開き、確認

# 方法②
# ⑴ make touch-sqlite データ保存用ファイルの作成
# ⑵ backend/.envの編集 DB_CONNECTION=sqliteとし、その他のDB_XXXXはコメントアウト
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

#* テスト用DBにdb-testコンテナを使用

# 記事
# https://imanaka.me/laravel/laravel-sail-mysql-test/
# https://www.engilaboo.com/laravel-test-by-docker/#rtoc-4
# https://maasaablog.com/development/docker/1169/
# https://qiita.com/ucan-lab/items/42c1814d8bd69895374c


# ........................

#~ ①テスト用DBコンテナの作成手順:
# ⑴ docker-compose.ymlのdbコンテナをコピペ

# ⑵ テスト用に修正
# - コンテナ名
# ※ db-test
# - ポート番号
# ※ 1ずらす 3307:3306
# - データベース名
# ※ ${DB_DATABASE:-laravel_local}_test
# - ボリュームマウント先
# ※ db-test-store:/var/lib/mysql


#~ ②テスト用DB管理ツールコンテナの作成手順
# ⑴ docker-compose.ymlのdbコンテナをコピペ

# ⑵ テスト用に修正
# - コンテナ名
# - ポート番号
# ※ 1ずらす 4041:80
# - ホスト名
# ※ テスト用DBコンテナ名に変更 db-test
# - links
# ※ テスト用DBコンテナ名に変更 db-test


#~ ③テスト用トップレベル名前付きボリュームの作成手順
# ⑴ db
# ⑵ テスト用に修正
# - db-test-store
# - device: $PWD/infra/data-test

# ⑶ infra/data-testディレクトリを作成
# ※ .gitignoreにも記載


#^ ここまでの修正ができたら、make upで反映させる


# ........................

#~ ④テスト用DBを開発用DBと一致させる手順
# ⑴ テスト用のenvファイルを作成
# ※ backend/.envファイルをコピーして.env.testingファイルを作成

# ⑵ .env.testingの修正
# - APP_ENV=testing
# - DB_CONNECTION
# ※ 使用するRDBを指定
# - DB_HOST
# ※ テスト用DBコンテナ名 db-test
# - DB_DATABASE
# ※ テスト用DB名 XXXX_test

# ⑶ APP_KEYの設定
# make keyenv env=testing
# or
# make keyshow → APP_KEYにコピペ

# ⑷ テストDBのmigrationをする
# make mig env=testing
# make seed env=testing


#^ docker-compose.ymlのweb|appコンテナのenvironmentのDB_HOSTとDB_DATABASEをコメントアウトし、make up
# → Laravelに関わる環境変数は.envファイルに任せた方が環境によってDBを切り替える際、柔軟になる。
# → 開発環境とテスト環境では、DB_PORT, DB_USERNAME, DB_PASSWORD は共通なので、docker-compose.ymlのenvironmentで管理してもいい。


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


# ==== 補足説明 ====

# 記事
# https://imanaka.me/laravel/laravel-sail-mysql-test/

# **** laravelのphpunitの設定ファイルについて *****

# ・testsuiteでUnitテスト、Featureテストを分けます。
# ・excludeでテストから除外したいファイルを指定します。
# ・coverageでカバレッジ対象を指定します。
# ・phpのenvセクションでenvファイルを指定します。この例だと、「.env.testing」ファイルが読み込まれます。


# **** テストコードの実行方法について ****

# $ sail test

# $ sail php artisan test

# $ sail shell
# $ ./vendor/bin/phpunit

# 応用
# testsuite毎にテストを実行できる
# $ php artisan test --testsuite=Feature # featureのみ実行する
# $ php artisan test --testsuite=Unit # Unitのみ実行する

# excludeで不必要なテストを除外する
# <testsuite name="Feature">
#     <directory suffix="Test.php">./tests/Feature</directory>
#     <exclude>./tests/Unit/ExampleTest.php</exclude>
# </testsuite>

# helpのやり方
# $ sail php artisan test --help


# **** Laravelのテストファイルの作成方法について ****

# featureテストファイルを作成したい場合は、オプションなし
# unitテストファイルを作成したい場合は、–unitとオプションをつけてください。

# $ sail php artisan make:test UserTest # featureの作成
# $ sail php artisan make:test UserTest --unit # unitの作成


# **** VSCodeからDockerコンテナ内のPHPUnitを実行する方法 ****

# 記事
# https://www.webopixel.net/php/1740.html

# 使用する拡張機能
# https://marketplace.visualstudio.com/items?itemName=emallin.phpunit

# .vscode/settings.json
# {
#   "makefile.extensionOutputFolder": "./.vscode",
#   "phpunit.command": "docker compose exec web",
#   "phpunit.phpunit": "vendor/bin/phpunit",
#   "phpunit.paths": {
#     "${workspaceFolder}": "/work"
#   }
# }


# テストコード上で、コマンドパレットを開く(Shift + Command + p) → "PHPUnit Test"を選択


# ==== コマンド群 ====

# **** 単体テスト関連 ****

# 全テストケース実行
tests:
	docker compose exec $(ctr) php artisan test

# name=Unit, name=Feature
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
	@make mktest-u


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

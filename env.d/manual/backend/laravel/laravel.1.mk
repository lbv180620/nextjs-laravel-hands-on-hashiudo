#todo [Laravel Tips]

# https://laravel.com/
# https://laracasts.com/
# https://laravel-news.com/
# https://laracon.net/
# https://larajobs.com/

# https://github.com/laravel/framework

# Laravel 9
# https://laravel.com/docs/9.x
# https://readouble.com/laravel/9.x/ja/
# https://imanaka.me/laravel/create-books-app-install/


# **** 基本的な流れ ****

# DB設計(テーブル設計)
# ⬇️
# マイグレーション
# ⬇️
# (ダミーデータ)

# URI設計
# ⬇️
# ルーティング


# **** マイグレートまでの流れ ****

#【Laravel】 マイグレーションでテーブルの作成や編集をする
# https://progtext.net/programming/laravel-migration/


# ⑴ ER図を見て、モデルとマイグレーションファイルを作成

# make mkmodel-m model=<モデル名>

# ? テーブルの単数型を調べる方法
# php artisan tinker // ターミナルでPHPを実行
# echo Str::plural('単語'); // 単数形 → 複数形
# echo Str::singular('単語'); // 複数形 → 単数形


# ⑵ ER図を見て、マイグレーションファイルの編集

#! FKのデータ型は全てunsignedBigIntegerで揃える(usersテーブルも忘れずに)!

#^ 例) 1つのmemoに複数のtagを紐づける場合、中間テーブルが必要。

# PK
#^ 中間テーブルでは無くてもいい。
# $table->unsignedBigInteger('id', true);

# 通常カラム
#^ 中間テーブルには不要。
# $table->longText('content');

# FK
# $table->unsignedBigInteger('user_id');
# $table->foreign('user_id')->references('id')->on('users');

# 論理削除(削除時刻)
#^ 中間テーブルでは無くてもいい。
# $table->softDeletes();

# 更新・作成時刻
#^ 中間テーブルでは無くてもいい。
#  $table->timestamp('created_at')->default(DB::raw('CURRENT_TIMESTAMP'));
#  $table->timestamp('updated_at')->default(DB::raw('CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP'));

# ⑶ マイグレート

# make mig


# ----------------

#? ロールバック時に外部キー制約を解除する方法

# 記事
# https://qiita.com/igayamaguchi/items/897097ff430588f43a30
# https://qiita.com/kamome_susume/items/67ab3c47b7f9fecfb04a
# https://blog.websandbag.com/entry/2020/07/27/223036
# https://progtext.net/programming/laravel-migration/


# $table->dropForeign('[テーブル名]_[フォーリンキーを取り除くカラム名]_foreign');
# or
# $table->dropForeign(['カラム名', ...])


# ----------------

#? 外部キー制約の設定方法

# Laravel 外部キー制約の設定方法【2つの方法を解説】
# https://takuma-it.com/laravel-foreign-key/


# 方法①: foreign() references() on()を使った書き方

# Schema::table('articles', function (Blueprint $table) {
#     $table->unsignedBigInteger('user_id');

#     $table->foreign('user_id')->references('id')->on('users')->onDelete('cascade');
# });


# ....................

# 方法②: foreignId() constrained()を使った書き方

# https://github.com/lbv180620/Laravel-TodoApp/blob/main/backend/database/migrations/2022_05_16_020614_create_tasks_table.php

# Schema::table('articles', function (Blueprint $table) {
#     $table->foreignId('user_id')->constrained();
# });


#^ どの書き方も同じ意味
# $table->unsignedBigInteger('user_id');

# $table->foreign('user_id')->references('id')->on('user_id');
# $table->foreignId('user_id')->constrained('users');
# $table->foreignId('user_id')->constrained(); // user_idからusersを推測してくれる


# ----------------

#! 外部キーを持つテーブルをマイグレーションした時のエラー'Failed to open the referenced table'の解決方法

# https://qiita.com/Mi_tsu_ya/items/2d850c981d5fc60856f5

# 子テーブルのマイグレーションファイルを作った後に、Usersテーブル親テーブルのマイグレーションファイルを作ったことが原因
# → 外部キーがある方が子テーブル

# 解決策: 日付けをずらす


# **** ダミーデータ作成手順 ****

# https://github.com/lbv180620/Laravel-TodoApp/tree/main/backend/database

# Fakerチートシート
# https://yukiyuriweb.com/2022/07/08/laravel-faker-cheat-sheet/
# https://qiita.com/tosite0345/items/1d47961947a6770053af
# https://qiita.com/kurosuke1117/items/c672405ac24b03af2a90


# ⑴ Seederクラスの作成とファイルの編集
# make mkseeder model=<モデル名>

# ⑵ Factoryクラスの作成とファイルの編集
# make mkf model=<モデル名>

# ⑶ DatabaseSeederへSeederクラスを登録
#^ 注意: 親テーブル(外部キーが無いテーブル)を優先して上から並べる！
# → でないと、make seedした時に以下のエラーが発生する
# SQLSTATE[23000]: Integrity constraint violation: 1452 Cannot add or update a child row: a foreign key constraint fails

# ⑷ Seederを実行
# make seed


# --------------------

#? TinkerでFakerのメソッドを確認する方法

# make tinker
# $faker = app()->make(Faker\Generator::class)
# $faker->name()


# --------------------

#? $faker->imageUrl() 「lorempixel.com」から「picsum.photos」に変更する方法

# 2019-06-13 23:48 時点で lorempixel.com が落ちてるので、fzaninotto/Faker で image() を使ってて $faker->image() が false になるので代替サビースを強引に使ってみるよ
# https://qiita.com/hokutoasari/items/68de9ede83f2bf47e67c


# /vendor/fzaninotto/faker/src/Faker/Provider/Image.php

#     public static function imageUrl($width = 640, $height = 480, $category = null, $randomize = true, $word = null, $gray = false)
#     {
# - $baseUrl = "https://lorempixel.com/";
# +         // $baseUrl = "https://lorempixel.com/";
# +         $baseUrl = "https://picsum.photos/";


#             $ch = curl_init($url);
#             curl_setopt($ch, CURLOPT_FILE, $fp);
# -           $success = curl_exec($ch) && curl_getinfo($ch, CURLINFO_HTTP_CODE) === 200;
# + //            $success = curl_exec($ch) && curl_getinfo($ch, CURLINFO_HTTP_CODE) === 200;
# +             $success = curl_exec($ch) && (curl_getinfo($ch, CURLINFO_HTTP_CODE) === 200 or curl_getinfo($ch, CURLINFO_HTTP_CODE) === 302 or curl_getinfo($ch, CURLINFO_HTTP_CODE) === 301);


# **** vendorのオーバーライド ****

# Laravelのvendorとは？注意点やオーバーライドを絵付きで分かりやすく解説
# https://biz.addisteria.com/laravel_vendor/

# Laravelでvendor内の処理をオーバーライドする方法
# https://qiita.com/hamkiti/items/d06367927e1a4ac1971d

# Laravelでvendor以下を汚さずユーザー登録をいい感じにする
# https://dev.dynamic-pricing.tech/post/laravel-user-registration/


# ----------------

#~ オーバーライドの手順

# ⑴ オーバーライドしたいvendorファイルをコピーし、app/に貼り付け
# 例）app\Vendor\laravel\framework\src\Illuminate\Foundation\Auth\RegistersUsers.php

# ⑵ 問題の箇所を修正

# ⑶ composer.jsonのautoloadを修正
# - exclude-from-classmap: 元のファイルを指定し、読み込まないようにする。
# - files: 修正後のファイルを指定し、こちらを優先して読み込むようにする。

# 例）
# "autoload": {

#     "exclude-from-classmap": [
#         "vendor\\laravel\\framework\\src\\Illuminate\\Foundation\\Auth\\RegistersUsers.php"
#     ],
#     "files":[
#         "app\\Vendor\\laravel\\framework\\src\\Illuminate\\Foundation\\Auth\\RegistersUsers.php"
#     ]
# }

# ⑷　composer.jsonの変更を反映する
# composer dump-autoload


# **** ルーティング ****

# ログイン必須
# Route::middleware(['auth'])->prefix('')->group(function () {
#
# });


# **** レイアウトの調整 ****

# layouts: @yield('content')
# auth: @extends('layouts.auth'), @section('content') @endsection
# モデル名: @extends('layouts.<モデル名>'), @section('content') @endsection


# --------------------

#? 日付のレイアウトを整える方法(Carbon使用)

# 例1:
# <td class="text-sm border-t-2 border-gray-200 px-4 py-3">{{ Carbon\Carbon::parse($book->read_at)->format('Y年n月j日') }}</td>

# 例2
# {{ $article->created_at->format('Y/m/d H:i') }}

#『Carbon』でよく使うパターンをまとめてみた【Laravel向け】
# https://coinbaby8.com/carbon-laravel.html

#【Laravel】Carbonを初めて使ってみた
# https://qiita.com/mackeyTA/items/e8b5e47a9f020a1902c0

# Carbonで日付操作(比較, 差分, format)
# https://www.wakuwakubank.com/posts/421-php-carbon/

# 全217件！Carbonで時間操作する実例
# https://blog.capilano-fw.com/?p=867

#【PHP日付ライブラリ】carbonの使い方について
# https://codelikes.com/laravel-carbon/

# Carbon（PHP/Laravel）でタイムゾーンが異なる日時を扱う場合の対応方法
# https://www.sria.co.jp/blog/2022/04/php-laravel-carbon/


# --------------------

#? 適切な長さで文字を区切る方法

# <td class="text-sm border-t-2 border-gray-200 px-4 py-3">{{ Str::limit($book->note, 40, $end='...') }}</td>


#【Laravel】指定の文字数以上の文字列を表示するとき、「...」としたい場合
# https://qiita.com/sasao3/items/42b1841f5dcfc1374b49


#【Laravel】bladeで表示文字数を制限して末尾を"..."や"...続きを読む"に変更する方法
# https://www.motokis-brain.com/article/39


# --------------------

#? ページネーションの設定

# Laravelのページネーション(Pagination)について（カスタマイズするには）
# https://codelikes.com/laravel-pagination-custom/

# Laravel8 でPaginationを簡単に美しく実装する方法【Bootstrap利用】
# https://biz.addisteria.com/laravel8_pagination/

# Laravel8でページネーション(Pagination)を実装する方法
# https://leben.mobi/blog/laravel8_pagination/php/

# Laravel のページャー（ページネーション）の表示とカスタマイズ
# https://pgmemo.tokyo/data/archives/1278.html

# Laravelで作る一覧画面: ページネーション
# https://zenn.dev/qljmssqh/articles/a2edc1373c001a


#~ 設定手順

# 【Laravel】独自のページネーションを作成する
# https://zakkuri.life/laravel-original-pagination/

# 1.Controllerを下記にする

# $books = Book::all();
# ⬇️
# $books = Book::paginate(10);


# .....................

# 2.books.index.blade.phpに書きを追加する

# {{ $books->links() }}


# .....................

# 3.ページネーション用のCSSを当てる

# sail php artisan vendor:publish --tag=laravel-pagination
# ※tailwind.blade.phpがデフォルトで適用される。


# .....................

# 4. 26〜40行目をコメントアウトか削除


# .....................

# 5 .25行目を変更する

# <div class="hidden sm:flex-1 sm:flex sm:items-center sm:justify-center">


# .....................

# 6. ja.jsonを変更する（示すこと → 全 に変更する）

# "Showing": "全"


# .....................

# 7.一番後ろに下記を追加する

#     <div>
#       <p class="text-sm text-gray-700 leading-5">
#         {!! __('Showing') !!}
#         <span class="font-medium">{{ $paginator->total() }}</span>
#         件中
#         @if ($paginator->firstItem())
#           <span class="font-medium">{{ $paginator->firstItem() }}</span>
#           〜
#           <span class="font-medium">{{ $paginator->lastItem() }}</span>
#         @else
#           {{ $paginator->count() }}
#         @endif
#         件
#       </p>
#     </div>
#   </nav>
# @endif


# .....................

# 8. navに、flex-colをつける

# <nav role="navigation" aria-label="{{ __('Pagination Navigation') }}" class="flex-col flex items-center justify-between">


# --------------------

#? ダッシュボードをbookにする方法

# 1.resources/views/layouts/navigation.bladeの14〜18行目を変更する

# 2.resouces/views/book/index.bladeの4行目を変更する

# 3.app/Providers/RouteServiceProvider.phpを変更する

#^ ログインされた際に、デフォルトではdashboardにリダイレクトされるように設定されている。

# public const HOME = '/dashboard';
# ⬇️
# public const HOME = '/book';


# --------------------

#? ボタン集

# 詳細ボタン
# <td class="border-t-2 border-gray-200 px-4 py-3">
#   <button onclick="location.href='/book/detail/{{ $book->id }}'"
#     class="text-sm shadow bg-gray-500 hover:bg-gray-400 focus:shadow-outline focus:outline-none text-white font-bold py-2 px-4 rounded">
#     詳細
#   </button>
# </td>


# 戻るボタン
# <button onclick="history.back()"
#   class="mt-4 mr-4 shadow bg-gray-500 hover:bg-gray-400 focus:shadow-outline focus:outline-none text-white font-bold py-2 px-4 rounded"
#   type="button">
#   {{ __('戻る') }}
# </button>


# 変更ボタン
# <button onclick="location.href='/book/edit/{{ $book->id }}'"
#   class="mt-4 mr-2 shadow bg-orange-500 hover:bg-orange-400 focus:shadow-outline focus:outline-none text-white font-bold py-2 px-4 rounded">
#   変更
# </button>


# 物理削除ボタン
# <div class="absolute inset-y-0 right-0">
#     <form action="/book/remove/{{ $book->id }}" method="POST">
#         @csrf
#         @method('delete')
#         <button type="submit" class="mt-4 mr-4 shadow bg-red-500 hover:bg-red-400 focus:shadow-outline focus:outline-none text-white font-bold py-2 px-4 rounded">削除</button>
#     </form>
# </div>


# 論理削除ボタン
# <form action="{{ route('destroy') }}" method="POST" id="delete-form">
#   @method('PATCH')
#   @csrf
#   <input type="hidden" name="memo_id" value="{{ $edit_memos[0]['id'] }}">
#   <i class="fas fa-trash mr-3" onclick="deleteHandle(event);"></i>
# </form>


# ................

#^ 確認ダイアログ

# @section('javascript')
#   <script src="{{ asset('js/confirm.js') }}"></script>
# @endsection

# @yield('javascript')

# onclick="deleteHandle(event);

# public/js/confirm.js
# const deleteHandle = (event) => {
#     // 一旦フォームの動きを止める
#     event.preventDefault();

#     if (window.confirm("本当に削除していいですか?")) {
#         // 削除OKならフォームを再開
#         document.getElementById("delete-form").submit();
#     } else {
#         alert("キャンセルしました");
#     }
# };


# --------------------

#? フラッシュメッセージを表示する

# components/ui/flash-message.blade.php
# <div x-show="isOpen" x-data="display()" class="bg-blue-100 border border-blue-400 text-blue-700 px-4 py-3 rounded relative" role="alert">
#   <span class="block sm:inline">{{ $attributes->get('message') }}</span>
#   <span class="absolute top-0 bottom-0 right-0 px-4 py-3">
#     <svg x-on:click="close()" class="fill-current h-6 w-6 text-blue-500" role="button" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20"><title>Close</title><path d="M14.348 14.849a1.2 1.2 0 0 1-1.697 0L10 11.819l-2.651 3.029a1.2 1.2 0 1 1-1.697-1.697l2.758-3.15-2.759-3.152a1.2 1.2 0 1 1 1.697-1.697L10 8.183l2.651-3.031a1.2 1.2 0 1 1 1.697 1.697l-2.758 3.152 2.758 3.15a1.2 1.2 0 0 1 0 1.698z"/></svg>
#   </span>
# </div>

# <script>
# function display() {
#     return {
#         show: true,
#         close() { this.show = false },
#         isOpen() { return this.show === true },
#     }
# }
# </script>


# index.blade.php
# @if(session('status'))
#   <x-ui.flash-message message="{{ session('status') }}"></x-ui.flash-message>
# @endif



# --------------------

#& フォームレイアウト

# input
# <div class="col-span-6 sm:col-span-3">
#     <input type="text" name="name" id="name" autocomplete="given-name" class="mt-1 focus:ring-indigo-500 focus:border-indigo-500 block w-full shadow-sm sm:text-sm border-gray-300 rounded-md">
# </div>


# textarea
# <div class="mt-1">
#     <textarea id="note" name="note" rows="3" class="shadow-sm focus:ring-indigo-500 focus:border-indigo-500 mt-1 block w-full sm:text-sm border border-gray-300 rounded-md"></textarea>
# </div>


# selectbox
# <select id="status" name="status" autocomplete="country-name" class="mt-1 block w-full py-2 px-3 border border-gray-300 bg-white rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm">
#     <option>United States</option>
#     <option>Canada</option>
#     <option>Mexico</option>
# </select>


# form
# <form class="w-full" action="{{ route('book.update') }}" method="POST">
#     @csrf
#     @method('PATCH')
# </form>


# hidden
# <input value="{{ $book->id }}" name="id" type="hidden">
#^ DIを使用する場合は不要


# submit
# <button type="submit"
# class="mt-4 mr-2 shadow bg-orange-500 hover:bg-orange-400 focus:shadow-outline focus:outline-none text-white font-bold py-2 px-4 rounded">
# 変更
# </button>


# ........................

# selectboxの値を設定


# 1.モデルに定数を定義する

# Book.php
# public const BOOK_STATUS_READING = 1;
# public const BOOK_STATUS_UNREAD = 2;
# public const BOOK_STATUS_DONE = 3;
# public const BOOK_STATUS_WANT_READ = 4;

# public const BOOK_STATUS_NAME_READING = '読書中';
# public const BOOK_STATUS_NAME_UNREAD = '未読';
# public const BOOK_STATUS_NAME_DONE = '読了';
# public const BOOK_STATUS_NAME_WANT_READ = '読みたい';

# public const BOOK_STATUS_OBJECT = [
#     self::BOOK_STATUS_READING => self::BOOK_STATUS_NAME_READING,
#     self::BOOK_STATUS_UNREAD => self::BOOK_STATUS_NAME_UNREAD,
#     self::BOOK_STATUS_DONE => self::BOOK_STATUS_NAME_DONE,
#     self::BOOK_STATUS_WANT_READ => self::BOOK_STATUS_NAME_WANT_READ,
# ];

# public const BOOK_STATUS_ARRAY = [
#     self::BOOK_STATUS_READING,
#     self::BOOK_STATUS_UNREAD,
#     self::BOOK_STATUS_DONE,
#     self::BOOK_STATUS_WANT_READ,
# ];


# 2.selectboxにforeachでbookの値を設定する

# @foreach(App\Models\Book::BOOK_STATUS_OBJECT as $key => $value)
#     <option value="{{ $key }}" @if($key === $book->status) selected @endif>{{ $value }}</option>
# @endforeach


#^ @php use App\Models\Book; @endphp

# ........................

#? 定数の定義場所

# 方法①: マスターテーブルを作成する

# 定数をテーブルに持たせておくやり方。

# メリット:
# 値が追加・変更された場合にソースコードを直接修正する必要がなくなる。
# デメリット:
# 作るのがめんどくさい。
# 値が大量にある場合はマスターテーブルを作った方がいい。


# 方法②: モデルに定数を定義する


# ........................

#? フォームの入力値を保持する方法

# 記事
# https://codelikes.com/laravel-old/
# https://rapicro.com/laravel_old_helper/
# https://qiita.com/yukibe/items/8bddeba1150437389eb0
# https://zenn.dev/hommayade/articles/fe633d624b3511
# https://www.kamome-susume.com/laravel-old/
# https://zakkuri.life/laravel-old/
# https://mutimutisan.com/old-laravel


# <input type="text" name="name" id="name" autocomplete="given-name" value="{{ $book->name ?? old('name') }}">


# **** マスターテーブル ****

# 記事
# マスタテーブルとはいったい何か？そして特徴について知ろう！！
# https://www.katalog.tokyo/?p=5986

#【Laravel】都道府県のセレクトボックスの実装方法
# https://takuma-it.com/laravel-prefecture-select-box/


# --------------------

#~ マスターテーブルの作成手順

# 例) 都道府県マスターテーブルの作成

# ⑴ マイグレーションファイルを作成
# php artisan make:migration create_mst_prefectures_table


# ........................

# ⑵ マイグレーションファイルの編集

    # public function up()
    # {
    #     Schema::create('mst_prefectures', function (Blueprint $table) {
    #         $table->id();
    #         $table->string('name')->unique();
    #         $table->timestamps();
    #     });
    # }

#^ ユニーク制約を付ける


# ........................

# ⑶ マイグレート
# php artisan migrate


# ........................

# ⑷ シーダーファイルを作成
# php artisan make:seeder MstPrefectureSeeder


# ........................

# ⑸ シーダーファイルの編集

    # public function run()
    # {
    #     $params = [
    #         ['id' => 1, 'name' => '北海道'],
    #         ['id' => 2, 'name' => '青森県'],
    #         ['id' => 3, 'name' => '岩手県'],
    #         ['id' => 4, 'name' => '宮城県'],
    #         ['id' => 5, 'name' => '秋田県'],
    #         ['id' => 6, 'name' => '山形県'],
    #         ['id' => 7, 'name' => '福島県'],
    #         ['id' => 8, 'name' => '茨城県'],
    #         ['id' => 9, 'name' => '栃木県'],
    #         ['id' => 10, 'name' => '群馬県'],
    #         ['id' => 11, 'name' => '埼玉県'],
    #         ['id' => 12, 'name' => '千葉県'],
    #         ['id' => 13, 'name' => '東京都'],
    #         ['id' => 14, 'name' => '神奈川県'],
    #         ['id' => 15, 'name' => '新潟県'],
    #         ['id' => 16, 'name' => '富山県'],
    #         ['id' => 17, 'name' => '石川県'],
    #         ['id' => 18, 'name' => '福井県'],
    #         ['id' => 19, 'name' => '山梨県'],
    #         ['id' => 20, 'name' => '長野県'],
    #         ['id' => 21, 'name' => '岐阜県'],
    #         ['id' => 22, 'name' => '静岡県'],
    #         ['id' => 23, 'name' => '愛知県'],
    #         ['id' => 24, 'name' => '三重県'],
    #         ['id' => 25, 'name' => '滋賀県'],
    #         ['id' => 26, 'name' => '京都府'],
    #         ['id' => 27, 'name' => '大阪府'],
    #         ['id' => 28, 'name' => '兵庫県'],
    #         ['id' => 29, 'name' => '奈良県'],
    #         ['id' => 30, 'name' => '和歌山県'],
    #         ['id' => 31, 'name' => '鳥取県'],
    #         ['id' => 32, 'name' => '島根県'],
    #         ['id' => 33, 'name' => '岡山県'],
    #         ['id' => 34, 'name' => '広島県'],
    #         ['id' => 35, 'name' => '山口県'],
    #         ['id' => 36, 'name' => '徳島県'],
    #         ['id' => 37, 'name' => '香川県'],
    #         ['id' => 38, 'name' => '愛媛県'],
    #         ['id' => 39, 'name' => '高知県'],
    #         ['id' => 40, 'name' => '福岡県'],
    #         ['id' => 41, 'name' => '佐賀県'],
    #         ['id' => 42, 'name' => '長崎県'],
    #         ['id' => 43, 'name' => '熊本県'],
    #         ['id' => 44, 'name' => '大分県'],
    #         ['id' => 45, 'name' => '宮崎県'],
    #         ['id' => 46, 'name' => '鹿児島県'],
    #         ['id' => 47, 'name' => '沖縄県'],
    #     ];
    #     DB::table('mst_prefectures')->insert($params);
    # }


# ........................

# ⑹ シーダーの親ファイルに作成したMstPrefectureSeederを登録

# class DatabaseSeeder extends Seeder
# {
#     /** 実行したいSeederをここに登録 */
#     private const SEEDERS = [
#         MstPrefectureSeeder::class,
#     ];
#     /**
#      * Seed the application's database.
#      *
#      * @return void
#      */
#     public function run()
#     {
#         foreach(self::SEEDERS as $seeder) {
#             $this->call($seeder);
#         }
#     }
# }


# ........................

# ⑺ シーダーを実行
#親シーダー(DatabaseSeeder)ファイルに登録してあるシーダー全てを実行する場合
# php artisan db:seed

#特定のシーダーファイルのみを実行する場合
# php artisan db:seed --class=MstPrefectureSeeder


# tinkerにてデータの確認
# php artisan tinker
# App\Models\MstPrefecture::all();


# ........................

# ⑻ モデルの作成
# php artisan make:model MstPrefecture


# ........................

# ⑼ モデルの編集

# MstPrefecture.php
# class MstPrefecture extends Model
# {
#     use HasFactory;

#     protected $fillable = [
#         'name',
#     ];

# /**
#      * 都道府県に紐付く投稿の取得(Postモデルとのリレーション)
#      */
#     public function posts()
#     {
#         return $this->hasMany(post::class, 'prefecture_id', 'id');
#     }
# }


#Post.php
# class Post extends Model
# {
#     use HasFactory;

#     protected $fillable = [
#     #他のカラム名はあなたのカラム名を書いてください
#         'prefecture_id',
#     ];

#     /**
#      * 投稿の都道府県の取得(MstPrefectureモデルとのリレーション)
#      */
#     public function prefecture()
#     {
#         return $this->belongsTo(MstPrefecture::class);
#     }
# }


# ........................

# (10) コントローラーにてマスターデータの取得

# PostController.php
# class PostController extends Controller
# {
#     /**
#      * 投稿作成
#      * @return \Illuminate\Contracts\View\View|\Illuminate\Contracts\View\Factory
#      */
#     public function create()
#     {
#         // 都道府県テーブルの全データを取得する
#         $prefectures = MstPrefecture::all();

#         return view('post.create')
#             ->with([
#                 'prefectures' => $prefectures,
#             ]);
#     }

#     /**
#      * 投稿編集
#      * @param Request $request
#      * @param int
#      * @return \Illuminate\Contracts\View\View|\Illuminate\Contracts\View\Factory
#      */
#     public function edit(Post $post)
#     {
#         // 都道府県テーブルの全データを取得する
#         $prefectures = MstPrefecture::all();

#         return view('post.edit')
#             ->with([
#                 'prefectures' => $prefectures,
#                 'post' => $post,
#             ]);
#     }
# }


# ........................

# (11) Viewファイルにセレクトボックスの設置

# create(edit).blade.php
# <div>
#     <label>都道府県</label>
#     <small class="text-red">※必須</small>
#     <select type="text" class="form-control" name="prefecture_id" required>
#         <option disabled style='display:none;' @if (empty($post->prefecture_id)) selected @endif>選択してください</option>
#         @foreach($prefectures as $pref)
#             <option value="{{ $pref->id }}" @if (isset($post->prefecture_id) && ($post->prefecture_id === $pref->id)) selected @endif>{{ $pref->name }}</option>
#         @endforeach
#     </select>
# </div>


# ........................

# (12) 投稿詳細ページでの表示方法

# // $postという変数がコントローラから渡せている前提で

# {{ $post->prefecture->name }}

# // prefecture_idが１で保存されていたら北海道と表示される


# **** トランザクション ****

# 複数のテーブルに同時に更新する時にデータに不整合が起きるのを防ぐために必要。

# https://github.com/lbv180620/laravel-simple-memo-v2/blob/main/backend/app/Http/Controllers/HomeController.php


# BookController.php
# public function update(Request $request)
# {
#   try {
#         DB::beginTransaction();
#         $book = Book::find($request->input('id'));
#         $book->name = $request->input('name');
#         $book->status = $request->input('status');
#         $book->author = $request->input('author');
#         $book->publication = $request->input('publication');
#         $book->read_at = $request->input('read_at');
#         $book->note = $request->input('note');
#         $book->save();
#         DB::commit();
#         return redirect('book')->with('status', '本を更新しました。');
#     } catch (\Exception $ex) {
#         DB::rollback();
#         logger($ex->getMessage());
#         return redirect('book')->withErrors($ex->getMessage());
#     }
# }


# public function store(Request $request)
#     {
#        try {
#            Book::create($request->all());
#            return redirect('book')->with('status', '本を作成しました。');
#        } catch (\Exception $ex) {
#            logger($ex->getMessage());
#            return redirect('book')->withErrors($ex->getMessage());
#        }
#     }


#^ 処理成功したら、成功メッセージを持たせてリダイレクトさせる。
# → 以下のようにして、値を取り出す。
# @if (session('status'))
#     <div class="alert alert-success" role="alert">
#         {{ session('status') }}
#     </div>
# @endif


#^ 処理失敗したら、ログにエラー内容を記録し、エラーメッセージを持たせてリダイレクトさせる。
# → 以下のようにして値を取り出す。
# @if ($errors->any())
#     <div class="alert alert-danger">
#         <ul>
#             @foreach ($errors->all() as $error)
#                 <li>{{ $error }}</li>
#             @endforeach
#         </ul>
#     </div>
# @endif


# ----------------

#? redirect()

#【Laravel】return back() で何が起きてるか調べてみた
# https://qiita.com/kondo0602/items/562b915e3e2f2734db96

#【Laravel】リダイレクトの書き方メモ
# https://qiita.com/manbolila/items/767e1dae399de16813fb

# Laravelでリダイレクトする方法や実装パターン6つ書いてみた
# https://codelikes.com/laravel-redirect/

# LaravelでSession(セッション)の使い方まとめ
# https://codelikes.com/laravel-use-session/


# ----------------

#? withErrors

# Laravel 【入門】 withErrorsの使い方
# https://qiita.com/adgjmptwgw/items/2a461cdeeb4d9848a57b


# ----------------

#? $fillableと$guarded

# 記事
# https://mebee.info/2020/05/12/post-11098/
# https://qiita.com/mmmmmmanta/items/74b6891493f587cc6599

#^ $fillableを指定しないで、create()やupdate()メソッドを使うと以下のエラーが出る。
# [2022-09-22 12:41:32] local.DEBUG: Add [_token] to fillable property to allow mass assignment on [App\Models\Book].

# ....................

# $fillable
# → ホワイトリストとして利用できます。(モデルがその属性以外を持ちません。)
# → 指定したカラムに対してのみ、 create()やupdate() 、fill()が可能になります。
# → not null指定したカラムはここに指定する。nullableなカラムは指定しなくいい。

# class Task extends Model
# {
#     protected $fillable = [
#         'subject',
#     ];
# }


# 挙動確認:
# // protected $fillable = ['name', 'hobby'];

# $model = new Model([
#     'id' => 9999,
#     'name' => 'Suzuki',
#     'hobby' => 'Music',
#     'created_at' => '2000-01-01 12:00:00',
#     'updated_at' => '2000-01-01 12:00:00',
#     'hoge' => 'fuga',
# ]);

# $model->getAttributes(); // ['name' => 'Suzuki', 'hobby' => 'Music']

# $model->save(); // 成功


# ....................

# $guarded
# → ブラックリストとして利用できます。(モデルからその属性が取り除かれます。)
# → 指定したカラムは、 create()やupdate() 、fill()が不可能となります。

# class Task extends Model
# {
#     protected $guarded = [
#         'subject',
#     ];
# }


# 挙動確認:
# // protected $guarded = ['id', 'created_at', 'updated_at'];

# $model = new Model([
#     'id' => 9999,
#     'name' => 'Suzuki',
#     'hobby' => 'Music',
#     'created_at' => '2000-01-01 12:00:00',
#     'updated_at' => '2000-01-01 12:00:00',
#     'hoge' => 'fuga',
# ]);

# $model->getAttributes(); // ['name' => 'Suzuki', 'hobby' => 'Music', 'hoge' => 'fuga']

# $model->save(); // エラー。hogeカラムはテーブルにない


# **** Laravel Eloquent Collection ****

# Laravel Eloquent Collectionまとめるぜ！
# https://www.yuulinux.tokyo/16949/

# Laravel Eloquent 個人用チートシート
# https://developer.same-san.com/detail/laravel-eloquent

# Laravel Eloquent Cheat Sheet
# https://qiita.com/netfish/items/1094f18fa32f03c614c3

#【Laravel】データ取得 find・first・get・all の違いをしっかり理解 【比較】
# https://enginiya.com/entry/laravel-get-data-methods


# -------------------

#? create()

#【Laravel】Eloquentのcreate、saveの使い分け
# https://maasaablog.com/development/laravel/897/

# Laravelのinsertはcreateメソッドを使うのがベストな選択肢になる
# https://tenshoku-miti.com/takahiro/laravel-insert-create/


# -------------------

#? groupBy()

#【Laravel】groupByメソッドとは？使い方を解説します
# https://inouelog.com/laravel-groupby/

# Laravel EloquentのGroupByまとめ
# https://wonwon-eater.com/laravel-groupby/


# -------------------

#? クエリスコープ

# https://readouble.com/laravel/9.x/ja/eloquent.html

# グローバルスコープ
# → モデルを利用する際に、毎回呼び出されるスコープ
# → where文とかのquerry関数
# → グローバルスコープを設定しておけば、book.status = 1となっていたら、コントローラ上で何もしなくてもbook.status = 1が付くイメージ

# ローカルスコープ
# → スコープを利用したい場合に、自身で都度呼び出すスコープ

#^ scopeは定義する際には、scope<Scope名> (例: scopeSearch)とするが、呼び出す際は、scopeを含まない。(例: Book::search()) 大文字小文字どちらでもOK。

#^ 第一引数は必ず$queryになる。


# ................

# Laravelでスコープ
# https://qiita.com/mikaku/items/09ff1adecb2dfb97269d

#【Laravel】スコープを使えば「うっかり」が減って「ラク」できる
# https://blog.capilano-fw.com/?p=8019

# LaravelのDBをデータ操作が楽にできる「スコープ」とは！
# https://zenn.dev/naoki_oshiumi/articles/28a14c75f79599

#【Laravel】ローカルスコープから考える要求と意図
# https://tech.012grp.co.jp/entry/laravel-local-scope

#【Laravel】Eloquent(エロクアント)のscopeとは？ローカルとグローバルの違い
# https://tech.amefure.com/php-laravel-eloquent-scope

#【Laravel】ローカルスコープとグローバルスコープの使い方｜active(), popular(), ofType()などの関数が見つからない時の確認方法
# https://prograshi.com/framework/laravel/local-and-global-scope/

# Laravel – ローカルスコープクエリー
# http://taustation.com/laravel-local-scope-query/

# Laravel8のMODELのグローバルスコープ・ローカルスコープを使用する
# https://leben.mobi/blog/laravel8_global_scope/php/

# Laravelのグローバルスコープとモデル結合ルートについて
# https://webty.jp/staffblog/production/post-4901/

# スコープ機能について
# https://laraweb.net/knowledge/2548/


# -------------------

#? when()

# "when"を用いて簡単に見やすい検索機能を実装しよう(Laravel )
# https://zenn.dev/naoki_oshiumi/articles/d9a571f7441783


# when メソッドとは？
# whenメソッドは第２引数にクエリを発行するコールバック関数を書き、第１引数には第２引数のコールバック関数を実行するかどうかを指定します。

# つまり、第一引数がtrueであれば、第２引数でクエリを発行しますよっていうメソッドです。

# 上記で先に見せているようにこのように使うことができます。
# この場合は変数nameが存在すれば、nameでLIKE検索をかけます。

# $query->when($name, function($query, $name) {
#     return $query->where('name', "LIKE", "%$name%");
# });

# 普通にifを使う場合だとこうなります。

# if ($name) {
#     $query->where('name', "LIKE", "%$name%");
# }

# どっちも同じことなので、こういう方法もありますよということを頭の片隅において、好きな方を使っていただければと思います！


# ....................

#【Laravel】クエリビルダでif文使うように条件付け足すwhen関数【696日目】
# https://www.nyamucoro.com/entry/2019/09/09/224900


# -------------------

#? where()

# LaravelでWhere句の使い方と使用パターン6つ！
# https://codelikes.com/laravel-where/


# **** Laravel クエリビルダ ****

# Laravel クエリビルダを用いてNULLを判定する
# https://qiita.com/miriwo/items/e62404c8475d86964746

# Laravel クエリビルダ記法まとめ
# https://www.ritolab.com/entry/93


# **** リレーション ****

# 元記事
# https://www.techpit.jp/courses/11/curriculums/12/sections/107/parts/389

# リレーションの追加

# articlesテーブルには、user_idというカラムを作りました。

# ですので、以下のようなコードを書いたとしたら、Articleモデルのuser_idプロパティを表示できます。

# <?php

# use App\Article;

# $article = Article::find(1); //-- idが1である記事モデルを$articleに代入
# echo($article->user_id); //-- idが1である記事モデルのuser_idプロパティを表示


# 0章のパート7でも触れましたが、本教材のWebサービスでは様々なテーブル(モデル)が、お互いに関連性を持っています。

# ですので、以下のように、記事モデルを起点として、紐付くユーザーモデルの各プロパティにアクセスできるようになると便利です。


# <?php

# use App\Article;

# $article = Article::find(1); //-- idが1である記事モデルを$articleに代入
# echo($article->user->name); //--  「idが1である記事のuser_id」の値がidであるユーザーモデルのnameプロパティを表示


# 上記を実現するためにはArticleモデルにUserモデルへのリレーションを追加する必要があります。

# app/Article.phpを以下の通り編集してください。

# <?php

# namespace App;

# use Illuminate\Database\Eloquent\Model;
# //==========ここから追加==========
# use Illuminate\Database\Eloquent\Relations\BelongsTo;
# //==========ここまで追加==========

# class Article extends Model
# {
#     //==========ここから追加==========
#     public function user(): BelongsTo
#     {
#         return $this->belongsTo('App\User');
#     }
#     //==========ここまで追加==========
# }


# .................

#~ $this

# $this->belongsTo('App\User')とありますが、この$thisは、Articleクラスのインスタンス自身を指しています。

# $this->メソッド名()とすることで、インスタンスが持つメソッドが実行され、$this->プロパティ名とすることで、インスタンスが持つプロパティを参照します。


# .................

#~ リレーション

# Articleモデルは、Modelクラスを継承していることで、belongsToメソッドというものが使えます。

# belongsToメソッドの引数には関係するモデルの名前を文字列で渡します。

# すると、belongsToメソッドは、関係するモデルとのリレーション(belongsToメソッドの場合は、BelongsToクラス)を返します。

# このようなリレーションを返すuserメソッドを作っておくと、$article->user->nameとコードを書くことで、記事モデルから紐付くユーザーモデルのプロパティ(ここではname)にアクセスできるようになります。

# 記事と、記事を書いたユーザーは多対1の関係ですが、そのような関係性の場合には、belongsToメソッドを使います。


# それ以外の関係性の場合は、それぞれ以下のメソッドを使います。

#・1対1の関係は、hasOneメソッド
#・1対多の関係は、hasManyメソッド
#・多対多の関係は、belongsToManyメソッド

# 各メソッドに渡すべき引数やサンプルコードは以下を参照してください。


# リレーション - Laravel公式
# https://readouble.com/laravel/6.x/ja/eloquent-relationships.html


# .................

# 外部キー名の省略について

# データベースとしてはarticlesテーブルのuser_idと、usersテーブルのidが結び付いています。

# しかし、以下のコードではbelongsToメソッドにuser_idやidといったカラム名が一切渡されていないのに、リレーションが成り立っています。

# return $this->belongsTo('App\User');

# これは、usersテーブルの主キーはid、articlesテーブルの外部キーは関連するテーブル名の単数形_id(つまりuser_id)であるという前提のもと、Laravel側で処理をしているためです。

# 上記のようなネーミングルールになっていない場合は、belongsToメソッドに追加で引数を渡す必要がありますので注意してください。


# リレーション - Laravel公式
# https://readouble.com/laravel/6.x/ja/eloquent-relationships.html


# .................

#~ リレーションの使い方の注意点

# 本パートでは

# public function user(): BelongsTo
# {
#     //-- 略

# とuserメソッドを定義しましたが、

# $article->user();

# としてもUserモデルは返ってきませんので、注意してください。

# $article->user;

# とすると、Userモデルが返ってきます。

# なお、user()がリレーションメソッドであるのに対し、()無しのuserは動的プロパティと呼ばれます。

# まとめると、


# $article->user;         //-- Userモデルのインスタンスが返る
# $article->user->name;   //-- Userモデルのインスタンスのnameプロパティの値が返る
# $article->user->hoge(); //-- Userモデルのインスタンスのhogeメソッドの戻り値が返る
# $article->user();       //-- BelongsToクラスのインスタンスが返る


# といった結果になります。


# ----------------------------

# 元記事
# https://www.techpit.jp/courses/78/curriculums/81/sections/616/parts/2095

# 多対多 - Laravel公式
# https://readouble.com/laravel/6.x/ja/eloquent-relationships.html#many-to-many


# 例)
# Article.php
# <?php

# namespace App;

# use Illuminate\Database\Eloquent\Model;
# use Illuminate\Database\Eloquent\Relations\BelongsTo;
# use Illuminate\Database\Eloquent\Relations\BelongsToMany;

# class Article extends Model
# {
#     public function likes(): BelongsToMany
#     {
#         return $this->belongsToMany('App\User', 'likes')->withTimestamps();
#     }

#     public function isLikedBy(?User $user): bool
#     {
#         return $user
#             ? (bool)$this->likes->where('id', $user->id)->count()
#             : false;
#     }
# }

# .................

#~ 動的プロパティ

# $this->likesは、動的プロパティlikesを使用している。
# リレーションメソッドを()無しで呼び出すと、動的プロパティというものを呼び出していることになる。


# Article.php
# public function likes(): BelongsToMany
# {
#     return $this->belongsToMany('App\User', 'likes')->withTimestamps();
# }

# belongsToManyメソッドを用いて、ArticleモデルとUserモデルを、likesテーブルを通じた多対多の関係で結び付けている。



# likesテーブルの構造は以下の通り。
# usersテーブルとarticlesテーブルを紐付ける中間テーブルとなっている。

# カラム名 | 属性 | 役割
# id | 整数 | いいねを識別するID
# user_id | 整数 | いいねしたユーザーのid
# article_id | 整数 | いいねされた記事のid
# created_at | 日付と時刻 | 作成日時
# updated_at | 日付と時刻 | 更新日時


#& $this->likesというコードで何を実現しているかというと、動的プロパティlikesを使用することで、Articleモデルからlikesテーブル経由で紐付くUserモデルが、コレクション(配列を拡張したもの)で返ります。
#& → つまり、この記事にいいねしたユーザーのリストがコレクション形式で返る。

# コレクション - Laravel公式
# https://readouble.com/laravel/6.x/ja/collections.html


# .................

#~ whereメソッド

# コレクションには、whereというメソッドがあります。
# whereメソッドの第一引数にキー名、第二引数に値を渡すと、その条件に一致するコレクションが返ります。

#& $this->likes->where('id', $user->id)により、この記事をいいねしたユーザーの中に、引数として渡された$userがいるかどうかを調べています。


# where - Laravel公式
# https://readouble.com/laravel/6.x/ja/collections.html#method-where


# .................

#~  countメソッド

# さらに、コレクションにはcountというメソッドがあります。
# countメソッドは、コレクションの要素数を数えて、数値を返します。


# $this->likes->where('id', $user->id)->count()

# この結果は、
# - この記事をいいねしたユーザーの中に、引数として渡された$userがいれば、1かそれより大きい数値が返る
# - この記事をいいねしたユーザーの中に、引数として渡された$userがいなければ、0が返る
# となります。


# count - Laravel公式
# https://readouble.com/laravel/6.x/ja/collections.html#method-count


# .................

#~ withCountメソッド

# Laravelでリレーション先の数の合計を数えて一覧に表示する方法【withCount】
# https://poppotennis.com/posts/laravel-withcount

# Laravelで小テーブルの件数を取得するなら「withCount」を使おう
# https://blog.nakamu.me/posts/laravel-withcount

# Laravel withCount ある商品の購入人数を知りたい時（同じユーザーが複数回購入しても1回でカウントする）
# https://qiita.com/adgjmptwgw/items/44dfdc4b9102db895fa4


# .................

#~ whereDoesntHaveメソッド

# Laravelでリレーショナルデータが無いデータだけを取得する
# https://zenn.dev/naoki_oshiumi/articles/2734fc15a14154


# **** バリデーション(HTTPリクエスト)  *****

# Laravel 9.x HTTPリクエスト
# https://readouble.com/laravel/9.x/ja/requests.html

# Laravelのバリデーションの利用方法について
# https://imanaka.me/laravel/create-books-app-validation/

#【保存版】バリデーションルールのまとめ
# https://www.wakuwakubank.com/posts/376-laravel-validation/

#【Laravel】GETやPOSTで渡されたデータを自由自在に取得する。$requestの用途別メソッドまとめ
# https://prograshi.com/framework/laravel/laravel-request-methods/

# Laravelのフォームリクエストクラスでバリデーションロジックをコントローラから分離する
# https://www.ritolab.com/entry/41


# Laravelのバリデーションには方法が２つあります。

# ①コントローラーを利用したバリデーション
# ②Requestクラスを利用したバリデーション


# ------------------------

#? コントローラーを利用したバリデーションについて

# 1.bookcontrollerのupdateに下記を追加する。

# $validated = Validator::make($request->all(), [
#     'name' => 'required|max:255',
#     'status' => ['required', Rule::in(BOOK::BOOK_STATUS_ARRAY)],
# ]);

# if($validated->fails()) {
#     return redirect()->route('book.edit', ['id' => $request->input('id')])->withErrors($validated)->withInput();
# }


# 2.inputタグの下に下記を追加する

# @error('name')
#     <div class="text-red-600">{{ $message }}</div>
# @enderror


# ------------------------

#? Requestクラスを利用したバリデーションについて

# 1.requestクラスを作成する
# sail php artisan make:request BookRequest


# 2.BookRequestのauthorizeの戻り値をtrueにする
# return true;


# 3.rulesを設定する

# return [
#     'name' => 'required|max:255',
#     // 'status' => ['required', Rule::in(BOOK::BOOK_STATUS_ARRAY)],
#     'status' => ['required', Rule::in(MstBookStatus::getBookStatusArray())],
#     'author' => 'max:255',
#     'publication' => 'max:255',
#     'note' => 'max:1000',
#     'read_at' => 'nullable|date'
# ];


# 4.bookcontrollerのupdateにBookRequestを追加する

# use App\Http\Requests\BookRequest;

# public function update(BookRequest $request)


# ------------------------

#? エラーメッセージの表示について

# inputタグの下に下記を追加する

# @error('status')
#     <div class="text-red-600">{{ $message }}</div>
# @enderror

# とか...

# @error('author')
#     <div class="text-red-600">{{ $message }}</div>
# @enderror


# ------------------------

#? フォームの入力値を記録するための方法について

# フォームの入力値を記録するためには、oldという関数を利用します。
# これをしないと、入力後に値が元にもどってしまって、再度変更する必要があります。

# old(<リダイレクトした時に表示される>, <デフォルトの表示>)

# 1.input
# value="{{ old('name', $book->name) }}"


# 2.selectbox
# <option value="{{$key }}" @if($key === (int)old('status', $book->status)) selected @endif>{{$value }}</option>


# ------------------------

#? バリデーションのエラーメッセージを日本語にする方法について

# 日本語の言語ファイルは「lang/ja/validation.php」になるので、こちらにattributesを追加して英語表記、日本語表記の配列を作ります。

# 'attributes' => [
# 'password' => 'パスワード',
# 'status' => 'ステータス',
# 'name' => '名前',
# 'author' => '著者',
# 'publication' => '出版',
# 'read_at' => '読み終わった日',
# 'note' => 'メモ',
# ],


# ------------------------

#? 名前の二重登録を防止する方法

#【Laravel/MySQL】FormRequestを使って重複チェック
# https://bonoponz.hatenablog.com/entry/2020/12/02/%E3%80%90Laravel/MySQL%E3%80%91FormRequest%E3%82%92%E4%BD%BF%E3%81%A3%E3%81%A6%E9%87%8D%E8%A4%87%E3%83%81%E3%82%A7%E3%83%83%E3%82%AF


#【Laravel】ユニークバリデーション【自分自身や論理削除時の除外】
# https://enginiya.com/entry/laravel-unique-validation

# Laravel：uniqueバリデーションで自分自身を対象外としたい
# https://blog.shinki.net/posts/laravel-unique-eliminate-yourself

# [Laravel] Uniqueバリデーションで、論理削除を考慮するなど、条件をカスタマイズしたい
# https://www.yoheim.net/blog.php?q=20190101


    # public function rules()
    # {
    #     $myName = Auth::user()->name;
    #     $myEmail = Auth::user()->email;


    #     return [
    #         //
    #         'name' => ['required', 'max:255', Rule::unique('users', 'name')->whereNull('deleted_at')->whereNot('name', $myName)],
    #         'email' => ['required', 'max:255', 'email:rfc', Rule::unique('users', 'email')->whereNull('deleted_at')->whereNot('email', $myEmail)],
    #         'age' => ['required', 'numeric'],
    #         'gender' => ['required', Rule::in(User::GENDER_STATUS_ARRAY)],
    #     ];
    # }

    # public function messages()
    # {
    #     return [
    #         'required' => '必須入力です。',
    #         'max' => '255文字以内で入力してください。',
    #         'name.unique' => 'すでに存在している名前です。',
    #         'email.unique' => 'すでに存在しているメールアドレスです。',
    #         'email.email' => '有効なメールアドレスを入力してください。',
    #         'age.numeric' => '数字を入力してください。',
    #     ];
    # }


# ------------------------

#? メールアドレス重複を防止する方法

# Laravelでメールアドレス重複をバリデーションする方法
# https://www.kamome-susume.com/email-unique/


# ------------------------

#! 勝手にリダイレクトされる問題

#【Laravel】フォームリクエストを使いつつ勝手にリダイレクトさせない
# https://qiita.com/rana_kualu/items/77134af5477d27bf2cc2

# FormRequestのバリデーションエラー時のリダイレクト先をカスタマイズする
# https://qiita.com/kazuhei/items/1c193a597da0cc0f34be

#【Laravel】フォームリクエストのバリデーションでリダイレクト前に任意の処理を行う
# https://zakkuri.life/laravel-formrequest-after/

# Laravel バリデーションが変な場所へリダイレクトしてしまう
# https://blog.capilano-fw.com/?p=18

# Laravel で 自動リダイレクトを使用せずに Validate（バリデーション）を行う
# https://pgmemo.tokyo/data/archives/1534.html

#【Laravel】バリデーション失敗時に勝手にリダイレクトしないようにする（jsonを返させる）
# https://naka-no-mura.hateblo.jp/entry/2022/08/23/170135


# ........................

# Laravelでバリデーション処理
# https://webxreal.com/laravel-validation/

# 自動リダイレクトしたくない場合
# failedValidationメソッドをオーバーライドして無効化するとともにコントローラーで失敗時の処理を行うためValidatorを取得できるメソッドを追加しておきます。

#   // @Override
#     protected function failedValidation(Validator $validator)
#     {
# 		// 自動リダイレクト無効化
# //        throw (new ValidationException($validator))
# //                    ->errorBag($this->errorBag)
# //                    ->redirectTo($this->getRedirectUrl());
#     }

# 	/**
# 	 * Validator取得
# 	 * return Illuminate\Contracts\Validation\Validator $validator
# 	 */
#     public function getValidator()
#     {
#         return $this->validator;
#     }


# コントローラーで失敗時のリダイレクト処理

# $validator = $request->getValidator();

# // バリデーション失敗時の処理
# if ($validator->fails()) {
# 	return redirect('/test')
# 		->withErrors($validator)
# 		->withInput();
# }



# ........................

# https://github.com/lbv180620/laravel-sns/blob/main/laravel/app/Http/Requests/ArticleRequest.php


# **** N + 1 問題 ****

#「N + 1 問題」と記事一覧画面の改善
# https://www.techpit.jp/courses/11/curriculums/12/sections/105/parts/369#retry

# Laravelのwithメソッド、loadメソッドでN+1問題を解決する
# https://migisanblog.com/laravel-with-load-n/


# LaravelでEloquentのリレーションを使ってみよう
# https://migisanblog.com/laravel-eloquent-relation/


# 【Laravel】N+1問題を完全理解！解消法も！
# https://tektektech.com/laravel-n1/

#【Laravel】EagerロードでN+1問題を解決する
# https://zenn.dev/ikeo/articles/26f3a8287b12f35c5b2c

# PHPerKaigi 2022 【Laravel】 サクッとN + 1問題を見つけて倒しチャオ！
# https://speakerdeck.com/ytsuzaki/phperkaigi-2022-laravel-sakututon-plus-1wen-ti-wojian-tuketedao-sitiyao


# [Laravel] N+1問題について少し調べた
# https://qiita.com/kke1229/items/918f484ca568826aa4c8

# [laravel8]N+1問題
# https://note.com/tomo_program/n/n3788bb7d77d3

# Laravel N+1検出ツールの紹介
# https://0-re--engines-com-0.cdn.ampproject.org/v/s/re-engines.com/2022/01/13/laravel-n1%E6%A4%9C%E5%87%BA%E3%83%84%E3%83%BC%E3%83%AB%E3%81%AE%E7%B4%B9%E4%BB%8B/?amp=&amp_gsa=1&amp_js_v=a9&usqp=mq331AQKKAFQArABIIACAw%3D%3D#amp_tf=%251%24s%20%E3%82%88%E3%82%8A&aoh=16644185084170&referrer=https%3A%2F%2Fwww.google.com&ampshare=https%3A%2F%2Fre-engines.com%2F2022%2F01%2F13%2Flaravel-n1%25E6%25A4%259C%25E5%2587%25BA%25E3%2583%2584%25E3%2583%25BC%25E3%2583%25AB%25E3%2581%25AE%25E7%25B4%25B9%25E4%25BB%258B%2F


# ----------------

# 一覧表示箇所で発生する
# → リレーションの箇所が問題


# 解消箇所の特定
# → クエリ構造とコード場所が一致して重複している箇所


# リレーション = 外部キーに基づくSQL = where id = 数値
# リレーションは、外部キーとして指定された方のモデルに定義する。
# リレーションを使用するとN + 1問題が発生する。
# 1は全件取得クエリで、Nがリレーション。


# **** 論理削除と物理削除 ****

# 物理削除
# public function remove($id)
# {
#     try {
#         Book::find($id)->delete();
#         return redirect()->route('book')->with('status', '本を物理削除しました。');
#     } catch (\Exception $ex) {
#         logger($ex->getMessage());
#         return redirect()->route('book')->withErrors($ex->getMessage());
#     }
# }

# 論理削除
# public function delete($id)
# {
#     try {
#         Book::find($id)->update([
#             'deleted_at' => date("Y-m-d H:i:s", time()),
#         ]);
#         return redirect()->route('book')->with('status', '本を論理削除しました。');
#     } catch (\Exception $ex) {
#         logger($ex->getMessage());
#         return redirect()->route('book')->withErrors($ex->getMessage());
#     }
# }

#^ $fillableに'deleted_at'を登録しないと、update()できない。


# **** DI ****


# **** リファクタリング ****

#~ View表示用ロジックの分割 → ビューコンポーザ

#~ Fat Controller → ビジネスロジックをモデルに書く

#~ クエリの重複 → query()を使って、共通化


# ----------------

#? Laravel view composerでロジックを一箇所にまとめる方法

# 記事
# https://qiita.com/bumptakayuki/items/212ec57ffbfb8e71cb60
# https://qiita.com/youkyll/items/c65af61eb33919b29e97
# https://tech.arms-soft.co.jp/entry/2020/07/01/090000
# https://www.webopixel.net/php/1287.html
# https://biz.addisteria.com/laravel_view_composer/


# ....................

#~ view composer 設定手順

# ①ServiceProvider作成
# php artisan make:provider ViewComposerServiceProvider


# ②config/app.phpに登録

# config/app.php
# 'providers' => [
#     App\Providers\ViewComposerServiceProvider::class,
# ]


# ③作成したファイルの編集

# <?php

# namespace App\Providers;

# use Illuminate\Support\ServiceProvider;
# use Illuminate\Support\Facades\View;
# class ViewComposerServiceProvider extends ServiceProvider
# {
#     /**
#      * Register services.
#      *
#      * @return void
#      */
#     public function register()
#     {
#         //
#     }

#     /**
#      * Bootstrap services.
#      *
#      * @return void
#      */
#     public function boot()
#     {
#         View::composer('*', function ($view)  {
#             $view->with('user', auth()->user());
#         });
#     }
# }


#^ View::composerの第一引数に表示するViewを指定します。
# ‘*’
# → すべてのView

# ‘layouts/app’
# → layouts/app.blade.phpを使用しているView

# [‘posts/*’,’tags/*’]
# → posts、tagsディレクトリ内のView
# ※配列にすることで複数の指定したViewで使用できます。


# ....................

#& ViewComposerをクラス化して外部ファイルにする

# app/Http/ViewComposers/HogeComposer.php

# <?php
# namespace App\Http\ViewComposers;

# use Illuminate\View\View;

# class HogeComposer
# {
#     /**
#     * @var String
#     */
#     protected $hoge;

#     public function __construct()
#     {
#         $this->hoge = 'hogehoge';
#     }

#     /**
#     * Bind data to the view.
#     * @param View $view
#     * @return void
#     */
#     public function compose(View $view)
#     {
#         $view->with('hoge', $this->hoge);
#     }
# }



# app/Providers/ComposerServiceProvider.php
# <?php
# namespace App\Providers;

# use Illuminate\Support\Facades\View;
# use Illuminate\Support\ServiceProvider;

# class ComposerServiceProvider extends ServiceProvider
# {
#     public function boot()
#     {
#         View::composer('*', 'App\Http\ViewComposers\HogeComposer');
#     }


# ....................

# https://github.com/lbv180620/laravel-simple-memo-v2/blob/main/backend/app/Providers/AppServiceProvider.php

# app/Providers/AppServiceProvider.php
#     public function boot()
#     {
#         // 全てのメソッドが呼ばれる前に先に呼ばれるメソッド
#         view()->composer('*', function ($view) {
#             // 自分のメモ取得はMemoモデルに任せる
#             // 自作したメソッドを使うには、インスタンス化しないといけない。
#             $memo_model = new Memo();

#             // メモ取得
#             $memos = $memo_model->getMyMemo();

#             $tags = Tag::where('user_id', '=', \Auth::id())
#                 ->whereNull('deleted_at')
#                 ->orderByDesc('id')
#                 ->get();

#             $view->with('memos', $memos)
#                 ->with('tags', $tags);
#         });
#     }


# ----------------

# Laravel view share

# 記事
# https://biz.addisteria.com/laravel_view_share/


# **** Laravel Collection ****


# Laravel 8.x コレクション
# https://readouble.com/laravel/8.x/ja/collections.html


# 全117種類！Laravel 5.6〜7.xのコレクション実例
# https://blog.capilano-fw.com/?p=727

# Laravelのcollectionメソッドを使いこなせるようになろう
# https://migisanblog.com/laravel-collection-method/

# Laravelでのcollectionをすっきり整理！データ操作方法を解説
# https://www.fenet.jp/dotnet/column/language/6951/


# ------------------------

#? コレクションから特定の値だけを抽出して新しい配列を作成する方法

# public static function getBookStatusArray()
# {
#     $mst_book_status_object = ModelsMstBookStatus::all();

#     $mst_book_status_array = $mst_book_status_object->map(function ($value) {
#         return $value->id;
#     });

#     return $mst_book_status_array;
# }


# or

#     public static function getBookStatusArray()
#     {
#         $mst_book_status_array = MstBookStatus::select('id')->orderBy('id')->pluck('id');
#         return $mst_book_status_array;
#     }


# ------------------------

#? pluck()

# pluck('バリュー', 'キー')->toArray();

# Laravelコレクションのpluck()メソッドを活用しよう
# https://qiita.com/jacksuzuki/items/eae943735bda747be09c

# Laravel 便利なコレクションメソッドpluckを使いこなそう！
# https://takuma-it.com/laravel-pluck/

#【Laravel】pluckを使いこなせ！！！
# https://tektektech.com/laravel-pluck/


# **** 検索機能の実装 ****

#~ Laravelの検索機能の実装方法について
# https://imanaka.me/laravel/create-books-app-search/


# Getパラメータを使って検索させる仕組み

# 1.BookControllerに下記を追加する

# public function index(Request $request)
# {
#     // $books = Book::paginate(10);
#     // $books = Book::whereNull('deleted_at')->paginate(10);

#     // return view('book.index', compact('books'));


#     // $input = $request->all();
#     $input = $request->only('name', 'status', 'author', 'publication', 'note');

#     $books = Book::search($input)->whereNull('deleted_at')->orderByDesc('id')->paginate(10);

#     $statuses = Book::select('mst_book_statuses.id', 'mst_book_statuses.status')
#         ->leftJoin('mst_book_statuses', 'mst_book_statuses.id', '=', 'books.mst_book_status_id')
#         ->groupBy('mst_book_statuses.id')
#         ->pluck('mst_book_statuses.status', 'mst_book_statuses.id');

#     $publications = Book::select('publication')->groupBy('publication')->pluck('publication');

#     $authors = Book::select('author')->groupBy('author')->pluck('author');

#     return view('book.index', [
#         'books' => $books,
#         // selectBox用のマスターデータ
#         'statuses' => $statuses,
#         'publications' => $publications,
#         'authors' => $authors,
#         // 検索する値
#         'name' => $input['name'] ?? '',
#         'status' => $input['status'] ?? '',
#         'publication' => $input['publication'] ?? '',
#         'author' => $input['author'] ?? '',
#         'status' => $input['status'] ?? '',
#         'note' => $input['note'] ?? '',
#     ]);
# }



#^ $authors = Book::select('author')->groupBy('author')->pluck('author');
# → select()でbooksテーブルからauthorカラムのデータを取得
# → groupBy()でauthorカラム内の重複を無くす
# → pluck()でauthorカラムの値だけで構成された配列を作る


# ...................

# 2.Models/Book.phpにscopeを追加する。

# public function scopeSearch($query, $search)
# {
#     $name = $search['name'] ?? '';
#     $status = $search['status'] ?? '';
#     $author = $search['author'] ?? '';
#     $publication = $search['publication'] ?? '';
#     $note = $search['note'] ?? '';

#     $query->when($name, function ($query, $name) {
#         $query->where('name', 'like', "%$name%");
#     });

#     $query->when($status, function ($query, $status) {
#         // $query->where('status', '=', $status);
#         $query->where('mst_book_status_id', '=', $status);
#     });

#     $query->when($author, function ($query, $author) {
#         $query->where('author', 'like', "%$author%");
#     });

#     $query->when($publication, function ($query, $publication) {
#         $query->where('publication', 'like', "%$publication%");
#     });

#     $query->when($note, function ($query, $note) {
#         $query->where('note', 'like', "%$note%");
#     });

#     return $query;
# }


# 尚、scopeはグローバルスコープとローカルスコープがあります。
# グローバルは、モデルを利用する際に毎回呼び出されるスコープです。
# ローカルスコープは、利用したいときに都度呼び出すスコープです。
# scopeを呼び出す際は、scopeという文字は入力せず、モデルにscope移行のメソッド名を入力します。


# Book::search($input);


# ...................

# 3.book/index.bladeの12行目にコピペします。

# <div class="pt-8">
#   <div class="max-w-7xl mx-auto sm:px-6 lg:px-8">
#     <div class="bg-white overflow-hidden shadow-xl sm:rounded-lg">
#       <div class="m-5">

#         <form action="{{ route('book') }}">
#           <div class="flex flex-row">
#             <div class="col-span-6 sm:col-span-3 p-2 w-48">
#               <label for="name" class="block text-sm font-medium text-gray-700">本の名前</label>
#               <input type="text" name="name" id="name" value="{{ $name }}"
#                 class="mt-1 focus:ring-indigo-500 focus:border-indigo-500 block w-full shadow-sm sm:text-sm border-gray-300 rounded-md">
#             </div>

#             <div class="p-2 w-48">
#               <label for="status" class="block text-sm font-medium text-gray-700">ステータス</label>
#               <select id="status" name="status"
#                 class="mt-1 block w-full py-2 px-3 border border-gray-300 bg-white rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm">
#                 <option value="">--</option>
#                 @foreach ($statuses as $key => $value)
#                   <option value="{{ $key }}" @if ($status == $key) selected @endif>
#                     {{ $value }}</option>
#                 @endforeach
#               </select>
#             </div>

#             <div class="p-2 w-48">
#               <label for="author" class="block text-sm font-medium text-gray-700">著者</label>
#               <select id="author" name="author"
#                 class="mt-1 block w-full py-2 px-3 border border-gray-300 bg-white rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm">
#                 <option value="">--</option>
#                 @foreach ($authors as $option)
#                   <option value="{{ $option }}" @if ($author == $option) selected @endif>
#                     {{ $option }}</option>
#                 @endforeach
#               </select>
#             </div>

#             <div class="p-2 w-48">
#               <label for="publication" class="block text-sm font-medium text-gray-700">出版</label>
#               <select id="publication" name="publication"
#                 class="mt-1 block w-full py-2 px-3 border border-gray-300 bg-white rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm">
#                 <option value="">--</option>
#                 @foreach ($publications as $option)
#                   <option value="{{ $option }}" @if ($publication == $option) selected @endif>
#                     {{ $option }}</option>
#                 @endforeach
#               </select>
#             </div>

#             <div class="col-span-6 sm:col-span-3 p-2 w-48">
#               <label for="note" class="block text-sm font-medium text-gray-700">特記事項</label>
#               <input type="text" name="note" id="note" value="{{ $note }}"
#                 class="mt-1 focus:ring-indigo-500 focus:border-indigo-500 block w-full shadow-sm sm:text-sm border-gray-300 rounded-md">
#             </div>

#             <div class="col-span-6 sm:col-span-3 p-2 w-48 relative">
#               <button type="submit"
#                 class="absolute inset-x-0 bottom-2 mr-2 shadow bg-blue-500 hover:bg-blue-400 focus:shadow-outline focus:outline-none text-white font-bold py-2 px-4 rounded">検索</button>
#             </div>
#           </div>
#         </form>
#       </div>
#     </div>
#   </div>
# </div>


# ----------------

#~【Laravel】キーワード検索機能の実装方法（複数キーワード、部分一致）
# https://takuma-it.com/laravel-keyword-search/


# Viewに検索フォームを追加

# <form method="GET" action="{{ route('users.index') }}">
#     <input type="search" placeholder="ユーザー名を入力" name="search" value="@if (isset($search)) {{ $search }} @endif">
#     <div>
#         <button type="submit">検索</button>
#         <button>
#             <a href="{{ route('users.index') }}" class="text-white">
#                 クリア
#             </a>
#         </button>
#     </div>
# </form>

# @foreach($users as $user)
#     <a href="{{ route('users.show', ['user_id' => $user->id]) }}">
#         {{ $user->name }}
#     </a>
# @endforeach


# <div>
# // 下記のようにページネーターを記述するとページネートで次ページに遷移しても、検索結果を保持する
#     {{ $institutions->appends(request()->input())->links() }}
# </div>


# ........................

# コントローラーに検索機能に関するコードを追加

# <?php

# namespace App\Http\Controllers;

# use App\Http\Controllers\Controller;
# use Illuminate\Http\Request;
# use App\Models\User;

# class UserController extends Controller
# {

#     /**
#      * ユーザー一覧
#      * @return \Illuminate\Contracts\View\View|\Illuminate\Contracts\View\Factory
#      */
#     public function index(Request $request)
#     {
#         // ユーザー一覧をページネートで取得
#         $users = User::paginate(20);

#         // 検索フォームで入力された値を取得する
#         $search = $request->input('search');

#         // クエリビルダ
#         $query = User::query();

#        // もし検索フォームにキーワードが入力されたら
#         if ($search) {

#             // 全角スペースを半角に変換
#             $spaceConversion = mb_convert_kana($search, 's');

#             // 単語を半角スペースで区切り、配列にする（例："山田 翔" → ["山田", "翔"]）
#             $wordArraySearched = preg_split('/[\s,]+/', $spaceConversion, -1, PREG_SPLIT_NO_EMPTY);


#             // 単語をループで回し、ユーザーネームと部分一致するものがあれば、$queryとして保持される
#             foreach($wordArraySearched as $value) {
#                 $query->where('name', 'like', '%'.$value.'%');
#             }

#             // 上記で取得した$queryをページネートにし、変数$usersに代入
#             $users = $query->paginate(20);

#         }

#         // ビューにusersとsearchを変数として渡す
#         return view('users.index')
#             ->with([
#                 'users' => $users,
#                 'search' => $search,
#             ]);
#     }
# }


# ----------------

#~ タグからの絞り込み検索

# https://www.udemy.com/course/laravel8mysql/learn/lecture/27068904#questions
# https://www.udemy.com/course/laravel8mysql/learn/lecture/27101514#questions


# (方針): クエリパラメータからタグIDを取得して、そのタグIDに一致したものだけを拾ってくることで、メモを絞り込む。


# ⑴ タグをクリックした時に、クエリパラメータも送信するようURLを設定
# https://github.com/lbv180620/laravel-simple-memo-v2/blob/main/backend/resources/views/layouts/app.blade.php

#           <div class="card">
#             <div class="card-header">
#               タグ一覧
#             </div>
#             <div class="card-body my-card-body">
#               <a href="/" class="card-text d-block text-decoration-none mb-2">すべて表示</a>
#               @foreach ($tags as $tag)
#                 <a class="card-text text-decoration-none d-block mb-2 cursor-pointer ellipsis"
#                   href="/?tag={{ $tag['id'] }}">
#                   {{ $tag['name'] }}
#                 </a>
#               @endforeach
#             </div>
#           </div>


# ⑵ 絞り込みのロジックを記述

# https://github.com/lbv180620/laravel-simple-memo-v2/blob/main/backend/app/Providers/AppServiceProvider.php

# AppServiceProvider.php
#     public function boot()
#     {
#         // 全てのメソッドが呼ばれる前に先に呼ばれるメソッド
#         view()->composer('*', function ($view) {
#             // 自分のメモ取得はMemoモデルに任せる
#             // 自作したメソッドを使うには、インスタンス化しないといけない。
#             $memo_model = new Memo();

#             // メモ取得
#             $memos = $memo_model->getMyMemo();

#             $tags = Tag::where('user_id', '=', \Auth::id())
#                 ->whereNull('deleted_at')
#                 ->orderByDesc('id')
#                 ->get();

#             $view->with('memos', $memos)
#                 ->with('tags', $tags);
#         });
#     }


# https://github.com/lbv180620/laravel-simple-memo-v2/blob/main/backend/app/Models/Memo.php

# Memo.php
#     public function getMyMemo()
#     {
#         //^ useでインポートしなくても、「\」から始めればファザードは使える。
#         $query_tag = \Request::query('tag');
#         // dd($query_tag);

#         // クエリビルダを分割する方法
#         // ==== ベースのクエリ ====
#         $query = Memo::query()
#             ->select('memos.*')
#             ->where('user_id', '=', \Auth::id())
#             ->whereNull('deleted_at')
#             ->orderByDesc('updated_at');
#         // ==== ベースのクエリここまで ====

#         // もしクエリパラメータtagがあれば、
#         if (!empty($query_tag)) {
#             // タグで絞り込み
#             $query
#                 ->leftJoin('memo_tags', 'memo_tags.memo_id', '=', 'memos.id')
#                 ->where('memo_tags.tag_id', '=', $query_tag);
#         }

#         $memos = $query->get();

#         return $memos;
#     }



# ....................

#^ $query_tag = \Request::query('tag'); でクエリパラメータを取得できる。


# Requestの各メソッド（query(), get(), all()...）の使い分け
# https://qiita.com/piotzkhider/items/feaba3acda27d2e432d8

# リクエストパラメータの「ベストな受け取り方」と「危ない受け取り方」（Laravel）
# https://zenn.dev/naoki_oshiumi/articles/b542f7daca7a95

# [Laravel] Requestクラスのメソッドまとめ
# https://gentuki-blog.site/articles/qV3KuS42UwcP9Y9Zcwv7n

# リクエストデータを取得する
# https://www.techpit.jp/courses/174/curriculums/177/sections/1199/parts/4749


# ----------------

#【Laravel】検索機能の実装①~基本！キーワード部分一致検索~
# https://qiita.com/hinako_n/items/7729aa9fec522c517f2a

# 検索機能の作成
# https://laraweb.net/tutorial/607/

# CRUDアプリの作成 STEP8：「検索機能」の作成
# https://laraweb.net/tutorial/9758/

# Laravelで検索機能の実装 [基本]
# https://noumenon-th.net/programming/2020/03/01/laravel-search/

#【初心者向け】laravelで検索機能を実装する
# https://terrblog.com/laravel%E3%81%A7%E6%A4%9C%E7%B4%A2%E6%A9%9F%E8%83%BD%E3%82%92%E5%AE%9F%E8%A3%85%E3%81%99%E3%82%8B/

#【Laravel】キーワード検索機能の実装と検索文字列にマーカーを引く方法
# https://kodyblog.com/laravel-search-keyword/

# "when"を用いて簡単に見やすい検索機能を実装しよう(Laravel )
# https://zenn.dev/naoki_oshiumi/articles/d9a571f7441783

# Docker×Laravel8もくもく会アプリ作成16(検索機能)
# https://www.kamome-susume.com/mokumoku-search/


# **** Tips****

#? メモに画像を添付できる機能 → Laravelのストレージに画像を保存して、画像パスをDBに保存

#? メモの共有機能 → 自分以外の人にも見える共有URLを作る機能

#? クラウドサーバーを使ったインターネット公開 → おすすめはAWSのLightSailを使ってインターネットにメモアプリを公開


# ----------------

#& お役立ち情報

# 全16実例！Laravelのモデルで使えるメンバ変数
# https://blog.capilano-fw.com/?p=2114


# ==== 概念説明 ====

# Eloquentとは、
# 1. データベースの操作を楽にするためのORMという仕組み
# 2. ORMとは、オブジェクトとデータベースを紐づける仕組み
# 3. Eloquentを利用するとSQL文を書かなくてもデータベースを操作できる

# ex)
# SELECT * FROM books;
# ⬇️
# $books = Book.all();


# --------------------

# クエリビルダとは、
# 1. メソッドチェーンを利用してSQL文を組み立てれる仕組み
# 2. メソッドチェーンとは、メソッドを繋げる、$query->latest()->get() のような仕組み
# 3. DBファサード(\Illuminate\Support\Facades\DB)を利用する

# ex)
# SELECT * FROM books;
# ⬇️
# $books = DB::table('books')->get();


# --------------------

# Seederとは、
# 1. Laravel上からデータベースにデータ挿入するための仕組み
# 2. Seederを利用すると、初期データの登録が楽になる
# 3. Seederを利用すると、テストデータの作成が楽になる


# --------------------

# モデルファクトリとは、
# 1. テストデータを楽に作成できる仕組み
# 2. eloquentで利用できる
# 3. モデルファクトリは、fakerが利用できる


# ==== Tailwind CSSの設定 ====

# https://tailwindcss.com/docs/guides/laravel

# 記事
# https://zenn.dev/naoki_oshiumi/articles/c6cec9b25fae56
# https://yama-weblog.com/using-tailwind-in-laravel8-startup/
# https://uedive.net/2021/5608/laravel8x-tailwind/
# https://codelikes.com/laravel-use-tailwindcss/
# https://reffect.co.jp/laravel/laravel-tailwindcss
# https://qiita.com/Masahiro111/items/c31261aa533313504bea
# https://www.gigas-jp.com/appnews/archives/11660


#? 設定手順

# ⑴ tailwindcssのインストールと設定ファイルの生成
# yarn add -D tailwindcss postcss autoprefixer
# npx tailwindcss init -p

# ⑵ tailwind.config.jsの編集

# /** @type {import('tailwindcss').Config} */
# module.exports = {
#   content: [
#     "./resources/**/*.blade.php",
#     "./resources/**/*.js",
#     "./resources/**/*.vue",
#   ],
#   theme: {
#     extend: {},
#   },
#   plugins: [],
# }

# ⑶ resources/css/app.cssの編集

# @import "tailwindcss/base";
# @import "tailwindcss/components";
# @import "tailwindcss/utilities";


# ⑷ webpack.mix.jsの編集
# mix.js('resources/js/app.js', 'public/js')
#     .postCss('resources/css/app.css', 'public/css', [
#         require('tailwindcss'),
#         require('autoprefixer'),
#     ])
#     .sourceMaps();

# ⑸ ビルド
# yarn dev


# ==== Laravel Sail ====

#* インストールの手順

# Laravel & Docker
# https://laravel.com/docs/9.x/installation#laravel-and-docker

# curl -s "https://laravel.build/<アプリ名>" | bash
# cd <アプリ名>
# ./vendor/bin/sail up


# ==== Laravel Mix ====

#? browserSync(hot reload)を有効化する方法

# 記事
# https://zenn.dev/shimotaroo/articles/1201a3b57306be
# https://hiro8blog.com/how-to-watch-laravel-container-by-browser-sync/


# ⑴ browser-sync をインストール
# yarn add -D browser-sync browser-sync-webpack-plugin

# ⑵ webpack.mix.js を編集
# webpack.mix.js
# mix.js('resources/js/app.js', 'public/js')
#     .postCss('resources/css/app.css', 'public/css', [
#         //
#     ])
#     // ここから下
#     .browserSync({
#         proxy: {
#             target: 'http://localhost:8080',
#         },
#         files: ['./resources/**/*', './public/**/*'],
#         open: false,
#         reloadOnRestart: true,
#     });

# ⑶ docker-compose.ymlのphpコンテナのportsに3000番ポートを追記 → make up

# ⑷ yarn watch

#^  open: true → browser-sync を起動したときに自動でブラウザを開くかの設定
#^ reloadOnRestart: true → browser-sync を再起動したときに、開いているブラウザをリロードするかの設定


# .....................

# HMR用設定を追加する場合
# https://kawadev.net/laravel-vue-hmr/

# mix.webpackConfig({
#   devServer: {
#     host: '0.0.0.0',
#     port: 3000, # docker-compose.ymlに3000番ポートを追記した場合
#     port: 8000, # php artisan serve
#     proxy: {
#       '*': 'http://loacalhost:8080'
#     }
#   }
# });

# php artisan serve
# yarn hot


# ------------------

#? Sailでホットリロードを有効化する方法

# 記事
# https://blog.no23kuromaru.net/posts/laravel-mix
# https://lotus-base.com/blog/41

# webpack.mix.js
# const mix = require('laravel-mix');

# // 変更を監視するjs, cssファイルを記載
# mix.js('resources/js/app.js', 'public/js')
#     .postCss('resources/css/app.css', 'public/css');

# mix.webpackConfig({
#     devServer: {
#         // proxy設定
#         proxy: {
#             '*': 'http://localhost:8000'
#         }
#     }
# });


# ------------------

#? Glob

#【Laravel Mix】複数のスタイルやスクリプトのコンパイル処理を改善する
# https://blog.websandbag.com/entry/2020/08/01/150449

#【Laravel】webpack.mix.jsのglob.syncとは何か？実例で使い方を説明。
# https://qiita.com/shizen-shin/items/0224f0617fd5a208a049

# Laravel Mixでマッピングの肥大化を防ぐ【Laravel-mix-glob】
# https://qiita.com/ntm718/items/5c2303108e32707d999c

# yarn add -D glob


# ------------------

#? webpack.mix.configのテンプレ

# Laravel Mixでいい感じにSassをコンパイルする
# https://inframenma.com/laravel-mix-sass-compile/


# ==== Laravel Vite ====

# Laravel 9.x アセットの構築（Vite）
# https://readouble.com/laravel/9.x/ja/vite.html

# Vite
# https://ja.vitejs.dev/
# https://ja.vitejs.dev/guide/backend-integration.html

# 記事
# https://blog.capilano-fw.com/?p=10168
# https://qiita.com/pop-culture-studio/items/027e612fa7e7b11cafa0
# https://zenn.dev/yamabiko/articles/laravel-jetstream-vite
# https://zakkuri.life/laravel-vite/

# 環境構築
# https://saunabouya.com/2022/07/25/laravel9-sail-react-typescript-vite/

#^ v9.19.0 (2022年6月30日)からMixからViteに変更

#^ Laravel Viteを使用するときは、.envのMixの項目をコメントアウトし、Viteの項目をアンコメントする


# ------------------

#? 【Laravel】に【Vite】が採用された
# https://coinbaby8.com/laravel-vite.html


# ------------------

#? laravelでViteからLaraevel-mixに戻す手順
# https://github.com/laravel/vite-plugin/blob/main/UPGRADE.md#migrating-from-vite-to-laravel-mix
# https://biz.addisteria.com/remove_vite/


#* LaravelからViteをアンインストールする手順:

# ①Vite削除コマンドを実行

# npm remove vite
# npm remove laravel-vite-plugin

# .....................

# ②Vite設定ファイル（vite.config.js) 削除


# .....................

# ③ テンプレートファイルのリンクを無効にする

# resources/views/layouts/app.balde.php と resources/views/layouts/guest.blade.phpに

# 自動で入っている下記のコードを無効にします。

#         @vite([‘resources/css/app.css’, ‘resources/js/app.js’])


# .....................

# ④ package.jsonの変更

# package.jsonのscriptsで、下記を削除します。

# "dev": "vite",
# "build": "vite build"


# .....................

# ⑤  jsファイルの修正

# resources/js/app.jsを書き替えます。

# importをrequireにします。

# // import './bootstrap';
# require('./bootstrap');


# resources/js/bootstrap.jsを書き替えます。

# // import _ from 'lodash';
# window._ = require('lodash');

# // import axios from 'axios';
# window.axios = require('axios');

uindow.axios.defaults.headers.common['X-Requested-With'] = 'XMLHttpRequest';


# .....................

# ⑥ .envの修正

# Vite用の設定を削除し、Laravel Mix用の設定を追加します。

# 削除

# VITE_PUSHER_APP_KEY="${PUSHER_APP_KEY}"
# VITE_PUSHER_HOST="${PUSHER_HOST}"
# VITE_PUSHER_PORT="${PUSHER_PORT}"
# VITE_PUSHER_SCHEME="${PUSHER_SCHEME}"
# VITE_PUSHER_APP_CLUSTER="${PUSHER_APP_CLUSTER}"

# 追加

# MIX_PUSHER_APP_KEY="${PUSHER_APP_KEY}"
# MIX_PUSHER_APP_CLUSTER="${PUSHER_APP_CLUSTER}"


# .....................

#* LaravelにLaravel Mixを入れる方法:

# ① Laravel Mixインストール

# npm install laravel-mix --save-dev


# .....................

# ② webpack.mix.jsファイル作成

# 下記コードを入れます。

# const mix = require('laravel-mix');

# /*
#  |--------------------------------------------------------------------------
#  | Mix Asset Management
#  |--------------------------------------------------------------------------
#  |
#  | Mix provides a clean, fluent API for defining some Webpack build steps
#  | for your Laravel applications. By default, we are compiling the CSS
#  | file for the application as well as bundling up all the JS files.
#  |
#  */

# mix.js('resources/js/app.js', 'public/js').postCss('resources/css/app.css', 'public/css', [
#     require('postcss-import'),
#     require('tailwindcss'),
#     require('autoprefixer'),
# ]);


# .....................

# ③ app.blade.phpにリンクを追加する

# resources/views/layouts/app.balde.php と resources/views/layouts/guest.blade.phpの<head></head>内に、下記を追加します。


        # <!-- Styles -->
        # <link rel="stylesheet" href="{{ asset('css/app.css') }}">

        # <!-- Scripts -->
        # <script src="{{ asset('js/app.js') }}" defer></script>


# .....................

# ④ package.jsonの変更

# package.jsonのscriptに、下記を追加します。

        # "dev": "npm run development",
        # "development": "mix",
        # "watch": "mix watch",
        # "watch-poll": "mix watch -- --watch-options-poll=1000",
        # "hot": "mix watch --hot",
        # "prod": "npm run production",
        # "production": "mix --production"


# .....................

# ⑤  jsファイルの修正

# Viteをアンインストールする項目に書いたので、省略します。

# ⑥ .envの修正

# Viteをアンインストールする項目に書いたので、省略します。


# .....................

# 準備は以上となります。npm run devを実行すると、Laravel Mixでコンパイルが行われます。

# なおプロジェクト作成後、npm run devを行った時に

#! WARNINGS in child compilations とエラーが出たりしますが、これはまたViteと違う問題です。対策は下記にあります。

# https://biz.addisteria.com/error_child_compilations/


# ==== Bladeテンプレート ====

# https://readouble.com/laravel/9.x/ja/blade.html


# Laravel bladeの @yield、@section、@include、@component、@stuckの違いってなんだ？
# https://zenn.dev/ytksato/articles/2a1c5352473723

# 【Laravel】Bladeの主要ディレクティブ一覧
# https://qiita.com/nyax/items/7f949bcb331b7221e593

# LaravelのBlade Componentsを使いこなすための基礎
# https://reffect.co.jp/laravel/laravel-components


# -------------------

#? Bladeテンプレートの書き方

# 方法１: @extends, @yield, @section, @include

# 方法２: x-

# <x-app-layout>: app/View/Components/AppLayout.phpを読み込む

# {{ $header }} ← <x-slot name="header">
# {{ $slot }} ← 中身

# <x-application-logo: resources/views/commponents/application-log.balde.phpを読み込む

# <x-auth-validation-errors class="mb-4" :errors="$errors" />
#  class="mb-4" → <div {{ $attributes }}>, :errors="$errors" → @props(['errors'])


# -------------------

#? __()って何？

# https://readouble.com/laravel/8.x/ja/localization.html

# https://qiita.com/rikua0023/items/6384075345b1d14dc9e3
# https://minememo.work/laravel-localization__


# -------------------

#? 改行コードを含んだ変数をBladeで表示させる

#記事
# https://biz.addisteria.com/nl2br/
# https://techracho.bpsinc.jp/wingdoor/2020_06_11/92793
# https://qiita.com/PKunito/items/e4a8273ebce267311690
# https://bonoponz.hatenablog.com/entry/2020/10/03/%E3%80%90Laravel/PHP%E3%80%91%E6%94%B9%E8%A1%8C%E3%82%B3%E3%83%BC%E3%83%89%EF%BC%88%5Cn%EF%BC%89%E3%81%AF%E8%AA%8D%E8%AD%98%E3%81%95%E3%81%9B%E3%81%9F%E3%81%84%E3%81%91%E3%81%A9%E3%80%81HTML%E3%82%BF
# https://nekoroblog.com/laravel-line-break/

# {!! nl2br(e($変数)) !!}

#^ 改行を含むようなテキストを表示させるときはこっちを使用。
# → textarea, body


# -------------------

#? formatメソッド(日付のフォーマット)

# https://www.techpit.jp/courses/11/curriculums/12/sections/107/parts/387

# {{ $article->created_at->format('Y/m/d H:i') }}

# formatメソッドは、Laravelの日付時刻クラスであるCarbonで使えるメソッドです。

# 引数には、日付時刻表示のフォーマット(形式)を渡します。

# 'Y/m/d H:i'とすれば、2020/02/01 12:00といった表示になります。

# 'Y年m月d日 H時i分'とすれば、2020年02月01日 12時00分といった表示になります。

# もし、月や日を1桁表示にしたければ、mの代わりにn、dの代わりにjを使います。(n月j日)

# 使えるフォーマットは、PHPのdate関数と同じなので、フォーマットの書式をさらに知りたい方は以下を参考にしてください。

# date - PHP公式マニュアル
# https://www.php.net/manual/ja/function.date.php


# -------------------

#? 三項演算子

#【Laravel】Bladeで@ifではなく三項演算子を使う
# https://qiita.com/shonansurvivors/items/1e3194cf3eb2ea089039


# <div>
#   @if ($item->is_approved)
#     承認済
#   @else
#     未承認
#   @endif
# </div>

# ↓

# <div>
#   {{ $item->is_approved ? '承認済' : '未承認' }}
# </div>


# .....................

# <div>
#   @if ($item->notice)
#     {{ $item->notice }}
#   @else
#     お知らせはありません
#   @endif
# </div>

# ↓

# <div>
#   {{ $item->notice ?: 'お知らせはありません' }}
# </div>


# ==== セキュリティ対策(XSS,CSRF,SQLインジェクション) ====

# 記事
# https://qiita.com/4649rixxxz/items/d31ecb33fcba1bffcb90
# https://poppotennis.com/posts/laravel-xss


# ==== Alpine.js ====

# https://alpinejs.dev/

# How to Install Alpine.js in Laravel 8
# https://larainfo.com/blogs/how-to-install-alpinejs-in-laravel-8

#? Adding Alpine.js using Laravel Mix

# npm install

# npm install alpinejs

# Alpine js 3:
# resources/js/app.js
# import Alpine from 'alpinejs';

# window.Alpine = Alpine;

# Alpine.start();


# npm run watch
# or
# npm run dev


#^ Laravel BreezeではAlpine.jsが使われている。
# resources/js/app.js

# import './bootstrap';

# import Alpine from 'alpinejs';

# window.Alpine = Alpine;

# Alpine.start();

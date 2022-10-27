#! 429 (Too Many Requests) 対策

# ⑴ app/Providers/RouteServiceProvider.php

# protected function configureRateLimiting()
# {
#     //元々設定された 1分間60分
#     RateLimiter::for('api', function (Request $request) {
#         return Limit::perMinute(60)->by(optional($request->user())->id ?: $request->ip());
#     });

#     //追加分
#     RateLimiter::for('seventy', function () {
#         return Limit::perMinute(70);
#     });
# }



# ⑵ app/Http/Kernel.php

# 'throttle:api'をコメントアウトにする


# ⑶ routes/api.php

# Route::get('/get', [CheckController::class, 'get']);
# ↓
# Route::middleware(['throttle:seventy'])->group(function() {
#     Route::get('/get', [CheckController::class, 'get']);
# });



# ----------------

# 429 (Too Many Requests)を回避する(Laravel 8)
# https://bashalog.c-brains.jp/20/12/25-170000.php

# Laravelでが出た時の対策
# https://qiita.com/HorikawaTokiya/items/c04e410e4ed76d3dddc2

#【Laravel】Too Many Requestsについて調べてみた
# https://tech.arms-soft.co.jp/entry/2021/09/29/090000

# Laravel8で429エラーが出たときの対処法
# https://zenn.dev/naoki_oshiumi/articles/e7a1e97ba858b4

# LaravelのAPIで429 Too Many Requestsが返る
# https://www.suzu6.net/posts/170-laravel-throttle/

# Laravel APIがアクセスできなくなるとき
# https://blog.splout.co.jp/12722/

#【Laravel】過剰なアクセスを制限する！レート制限
# https://e-seventh.com/laravel-rate-limit/


# ==== Next.js + Laravel + AWS ====

#【AWS】Next.js+LaravelをECS+Fargateにデプロイする時のアレコレ
# https://yutaro-blog.net/2022/01/22/nextjs-laravel-aws-ecs-fargate/

# ECS(Fargate)でnextjs+laravel+rds環境構築
# https://zenn.dev/nicopin/books/58c922f51ea349

# Next.js + Laravel 8 の準備編
# https://zenn.dev/knaka0209/articles/f0082eb105b2c4

#【Next.jsとLaravelのJamstackなWebサービス】Part1：環境構築
# https://maasaablog.com/development/nextjs/3104/

#【Next.jsとLaravelのJamstackなWebサービス】Part2：ルーティング
# https://maasaablog.com/development/nextjs/3201/

#【Next.jsとLaravelのJamstackなWebサービス】Part3：認証
# https://maasaablog.com/development/nextjs/3138/

# Next.jsとLaravelで作ったアプリをAWSにデプロイ出来なかった話
# https://qiita.com/2san/items/0d943e839cfa4d0f7ba0

#【AWS】LaravelアプリをEC2デプロイ⑦【API編】
# https://qiita.com/kazumakishimoto/items/fd4afc02f9490ddb89e5


# ==== Next.js + Laravel Sanctum + Heroku or AWS ====

# Laravel 8.X Sanctumが本番環境だと動かない message: "Unauthenticated." と返ってくる時の対処法
# https://zenn.dev/takaharayuuki22/articles/b1fac7233cbf51


# Sanctumに関する環境変数を実行環境に合わせて変更するのを忘れていた（というか知らなかった）
# ルートディレクトリにある.envの環境変数 SANCTUM_STATEFUL_DOMAINSの値を本番環境のドメインに変更する

# 変更前

# .env
# SANCTUM_STATEFUL_DOMAINS=localhost:8080

# 変更後(例herokuの場合)

# .env
# SANCTUM_STATEFUL_DOMAINS=自分のドメイン.herokuapp.com

# これで正常にログインすることができました。


# -------------------

# Laravel Sanctum によるSPA認証とLaravelサーバとフロントエンドのローカルサーバーを別IPでのテスト
# https://pgmemo.tokyo/data/archives/2072.html


# ● CORの設定
# config/cors.php 次の設定を変更します

#     'paths' => ['api/*', 'sanctum/csrf-cookie', 'api-register', 'api-login', 'api-logout'], // ● 3つのエンドポイントを追加
#     'allowed_origins_patterns' => ['/localhost:?[0-9]*/'],  // ● localhost:3000 追加
#     'supports_credentials' => true,     // ● trueに変更


# ................

# ● セッションCookieの設定
# config/session.php:158 次の設定を確認します

#     'domain' => env('SESSION_DOMAIN', null),
# .envファイルの SESSION_DOMAIN の値を読み取る設定となっているので、 .env の設定を変更します。

# サブドメインに対応するために先頭を . にします
# 例: dev.myhost.com の場合

# .env

# # config/session.php の SESSION 設定
# SESSION_DOMAIN=".myhost.com"


# ................

# ● sanctumの設定
# config/sanctum.php:16 の次の設定を確認します

#     'stateful' => explode(',', env('SANCTUM_STATEFUL_DOMAINS', sprintf(
#         '%s%s',
#         'localhost,localhost:3000,127.0.0.1,127.0.0.1:8000,::1',
#         env('APP_URL') ? ','.parse_url(env('APP_URL'), PHP_URL_HOST) : ''
#     ))),
# これは次のホスト名をファーストパーティーとして認識させます

# localhost
# localhost:3000
# 127.0.0.1
# 127.0.0.1:8000
# ::1
# env('APP_URL')
# 開発や実際に動作させるサーバー名がこちらのリスト↑ にない場合は追加するか、 .env の5行目の APP_URL を変更します


# -------------------

#【Heroku】Laravel+MySQLで作成したアプリを公開【完全版】
# https://chigusa-web.com/blog/heroku-laravel/

# Laravel・Vue.jsで作ったアプリをherokuで公開する
# https://qiita.com/zako1560/items/32a58940de0e564754ca

# NextjsのmiddlewareからLaravel Sanctumの認証を通す方法
# https://zenn.dev/nicopin/articles/2cf7d90edc8b07

# Laravel API SanctumでSPA認証する
# https://qiita.com/ucan-lab/items/3e7045e49658763a9566


# ==== React + Laravel +React Query ====

# React × LaravelでReact Queryの練習がてら、ログイン機能を作ってみた
# https://zenn.dev/yumemi_inc/articles/2021-03-21-laravel-react-query-auth

# React × LaravelでSocialiteを使ったGitHubソーシャルログインを実装してみた
# https://changeofpace.site/develop/2021/05/19/react-query-socialite


# ==== Laravel + Nuxt.js ====

# Laravelとnuxt/authでSPA認証！ログイン機能を実装しよう！（第1回 バックエンド編）
# https://takabus.com/tips/940/

# Laravelとnuxt/authでSPA認証！ログイン機能を実装しよう！（第2回 フロントエンド編）
# https://takabus.com/tips/1396/

#【nuxt/authｘLaravel SanctumでSPA認証】サンプルを公開しました
# https://takabus.com/tips/1826/


# ==== TypeScript+Next.js+Laravel ====

# ***** TypeScript+Next.js+Laravelで超簡易的なメモアプリ開発ハンズオン（全回分） ****

# https://codoc.jp/sites/k73pDQ1olw/subscriptions/1AE2zciYow


# **** TypeScript+Next.js+Laravelで超簡易的なメモアプリ開発ハンズオン-1（概要説明） ****

# https://yutaro-blog.net/2022/01/28/typescript-nextjs-laravel-hands-on-1/


#~ 環境構築


# ------------------------

#~ マイグレーション:

# 2014_10_12_000000_create_users_table.phpの修正
# <?php

# use Illuminate\Database\Migrations\Migration;
# use Illuminate\Database\Schema\Blueprint;
# use Illuminate\Support\Facades\Schema;

# class CreateUsersTable extends Migration
# {
#     /**
#      * Run the migrations.
#      *
#      * @return void
#      */
#     public function up()
#     {
#         Schema::create('users', function (Blueprint $table) {
#             $table->id();
#             $table->string('name');
#             $table->string('email')->unique();
#             $table->string('password');
#             $table->timestamps();
#         });
#     }

#     /**
#      * Reverse the migrations.
#      *
#      * @return void
#      */
#     public function down()
#     {
#         Schema::dropIfExists('users');
#     }
# }



# make mkmodel-m model=Memo

# 2022_01_23_111119_create_memos_table.php
# <?php

# use Illuminate\Database\Migrations\Migration;
# use Illuminate\Database\Schema\Blueprint;
# use Illuminate\Support\Facades\Schema;

# class CreateMemosTable extends Migration
# {
#     /**
#      * Run the migrations.
#      *
#      * @return void
#      */
#     public function up()
#     {
#         Schema::create('memos', function (Blueprint $table) {
#             $table->id();
#             $table->foreignId('user_id')
#                 ->constrained()
#                 ->onUpdate('cascade')
#                 ->onDelete('cascade')
#                 ->comment('ユーザーID');
#             $table->string('title', 50)->comment('タイトル');
#             $table->string('body', 255)->comment('メモの内容');
#             $table->timestamps();
#         });
#     }

#     /**
#      * Reverse the migrations.
#      *
#      * @return void
#      */
#     public function down()
#     {
#         Schema::dropIfExists('memos');
#     }
# }


# make mig


# ------------------------

#~ ダミーデータの作成:

# make mkseeder model=User

# database/seeders/UserSeeder.php
# <?php

# namespace Database\Seeders;

# use Illuminate\Database\Seeder;
# use Illuminate\Support\Facades\DB;
# use Illuminate\Support\Facades\Hash;

# class UserSeeder extends Seeder
# {
#     /**
#      * Run the database seeds.
#      *
#      * @return void
#      */
#     public function run()
#     {
#         DB::table('users')->insert([
#             [
#                 'name' => 'サンプルユーザー',
#                 'email' => 'test@example.com',
#                 'password' => Hash::make('password'),
#                 'created_at' => now(),
#                 'updated_at' => now(),
#             ],
#         ]);
#     }
# }


# make mkseeder model=Memo

# database/seeders/MemoSeeder.php
# <?php

# namespace Database\Seeders;

# use Illuminate\Database\Seeder;
# use Illuminate\Support\Facades\DB;

# class MemoSeeder extends Seeder
# {
#     /**
#      * Run the database seeds.
#      *
#      * @return void
#      */
#     public function run()
#     {
#         DB::table('memos')->insert([
#             [
#                 'user_id' => 1,
#                 'title' => 'タイトル1',
#                 'body' => 'サンプルメモ1',
#                 'created_at' => now(),
#                 'updated_at' => now(),
#             ],
#             [
#                 'user_id' => 1,
#                 'title' => 'タイトル2',
#                 'body' => 'サンプルメモ2',
#                 'created_at' => now(),
#                 'updated_at' => now(),
#             ],
#             [
#                 'user_id' => 1,
#                 'title' => 'タイトル3',
#                 'body' => 'サンプルメモ3',
#                 'created_at' => now(),
#                 'updated_at' => now(),
#             ],
#             [
#                 'user_id' => 1,
#                 'title' => 'タイトル4',
#                 'body' => 'サンプルメモ4',
#                 'created_at' => now(),
#                 'updated_at' => now(),
#             ],
#             [
#                 'user_id' => 1,
#                 'title' => 'タイトル5',
#                 'body' => 'サンプルメモ5',
#                 'created_at' => now(),
#                 'updated_at' => now(),
#             ],
#             [
#                 'user_id' => 1,
#                 'title' => 'タイトル6',
#                 'body' => 'サンプルメモ6',
#                 'created_at' => now(),
#                 'updated_at' => now(),
#             ],
#         ]);
#     }
# }


# database/seeders/DatabaseSeeder.php
# <?php

# namespace Database\Seeders;

# use Illuminate\Database\Seeder;

# class DatabaseSeeder extends Seeder
# {
#     /**
#      * Seed the application's database.
#      *
#      * @return void
#      */
#     public function run()
#     {
#         $this->call([
#             UserSeeder::class,
#             MemoSeeder::class
#         ]);
#     }
# }


# make refresh-seed



# **** TypeScript+Next.js+Laravelで超簡易的なメモアプリ開発ハンズオン-2（ログイン機能） ****

# https://yutaro-blog.net/2022/01/28/typescript-nextjs-laravel-hands-on-2/
# https://github.com/shimotaroo/nextjs-laravel-hands-on/tree/feature/feat%2Flogin

#~ Laravel Sanctumの導入・セットアップ


# ⑴ 導入

# make install-sanctum v=:2.x

#^ コマンドを実行するとdatabase/migrations/****_**_**_******_create_personal_access_tokens_table.phpが作成されますが、SPA認証では不要なので削除しておいてください。（トークン認証では使います）


# ........................

# ⑵ セットアップ

# ①.envに
#・認証を保持したいアプリケーションのドメイン+ポート番号
#・セッションの保持するドメイン
# を定義します。

# 以下の2行を追加してください。

# .env
# SANCTUM_STATEFUL_DOMAINS=localhost:3000
# SESSION_DOMAIN=localhost


# ②app/Http/Kernel.phpのコメントアウトを外します。

# app/Http/Kernel.php
# protected $middlewareGroups = [
#     'web' => [
#         // 略
#     ],

#     'api' => [
#         // コメントアウトを外す
#         \Laravel\Sanctum\Http\Middleware\EnsureFrontendRequestsAreStateful::class,
#         'throttle:api',
#         \Illuminate\Routing\Middleware\SubstituteBindings::class,
#     ],
# ];



# ③config/cors.phpを以下の通り修正します。

# config/cors.php
# return [

#     //略

#     // false → true
#     'supports_credentials' => true,

# ];

#^ レスポンスヘッダの Access-Control-Allow-Credentials が true を返すようになります。


# ------------------------

#~ ログインAPIの実装

# ⑴ ルーティング追加

# LoginController.phpの作成
# make mkctrl model=Login

# routes/web.phpにルーティングを追加します。

# routes/web.php
# Route::post('/login', [LoginController::class, 'login'])->name('login');

#^ LaravelをAPIとして扱う場合のエンドポイントは/api/〜とすることが一般的ですが、公式ドキュメントにのっとってroutes/web.phpに定義します。（検証はしていませんがroutes/api.phpに定義しても動作すると思います）


# ........................

# ⑵ CORS設定

# config/cors.phpを見ると現状、CORSを許可しているパス（エンドポイント）はapi/*とsanctum/csrf-cookieだけなのでここにloginを追加します。

# config/cors.php
# return [
#     // 略

#     // 'login'を追加
#     'paths' => ['api/*', 'sanctum/csrf-cookie', 'login'],

#     // 略
# ];

#^ これで、異なるオリジン（プロトコル＋ドメイン＋ポート番号）からのログインAPI（/login）へのリクエストを許可します。


# ........................

# ⑶ FormRequestの実装

# POSTリクエストのバリデーションはFormRequestに定義します。


# Laravel 8.x バリデーション
# https://readouble.com/laravel/8.x/ja/validation.html#:~:text=%E5%88%A4%E5%AE%9A%E3%81%97%E3%81%BE%E3%81%99%E3%80%82-,%E3%83%95%E3%82%A9%E3%83%BC%E3%83%A0%E3%83%AA%E3%82%AF%E3%82%A8%E3%82%B9%E3%83%88%E3%83%90%E3%83%AA%E3%83%87%E3%83%BC%E3%82%B7%E3%83%A7%E3%83%B3,-%E3%83%95%E3%82%A9%E3%83%BC%E3%83%A0%E3%83%AA%E3%82%AF%E3%82%A8%E3%82%B9%E3%83%88%E4%BD%9C%E6%88%90


# 今回はapp/Http/Requests/LoginRequest.phpを準備しています。

# make mkreq model=Login


# app/Http/Requests/LoginRequest.php
# <?php

# namespace App\Http\Requests;

# use Illuminate\Foundation\Http\FormRequest;

# class LoginRequest extends FormRequest
# {
#     /**
#      * Determine if the user is authorized to make this request.
#      *
#      * @return bool
#      */
#     public function authorize()
#     {
#         return true;
#     }

#     /**
#      * Get the validation rules that apply to the request.
#      *
#      * @return array
#      */
#     public function rules()
#     {
#         return [
#             'email' => ['required', 'email:rfc'],
#             'password' => ['required', 'regex:/\A([a-zA-Z0-9]{8,})+\z/u']
#         ];
#     }

#     public function messages()
#     {
#         return [
#             'required' => '必須入力です。',
#             'email.email' => '有効なメールアドレスを入力してください。',
#             'password.regex' => '8文字以上の半角英数字で入力してください',
#         ];

#     }
# }



#・email（メールアドレス）: 必須入力、有効なメールアドレス
#・password（パスワード）: 必須入力、8文字以上の半角英数字


#^ emailの「有効なメールアドレスかどうか」のバリデーションは正規表現を使って実装する方法もありますが、今回は簡略化のためLaravelに組み込まれた'email:rfc'ルールを使います。

# email
# https://readouble.com/laravel/8.x/ja/validation.html#rule-email


#^ passwordの「半角英数字かどうか」のバリデーションはLaravelに標準搭載されている'alpha_num'でできると思いますが、実は全角文字を通してしまうので正規表現で設定しています。

#【Laravel】『alpha系』のバリデーションルールには注意が必要だよというお話
# https://yutaro-blog.net/2021/05/05/laravel-validation-alpha/


# Laravel バリデーションルール (まとめ)
# https://laraweb.net/knowledge/6265/

# Laravelのバリデーションで使える標準ルール11選！
# https://codelikes.com/laravel-validation-rule/#toc9


# ........................

# ⑷ Controllerの実装

# app/Http/Controllers/LoginController.phpを以下のとおり実装します。

# app/Http/Controllers/LoginController.php
# <?php

# namespace App\Http\Controllers;

# use App\Http\Requests\LoginRequest;
# use Illuminate\Http\Resources\Json\JsonResource;
# // ここから追加
# use Illuminate\Support\Facades\Auth;
# use Illuminate\Validation\ValidationException;
# // ここまで追加

# class LoginController extends Controller
# {
#     /**
#      * ログイン
#      * @param LoginRequest $request
#      * @return JsonResource
#      */
#     public function login(LoginRequest $request): JsonResource
#     {
#         // ログイン成功時
#         if (Auth::attempt($request->all())) {
#             $request->session()->regenerate();
#         }

#         // ログイン失敗時のエラーメッセージ
#         throw ValidationException::withMessages([
#             'loginFailed' => 'IDまたはパスワードが間違っています。'
#         ]);
#     }
# }


# ログインAPIから返却するバリデーションメッセージの種類は以下の3つです。

#・email: FormRequestに定義したメールアドレスのルールにエラーした場合
#・password: FormRequestに定義したパスワードのルールにエラーした場合
#・loginFailed: メールアドレス、パスワードに一致するユーザーが見つからない場合


# loginFailedをバリデーションエラー（ステータスコード422）とした理由はフロントエンド側でエラーハンドリングする時に

#・ステータスコード422（バリデーションエラー）: 画面にエラーメッセージを表示
#・ステータスコード500: アラート表示

# としたく、ログイン失敗を500で返してしまうとエラーハンドリングがややこしくなるため、バリデーションエラーとして扱います。

# エラーの意味合いとしても入力値が間違っているということでそこまで違和感のない実装かと思います。


# ........................

# ⑸ API Resourceの実装

# APIからJSONを返却する際にはJSONの形式を明示的にするためにAPI Resourceを使います。


# Laravel 8.x Eloquent：ＡＰＩリソース
# https://readouble.com/laravel/8.x/ja/eloquent-resources.html

# API Resourceを使わずにreturn response()->json(['key' => 'value']);という感じでJSONレスポンスを返してあげてもいいですが、せっかくなのでAPI Resourceを使います。


# ①app/Http/Resources/UserResource.phpを修正します。

# make mkresource model=User

# app/Http/Resources/UserResource.php
# <?php

# namespace App\Http\Resources;

# use Illuminate\Http\Resources\Json\JsonResource;

# class UserResource extends JsonResource
# {
#     /**
#      * Transform the resource into an array.
#      *
#      * @param  \Illuminate\Http\Request  $request
#      * @return array|\Illuminate\Contracts\Support\Arrayable|\JsonSerializable
#      */
#     public function toArray($request)
#     {
#         // ここから削除する
#         // return [parent::toArray($request)];
#         // ここまで削除
#         // ここから追記
#         return [
#             'id' => $this->id
#         ];
#         // ここまで追記
#     }
# }


# 今回はマイページなどAPIから返却したユーザー情報を使って画面に表示することはないので、idだけを返却します。

# 実装したAPI ResourceをControllerで使います。


# ②app/Http/Controllers/LoginController.phpを以下のとおり修正します。

# app/Http/Controllers/LoginController.php
# namespace App\Http\Controllers;

# use App\Http\Requests\LoginRequest;
# // ここから追加
# use App\Http\Resources\UserResource;
# // ここまで追加
# use Illuminate\Http\Resources\Json\JsonResource;
# use Illuminate\Support\Facades\Auth;
# use Illuminate\Validation\ValidationException;

# class LoginController extends Controller
# {
#     /**
#      * ログイン
#      * @param LoginRequest $request
#      * @return JsonResource
#      */
#     public function login(LoginRequest $request): JsonResource
#     {
#         // ログイン成功時
#         if (Auth::attempt($request->all())) {
#             $request->session()->regenerate();
#             // ここから追加
#             return new UserResource(Auth::user());
#             // ここまで追加
#         }

#         // ログイン失敗時のエラーメッセージ
#         throw ValidationException::withMessages([
#             'loginFailed' => 'IDまたはパスワードが間違っています。'
#         ]);
#     }
# }



#^ 以下のように、引数にオブジェクト（今回はモデルインスタンス）を渡してJSONを生成します。
#^ return new HogeHogeResource(model);


# これでUserResourceを見て「LoginControllerのloginメソッドはログインユーザーのidを返却する」ということがすぐわかるようになります。


# ........................

# ログインAPIの仕様まとめ

# エンドポイント:
# /login

# HTTPメソッド:
# POST

# リクエストパラメータ:
# - email（メールアドレス）
# - pasword（パスワード）

# バリデーション:
# - email: 必須入力、有効なメールアドレス
# - pasword: 必須入力、8文字以上の半角英数字

# レスポンス:
# - ログイン成功: ユーザーIDを含むJSON
# - ログイン失敗: バリデーションエラー(422）or システムエラー(500)


# ------------------------

#~ フロントエンド(Next.js側)の実装

# ⑴ stateの定義

# pages/index.tsxに

#・ログインAPIにPOSTするデータ
#・APIから返却されるバリデーションメッセージ

# を管理するためのstateを定義します。
#! (自分ならReat Hook FormとYupを使用する)

# pages/index.tsx
# import type { NextPage } from 'next';
# // 追加
# import { useState } from 'react';
# import { RequiredMark } from '../components/RequiredMark';

# // POSTデータの型
# type LoginForm = {
#   email: string;
#   password: string;
# };

# // バリデーションメッセージの型
# type Validation = LoginForm & { loginFailed: string };

# const Home: NextPage = () => {
#   // 追加
#   // POSTデータのstate
#   const [loginForm, setLoginForm] = useState<LoginForm>({
#     email: '',
#     password: '',
#   });
#   // バリデーションメッセージのstate
#   const [validation, setValidation] = useState<Validation>({
#     email: '',
#     password: '',
#     loginFailed: '',
#   });

#   return (
#     // 略
#   );
# };

# export default Home;



# loginFormとvalidationという名前のstateを定義しました。


# ........................

# ⑵ stateの更新処理

# 入力フォームへの文字入力に連動してAPIに渡すstateであるloginFormを更新する処理を実装します。

# pages/index.tsxを修正します。

# pages/index.tsx
# import type { NextPage } from 'next';
# // ChangeEventを追加
# import { ChangeEvent, useState } from 'react';
# import { RequiredMark } from '../components/RequiredMark';

# // 略

# const Home: NextPage = () => {
#   // state定義
#   const [loginForm, setLoginForm] = useState<LoginForm>({
#     email: '',
#     password: '',
#   });
#   const [validation, setValidation] = useState<Validation>({
#     email: '',
#     password: '',
#     loginFailed: '',
#   });

#   // 追加
#   // POSTデータの更新
#   const updateLoginForm = (e: ChangeEvent<HTMLInputElement>) => {
#     setLoginForm({ ...loginForm, [e.target.name]: e.target.value });
#   };

#   return (
#     <div className='w-2/3 mx-auto py-24'>
#       <div className='w-1/2 mx-auto border-2 px-12 py-16 rounded-2xl'>
#         <h3 className='mb-10 text-2xl text-center'>ログイン</h3>
#         <div className='mb-5'>
#           <div className='flex justify-start my-2'>
#             <p>メールアドレス</p>
#             <RequiredMark />
#           </div>
#           {/* value属性とonChangeイベントを追加 */}
#           <input
#             className='p-2 border rounded-md w-full outline-none'
#             name='email'
#             value={loginForm.email}
#             onChange={updateLoginForm}
#           />
#           {/* <p className='py-3 text-red-500'>必須入力です。</p> */}
#         </div>
#         <div className='mb-5'>
#           <div className='flex justify-start my-2'>
#             <p>パスワード</p>
#             <RequiredMark />
#           </div>
#           <small className='mb-2 text-gray-500 block'>
#             8文字以上の半角英数字で入力してください
#           </small>
#           {/* value属性とonChangeイベントを追加 */}
#           <input
#             className='p-2 border rounded-md w-full outline-none'
#             name='password'
#             type='password'
#             value={loginForm.password}
#             onChange={updateLoginForm}
#           />
#           {/* <p className='py-3 text-red-500'>
#             8文字以上の半角英数字で入力してください。
#           </p> */}
#         </div>
#         <div className='text-center mt-12'>
#           {/* <p className='py-3 text-red-500'>
#             IDまたはパスワードが間違っています。
#           </p> */}
#           <button className='bg-gray-700 text-gray-50 py-3 sm:px-20 px-10 rounded-xl cursor-pointer drop-shadow-md hover:bg-gray-600'>
#             ログイン
#           </button>
#         </div>
#       </div>
#     </div>
#   );
# };

# export default Home;



# 更新処理はこちらです。

# const updateLoginForm = (e: ChangeEvent<HTMLInputElement>) => {
#   setLoginForm({ ...loginForm, [e.target.name]: e.target.value });
# };

# ChangeEvent型のイベントオブジェクトを引数に取ることで、

#・e.target.nameでinputタグのname属性の値
#・e.target.valueでinputタグのvalue属性の値

# にアクセスすることができます。

# オブジェクト型のstateの更新はスプレッド構文を使います。


# 関数コンポーネント内の適当な場所に以下のコードを入れて、入力フォームに文字を入力するとリアルタイムでloginFormの値が更新されるようになります。

# console.log(loginForm)


# ........................

# ⑶ Axiosのインストールとセットアップ

# ログインAPIにPOSTするデータの準備（定義・更新処理実装）ができたので、APIにリクエストする部分を実装していきます。

# フロントエンドから非同期でHTTP通信を行うライブラリとしてAxiosをインストールします。

# yarn add axios


# Axiosを使ってAPIに非同期通信する時は

# axios.post('http://localhost:80/api/user', postData)

# のようにしますが、毎回http://localhost:80を書くのもめんどくさいのでAxiosの設定を共通化して使いまわせるようにします。

# lib/axios.tsを作成し、実装します。

# lib/axios.ts
# import axios from 'axios';

# export const axiosApi = axios.create({
#   baseURL: 'http://localhost:80',
#   withCredentials: true,
# });


# このようにすることで以下の書き方でaxios.post('http://localhost:80/api/user', postData)を同じ処理を行えます。

# axiosApi.post('/api/user', postData)


#^ withCredentials: trueとすることで、AxiosでAPIのリクエストするときにCookieを一緒に送ることができます。


# ........................

# ⑷ ログインAPIへのリクエスト

# Axiosのセットアップができたので、ログインAPIにリクエストしてログインできるようにします。

# 現状のルーティングを確認します。

# make route-list

# +--------+----------+---------------------+------+------------------------------------------------------------+------------------------------------------+
# | Domain | Method   | URI                 | Name | Action                                                     | Middleware                               |
# +--------+----------+---------------------+------+------------------------------------------------------------+------------------------------------------+
# |        | GET|HEAD | /                   |      | Closure                                                    | web                                      |
# |        | GET|HEAD | api/memos           |      | App\Http\Controllers\MemoController@fetch                  | api                                      |
# |        | POST     | api/memos           |      | App\Http\Controllers\MemoController@create                 | api                                      |
# |        | GET|HEAD | api/user            |      | Closure                                                    | api                                      |
# |        |          |                     |      |                                                            | App\Http\Middleware\Authenticate:sanctum |
# |        | POST     | login               |      | App\Http\Controllers\LoginController@login                 | web                                      |
# |        | GET|HEAD | sanctum/csrf-cookie |      | Laravel\Sanctum\Http\Controllers\CsrfCookieController@show | web                                      |
# +--------+----------+---------------------+------+------------------------------------------------------------+------------------------------------------+


# ルーティングを定義するroutes/api.php、routes/web.phpにはsanctum/csrf-cookieをエンドポイントとするルーティングは定義していないですが、Laravel Sanctumを導入したことで自動的に追加されています。

# このエンドポイントにリクエストを送ることでアプリケーションのCSRF保護を初期化するとともにCookieに以下の内容を保存します。

#・laravel_session
#・XSRF-TOKEN

#^ SPAを認証するには、SPAの「ログイン」ページで最初に/sanctum/csrf-cookieエンドポイントにリクエストを送信して、アプリケーションのCSRF保護を初期化する必要があります。
# → ログイン処理を含むPOST処理の前に実行する必要があります。


# pages/index.tsxにログインAPIへのリクエスト処理を実装します。
#! (自分ならreact-queryを使ってhookにする。)

# pages/index.tsx
# import type { NextPage } from 'next';
# // 追加
# import { AxiosError, AxiosResponse } from 'axios';
# import { ChangeEvent, useState } from 'react';
# import { RequiredMark } from '../components/RequiredMark';
# // 追加
# import { axiosApi } from '../lib/axios';

# // 略

# const Home: NextPage = () => {
#   // 略

#   // 追加
#   // ログイン
#   const login = () => {
#     axiosApi
#       // CSRF保護の初期化
#       .get('/sanctum/csrf-cookie')
#       .then((res) => {
#         // ログイン処理
#         axiosApi
#           .post('/login', loginForm)
#           .then((response: AxiosResponse) => {
#             console.log(response.data);
#           })
#           .catch((err: AxiosError) => {
#             console.log(err.response);
#           });
#       });
#   };

#   return (
#     <div className='w-2/3 mx-auto py-24'>
#       <div className='w-1/2 mx-auto border-2 px-12 py-16 rounded-2xl'>
#         <h3 className='mb-10 text-2xl text-center'>ログイン</h3>
#         // 略
#         <div className='text-center mt-12'>
#           {/* <p className='py-3 text-red-500'>
#             IDまたはパスワードが間違っています。
#           </p> */}
#           {/* onClick={login}を追加 */}
#           <button
#             className='bg-gray-700 text-gray-50 py-3 sm:px-20 px-10 rounded-xl cursor-pointer drop-shadow-md hover:bg-gray-600'
#             onClick={login}
#           >
#             ログイン
#           </button>
#         </div>
#       </div>
#     </div>
#   );
# };

# export default Home;


# 現状は暫定的に

#・ログイン成功時: response.dataをコンソール表示
#・ログイン失敗時: err.responseをコンソール表示

# としています。

# ここまでできたら以下の情報を入力して実際にログインしてみます。
#! ダミーデータを作成して置く必要がある。

#・メールアドレス: test@example.com
#・パスワード: password

# 上記のとおり入力してログインボタンを押すとコンソールにこのように出力されたらログイン成功です。

# console
# {
#     "data": {
#         "id": 1
#     }
# }


# パスワード（or メールアドレス or どちらも）を空にしてログインを試行するとLaravel側で設定したバリデーションメッセージが出力されています。

# console
# {
#     "message": "The given data was invalid.",
#     "errors": {
#         "password": [
#             "必須入力です。"
#         ]
#     }
# }


# ........................

# ⑸ ログイン成功時の画面遷移

# ログインが成功したら「メモ一覧画面」に自動的に遷移できるようにします。

# Next.jsではルーティング機能を使う場合はuseRouterというHooksを使えます。

# pages/index.tsxを以下のとおり修正します。

# pages/index.tsx
# import type { NextPage } from 'next';
# import { AxiosError, AxiosResponse } from 'axios';
# import { ChangeEvent, useState } from 'react';
# import { RequiredMark } from '../components/RequiredMark';
# import { axiosApi } from '../lib/axios';
# // ここから追加
# import { useRouter } from 'next/router';
# // ここまで追加

# // 略

# const Home: NextPage = () => {
#   // ここから追加
#   const router = useRouter();
#   // ここまで追加

#   // 略

#   // ログイン
#   const login = () => {
#     axiosApi
#       // CSRF保護の初期化
#       .get('/sanctum/csrf-cookie')
#       .then((res) => {
#         // ログイン処理
#         axiosApi
#           .post('/login', loginForm)
#           .then((response: AxiosResponse) => {
#             console.log(response.data);
#             // ここから追加
#             router.push('/memos');
#             // ここまで追加
#           })
#           .catch((err: AxiosError) => {
#             console.log(err.response);
#           });
#       });
#   };

#   return (
#      // 略
#    );
# };

# export default Home;



# next/router
# https://nextjs.org/docs/api-reference/next/router


# 以下の内容を入力してログインすると、メモ一覧画面に遷移します。

#・メールアドレス: test@example.com
#・パスワード: password


# ------------------------

#~ 注意点

# 現状の認証周りは以下のようにかなり不完全なものとなっています。

# 現在はログインしていてもしていなくてもhttp://localhost:3000/memosと入力すればメモ一覧画面に、http://localhost:3000/memos/postと入力すればメモ登録画面に遷移できてしまうというかなりガバガバな状態になっています。


# **** TypeScript+Next.js+Laravelで超簡易的なメモアプリ開発ハンズオン-3（メモ一覧画面） ****

# https://yutaro-blog.net/2022/01/29/typescript-nextjs-laravel-hands-on-3/

# https://github.com/shimotaroo/nextjs-laravel-hands-on/tree/feature/feat%2Fmemos%2Fpage


# ログイン機能の実装と同じように

#・メモデータ取得APIの実装(Laravel側)
#・メモ一覧画面の実装(Next.js側)

# の順に行います。


#~ メモデータ取得APIの実装

# ⑴ ルーティング追加

# make mkctrl model=Memo

# routes/api.phpにルーティングを追加します。

# // メモ全件取得
# Route::get('/memos', [MemoController::class, 'fetch']);

# これでhttp://localhost:80/api/memosのエンドポイントにGETリクエストを送信するとこのルーティングが適用されます。

# 余談ですが、routes/api.phpに定義したルーティングのパスには/apiのプレフィックスがつきます。


# ........................

# ⑵ Controllerの実装

# app/Http/Controllers/MemoController.phpを以下の通り実装します。

# <?php

# namespace App\Http\Controllers;

# use App\Http\Requests\MemoPostRequest;
# // ここから追加
# use App\Models\Memo;
# use Exception;
# // ここまで追加
# use Illuminate\Http\JsonResponse;
# use Illuminate\Http\Resources\Json\AnonymousResourceCollection;
# // 追加
# use Illuminate\Support\Facades\Auth;

# class MemoController extends Controller
# {
#     /**
#      * メモの全件取得
#      * @return AnonymousResourceCollection
#      */
#     public function fetch(): AnonymousResourceCollection
#     {
#         // ここから追加
#         // ログインユーザーのID取得
#         $id = Auth::id();
#         if (!$id) {
#             throw new Exception('未ログインです。');
#         }

#         try {
#             $memos = Memo::where('user_id', $id)->get();
#         } catch (Exception $e) {
#             throw $e;
#         }
#         // ここまで追加
#     }

#     // 略
# }


# 処理の流れとしては

# Auth::id()でログインユーザーのIDを取得する（ログインしているかどうかのチェック）→memosテーブルからログインユーザーが作成したメモデータを取得

# こんな感じです。

# 例外処理も入れています。（例外が投げられた場合はステータスコード500のレスポンスを返却します）


# ........................

# ⑶ API Resourceの実装

# Next.jsに返却するJSONレスポンスの生成にはAPI Resourceを使います。

# app/Http/Resources/MemoResource.phpを以下のとおり実装します。

# make mkresource model=Memo

# <?php

# namespace App\Http\Resources;

# use Illuminate\Http\Resources\Json\JsonResource;

# class MemoResource extends JsonResource
# {
#     /**
#      * Transform the resource into an array.
#      *
#      * @param  \Illuminate\Http\Request  $request
#      * @return array|\Illuminate\Contracts\Support\Arrayable|\JsonSerializable
#      */
#     public function toArray($request)
#     {
#         // ここを修正
#         return [
#             'id' => $this->id,
#             'title' => $this->title,
#             'body' => $this->body
#         ];
#     }
# }


# memosテーブルのカラムの内、user_id, created_at, updated_atは画面表示には不要なため、id, title, bodyのみをJSONに入れるように設定しています。

# （idもなくてもできますが一応入れています）

# それでは実装したAPI ResourceをControllerで使います。

# <?php

# namespace App\Http\Controllers;

# use App\Http\Requests\MemoPostRequest;
# // ここから追加
# use App\Http\Resources\MemoResource;
# // ここまで追加
# use App\Models\Memo;
# use Exception;
# use Illuminate\Http\JsonResponse;
# use Illuminate\Http\Resources\Json\AnonymousResourceCollection;
# // 追加
# use Illuminate\Support\Facades\Auth;

# class MemoController extends Controller
# {
#     /**
#      * メモの全件取得
#      * @return AnonymousResourceCollection
#      */
#     public function fetch(): AnonymousResourceCollection
#     {
#         // ログインユーザーのID取得
#         $id = Auth::id();
#         if (!$id) {
#             throw new Exception('未ログインです。');
#         }

#         try {
#             $memos = Memo::where('user_id', $id)->get();
#         } catch (Exception $e) {
#             throw $e;
#         }
#         // ここから追加
#         return MemoResource::collection($memos);
#         // ここまで追加
#     }

#     // 略
# }



# 返却するデータが1件（＝モデルインスタンス）の場合は

# return new HogeHogeResource($model);

# と書きますが、データが複数（＝コレクション）の場合は

# return HogeHogeResource::collection($collection);

# と書きます。

#^ コレクションはモデルインスタンスの配列という認識で良いです。


# ログインユーザーが作成したメモがない場合、$memosは空の配列（[]）が入るのでAPI Resourceのcollectionメソッドによって返却されるレスポンスデータも空の配列です。

# 余談ですが、返り値の型は以下の違いがあります。

#・new HogeHogeResource($model): JsonResource
#・HogeHogeResource::collection($collection): AnonymousResourceCollection

# API ResourceにはResource Collectionもありますが、今回の実装では特段使う必要がないので、使いませんが気になる方は調べてみてください。


# ........................

# メモデータ取得APIの仕様まとめ

# エンドポイント:
# /api/memos

# HTTPメソッド:
# GET

# リクエストパラメータ:
# なし

# バリデーション:
# なし

# レスポンス:
# ログインユーザーが作成したメモデータが入ったJSON


# ------------------------

#~ メモ一覧画面の実装

# APIの実装ができたので、Next.js側の実装をしていきます。

# pages/memos/index.tsxを見るとわかりますが、現在は定数として定義した仮のメモデータを画面に表示している状態です。

# これをLaravel API経由で取得したDBのデータを使って画面に表示できるように実装します。


# ⑴ stateの定義

#! (自分ならreact-queryを使用し、hook化する)

# まずはAPIから取得したメモデータをフロントエンド側で管理するためのstateを定義します。

# pages/memos/index.tsxにuseStateでローカルstateを定義します。


# import type { NextPage } from 'next';
# import { useRouter } from 'next/router';
# // 追加
# import { useState } from 'react';

# type Memo = {
#   title: string;
#   body: string;
# };

# // 略

# const Memo: NextPage = () => {
#   const router = useRouter();
#   // state定義
#   const [memos, setMemos] = useState<Memo[]>([]);

#   return (
#     // 略
#   );
# };

# export default Memo;


# memosというstateとsetMemosというstate更新メソッドを定義します。


# ........................

# ⑵ APIからメモデータの取得

#!(自分ならgetServerSidePropsなどを使う)

# APIへのリクエスト方法としてNext.jsに搭載されているgetServerSidePropsを使ってSSRで画面を構築する方法もありますが、今回はuseEffectを使って画面の初期表示時（初期レンダリング時）にクライアントサイド（ブラウザ）からAPIリクエストをし、クライアントサイドで取得したメモデータをレンダリングする方法を採用します。

# フロントエンド開発におけるCSR（クライアントサイドレンダリング）、SSR（サーバーサイドレンダリング）、SSG（静的サイトジェネレーター）についてはこちらの記事にまとめています。


# SPA(Single Page Application)と利用されるレンダリング技術まとめ
# https://yutaro-blog.net/2021/12/03/spa-csr-ssr-ssg-sg/

# SPA/CSR/SSR/SSGまとめ/SPA-SSR-SSG
# https://speakerdeck.com/shimotaroo/spa-ssr-ssg


# pages/memos/index.tsxを以下のように修正します。

# // ここから追加
# import { AxiosError, AxiosResponse } from 'axios';
# // ここまで追加
# import type { NextPage } from 'next';
# import { useRouter } from 'next/router';
# // useEffectを追加
# import { useEffect, useState } from 'react';
# // 追加
# import { axiosApi } from '../../lib/axios';

# type Memo = {
#   title: string;
#   body: string;
# };

# // 略

# const Memo: NextPage = () => {
#   const router = useRouter();
#   // state定義
#   const [memos, setMemos] = useState<Memo[]>([]);

#   // ここから追加
#   // 初回レンダリング時にAPIリクエスト
#   useEffect(() => {
#     axiosApi
#       .get('/api/memos')
#       .then((response: AxiosResponse) => console.log(response.data))
#       .catch((err: AxiosError) => console.log(err.response));
#   }, []);
#   // ここまで追加

#   return (
#     // 略
#   );
# };

# export default Memo;


# useEffectの第二引数である依存配列（最後の, []）を今回のように空配列にすると、初回レンダリング時にのみuseEffect内の処理が実行されます。

# ログイン画面（http://localhost:3000）で以下の情報でログインして、メモ一覧画面（http://localhost:3000/memos）にアクセスするとコンソールに以下のレスポンスが出力されます。


# console
# [
#     {
#         "id": 1,
#         "title": "タイトル1",
#         "body": "サンプルメモ1"
#     },
#     {
#         "id": 2,
#         "title": "タイトル2",
#         "body": "サンプルメモ2"
#     },
#     {
#         "id": 3,
#         "title": "タイトル3",
#         "body": "サンプルメモ3"
#     },
#     {
#         "id": 4,
#         "title": "タイトル4",
#         "body": "サンプルメモ4"
#     },
#     {
#         "id": 5,
#         "title": "タイトル5",
#         "body": "サンプルメモ5"
#     },
#     {
#         "id": 6,
#         "title": "タイトル6",
#         "body": "サンプルメモ6"
#     }
# ]

# これで、DBに保存されているデータがLaravel API経由で取得できていることが確認できました。


# ........................

# ⑶ stateの更新

# APIから取得したメモデータをstateに保存します。

# pages/memos/index.tsxを以下のとおり修正します。

# // 略

# type Memo = {
#   title: string;
#   body: string;
# };

# // 略

# const Memo: NextPage = () => {
#   const router = useRouter();
#   // state定義
#   const [memos, setMemos] = useState<Memo[]>([]);

#   // 初回レンダリング時にAPIリクエスト
#   useEffect(() => {
#     axiosApi
#       .get('/api/memos')
#       .then((response: AxiosResponse) => {
#         console.log(response.data);
#         // 追加
#         setMemos(response.data.data);
#       })
#       .catch((err: AxiosError) => console.log(err.response));
#   }, []);

#   return (
#     // 略
#   );
# };

# export default Memo;


# setMemosでAPIレスポンスを更新します。
# （API Resourceで生成したJSONの場合、response.data.dataにデータが入っています）

# これでmemosにはログインユーザーのメモデータが入ります。


#^ useEffectの下にconsole.log(memos)を埋め込んでみて、画面にアクセスするとmemosが空の配列（[]）→メモデータが入った配列に変わっていることがわかります。


# ........................

# ⑷ メモデータの画面表示

# 最後にmemosに入っているメモデータを画面表示します。

# 一旦、定数定義している仮データは削除します。

# pages/memos/index.tsxのtempMemosをコメントアウトします。（今後は使わないので削除でも問題ありません）


# 現在、returnの中でmap関数を使ってtempMemosを繰り返し処理をして画面に表示しているので、そのtempMemosが無くなることでエラーになります。


# pages/memos/index.tsxを修正します。


# // 略

# const Memo: NextPage = () => {
#   // 略

#   return (
#     <div className='w-2/3 mx-auto mt-32'>
#       <div className='w-1/2 mx-auto text-center'>
#         <button
#           className='text-xl mb-12 py-3 px-10 bg-blue-500 text-white rounded-3xl drop-shadow-md hover:bg-blue-400'
#           onClick={() => router.push('/memos/post')}
#         >
#           メモを追加する
#         </button>
#       </div>
#       <div className='mt-3'>
#         {/* DBから取得したメモデータの一覧表示 */}
#         <div className='grid w-2/3 mx-auto gap-4 grid-cols-2'>
#           {/* tempMemosをmemosに変更する */}
#           {memos.map((memo: Memo, index) => {
#             return (
#               <div className='bg-gray-100 shadow-lg mb-5 p-4' key={index}>
#                 <p className='text-lg font-bold mb-1'>{memo.title}</p>
#                 <p className=''>{memo.body}</p>
#               </div>
#             );
#           })}
#         </div>
#       </div>
#     </div>
#   );
# };

# export default Memo;


# map関数で繰り返す対象の配列をtempMemos（仮でベタ書きしたデータ）からmemos（APIから取得したデータ）に変更することで、stateに入っているDBから取得したメモデータが画面表示されます。


# map関数はReactでのフロントエンド開発ではよく使うので使い方をしっかり理解しておくことをオススメします。

# Array.prototype.map()
# https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Global_Objects/Array/map

# map関数の中身は既に準備していたので、これでメモ一覧画面の実装は完了です。


# **** TypeScript+Next.js+Laravelで簡易的なメモアプリ開発ハンズオン-4（メモ登録機能） ****

# https://yutaro-blog.net/2022/01/30/typescript-nextjs-laravel-hands-on-4/

# https://github.com/shimotaroo/nextjs-laravel-hands-on/tree/feature/feat/memo/post


#~ メモ登録APIの実装


# ⑴ ルーティング追加

# routes/api.phpにルーティングを追加します。

# // メモ登録
# Route::post('/memos', [MemoController::class, 'create']);


# この定義でhttp://localhost:80/api/memosにPOSTリクエストを送ると、MemoControllerのcreateメソッドが実行されます。


# ........................

# ⑵ FormRequestの実装

# POSTリクエストでAPIがユーザーの入力値を受け取るのでバリデーションを設けます。

# 今回はapp/Http/Requests/MemoPostRequest.phpを準備しています。

# make mkreq model=MemoPost

# <?php

# namespace App\Http\Requests;

# use Illuminate\Foundation\Http\FormRequest;

# class MemoPostRequest extends FormRequest
# {
#     /**
#      * Determine if the user is authorized to make this request.
#      *
#      * @return bool
#      */
#     public function authorize()
#     {
#         return true;
#     }

#     /**
#      * Get the validation rules that apply to the request.
#      *
#      * @return array
#      */
#     public function rules()
#     {
#         return [
#             'title' => ['required'],
#             'body' => ['required']
#         ];
#     }

#     public function messages()
#     {
#         return [
#             'required' => '必須入力です。',
#         ];
#     }
# }


# メモ登録処理のバリデーションは以下のルールです。

#・title（メモのタイトル）: 必須入力
#・body（メモの内容）: 必須入力

# 文字数の上限も下限もないかなり簡易的なバリデーションとしています。

#^ 実際にはDBへの負荷等を考慮して文字数を制限するのが良いと思います。

# タイトル、内容が空文字で送られた場合は「必須入力です。」というメッセージを返します。

#^ Laravelが準備しているバリデーションルールに文字列かどうかをチェックするstringがありますが、Requestクラスのインスタンスのプロパティは全て文字列になるため、ここでは追加していません。（追加してもいいですが追加する意味もないかと思います）

# string
# https://readouble.com/laravel/8.x/ja/validation.html#rule-string


# ........................

# ⑶ Controllerの実装

# app/Http/Controllers/MemoController.phpを以下の通り実装します。

# <?php

# namespace App\Http\Controllers;

# // 略

# class MemoController extends Controller
# {
#     // 略

#     /**
#      * メモの登録
#      * @param MemoPostRequest $request
#      * @return JsonResponse
#      */
#     public function create(MemoPostRequest $request): JsonResponse
#     {
#         // ここから追加
#         try {
#             // モデルクラスのインスタンス化
#             $memo = new Memo();
#             // パラメータのセット
#             $memo->user_id = Auth::id();
#             $memo->title = $request->title;
#             $memo->body = $request->body;
#             // モデルの保存
#             $memo->save();

#         } catch (Exception $e) {
#             throw $e;
#         }

#         return response()->json([
#             'message' => 'メモの登録に成功しました。'
#         ], 201);
#         // ここまで追加
#     }
# }


# メモの登録の順序としてはコードのとおり、モデルクラスのインスタンス化→インスタンスのプロパティにリクエストパラメータをセット→モデルを保存です。

# APIが返却するレスポンスに関して、メモ登録画面で登録に成功した場合にAPIから何かデータを受け取る必要がないので、成功した旨のメッセージを受け取るようにしています。（レスポンスの返り値はJsonResponseです）

# 新しいデータ（リソース）の作成なのでレスポンスのステータスコードは201としています。


# ........................

# メモ登録APIの仕様まとめ


# エンドポイント:
# /api/memos

# HTTPメソッド:
# POST

# リクエストパラメータ:
#・title（タイトル）
#・body（メモの内容）

# バリデーション:
#・title: 必須入力
#・body: 必須入力

# レスポンス:
#・登録成功: メッセージを含むJSON
#・登録失敗: バリデーションエラー(422）or システムエラー(500)


# ------------------------

#~ フロントエンドの実装

# ⑴ stateの定義

# pages/memos/post.tsxに

#・メモ登録APIにPOSTするデータ
#・APIから返却されるバリデーションメッセージ

# を管理するためのstateとstateの型を定義します。


# import type { NextPage } from 'next';
# // ここから追加
# import { useState } from 'react';
# // ここまで追加
# import { RequiredMark } from '../../components/RequiredMark';

# // ここから追加
# // POSTデータの型
# type MemoForm = {
#   tile: string;
#   body: string;
# };
# // ここまで追加

# const Post: NextPage = () => {
#   // ここから追加
#   // state定義
#   const [memoForm, setMemoForm] = useState<MemoForm>({
#     tile: '',
#     body: '',
#   });
#   const [validation, setValidation] = useState<MemoForm>({
#     tile: '',
#     body: '',
#   });
#   // ここまで追加

#   return (
#     // 略
#   );
# };

# export default Post;



#・メモ登録APIにPOSTするデータ: memoForm
#・APIから返却されるバリデーションメッセージ: validation


#^ memoFormという命名はログイン画面での定義したloginFormに合わせていますが、個人的にあまりしっくりくる命名ではないのでformDataとかでも良いと思います。


# ログイン画面とは異なり、バリデーションは通るけどログインが失敗するというようなケースはここでは発生しない（＝loginFailedのように追加プロパティが必要ない）ので型は同じものを使っています。


# ........................

# ⑵ stateの更新処理

# 入力フォームへの文字入力に連動してmemoFormを更新する処理を実装します。

# pages/memos/post.tsxを修正します。

# import type { NextPage } from 'next';
# // ChangeEventを追加
# import { ChangeEvent, useState } from 'react';
# import { RequiredMark } from '../../components/RequiredMark';

# // 略

# const Post: NextPage = () => {
#   // 略

#   // ここから追加
#   // POSTデータの更新
#   const updateMemoForm = (
#     e: ChangeEvent<HTMLInputElement | HTMLTextAreaElement>
#   ) => {
#     setMemoForm({ ...memoForm, [e.target.name]: e.target.value });
#   };
#   // ここまで追加

#   return (
#     <div className='w-2/3 mx-auto'>
#       <div className='w-1/2 mx-auto mt-32 border-2 px-12 py-16 rounded-2xl'>
#         <h3 className='mb-10 text-2xl text-center'>メモの登録</h3>
#         <div className='mb-5'>
#           <div className='flex justify-start my-2'>
#             <p>タイトル</p>
#             <RequiredMark />
#           </div>
#           {/* value属性とonChange属性を追加 */}
#           <input
#             className='p-2 border rounded-md w-full outline-none'
#             name='title'
#             value={memoForm.title}
#             onChange={updateMemoForm}
#           />
#         </div>
#         <div className='mb-5'>
#           <div className='flex justify-start my-2'>
#             <p>メモの内容</p>
#             <RequiredMark />
#           </div>
#           {/* value属性とonChange属性を追加 */}
#           <textarea
#             className='p-2 border rounded-md w-full outline-none'
#             name='body'
#             cols={30}
#             rows={4}
#             value={memoForm.body}
#             onChange={updateMemoForm}
#           />
#         </div>
#         // 略
#     </div>
#   );
# };

# export default Post;


# ここもログイン画面の時と同じようにチェンジイベントのオブジェクトを受け取ってnameとvalueにアクセスして値を取得しています。（メモの内容は<textarea>タグで入力するので、ChangeEventのジェネリクスでHTMLTextAreaElementを設定しています）

# updateMemoFormの下（関数コンポーネント内のreturnより上であればどこまで良いです）に

# console.log(memoForm)

# を埋め込んで入力フォームに文字を入力すると、memoFormが更新されるのがわかると思います。（コンソールをご確認ください）

# これでAPIにPOSTするデータをフロントエンドで準備できるようになりました。


# ........................

# ⑶ メモ登録APIへのリクエスト

#! (自分ならreact-queryを使用しhook化する)

# フロントで作成したデータをAPIに送って、メモを登録できるようにしていきます。

# pages/memos/post.tsxを以下のとおり実装します。

# // ここから追加
# import { AxiosError, AxiosResponse } from 'axios';
# // ここまで追加
# import type { NextPage } from 'next';
# import { ChangeEvent, useState } from 'react';
# import { RequiredMark } from '../../components/RequiredMark';
# // ここから追加
# import { axiosApi } from '../../lib/axios';
# // ここまで追加

# // 略

# const Post: NextPage = () => {
#   // 略

#   // ここから追加
#   // メモの登録
#   const createMemo = () => {
#     axiosApi
#       // CSRF保護の初期化
#       .get('/sanctum/csrf-cookie')
#       .then((res) => {
#         // APIへのリクエスト
#         axiosApi
#           .post('/api/memos', memoForm)
#           .then((response: AxiosResponse) => {
#             console.log(response.data);
#           })
#           .catch((err: AxiosError) => {
#             console.log(err.response);
#           });
#       });
#   };
#   // ここまで追加

#   return (
#     // 略
#   );
# };

# export default Post;


# それでは実際にAPIにPOSTリクエストを送ります。

# タイトル、内容は何でも良いので以下のように入力して「登録する」ボタンを押します。

#・タイトル: ハンズオン受講中
#・内容: TypeScript+Next.js+Laravelでメモアプリ開発


# コンソールに以下が出力されると登録成功です。

# console
# {
#     "message": "メモの登録に成功しました。"
# }



# ではバリデーションエラー時の挙動も確認しておきます。

# タイトル、内容ともに空のままPOSTすると以下が出力されます。


# console
# {
#     "message": "The given data was invalid.",
#     "errors": {
#         "title": [
#             "必須入力です。"
#         ],
#         "body": [
#             "必須入力です。"
#         ]
#     }
# }


# バリデーションも正常に動作しているのが確認できました。

# http://localhost:3000/memosにアクセスすると、登録したメモが画面に表示されるのが確認できます。（1番下に新しい記事が追加されています）


# メモの表示が上から古い順になってしまっているので新しい順の方がよかったなと思いました。笑

# 本ハンズオンでは上記対応はしませんが、もし新しい順に変更する場合はapp/Http/Controllers/MemoController.phpのfetchメソッドのメモデータを取得する箇所を以下のように変更してください。（->latest()を追加）


# $memos = Memo::where('user_id', $id)
#     ->latest()
#     ->get();


# ........................

# ⑷ 登録成功時の画面遷移処理

# 先ほど、メモ一覧画面に直接アクセスして登録したメモを確認しましたが、毎回この動作をするのはめんどくさいのでメモが登録されたら自動的にメモ一覧画面に遷移できるようにします。

# ここもログイン画面実装時と同じくuseRouterを使ってサクッと実装します。

#^ APIの場合は、リダイレクト処理はフロント側で行う。

# pages/memos/post.tsxを修正してください。

# import { AxiosError, AxiosResponse } from 'axios';
# import type { NextPage } from 'next';
# // ここから追加
# import { useRouter } from 'next/router';
# // ここまで追加
# import { ChangeEvent, useState } from 'react';
# import { RequiredMark } from '../../components/RequiredMark';
# import { axiosApi } from '../../lib/axios';

# // POSTデータの型
# type MemoForm = {
#   title: string;
#   body: string;
# };

# const Post: NextPage = () => {
#   // ここから追加
#   // ルーター定義
#   const router = useRouter();
#   // ここまで追加

#   // 略

#   // メモの登録
#   const createMemo = () => {
#     axiosApi
#       // CSRF保護の初期化
#       .get('/sanctum/csrf-cookie')
#       .then((res) => {
#         // APIへのリクエスト
#         axiosApi
#           .post('/api/memos', memoForm)
#           .then((response: AxiosResponse) => {
#             console.log(response.data);
#             // ここから追加
#             router.push('/memos');
#             // ここまで追加
#           })
#           .catch((err: AxiosError) => {
#             console.log(err.response);
#           });
#       });
#   };

#   return (
#     // 略
#   );
# };

# export default Post;


# ここまで終わったら再度メモ登録画面でメモの登録に成功するとメモ一覧画面に遷移することを確認してください。

# これでメモ登録画面の実装は終わりです。


# **** TypeScript+Next.js+Laravelで簡易的なメモアプリ開発ハンズオン-5（バリデーションメッセージ表示） ****

# https://yutaro-blog.net/2022/01/30/typescript-nextjs-laravel-hands-on-5/

# https://github.com/shimotaroo/nextjs-laravel-hands-on/tree/feature/feat/validation


# この記事ではLaravel APIから返却されたバリデーションメッセージをフロントエンド（Next.js）で表示していきます。

# また、バリデーションエラーのレスポンスのステータスコードは422、システムエラーのステータスコードは500なのでそれぞれのエラーをハンドリングできるような実装にしていきます。

# 修正するのはバリデーションメッセージを表示するフロントエンド側のコードのみです。

# なお、バリデーションメッセージの表示が必要な画面はログイン画面とメモ登録画面なのでどちらも実装していきます。（方法は全く同じです）


#~ ログイン画面

# 現状、ログイン画面でメールアドレス、パスワードともに空の状態でログインしようとすると、Laravelからバリデーションエラーが返ってきますが画面には何も表示されません。


# console
# {
#     "message": "The given data was invalid.",
#     "errors": {
#         "email": [
#             "必須入力です。"
#         ],
#         "password": [
#             "必須入力です。"
#         ]
#     }
# }


# 画面にバリデーションメッセージが表示されるように実装していきます。


# ⑴ バリデーションエラー(422)のハンドリング

# pages/index.tsxのAPIリクエスト処理のcatchの中を修正してステータスコードを取得してみます。


# // 略

# const Home: NextPage = () => {
#   // 略

#   // ログイン
#   const login = () => {
#     axiosApi
#       // CSRF保護の初期化
#       .get('/sanctum/csrf-cookie')
#       .then((res) => {
#         // ログイン処理
#         axiosApi
#           .post('/login', loginForm)
#           .then((response: AxiosResponse) => {
#             console.log(response.data);
#             router.push('/memos');
#           })
#           .catch((err: AxiosError) => {
#             // ここを修正
#             console.log(err.response?.status);
#           });
#       });
#   };

#   return (
#     //略
#   );
# };

# export default Home;



# この状態で再度入力フォームを空のままでログインしようとするとコンソールに422が出力されます。

# ステータスコードが取得できることがわかったのでこれを条件としてエラーの種類で処理を分けることができますので、以下の形にします。



# // 略

# const Home: NextPage = () => {
#   // 略

#   // ログイン
#   const login = () => {
#     axiosApi
#       // CSRF保護の初期化
#       .get('/sanctum/csrf-cookie')
#       .then((res) => {
#         // ログイン処理
#         axiosApi
#           .post('/login', loginForm)
#           .then((response: AxiosResponse) => {
#             console.log(response.data);
#             router.push('/memos');
#           })
#           .catch((err: AxiosError) => {
#             // ここから修正
#             cconsole.log(err.response);
#             // バリデーションエラー
#             if (err.response?.status === 422) {
#               // 処理
#             }
#             if (err.response?.status === 500) {
#               // 処理
#             }
#             // ここまで修正
#           });
#       });
#   };

#   return (
#     //略
#   );
# };

# export default Home;



# それでは、ハンズオン2回目で定義したバリデーションメッセージ用のstateであるvalidationを更新する処理を実装します。


# // 略

# const Home: NextPage = () => {
#   // 略

#   // ログイン
#   const login = () => {
#     axiosApi
#       // CSRF保護の初期化
#       .get('/sanctum/csrf-cookie')
#       .then((res) => {
#         // ログイン処理
#         axiosApi
#           .post('/login', loginForm)
#           .then((response: AxiosResponse) => {
#             console.log(response.data);
#             router.push('/memos');
#           })
#           .catch((err: AxiosError) => {
#             cconsole.log(err.response);
#             // バリデーションエラー
#             if (err.response?.status === 422) {
#               // ここから追加
#               const errors = err.response?.data.errors;
#               // state更新用のオブジェクトを別で定義
#               const validationMessages: { [index: string]: string } = {};
#               Object.keys(errors).map((key: string) => {
#                 validationMessages[key] = errors[key][0];
#               });
#               // state更新用オブジェクトに更新
#               setValidation({ ...validation, ...validationMessages });
#               // ここまで追加
#             }
#             if (err.response?.status === 500) {
#               // 処理
#             }
#           });
#       });
#   };

#   return (
#     //略
#   );
# };

# export default Home;


# 少し難しい実装に見えますので解説します。

# まずはLaravelから返却されるレスポンスのバリデーションメッセージ情報はerr.response?.data.errorsに含まれていますが、ちょっと長いので変数に入れておきます。


# const errors = err.response?.data.errors;


# （変数に入れる理由は「長ったらしいから」ですし、2回しか使わないので必ずしも変数定義しなくても良いかと思います）

# 次がこの記事の1番のキモですがvalidationを更新するための暫定的なstate更新用オブジェクトを定義します。


# const validationMessages: { [index: string]: string } = {};


#^ 初めに書いておきますが、state更新用オブジェクトを定義せずともvalidationを更新する方法はいくつもあると思いますが、個人的にスッキリ書けるこの方法で実装します。


# オブジェクト型のstateを一気に更新する方法は別の記事でもまとめていますが、

#・メールアドレス
#・パスワード
#・ログイン失敗

# のうち、どこがエラーになるかを予想することができないため、今回は別の方法をとっています。

# 再びここの説明に戻りますが、validationMessagesの型指定で使っている{ [index: string]: string }インデックスシグネチャと呼ばれる仕組みによって、インデックスや要素のデータ型を指定しています。

# const validationMessages: { [index: string]: string } = {};

# 第9回 連想配列の取り扱い方
# https://atmarkit.itmedia.co.jp/ait/articles/1501/29/news117_4.html

# validationMessagesは

#・string型のkey
#・string型のvalue

# で構成されるオブジェクトであることを指定できます。

# validationMessagesを型定義しない場合はTypeScriptのコンパイルエラーになります。

# { [index: string]: string }の部分をinterfaceもしくはtypeで定義して使っても良かったですが、今回は直書きして進めます。

# 次にこの部分の解説です。


# Object.keys(errors).map((key: string) => {
  # validationMessages[key] = errors[key][0];
# });

# まず、errorsは以下のオブジェクトです。（両方の入力フォームが空の場合）

# {
#   "email": [
#     "必須入力です。"
#   ],
#   "password": [
#     "必須入力です。"
#   ]
# }


# Object.keys(errors)で上記オブジェクトのkeyで構成された配列を作成し、それをmapでループさせ、state更新用オブジェクトであるvalidationMessagesをローカルstateのvalidationのように

# { バリデーションエラーになった項目: メッセージ }

# の形に更新しています。

# 最後にローカルstateをスプレッド構文を使用して更新します。

# setValidation({ ...validation, ...validationMessages });


# ここまで実装が終わったら適当な箇所に以下のコードを入れて、入力フォームを空にしてログインしてみましょう。

# console.log(validation);

# 以下の画面のようにvalidationの中にエラーメッセージが入っているのがわかります。

# console
# {
#     "email": "必須入力です。",
#     "password": "必須入力です。",
#     "loginFailed": ""
# }


# ........................

# ⑵ バリデーションメッセージの表示

# 表示するメッセージの管理ができるようになったので画面に表示します。

# pages/index.tsxを以下の通り修正してください。

# // 略

# const Home: NextPage = () => {
#   // 略

#   return (
#     <div className='w-2/3 mx-auto py-24'>
#       <div className='w-1/2 mx-auto border-2 px-12 py-16 rounded-2xl'>
#         <h3 className='mb-10 text-2xl text-center'>ログイン</h3>
#         <div className='mb-5'>
#           <div className='flex justify-start my-2'>
#             <p>メールアドレス</p>
#             <RequiredMark />
#           </div>
#           <input
#             className='p-2 border rounded-md w-full outline-none'
#             name='email'
#             value={loginForm.email}
#             onChange={updateLoginForm}
#           />
#           {/* コメントアウトを外してここから修正 */}
#           {validation.email && (
#             <p className='py-3 text-red-500'>{validation.email}</p>
#           )}
#           {/* ここまで修正 */}
#         </div>
#         <div className='mb-5'>
#           <div className='flex justify-start my-2'>
#             <p>パスワード</p>
#             <RequiredMark />
#           </div>
#           <small className='mb-2 text-gray-500 block'>
#             8文字以上の半角英数字で入力してください
#           </small>
#           <input
#             className='p-2 border rounded-md w-full outline-none'
#             name='password'
#             type='password'
#             value={loginForm.password}
#             onChange={updateLoginForm}
#           />
#           {/* コメントアウトを外してここから修正 */}
#           {validation.password && (
#             <p className='py-3 text-red-500'>{validation.password}</p>
#           )}
#           {/* ここまで修正 */}
#         </div>
#         <div className='text-center mt-12'>
#           {/* コメントアウトを外してここから修正 */}
#           {validation.loginFailed && (
#             <p className='py-3 text-red-500'>{validation.loginFailed}</p>
#           )}
#           {/* ここまで修正 */}
#           <button
#             className='bg-gray-700 text-gray-50 py-3 sm:px-20 px-10 rounded-xl cursor-pointer drop-shadow-md hover:bg-gray-600'
#             onClick={login}
#           >
#             ログイン
#           </button>
#         </div>
#       </div>
#     </div>
#   );
# };

# export default Home;


# メールアドレスのバリデーションメッセージを例にすると、validation.messageが空文字でなければメッセージを表示するという実装です。


# {validation.email && (
#   <p className='py-3 text-red-500'>{validation.email}</p>
# )}

# これを条件付きレンダリングと言います。

# 条件付きレンダー
# https://ja.reactjs.org/docs/conditional-rendering.html


# 実際に入力フォームを空にしてログインしようとするとメッセージが表示されます。

# またメールアドレス、パスワードをログインできない内容にしてログインしようとするとログイン失敗のメッセージが表示されます。


# ここで1つ問題があって、ログインできない情報でログインしようとする→入力フォームを空にしてログインしようとすると「IDまたはパスワードが間違っています」というメッセージが残ってしまいます。

# これを防ぐためにpages/index.tsxを以下の通り修正します。


# // 略

# // ここから修正
# // バリデーションメッセージの型
# type Validation = {
#   email?: string;
#   password?: string;
#   loginFailed?: string;
# };
# // ここまで修正

# const Home: NextPage = () => {
#   // 略

#   // ここから修正
#   const [validation, setValidation] = useState<Validation>({});
#   // ここまで修正

#   //　略

#   // ログイン
#   const login = () => {
#     // ここから追加
#     // バリデーションメッセージの初期化
#     setValidation({});
#     // ここまで追加

#     axiosApi
#       // CSRF保護の初期化
#       .get('/sanctum/csrf-cookie')
#       .then((res) => {
#         // ログイン処理
#         axiosApi
#           .post('/login', loginForm)
#           .then((response: AxiosResponse) => {
#             console.log(response.data);
#             router.push('/memos');
#           })
#           .catch((err: AxiosError) => {
#             console.log(err.response);
#             // バリデーションエラー
#             if (err.response?.status === 422) {
#               const errors = err.response?.data.errors;
#               // ここから修正
#               // state更新用のオブジェクトを別で定義
#               const validationMessages: { [index: string]: string } =
#                 {} as Validation;
#               // ここまで修正
#               Object.keys(errors).map((key: string) => {
#                 validationMessages[key] = errors[key][0];
#               });
#               // ここから修正
#               // state更新用オブジェクトに更新
#               setValidation(validationMessages);
#               // ここまで修正
#             }
#             if (err.response?.status === 500) {
#               // 処理
#             }
#           });
#       });
#   };

#   return (
#     // 略
#   )
# };

# export default Home;


# 修正点は以下の通りです。

#・バリデーションメッセージの型定義（Validation）の各プロパティのundefined許容。（Laravelから返って来るプロパティは3つ全てが揃うことは無いから）

#・validationのプロパティをundefinedに許容したので初期値を空オブジェクトに変更

#・バリデーションメッセージの初期化（これはUI的な改善）

#・validationMessagesを型アサーションasでValidationの型のオブジェクトとして扱えるようにした（state更新の内容をvalidationMessagesそのものとするため）

#・state更新でスプレッド構文を無くした


#【TypeScript】型アサーション（as）について
# https://yutaro-blog.net/2021/10/16/typescript-type-assertion-as/


# 修正前のスプレッド構文を使ったやり方だと、一度stateのloginFailedにメッセージが入っている状態で、emailにメッセージがvalidationMessagesに入って更新する場合、loginFailedのメッセージが残り続けてしまいエラー表示がおかしくなるのでvalidationMessagesそのものでstateを更新するようにしました。

# これでバリデーションメッセージの表示は完了です。


# ........................

# ⑶ システムエラー(500)のハンドリング

# このハンズオンではシステムエラー時はアラートを出すだけにします。

#! 本来はエラーページを準備してそのページに自動的に遷移するのが良さそうです。

# pages/index.tsxを以下のとおり修正します。


# // 略

# const Home: NextPage = () => {
#   // 略

#   // ログイン
#   const login = () => {
#     // バリデーションメッセージの初期化
#     setValidation({ email: '', password: '', loginFailed: '' });
#     axiosApi
#       // CSRF保護の初期化
#       .get('/sanctum/csrf-cookie')
#       .then((res) => {
#         // ログイン処理
#         axiosApi
#           .post('/login', loginForm)
#           .then((response: AxiosResponse) => {
#             // 略
#           })
#           .catch((err: AxiosError) => {
#             // 略
#             if (err.response?.status === 500) {
#               // ここから修正
#               alert('システムエラーです！！');
#               // ここまで修正
#             }
#           });
#       });
#   };

#   return (
#     // 略
#   );
# };

# export default Home;


# こちらも動作確認しておきます。

# routes/web.phpを以下のとおりわざとシステムエラーになるよう修正して、ログインボタンを押すとアラートが表示されます。

# Route::post('/login', [LoginController::class, 'loginlogin']);


# これでAP側のエラー（システムエラー）の時の処理も完了です。

#^ 動作検証のために修正したapi/routes/web.phpは戻しておいてください。


# ------------------------

#~ メモ登録画面

# ログイン画面と同じ実装内容なので説明は割愛します。

# pages/memos/post.tsxを以下のように実装してください。


# // 略

# // ここから追加
# // バリデーションメッセージの型
# type Validation = {
#   title?: string;
#   body?: string;
# };
# // ここまで追加

# const Post: NextPage = () => {
#   // 略

#   // ここから修正
#   // 型をValidationに変更して初期値を空オブジェクトに変更
#   const [validation, setValidation] = useState<Validation>({});
#   // ここまで修正

#   // 略

#   // メモの登録
#   const createMemo = () => {
#     // ここから追加
#     // バリデーションメッセージの初期化
#     setValidation({});
#     // ここまで追加

#     axiosApi
#       // CSRF保護の初期化
#       .get('/sanctum/csrf-cookie')
#       .then((res) => {
#         // APIへのリクエスト
#         axiosApi
#           .post('/api/memos', memoForm)
#           .then((response: AxiosResponse) => {
#             console.log(response.data);
#             router.push('/memos');
#           })
#           .catch((err: AxiosError) => {
#             // ここから修正
#             // バリデーションエラー
#             if (err.response?.status === 422) {
#               const errors = err.response?.data.errors;
#               // state更新用のオブジェクトを別で定義
#               const validationMessages: { [index: string]: string } =
#                 {} as Validation;
#               Object.keys(errors).map((key: string) => {
#                 validationMessages[key] = errors[key][0];
#               });
#               // state更新用オブジェクトに更新
#               setValidation(validationMessages);
#             }
#             if (err.response?.status === 500) {
#               alert('システムエラーです！！');
#             }
#             // ここまで修正
#           });
#       });
#   };

#   return (
#     <div className='w-2/3 mx-auto'>
#       <div className='w-1/2 mx-auto mt-32 border-2 px-12 py-16 rounded-2xl'>
#         <h3 className='mb-10 text-2xl text-center'>メモの登録</h3>
#         <div className='mb-5'>
#           <div className='flex justify-start my-2'>
#             <p>タイトル</p>
#             <RequiredMark />
#           </div>
#           <input
#             className='p-2 border rounded-md w-full outline-none'
#             name='title'
#             value={memoForm.title}
#             onChange={updateMemoForm}
#           />
#           {/* ここから追加 */}
#           {validation.title && (
#             <p className='py-3 text-red-500'>{validation.title}</p>
#           )}
#           {/* ここまで追加 */}
#         </div>
#         <div className='mb-5'>
#           <div className='flex justify-start my-2'>
#             <p>メモの内容</p>
#             <RequiredMark />
#           </div>
#           <textarea
#             className='p-2 border rounded-md w-full outline-none'
#             name='body'
#             cols={30}
#             rows={4}
#             value={memoForm.body}
#             onChange={updateMemoForm}
#           />
#           {/* ここから追加 */}
#           {validation.body && (
#             <p className='py-3 text-red-500'>{validation.body}</p>
#           )}
#           {/* ここまで追加 */}
#         </div>
#         <div className='text-center'>
#           <button
#             className='bg-gray-700 text-gray-50 py-3 sm:px-20 px-10 mt-8 rounded-xl cursor-pointer drop-shadow-md hover:bg-gray-600'
#             onClick={createMemo}
#           >
#             登録する
#           </button>
#         </div>
#       </div>
#     </div>
#   );
# };

# export default Post;


# ここまで実装して入力フォームを空にして登録しようとして画面にバリデーションメッセージが表示されたらOKです。


# システムエラー時のアラート表示は各自で確認してみてください。

# これでメモ登録画面のバリデーションメッセージの表示およびエラーハンドリングの実装は完了です。


# **** TypeScript+Next.js+Laravelで簡易的なメモアプリ開発ハンズオン-6（Recoilを使った認証情報の保持) ****

# https://yutaro-blog.net/2022/02/12/typescript-nextjs-laravel-hands-on-6/

# https://github.com/shimotaroo/nextjs-laravel-hands-on/tree/feature/feat/auth


# 今回はフロントエンド側での認証情報（ログインしているかどうか）の保持ができるようにしていき、画面によよって認証のある／ないでアクセス制御できるようにしていきます。


#~ 現在の挙動確認

# 現在までの実装内容で認証情報周りの挙動を確認します。

# 現在は/でログイン画面にアクセスでき、そこからログインをすることができます。

# 本来、/memos（メモ一覧画面）、/memos/post（メモ登録画面）はログイン後にしかアクセスできないべきですが、現在はログインしていない状態で直接アクセスできてしまいます。

# 実際にURL欄に入力してアクセスしてみてください。

# またログイン済みの場合はデベロッパーツールのApplicationタブからCookieを削除して、再度上記2つの画面にアクセスしてみてください。


#・メモ一覧画面（/memos）、メモ登録画面（/memos/post）には未ログイン状態でアクセスするとログイン画面（/）に遷移する

#・ログイン画面でログインした状態をフロントエンドで保持する

# この2つを実装しています。


# --------------------

#~ フロントエンドでの認証情報の保持

#! (Toolkit, Zustand, Jotaiがおすすめ)

# 認証情報をコンポーネントを跨って保持するためには定義したコンポーネント内でしか値を保持できないローカルstateではなく、コンポーネントを跨って保持することができるグローバルstateが必要です。

# ReactでグローバルStateを使った状態管理方法はContext APIやReduxなどがありますが、今回は個人的にコードも見やすく導入も楽なRecoilというライブラリを使います。

# Recoil
# https://recoiljs.org/

# コンテクスト
# https://ja.reactjs.org/docs/context.html

# Redux
# https://redux.js.org/


# ⑴ Recoilのインストール

# 以下のコマンドでNext.jsにRecoilをインストールします。

# yarn add recoil

# package.jsonとyarn.lockに変更が加わったらOKです。


# ........................

# ⑵ Recoilでグローバルstateを定義する

# Recoilで管理するグローバルstateの定義はatomsディレクトリで行いますのでルートディレクトリにatomsディレクトリを作成し、userAtom.tsを作成します。


# import { atom, useRecoilState } from 'recoil';

# type UserState = { id: number } | null;

# const userState = atom<UserState>({
#   key: 'user',
#   default: null,
# });

# export const useUserState = () => {
#   const [user, setUser] = useRecoilState<UserState>(userState);

#   return { user, setUser };
# };


# 上記のファイルの実装内容は以下の通りです。

# グローバルstateの名前:
# user

# グローバルstateの更新関数:
# setUser

# key（グローバルstateを判別する一意の値:
# user（userStateでも何でも良い）

# 初期値:
# null

# 型:
# { id: number } | null


# ログイン機能の実装でログインが成功した場合はユーザーのidを返す仕様にしたため、型は{ id: number } | nullとしました。



#^ このハンズオンではログインユーザーの情報を使って何かするわけではなく、「nullかどうか」の判定でも十分ななため、userの型をnumber | nullとしても問題ありません。


# 公式ドキュメントの基本的なグローバルstateの定義方法と少し異なりますが、コンポーネントによって

# https://recoiljs.org/docs/introduction/getting-started/#atom

#・stateだけを使いたい場合
#・stateの更新だけをしたい場合

# があるので、それぞれを個別に呼び出せるようにカスタムフックっぽいexportのやり方を採用しています。


# ........................

# ⑵ Recoilのstateをコンポーネント全体で使えるようにする

# Recoilではグローバルstateを定義するだけで色々なコンポーネントから呼び出したり更新したりできるわけではないです。（Reduxの使用経験はありませんが、Context APIを使う場合も同様です）

# pages/_app.tsxを以下のように修正します。


# import 'tailwindcss/tailwind.css';
# import type { AppProps } from 'next/app';
# // ここから追記
# import { RecoilRoot } from 'recoil';
# // ここまで追記

# function MyApp({ Component, pageProps }: AppProps) {
#   return (
#     // ここから追記
#     <RecoilRoot>
#     // ここまで追記
#       <Component {...pageProps} />;
#     // ここから追記
#     </RecoilRoot>
#     // ここまで追記
#   );
# }

# export default MyApp;


# <RecoilRoot></RecoilRoot>で適用したいコンポーネントの範囲を囲みます。

# 今回は全コンポーネントでグローバルstateを使いたいので、<Component {...pageProps} />;を囲んでいます。（ここにはNext.js側でルーティングに対応したpagesディレクトリ内のコンポーネントが入ります）


# RecoilRoot
# https://recoiljs.org/docs/introduction/getting-started/#recoilroot


# ........................

# ⑶ ログイン成功時にグローバルstateにユーザー情報をセットする

# グローバルstateの定義、全コンポーネントへの適用も完了したので、ログインが成功したらグローバルstateにLaravelから返却されたユーザーidをセットします。

# pages/index.tsxを修正します。


# import type { NextPage } from 'next';
# // 略
# // 追加
# import { useUserState } from '../atoms/userAtom';

# // 略

# const Home: NextPage = () => {
#   // 略
#   // 追加
#   const { setUser } = useUserState();

#   // ログイン
#   const login = () => {
#     // バリデーションメッセージの初期化
#     setValidation({});

#     axiosApi
#       // CSRF保護の初期化
#       .get('/sanctum/csrf-cookie')
#       .then((res) => {
#         // ログイン処理
#         axiosApi
#           .post('/login', loginForm)
#           .then((response: AxiosResponse) => {
#             // ここから追加
#             setUser(response.data.data);
#             // ここまで追加
#             router.push('/memos');
#           })
#           .catch((err: AxiosError) => {
#             // 略
#           });
#       });
#   };

#   return (
#     // 略
#   );
# };

# export default Home;


# ログインAPIでログイン成功時のレスポンスは

# {
#     "data": {
#         "data": {
#             "id": 1
#         }
#     },
#     "status": 200,
#     // 略
# }



# なので、setUser(response.data.data);でグローバルstateを{ id: 1 }で更新します。

# 処理としてはこれでuserの値が初期値のnullから{ id: 1 }に更新されているはずなので、それを確認してみます。

# まずはpages/memos/index.tsxを以下の通り修正します。


# import { AxiosError, AxiosResponse } from 'axios';
# import type { NextPage } from 'next';
# import { useRouter } from 'next/router';
# import { useEffect, useState } from 'react';
# // ここから追記
# import { useUserState } from '../../atoms/userAtom';
# // ここまで追記
# import { axiosApi } from '../../lib/axios';

# // 略

# const Memo: NextPage = () => {
#   // 略
#   // ここから追記
#   const { user } = useUserState();

#   console.log(user);
#   // ここまで追記

#   // 略

#   return (
#     // 略
#   );
# };

# export default Memo;



# 次にpages/index.tsxに追記した

# setUser(response.data.data);


# をコメントアウトして、ログイン画面に再度アクセスしログインします。

# （メールアドレスはtest@example.com、パスワードはpasswordを使ってください）

# ログインが成功して自動でメモ一覧画面に遷移した時にコンソールにはnullが表示されるのが分かります。


# これで

#・Recoilで定義したstateがメモ一覧画面で呼び出せていること
#・初期値がnullであること

# を確認できたので、pages/index.tsxのコメントアウトを戻して再度、ログイン画面からログインしてみます。


# グローバルstateの値が更新されているのが分かります。

# 2回出力されているのは、初回レンダリング時の出力と初回レンダリング後にuseEffect内でAPIからメモデータを取得→画面をレンダリングした際の出力です。

# これでログイン成功時にグローバルstateにユーザー情報をセットすることができました。


# --------------------

#~ メモ一覧画面とメモ登録画面のアクセス制限機能を実装する

# Recoilを使用したグローバルstateの使い方がわかったので、メモ一覧画面とメモ登録画面のアクセス制限を実装します。


# ⑴ メモ一覧画面（/memos）

# pages/memos/index.tsxのuseEffect内にuserの値の判定ロジックを追加します。

# // 略

# const Memo: NextPage = () => {
#   // 略

#   // 初回レンダリング時にAPIリクエスト
#   useEffect(() => {
#     // ここから追加
#     if (!user) {
#       router.push('/');
#       return;
#     }
#     // ここまで追加
#     axiosApi
#       .get('/api/memos')
#       .then((response: AxiosResponse) => {
#         console.log(response.data);
#         setMemos(response.data.data);
#       })
#       .catch((err: AxiosError) => console.log(err.response));
#   // ここから修正
#   }, [user, router]);
#   // ここまで修正

#   return (
#     // 略
#   );
# };

# export default Memo;


#^ 今回のuseEffect内の処理は初期レンダリング時のみに実行したいので、依存配列の中身を空にする必要があるのですが、ESLintのデフォルトの設定だとwarningが出てしまうので、暫定的に[user, router]としています。次の記事で対応いたします。この時点で対応する場合は以下の記事を参考にしてください。


# useEffect has amissing dependencyのwarningを解消する
# https://zenn.dev/mackay/articles/1e8fcce329336d


# 以下のようにすることでグローバルstateのuserがnullの場合はログイン画面（/）に遷移させることができます。

# if (!user) {
#   router.push('/');
#   return;
# }


# それでは、URL欄にhttp://localhost:3000/memosを入力してメモ一覧画面に直接アクセスしてみてください。

# ログイン画面に遷移されると正常に認証による制御ができています。

#^ Context APIもRecoilも同様ですが、画面リロードするとグローバルstateは初期化されます。（今回の場合はLaravel側ではログイン中ですが、Next.js側では未ログイン扱いになります）

# これではメモ一覧画面（http://localhost:3000/memos）に直接アクセスしたり、リロードしたりするとフロントエンドでは「未ログイン」扱いされてログイン画面に遷移してしまいます。

# この対策として、次の記事で以下のようなロジックで認証情報でアクセス制御を行うようにします。


#・グローバルstateにユーザー情報が入っていたらそのままメモデータを取得する
#・グローバルstateがnullの場合、APIからログインユーザーの情報を取得してグローバルstateを更新する
#・上記処理で更新後にユーザー情報が入っていたらメモデータを取得する
#・上記処理で更新後もnullならログイン画面に遷移する

# 一旦はログイン画面でログインしてからでないとメモ一覧画面（およびメモ登録画面）にアクセスできない仕様にしておきます。


# ........................

# ⑵ メモ登録画面（/memos/post）

# メモ一覧画面同様にメモ登録画面もアクセス制御を行なっておきます。

# pages/memos/post.tsxを以下のとおり修正します。

# import { AxiosError, AxiosResponse } from 'axios';
# import type { NextPage } from 'next';
# import { useRouter } from 'next/router';
# import { ChangeEvent, useEffect, useState } from 'react';
# // ここから追加
# import { useUserState } from '../../atoms/userAtom';
# // ここまで追加
# import { RequiredMark } from '../../components/RequiredMark';
# import { axiosApi } from '../../lib/axios';

# // 略

# const Post: NextPage = () => {
#   // 略

#   //ここから追加
#   const { user } = useUserState();

#   useEffect(() => {
#     // ログイン中か判定
#     if (!user) {
#       router.push('/');
#       return;
#     }
#   }, [user, router]);
#   // ここまで追加

#   // 略

#   return (
#     // 略
#   );
# };

# export default Post;


# 実装内容もメモ一覧画面と同じです。

# ここまでで、UXはかなり悪いですが、「Next.js上でログイン状態でないとメモ一覧画面およびメモ登録画面にアクセスできない」制御を実装することができました。


# --------------------

#~ グローバルstateの永続化について

# ここまで進めて「画面をリロードしてもグローバルstateがリセットされないような設定をすれば良いのではないか？」という疑問を持たれるかもしれません。

# 確かに僕もそれは考えたことがあり、実際にRecoilでのstate永続化について調べて永続化の方法も分かりました。（実装はめちゃくちゃ簡単です）


# Recoil最低限 Next編 （2021年9月）
# https://qiita.com/zaburo/items/225d0731faeaa6966ea9#%E5%80%A4%E3%81%AE%E6%B0%B8%E7%B6%9A%E5%8C%96persist


# 本ハンズオンにおいては、

#・執筆者の自分自身が業務でこのstate永続化を導入していないこと
#・フロントエンドとAPIの認証状態の乖離が発生する恐れがある

# ことから導入しません。

# 後者に関しては、フロントエンドではログイン判定はされるけど、Laravelではログイン状態は終了しているという状態が発生する可能性があることを指します。逆の場合、Laravelにログインユーザーを返却してくれるように要求してフロントエンドのstateを更新すれば両者の認証情報を揃えることができますが、フロントエンドだけログイン判定をされている状態だと、ログイン中でしか受け付けないAPIがあると認証エラーになってしまいます。

#! (フロントエンドとバックエンドとの整合性を解決しないといけない)


# **** TypeScript+Next.js+Laravelで簡易的なメモアプリ開発ハンズオン-7（認証周りのリファクタリング1） ****

# https://yutaro-blog.net/2022/02/16/typescript-nextjs-laravel-hands-on-7/

# https://github.com/shimotaroo/nextjs-laravel-hands-on/tree/feature/refactor/auth/1


# 第7回の今回は、第6回の最後に記載したようにフロントエンド側での認証によるアクセス制御のリファクタリング・ブラッシュアップを行います。

# カスタムフックを作成したり、axiosの使い方を変更したりしていきます。

#^ ここのリファクタリング、ブラッシュアップはボリュームがそこそこあるので、7回目ではメモ登録画面、8回目でメモ登一覧画面を実装してきます。


#~ 現在の仕様の把握

# まずは現在のメモ登録画面のコードを確認します。（pages/memos/post.tsx）

# import { AxiosError, AxiosResponse } from 'axios';
# import type { NextPage } from 'next';
# import { useRouter } from 'next/router';
# import { ChangeEvent, useEffect, useState } from 'react';
# import { useUserState } from '../../atoms/userAtom';
# import { RequiredMark } from '../../components/RequiredMark';
# import { axiosApi } from '../../lib/axios';

# // POSTデータの型
# type MemoForm = {
#   title: string;
#   body: string;
# };

# // バリデーションメッセージの型
# type Validation = {
#   title?: string;
#   body?: string;
# };

# const Post: NextPage = () => {
#   // ルーター定義
#   const router = useRouter();
#   // state定義
#   const [memoForm, setMemoForm] = useState<MemoForm>({
#     title: '',
#     body: '',
#   });
#   const [validation, setValidation] = useState<Validation>({});
#   const { user } = useUserState();

#   useEffect(() => {
#     // ログイン中か判定
#     if (!user) {
#       router.push('/');
#       return;
#     }
#   }, [user, router]);

#   // POSTデータの更新
#   const updateMemoForm = (
#     e: ChangeEvent<HTMLInputElement | HTMLTextAreaElement>
#   ) => {
#     setMemoForm({ ...memoForm, [e.target.name]: e.target.value });
#   };

#   // メモの登録
#   const createMemo = () => {
#     // バリデーションメッセージの初期化
#     setValidation({});

#     axiosApi
#       // CSRF保護の初期化
#       .get('/sanctum/csrf-cookie')
#       .then((res) => {
#         // APIへのリクエスト
#         axiosApi
#           .post('/api/memos', memoForm)
#           .then((response: AxiosResponse) => {
#             console.log(response.data);
#             router.push('/memos');
#           })
#           .catch((err: AxiosError) => {
#             // バリデーションエラー
#             if (err.response?.status === 422) {
#               const errors = err.response?.data.errors;
#               // state更新用のオブジェクトを別で定義
#               const validationMessages: { [index: string]: string } =
#                 {} as Validation;
#               Object.keys(errors).map((key: string) => {
#                 validationMessages[key] = errors[key][0];
#               });
#               // state更新用オブジェクトに更新
#               setValidation(validationMessages);
#             }
#             if (err.response?.status === 500) {
#               alert('システムエラーです！！');
#             }
#           });
#       });
#   };

#   return (
#     <div className='w-2/3 mx-auto'>
#       <div className='w-1/2 mx-auto mt-32 border-2 px-12 py-16 rounded-2xl'>
#         <h3 className='mb-10 text-2xl text-center'>メモの登録</h3>
#         <div className='mb-5'>
#           <div className='flex justify-start my-2'>
#             <p>タイトル</p>
#             <RequiredMark />
#           </div>
#           <input
#             className='p-2 border rounded-md w-full outline-none'
#             name='title'
#             value={memoForm.title}
#             onChange={updateMemoForm}
#           />
#           {validation.title && (
#             <p className='py-3 text-red-500'>{validation.title}</p>
#           )}
#         </div>
#         <div className='mb-5'>
#           <div className='flex justify-start my-2'>
#             <p>メモの内容</p>
#             <RequiredMark />
#           </div>
#           <textarea
#             className='p-2 border rounded-md w-full outline-none'
#             name='body'
#             cols={30}
#             rows={4}
#             value={memoForm.body}
#             onChange={updateMemoForm}
#           />
#           {validation.body && (
#             <p className='py-3 text-red-500'>{validation.body}</p>
#           )}
#         </div>
#         <div className='text-center'>
#           <button
#             className='bg-gray-700 text-gray-50 py-3 sm:px-20 px-10 mt-8 rounded-xl cursor-pointer drop-shadow-md hover:bg-gray-600'
#             onClick={createMemo}
#           >
#             登録する
#           </button>
#         </div>
#       </div>
#     </div>
#   );
# };

# export default Post;


# この中の以下の部分でフロントエンドで未ログインと判定されるとログイン画面に遷移するように書いています。


  # useEffect(() => {
  #   // ログイン中か判定
  #   if (!user) {
  #     router.push('/');
  #     return;
  #   }
  # }, [user, router]);


#^ useEffectの依存配列に変数を入れていますが、初期レンダリング時にのみ実行する処理なのでから配列（[]）にしたいので、それも今回で対応いたします。


# フロント側で未ログインと判定される場合は

#・単純にログインしていない
#・ログイン画面からログインしたけどその後画面をリロードした

# です。


# 後者の場合、APIではログイン中なのにグローバルstateが初期化されてしまうためフロントエンドでは未ログイン扱いになってしまいます。

# これだと使い勝手がかなり悪いのでAPI側でログイン中と判定される場合にはフロントエンドでも画面をリロードしてもメモ登録画面、メモ一覧画面にアクセスできるようにします。


# --------------------

#~ ログインユーザー取得APIの実装

# ログイン画面でログイン後にメモ登録画面とメモ一覧画面でリロードしてもログイン画面に遷移してしまわないようにするためには、


#・フロントエンド側でグローバルstateが空（今回だとnull）の場合は一旦APIにログインユーザーを取得するようリクエストを投げる

#・APIからログインユーザー情報が返却されたらグローバルstateを更新する

#・APIから返却された情報が無ければフロントエンドでも未ログインとみなす


# こんな処理が必要かと思います。

# このハンズオンで実装する上記ロジックは1つの方法なのでこれが絶対解でも最適解でもないかもしれませんが、シンプルでわかりやすいと思います。

# ではログインユーザーを返却するAPIを実装します。

# routes/api.phpに以下のルーティングを追加します。


# // ログインユーザー取得
# Route::get('/user', function() {
#     $user = Auth::user();
#     return $user ? new UserResource($user) : null;
# });


# この処理はControllerに書くまでもないくらい簡単な処理なのでルーティングファイルに書きました。（実際は開発方針に従ってControllerに書く方がよい場合が多いです）

# このAPIは

#・ログイン中：response.data.dataにユーザー情報が入っている
#・未ログイン：response.dataがnull

# という感じのレスポンスを返却します。

# これでAPI側の実装が終わりました。


# --------------------

#~ カスタムフックの作成

# 少し本題から逸れてしまいますが、コンポーネントからロジックを分離するためカスタムフックを作成します。

# カスタムフックにロジックを集中させることでコンポーネントがスッキリし、またテストも書きやすくなります。

# プロジェクトルートにhooksディレクトリを作成し、useAuth.tsというファイルを作成します。

# 作成したら、「ログイン中かどうかをチェックするカスタムフック」であるuseAuthを定義し、checkLoggedInメソッドを実装します。

#^ カスタムフックのファイル名、変数名はReact Hooks同様、use〜とするのが一般的です。

# hooks/useAuth.ts
# import { useUserState } from '../atoms/userAtom';
# import { axiosApi } from '../lib/axios';

# export const useAuth = () => {
#   const { user, setUser } = useUserState();

#   // ①
#   const checkLoggedIn = async (): Promise<boolean> => {
#     // ②
#     if (user) {
#       return true;
#     }

#     try {
#       // ③
#       const res = await axiosApi.get('/api/user');
#       // ④
#       if (!res.data.data) {
#         return false;
#       }
#       // ⑤
#       setUser(res.data.data);
#       return true;
#     } catch {
#       // ⑥
#       return false;
#     }
#   };

#   return { checkLoggedIn };
# };


# checkLoggedInの処理内容は以下の通りです。

# ❶返り値の型はboolean
# ❷グローバルstateにユーザー情報が含まれている（フロントエンドでもバックエンドでのログイン中の判定）場合はtrueを返す
# ❸グローバルstateがnull（フロントエンドでは未ログイン判定）の場合はLaravel APIにリクエストしてログインユーザーを取得する
# ❹APIレスポンスでresponse.data.dataにユーザー情報がfalsyな値ならAPI側でも未ログイン判定なのでfalseを返す（APIで未ログイン判定される場合、response.dataがnullとして返却されるのでresponse.data.dataはundefinedになる）
# ❺API側でログイン判定の場合はユーザー情報が返却された場合はグローバルstateを更新してtrueを返す
# ❻システムエラー等の場合はfalseを返す


# これまでaxiosを使う場合はthen-catchを使ってきましたが、try-catchに変更しています。

# この理由はメモ一覧画面の実装を例にした方がわかりやすいと思うので、8回目で説明しようと思います。

# これで以下のようにしてどこでもログイン中かどうかをチェックする処理を呼び出せるようになりました。


# // 呼び出し
# const { checkLoggedIn } = useAuth()

# // 実行
# checkLoggedIn()


# カスタムフックの作成はこれで完了です。

# React開発において、コンポーネントに定義したロジックをカスタムフックに切り出すことはよくするのでやり方を抑えておくと良いかと思います。


# --------------------

#~ カスタムフックを使ってuseEffect内の処理をリファクタリングする

# それでは作成したカスタムフックを使って、useEffect内の認証チェック（未ログインならログイン画面に飛ばず）する処理をリファクタリングしましょう。

# 一旦現状のコードを載せます。

# useEffect(() => {
#   // ログイン中か判定
#   if (!user) {
#     router.push('/');
#     return;
#   }
# }, [user, router]);


# ⑴ 依存配列を空配列にする

# 6回目で書きましたが、ログインしているかどうかのチェックは初期レンダリング時に1度だけ実行されれば良いので、依存配列は空配列にするのが望ましいです。


# 現状のままだと空配列にすると以下のwaringが出ます。

# React Hook useEffect has missing dependencies: 'router' and 'user'. Either include them or remove the dependency array.

# これを解消するために、.eslintrc.json（ESlintの設定ファイル）を以下のように修正します。

# {
#   "extends": "next/core-web-vitals",
#   // ここから追加
#   "rules": {
#     "react-hooks/exhaustive-deps": "off"
#   }
#   // ここまで追加
# }

# これで依存配列を空配列にしてもwarningが出なくなりました。

# useEffect(() => {
#   // ログイン中か判定
#   if (!user) {
#     router.push('/');
#     return;
#   }
# // ここから修正
# }, []);
# // ここまで修正


# ........................

# ⑵ カスタムフックの使用

# それではuseAuthを使って、pages/memos/post.tsxを修正します。

# import { AxiosError, AxiosResponse } from 'axios';
# import type { NextPage } from 'next';
# import { useRouter } from 'next/router';
# import { ChangeEvent, useEffect, useState } from 'react';
# // ここから削除
# import { useUserState } from '../../atoms/userAtom';
# // ここまで削除
# import { RequiredMark } from '../../components/RequiredMark';
# // ここから追加
# import { useAuth } from '../../hooks/useAuth';
# // ここまで追加
# import { axiosApi } from '../../lib/axios';

# // 略

# const Post: NextPage = () => {
#   // 略

#   // ここから削除
#   const { user } = useUserState();
#   // ここまで削除
#   // ここから追加
#   const { checkLoggedIn } = useAuth();
#   // ここまで追加

#   useEffect(() => {
#     const init = async () => {
#       // ログイン中か判定
#       const res: boolean = await checkLoggedIn();
#       if (!res) {
#         router.push('/');
#       }
#     };
#     init();
#   }, []);

#   // 略

#   return (
#     // 略
#   );
# };

# export default Post;


# useEffectの部分だけにフォーカスすると以下のコードになります。

# useEffect(() => {
#   const init = async () => {
#     // ログイン中か判定
#     const res: boolean = await checkLoggedIn();
#     if (!res) {
#       router.push('/');
#     }
#   };
#   init();
# }, []);


# まずはcheckLoggedInを実行し、フロントエンド、APIでログインしているかどうかのチェックを行います。その後の処理（if (!res) {以降）はresに値が格納されてから実行したいので、async-awaitを使ってcheckLoggedInが終わってから実行するようにしています。

# resがfalse（＝未ログイン）の場合はログイン画面に遷移させます。

# ここまで説明して「あれ？initっていう名前の関数を定義して実行しているけどなんか無駄じゃない？」と思われるかもしれません。

# useEffect内では以下のようにシンプルにasync-awaitのような非同期関数を定義するができません。


# useEffect(async () => {
#   // 中で await を使う
# }, [])

# そのため、useEffectの中で非同期関数を定義し、それを実行するような対応をしています。（詳しくはこちらを見ていただくのが良いかと思います）

# useEffectに非同期関数を設定する方法
# https://zenn.dev/syu/articles/b97fb155137d1f


# ここまで実装ができたら、未ログイン状態でlocalhost:3000/memos/postにアクセスするとログイン画面に遷移することを確認してください。

# ログイン画面からログイン済みの場合はデベロッパーツールからCookieを削除してアクセスしてください。

# ログイン画面に遷移されたらこの記事での実装は完了です。


# **** TypeScript+Next.js+Laravelで簡易的なメモアプリ開発ハンズオン-8（認証周りのリファクタリング2） ****

# https://yutaro-blog.net/2022/02/20/typescript-nextjs-laravel-hands-on-8/

# https://github.com/shimotaroo/nextjs-laravel-hands-on/tree/feature/refactor/auth/2


# 第8回はメモ一覧画面のログインチェック周りの処理のリファクタリングおよびブラッシュアップを行います。

# 基本的にはメモ登録画面での実装と同じですが、異なる箇所があるのでそこを詳しく説明していきます。


#~ 現在の仕様の確認

# 現時点のメモ一覧画面（/memos）のログインチェック周りの処理を把握するためにpages/memos/index.tsxを確認します。

  # useEffect(() => {
  #   // ログイン中か判定
  #   if (!user) {
  #     router.push('/');
  #     return;
  #   }
  #   axiosApi
  #     .get('/api/memos')
  #     .then((response: AxiosResponse) => {
  #       console.log(response.data);
  #       setMemos(response.data.data);
  #     })
  #     .catch((err: AxiosError) => console.log(err.response));
  # }, [user, router]);


# 現状、グローバルstateのuserが空の場合はログイン画面に遷移するような仕様になっています。

# そのため、仮にログイン画面からログインしている場合でも、メモ一覧画面でリロードをするとグローバルstateが初期化（＝nullになる）され、フロントエンドでは「未ログイン扱い」となるためログイン画面に遷移してしまいます。

# メモ登録画面と似ていますが、以下の仕様になるように手を加えます。


#・フロントエンド側でグローバルstateが空（今回だとnull）の場合は一旦APIにログインユーザーを取得するようリクエストを投げる

#・APIからログインユーザー情報が返却されたらグローバルstateを更新する

#・APIから返却された情報が無ければフロントエンドでも未ログインとみなす

#・ここまで処理を進めた上で、グローバルstateのuserにユーザー情報が入っていれば記事情報を取得するようAPIにリクエストとする、nullの場合はログイン画面に遷移する


# ユーザーを取得する方法は前回実装したAPIを使用します。

# // ログインユーザー取得
# Route::get('/user', function() {
#     $user = Auth::user();
#     return $user ? new UserResource($user) : null;
# });


# フロントエンドに返却する情報としては以下のとおりです。

#・ログイン中：response.data.dataにユーザー情報が入っている
#・未ログイン：response.dataがnull


# --------------------

#~ ログインチェック用カスタムフックでuseEffect内の処理をリファクタリングする


# それではこちらも前回作成したカスタムフックであるhooks/useAuth.tsを使ってuseEffect内をリファクタリングします。（確認のため再度コードを掲載します。）

# import { useUserState } from '../atoms/userAtom';
# import { axiosApi } from '../lib/axios';

# export const useAuth = () => {
#   const { user, setUser } = useUserState();

#   const checkLoggedIn = async (): Promise<boolean> => {
#     if (user) {
#       return true;
#     }

#     try {
#       const res = await axiosApi.get('/api/user');
#       if (!res.data.data) {
#         return false;
#       }
#       setUser(res.data.data);
#       return true;
#     } catch {
#       return false;
#     }
#   };

#   return { checkLoggedIn };
# };


# pages/memos/index.tsxを以下の通り修正してください。

# import { AxiosError, AxiosResponse } from 'axios';
# import type { NextPage } from 'next';
# import { useRouter } from 'next/router';
# import { useEffect, useState } from 'react';
# // ここから削除
# import { useUserState } from '../../atoms/userAtom';
# // ここまで削除
# // ここから追加
# import { useAuth } from '../../hooks/useAuth';
# // ここまで追加
# import { axiosApi } from '../../lib/axios';

# // 略

# const Memo: NextPage = () => {
#   const router = useRouter();
#   // state定義
#   const [memos, setMemos] = useState<Memo[]>([]);
#   // ここから削除
#   const { user } = useUserState();
#   // ここまで削除
#   // ここから追加
#   const { checkLoggedIn } = useAuth();
#   // ここまで追加

#   // 初回レンダリング時にAPIリクエスト
#   useEffect(() => {
#     // ここから修正
#     const init = async () => {
#       const res: boolean = await checkLoggedIn();
#       if (!res) {
#         router.push('/');
#         return;
#       }
#       axiosApi
#         .get('/api/memos')
#         .then((response: AxiosResponse) => {
#           console.log(response.data);
#           setMemos(response.data.data);
#         })
#         .catch((err: AxiosError) => console.log(err.response));
#     };
#     init();
#   }, []);
#   // ここまで修正

#   return (
#     // 略
#   );
# };

# export default Memo;


#^ ついでにuseEffectの依存配列を空配列（[]）にしています。（初期レンダリング時のみに実行するためです）

# useEffectの部分を取り出すと以下のコードです。


  # useEffect(() => {
  #   // ここから修正
  #   const init = async () => {
  #     // ①
  #     const res: boolean = await checkLoggedIn();
  #     // ②
  #     if (!res) {
  #       router.push('/');
  #       return;
  #     }
  #     // ③
  #     axiosApi
  #       .get('/api/memos')
  #       .then((response: AxiosResponse) => {
  #         console.log(response.data);
  #         setMemos(response.data.data);
  #       })
  #       .catch((err: AxiosError) => console.log(err.response));
  #   };
  #   init();
  # }, []);


# 処理は以下の流れで行われます。（コードの中の数字と下記リストの数字は対応しています）


# ❶カスタムフックでログイン中かどうかのチェックを行う。変数resにはboolean値が入り、trueの場合にはグローバルstateのuserにユーザ情報が入っている。また、awaitを設定しているのでcheckLoggedInの処理が完了される（resにtrueもしくはfalseが格納される）までは後続の処理は行われない。

# ❷未ログインの場合はログイン画面に遷移する（returnをつけているので、後続のメモ一覧画面の処理は行われない）

# ❸ログイン中であれば登録済みのメモ情報を取得し、ローカルstateのmemosを更新する


# ここまで修正したら、

#^ ログイン画面からログイン→メモ一覧画面に遷移される→画面をリロードする→ログイン画面に遷移せず、メモ一覧画面のままになる

# ことを確認してください。

# ログイン画面に遷移してしまったり、エラーになったりする場合はどこかのコードを修正し間違えている可能性がありますので見直してみてください。

# 複数のコンポーネントで使い回す処理、それこそ今回のようなログインしているかどうかの判定処理はカスタムフックとしてコンポーネント化（部品化）しておくことで使いまわせるようになります。

# これでuseEffect内のログインチェックの処理のリファクタリングは完了ですが補足説明を入れておきます。


# --------------------

#~ 補足説明

# 前回のTypeScript+Next.js+Laravelで簡易的なメモアプリ開発ハンズオン-7（認証周りのリファクタリング1）でログインチェック用のカスタムフックはこれまでAxiosを使うときに用いていたthen-catchではなくtry-catchを使って書いています。

# これに変更した理由は以下のとおり。

#・then-catchだとネストして書く必要があり可視性が悪くなると感じたため
#・then-catchだとログインチェック処理の結果を返せないため


# ........................

# ⑴ then-catchだとネストして書く必要があり可視性が悪くなると感じたため

# axiosでthen-catchを使った場合の基本形は以下の通りです。

# axios.get(path)
#   .then((res) => {
#     // 成功時の処理
#   })
#   .catch((e) => {
#     // 失敗時の処理
#   })


# 例えば、1つ目のAPIリクエストの結果が成功したら次のAPIリクエストを実行したい、という場合では以下のように1つ目のthenの中でAPIリクエストの処理を書きます。

# axios.get(path1)
#   .then((res) => {
#     axios.get(path2)
#       .then((res) => {
#          // 成功時の処理
#       })
#       .catch((e) => {
#         // 失敗時の処理
#       })
#   })
#   .catch((e) => {
#     // 失敗時の処理
#   })


# これを防ぐためにログインチェックの処理にtry-catchを使いました。

#^ が、カスタムフックに切り出しているので実際にはここはそこまで大きな理由ではありません。

# ですが、例えばカスタムフックなどの1つのかたまりの中で今回のようなケースがある場合は発生するのでご紹介でした。


# ........................

# ⑵ then-catchだとログインチェック処理の結果を返せないため

# メモ一覧画面の初期レンダリング後の処理の流れはログインチェックして、ログイン中と判定されたらメモデータを取得する、未ログインと判定されたらログイン画面に遷移する、というものです。

# 現在はtry-catchを使ってcheckLoggedIn()からboolean型の返り値を返却して判定を行っていますが、then-catchを使う場合、返り値を返却しようとしてもundefinedになってしまいます。（下はサンプルコードです）


# // then-catch定義
# const sample = async () => {
#   await axios.get('/sample')
#     .then((res) => {
#       return true;
#     })
#     .catch((e) => {
#       return false;
#     })
# };

# // 呼び出し
# const result = await sample(); // resultはundefinedになる


# 上記より、checkLoggedIn()をtry-catch構文に変更しています。

# 補足説明は以上です。


# **** TypeScript+Next.js+Laravelで簡易的なメモアプリ開発ハンズオン-9（ローディング画面の実装） ****

# https://yutaro-blog.net/2022/02/23/typescript-nextjs-laravel-hands-on-9/

# https://github.com/shimotaroo/nextjs-laravel-hands-on/tree/feature/feat/loading


# 第9回の今回は、メモ一覧画面にローディング画面を実装していきます。

# TypeScript、React、Next.js、Laravelの学習というよりUI・UXに関する話になりますが、stateの使い方や条件付きレンダリングを使った実装方法を学べる回です。


#~ 現在のメモ一覧画面の挙動


# 現在のメモ一覧画面の初期表示時の挙動を確認しておきます。

# ログインがした状態でメモ一覧画面（/memos）で画面をリロード、もしくはURL欄に直接http://localhost:3000/memosを入力してアクセスすると以下の動画のようにまずは「メモを追加する」ボタンだけが表示され、時間差でメモのデータが画面に表示されます。


# 人によっては「これくらいのラグは気にならない」と思うかもしれませんが、このメモの数がもっと多くなれば上の動画以上に「メモを追加する」ボタンだけが表示されている時間が長くなり、ユーザーのストレスにつながります。

# この対策として画面へのアクセスからメモデータの取得までの間はローディング画面を表示するようにします。


# --------------------

#~ ローディング画面用コンポーネントの作成

# まずはローディング画面用のコンポーネントを作成します。

# components/Loading.tsxを作成し、以下のように実装します。（ここは単なるマークアップなのでコピペで問題なしです）


# export const Loading = () => {
#   return (
#     <div className='flex items-center justify-center w-full h-full'>
#       <div className='flex justify-center items-center space-x-1 text-xl pt-96 text-gray-700'>
#         <svg
#           fill='none'
#           className='w-6 h-6 animate-spin'
#           viewBox='0 0 32 32'
#           xmlns='http://www.w3.org/2000/svg'
#         >
#           <path
#             clipRule='evenodd'
#             d='M15.165 8.53a.5.5 0 01-.404.58A7 7 0 1023 16a.5.5 0 011 0 8 8 0 11-9.416-7.874.5.5 0 01.58.404z'
#             fill='currentColor'
#             fillRule='evenodd'
#           />
#         </svg>
#         <div>Loading ...</div>
#       </div>
#     </div>
#   );
# };


# ちなみにコンポーネントにReact.memoを使うことで不要な再レンダリングを防ぐことができますが、

#・このコンポーネントは画面表示の変更に影響を受けない
#・そもそもこのメモアプリは規模がかなり小さいのでレンダリングコストが問題になることはない

# ので使用していません。

# 参考程度ですが公式ドキュメントを貼っておきます。


# React.memo
# https://ja.reactjs.org/docs/react-api.html#reactmemo


# --------------------

#~ メモデータを取得するまではローディング画面を表示する

# それでは作成したコンポーネントを使って、

#^ 画面へのアクセスからメモデータの取得までの間はローディング画面を表示する

# を実装します。

# pages/memos/index.tsxを以下のとおり実装します。


# // 略

# const Memo: NextPage = () => {
#   const router = useRouter();
#   const [memos, setMemos] = useState<Memo[]>([]);
#   // ここから追加
#   const [isLoading, setIsLoading] = useState(true);
#   // ここまで追加
#   const { checkLoggedIn } = useAuth();

#   // 初回レンダリング時にAPIリクエスト
#   useEffect(() => {
#     const init = async () => {
#       // ログイン中か判定
#       const res: boolean = await checkLoggedIn();
#       if (!res) {
#         router.push('/');
#         return;
#       }
#       axiosApi
#         .get('/api/memos')
#         .then((response: AxiosResponse) => {
#           console.log(response.data);
#           setMemos(response.data.data);
#         })
#         .catch((err: AxiosError) => console.log(err.response))
#         // ここから追加
#         .finally(() => setIsLoading(false));
#         // ここまで追加
#     };
#     init();
#   }, []);

#   // ここから追加
#   if (isLoading) return <Loading />;
#   // ここまで追加

#   return (
#     // 略
#   );
# };

# export default Memo;


# コードの説明をします。

# まずはローディング画面の表示／非表示を切り替えるためにローディング中かどうかを表すisLoadingというstateを定義します。

# const [isLoading, setIsLoading] = useState(true);

# メモ一覧画面にアクセスした時点でローディング画面を表示したいので、初期値をtrueにしています。

# 次にisLoadingを変更する処理をメモデータ取得処理の最後に入れてあげます。


# axiosApi
#   .get('/api/memos')
#   .then((response: AxiosResponse) => {
#     console.log(response.data);
#     setMemos(response.data.data);
#   })
#   .catch((err: AxiosError) => console.log(err.response))
#   // ここから追加
#   .finally(() => setIsLoading(false));
#   // ここまで追加


# メモデータの取得（APIアクセス）が成功しても失敗してもローディング画面を非表示にするため、finallyの中でisLoadingを更新しています。

# そして、以下のコードでisLoadingがtrueの間だけローディング画面を表示するようにします。


# if (isLoading) return <Loading />;


# ここまで実装したら再度、ログインがした状態でメモ一覧画面（/memos）で画面をリロード、もしくはURL欄に直接http://localhost:3000/memosを入力してアクセスしてみてください。

# 以下の動画のようにメモデータが画面に表示されるまではローディング画面が表示されるようになれば正しく実装できています。



# 余談ですが、

#^ 「そもそもisLoadingというstateなんか定義せずに、memos（配列型）の要素が1つ以上あればローディング画面を非表示にすればいいんじゃないか？」

# と思われたかもしれません。（以下のコードのような感じです）

# if (memos.length) return <Loading />;


# これだとstateを新たに定義しなくて済むのでよさそうですが、ログインユーザーが1つもメモを登録していない場合、永遠にローディング画面が表示されることになるのでこの画面では採用できません。

# 逆に

#・初期値は空配列（[]）
#・APIから取得するデータが必ず1つ以上ある

# の場合は採用できます。


# --------------------

#~ 最後に

# 今回取り扱った「○○している時は△△を表示する」という処理は結構汎用的なので、ソースコードをストックしていたり自分の引き出しに持っておくと良いかと思います。


# **** TypeScript+Next.js+Laravelで簡易的なメモアプリ開発ハンズオン-10（React-Hook-Formの導入） ****

# https://yutaro-blog.net/2022/02/23/typescript-nextjs-laravel-hands-on-10/

# https://github.com/shimotaroo/nextjs-laravel-hands-on/tree/feature/add/react-hook-form


# 本ハンズオンの最後はReact-Hook-Form（ドキュメント）というライブラリを使ってフロントエンドでのバリデーションを実装していきます。

# React Hook Form
# https://react-hook-form.com/

# ユーザーの入力が必要が画面でフロントエンドのバリデーションを設けることで、APIへのリクエストの前段階で明らかに正しくない入力値の場合は弾くことができ、無駄なAPIリクエストを防ぐことができます。


#【React】フロント側のバリデーション実装に便利なReact-Hook-Formのキホン
# https://yutaro-blog.net/2021/11/06/react-hook-form-1/

#【React】React-Hook-Formでバリデーション時のフォーカスを自作する
# https://yutaro-blog.net/2022/02/22/react-hook-form-custom-focus/


#~ React-Hook-Formの導入

#! (yupも使う)

# まずはReact-Hook-Formを現在のプロジェクトにインストールします。以下のコマンドを実行してください。

# yarn add react-hook-form

# package.json、yarn.lockに変更が追加されていたらインストール完了です。


# --------------------

#~ React-Hook-Formでのフロントエンドバリデーション実装

# React-Hook-Formが使えるようになったので、ユーザーの入力が必要な画面にフロントエンドのバリデーションを実装します。

# まずはバリデーション条件が易しいメモ登録画面（/memos/post）からです。


# ⑴ メモ登録画面

# メモ登録画面の入力項目とバリデーション内容は以下のとおりです。

# 入力項目 | バリデーション内容
# タイトル（title） | 必須入力
# メモの内容（body） | 必須入力


#^ 現在はLaravelのフォームリクエストでのみバリデーションを設けています。


# pages/memos/post.tsxを以下のとおり修正します。

#^ 修正箇所が多いので見落とさないようにしてください。


# import { AxiosError, AxiosResponse } from 'axios';
# import type { NextPage } from 'next';
# import { useRouter } from 'next/router';
# // ChangeEvent を削除
# import { useEffect, useState } from 'react';
# // ここから追加
# import { useForm } from 'react-hook-form';
# // ここまで追加
# import { RequiredMark } from '../../components/RequiredMark';
# import { useAuth } from '../../hooks/useAuth';
# import { axiosApi } from '../../lib/axios';

# // 略

# const Post: NextPage = () => {
#   const router = useRouter();
#   // ここから削除
#   const [memoForm, setMemoForm] = useState<MemoForm>({
#     title: '',
#     body: '',
#   });
#   // ここまで削除
#   const [validation, setValidation] = useState<Validation>({});
#   const { checkLoggedIn } = useAuth();

#   // ここから追加
#   const {
#     register,
#     handleSubmit,
#     formState: { errors },
#   } = useForm<MemoForm>();

#   console.log(errors);
#   // ここまで追加

#   // 略

#   // ここから削除
#   const updateMemoForm = (
#     e: ChangeEvent<HTMLInputElement | HTMLTextAreaElement>
#   ) => {
#     setMemoForm({ ...memoForm, [e.target.name]: e.target.value });
#   };
#   // ここまで削除

#   // ここから修正
#   const createMemo = (data: MemoForm) => {
#   // ここまで修正
#     setValidation({});

#     axiosApi
#       // CSRF保護の初期化
#       .get('/sanctum/csrf-cookie')
#       .then((res) => {
#         // APIへのリクエスト
#         axiosApi
#           // ここから修正
#           .post('/api/memos', data)
#           // ここまで修正
#           .then((response: AxiosResponse) => {
#             // 略
#           })
#           .catch((err: AxiosError) => {
#             // 略
#           });
#       });
#   };

#   return (
#     <div className='w-2/3 mx-auto'>
#       <div className='w-1/2 mx-auto mt-32 border-2 px-12 py-16 rounded-2xl'>
#         <h3 className='mb-10 text-2xl text-center'>メモの登録</h3>
#         <div className='mb-5'>
#           <div className='flex justify-start my-2'>
#             <p>タイトル</p>
#             <RequiredMark />
#           </div>
#           {/* ここから修正 */}
#           <input
#             className='p-2 border rounded-md w-full outline-none'
#             {...register('title', { required: '必須入力です。' })}
#           />
#           {/* ここまで修正 */}
#           {validation.title && (
#             <p className='py-3 text-red-500'>{validation.title}</p>
#           )}
#         </div>
#         <div className='mb-5'>
#           <div className='flex justify-start my-2'>
#             <p>メモの内容</p>
#             <RequiredMark />
#           </div>
#           {/* ここから修正 */}
#           <textarea
#             className='p-2 border rounded-md w-full outline-none'
#             cols={30}
#             rows={4}
#             {...register('body', { required: '必須入力です。' })}
#           />
#           {/* ここまで修正 */}
#           {validation.body && (
#             <p className='py-3 text-red-500'>{validation.body}</p>
#           )}
#         </div>
#         <div className='text-center'>
#           <button
#             className='bg-gray-700 text-gray-50 py-3 sm:px-20 px-10 mt-8 rounded-xl cursor-pointer drop-shadow-md hover:bg-gray-600'
#             onClick={handleSubmit(createMemo)}
#           >
#             登録する
#           </button>
#         </div>
#       </div>
#     </div>
#   );
# };

# export default Post;



# 修正後の全体のコードはこちらです。

# import { AxiosError, AxiosResponse } from 'axios';
# import type { NextPage } from 'next';
# import { useRouter } from 'next/router';
# import { useEffect, useState } from 'react';
# import { useForm } from 'react-hook-form';
# import { RequiredMark } from '../../components/RequiredMark';
# import { useAuth } from '../../hooks/useAuth';
# import { axiosApi } from '../../lib/axios';

# // POSTデータの型
# type MemoForm = {
#   title: string;
#   body: string;
# };

# // バリデーションメッセージの型
# type Validation = {
#   title?: string;
#   body?: string;
# };

# const Post: NextPage = () => {
#   // ルーター定義
#   const router = useRouter();
#   // state定義
#   const [validation, setValidation] = useState<Validation>({});
#   const { checkLoggedIn } = useAuth();

#   const {
#     register,
#     handleSubmit,
#     formState: { errors },
#   } = useForm<MemoForm>();

#   console.log(errors);

#   useEffect(() => {
#     const init = async () => {
#       // ログイン中か判定
#       const res: boolean = await checkLoggedIn();
#       if (!res) {
#         router.push('/');
#       }
#     };
#     init();
#   }, []);

#   // メモの登録
#   const createMemo = (data: MemoForm) => {
#     // バリデーションメッセージの初期化
#     setValidation({});

#     axiosApi
#       // CSRF保護の初期化
#       .get('/sanctum/csrf-cookie')
#       .then((res) => {
#         // APIへのリクエスト
#         axiosApi
#           .post('/api/memos', data)
#           .then((response: AxiosResponse) => {
#             console.log(response.data);
#             router.push('/memos');
#           })
#           .catch((err: AxiosError) => {
#             // バリデーションエラー
#             if (err.response?.status === 422) {
#               const errors = err.response?.data.errors;
#               // state更新用のオブジェクトを別で定義
#               const validationMessages: { [index: string]: string } =
#                 {} as Validation;
#               Object.keys(errors).map((key: string) => {
#                 validationMessages[key] = errors[key][0];
#               });
#               // state更新用オブジェクトに更新
#               setValidation(validationMessages);
#             }
#             if (err.response?.status === 500) {
#               alert('システムエラーです！！');
#             }
#           });
#       });
#   };

#   return (
#     <div className='w-2/3 mx-auto'>
#       <div className='w-1/2 mx-auto mt-32 border-2 px-12 py-16 rounded-2xl'>
#         <h3 className='mb-10 text-2xl text-center'>メモの登録</h3>
#         <div className='mb-5'>
#           <div className='flex justify-start my-2'>
#             <p>タイトル</p>
#             <RequiredMark />
#           </div>
#           <input
#             className='p-2 border rounded-md w-full outline-none'
#             {...register('title', { required: '必須入力です。' })}
#           />
#           {validation.title && (
#             <p className='py-3 text-red-500'>{validation.title}</p>
#           )}
#         </div>
#         <div className='mb-5'>
#           <div className='flex justify-start my-2'>
#             <p>メモの内容</p>
#             <RequiredMark />
#           </div>
#           <textarea
#             className='p-2 border rounded-md w-full outline-none'
#             cols={30}
#             rows={4}
#             {...register('body', { required: '必須入力です。' })}
#           />
#           {validation.body && (
#             <p className='py-3 text-red-500'>{validation.body}</p>
#           )}
#         </div>
#         <div className='text-center'>
#           <button
#             className='bg-gray-700 text-gray-50 py-3 sm:px-20 px-10 mt-8 rounded-xl cursor-pointer drop-shadow-md hover:bg-gray-600'
#             onClick={handleSubmit(createMemo)}
#           >
#             登録する
#           </button>
#         </div>
#       </div>
#     </div>
#   );
# };

# export default Post;


# 大きな修正箇所を挙げます。

#・React-Hook-Formが内部で入力値を保持してくれるので、useStateで入力値（memos）を保持する必要がなくなるので削除

#・React-Hook-Formが内部で入力値の更新を行ってくれるので、updateMemoForm()が不要となり削除

# React-Hook-Formの使い方についてコードで解説します。


# まずはReact-Hook-Formで数多く準備されているパラメータから必要なパラメータを分割代入します。


# const {
#   register,
#   handleSubmit,
#   formState: { errors },
# } = useForm<MemoForm>();

# register、handleSubmit、errorsを準備しています。

# useFormの書き方は

# useForm<入力値の型>(オプションをオブジェクトで渡す)


# とし、今回は準備済みのMemoFormという型を設定し、オプションは指定せずデフォルト設定のまま使います。

# オプションもたくさん準備されていますので気になる方はこちらをご覧ください。

# Props
# https://react-hook-form.com/api/useform/#props


# 入力エリアにはregisterを使って保持するデータの名前（key）とバリデーション内容およびバリデーションメッセージを設定します。


# <input
#   className='p-2 border rounded-md w-full outline-none'
#   {...register('title', { required: '必須入力です。' })}
# />


#^ バリデーション内容およびバリデーションメッセージの設定の仕方は他にもあるので今回の実装はあくまで一例です。詳しくは公式ドキュメントをご確認ください。


# 上記の書き方で、

#・React-Hook-Formで保持するデータの名前（key）はtitle
#・バリデーション内容は「必須入力」
#・バリデーションメッセージは「必須入力です。」

# という情報を付与することができます。

# registerプロパティの役割はライブラリのコードを辿っていけば紐解くことができますがこの記事では割愛します。（他の記事で書くかもです）

# メモの内容（body）の入力エリア（テキストエリア）も実装方法は同じなので解説は割愛します。

# 次に「登録する」ボタンのコードです。


# <button
#   className='bg-gray-700 text-gray-50 py-3 sm:px-20 px-10 mt-8 rounded-xl cursor-pointer drop-shadow-md hover:bg-gray-600'
#   onClick={handleSubmit(createMemo)}
# >


# useFormから取得したhandleSubmitを設定することでhandleSubmitの引数に渡した関するを実行する前にReact-Hook-Formで設定したバリデーションを実行することができます。

# それでは、フロントエンドでのバリデーションが効いているかを検証するためにデベロッパーツールを表示した状態でタイトル、メモの内容を空に（どちらか片方、どちらとも、でもOK）して「登録する」ボタンを押してください。

# 下の画像のようにバリデーション情報が出力されます。（画像は両方の入力エリアを空にした場合）


# 35行目のconsole.log(errors);でバリデーションエラーをコンソールに出力するようにしています。

# これでバリデーションが効いていることが確認できたので、次はバリデーションメッセージを表示できるようにします。

# 35行目のconsole.log(errors);は不要なので削除しておいてください。

# 以下のコマンドでエラーメッセージ用のコンポーネントをインストールします。


# yarn add @hookform/error-message

# ErrorMessage
# https://react-hook-form.com/api/useformstate/errormessage/


# package.json、yarn.lockに変更が追加されていたらインストール完了です。

# pages/memos/post.tsxを修正してください。


# import { AxiosError, AxiosResponse } from 'axios';
# import type { NextPage } from 'next';
# import { useRouter } from 'next/router';
# import { useEffect, useState } from 'react';
# import { useForm } from 'react-hook-form';
# // ここから追加
# import { ErrorMessage } from '@hookform/error-message';
# // ここまで追加
# import { RequiredMark } from '../../components/RequiredMark';
# import { useAuth } from '../../hooks/useAuth';
# import { axiosApi } from '../../lib/axios';

# // 略

# const Post: NextPage = () => {
#   // 略

#   return (
#     <div className='w-2/3 mx-auto'>
#       <div className='w-1/2 mx-auto mt-32 border-2 px-12 py-16 rounded-2xl'>
#         <h3 className='mb-10 text-2xl text-center'>メモの登録</h3>
#         <div className='mb-5'>
#           <div className='flex justify-start my-2'>
#             <p>タイトル</p>
#             <RequiredMark />
#           </div>
#           <input
#             className='p-2 border rounded-md w-full outline-none'
#             {...register('title', { required: '必須入力です。' })}
#           />
#           // ここから追加
#           <ErrorMessage
#             errors={errors}
#             name={'title'}
#             render={({ message }) => (
#               <p className='py-3 text-red-500'>{message}</p>
#             )}
#           />
#           // ここまで追加
#           {validation.title && (
#             <p className='py-3 text-red-500'>{validation.title}</p>
#           )}
#         </div>
#         <div className='mb-5'>
#           <div className='flex justify-start my-2'>
#             <p>メモの内容</p>
#             <RequiredMark />
#           </div>
#           <textarea
#             className='p-2 border rounded-md w-full outline-none'
#             cols={30}
#             rows={4}
#             {...register('body', { required: '必須入力です。' })}
#           />
#           // ここから追加
#           <ErrorMessage
#             errors={errors}
#             name={'body'}
#             render={({ message }) => (
#               <p className='py-3 text-red-500'>{message}</p>
#             )}
#           />
#           // ここまで追加
#           {validation.body && (
#             <p className='py-3 text-red-500'>{validation.body}</p>
#           )}
#         </div>
#         <div className='text-center'>
#           <button
#             className='bg-gray-700 text-gray-50 py-3 sm:px-20 px-10 mt-8 rounded-xl cursor-pointer drop-shadow-md hover:bg-gray-600'
#             onClick={handleSubmit(createMemo)}
#           >
#             登録する
#           </button>
#         </div>
#       </div>
#     </div>
#   );
# };

# export default Post;


# ErrorMessageの使い方は公式ドキュメントとおり以下のように書き、これでtitleのバリデーションエラーがある場合にregisterで設定したバリデーションメッセージを表示することができます。


# <ErrorMessage
#   errors={errors}
#   name={'title'}
#   render={({ message }) => (
#     <p className='py-3 text-red-500'>{message}</p>
#   )}
# />


# ではメモ登録画面でフロントエンドのバリデーションメッセージが表示されるか確認してください。

# 以下の動画のような挙動になればメモ登録画面のフロントエンドバリデーション実装は完了です。


#^ 期待する挙動にならない場合はタイポや実装漏れがあると思うので見直してみてください。


# ........................

# ⑵ ログイン画面


# ログイン画面もメモ登録画面と同様にバリデーションを実装します。

# まずは入力項目とAPI側のバリデーション内容です。


# 入力項目 | バリデーション内容

# メールアドレス（email） |
# - 必須入力
# - メールアドレスの形式かどうか

# パスワード（password） |
# - 必須入力
# - 8文字以上の半角英数字


# pages/index.tsxを修正します。

#^ 修正箇所はメモ登録画面と同じなので修正後の全体のコードです。


# import type { NextPage } from 'next';
# import { AxiosError, AxiosResponse } from 'axios';
# import { useState } from 'react';
# import { RequiredMark } from '../components/RequiredMark';
# import { axiosApi } from '../lib/axios';
# import { useRouter } from 'next/router';
# import { useUserState } from '../atoms/userAtom';
# import { useForm } from 'react-hook-form';
# import { ErrorMessage } from '@hookform/error-message';

# // POSTデータの型
# type LoginForm = {
#   email: string;
#   password: string;
# };

# // バリデーションメッセージの型
# type Validation = {
#   email?: string;
#   password?: string;
#   loginFailed?: string;
# };

# const Home: NextPage = () => {
#   // ルーター定義
#   const router = useRouter();
#   // state定義
#   const [validation, setValidation] = useState<Validation>({});
#   // recoil stateの呼び出し
#   const { setUser } = useUserState();

#   const {
#     register,
#     handleSubmit,
#     formState: { errors },
#   } = useForm<LoginForm>();

#   // ログイン
#   const login = (data: LoginForm) => {
#     // バリデーションメッセージの初期化
#     setValidation({});

#     axiosApi
#       // CSRF保護の初期化
#       .get('/sanctum/csrf-cookie')
#       .then((res) => {
#         // ログイン処理
#         axiosApi
#           .post('/login', data)
#           .then((response: AxiosResponse) => {
#             setUser(response.data.data);
#             router.push('/memos');
#           })
#           .catch((err: AxiosError) => {
#             console.log(err.response);
#             // バリデーションエラー
#             if (err.response?.status === 422) {
#               const errors = err.response?.data.errors;
#               // state更新用のオブジェクトを別で定義
#               const validationMessages: { [index: string]: string } =
#                 {} as Validation;
#               Object.keys(errors).map((key: string) => {
#                 validationMessages[key] = errors[key][0];
#               });
#               // state更新用オブジェクトに更新
#               setValidation(validationMessages);
#             }
#             if (err.response?.status === 500) {
#               alert('システムエラーです！！');
#             }
#           });
#       });
#   };

#   return (
#     <div className='w-2/3 mx-auto py-24'>
#       <div className='w-1/2 mx-auto border-2 px-12 py-16 rounded-2xl'>
#         <h3 className='mb-10 text-2xl text-center'>ログイン</h3>
#         <div className='mb-5'>
#           <div className='flex justify-start my-2'>
#             <p>メールアドレス</p>
#             <RequiredMark />
#           </div>
#           <input
#             className='p-2 border rounded-md w-full outline-none'
#             {...register('email', {
#               required: '必須入力です。',
#               pattern: {
#                 value: /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$/i,
#                 message: '有効なメールアドレスを入力してください。',
#               },
#             })}
#           />
#           <ErrorMessage
#             errors={errors}
#             name={'email'}
#             render={({ message }) => (
#               <p className='py-3 text-red-500'>{message}</p>
#             )}
#           />
#           {validation.email && (
#             <p className='py-3 text-red-500'>{validation.email}</p>
#           )}
#         </div>
#         <div className='mb-5'>
#           <div className='flex justify-start my-2'>
#             <p>パスワード</p>
#             <RequiredMark />
#           </div>
#           <small className='mb-2 text-gray-500 block'>
#             8文字以上の半角英数字で入力してください
#           </small>
#           <input
#             className='p-2 border rounded-md w-full outline-none'
#             type='password'
#             {...register('password', {
#               required: '必須入力です。',
#               pattern: {
#                 value: /^([a-zA-Z0-9]{8,})$/,
#                 message: '8文字以上の半角英数字で入力してください',
#               },
#             })}
#           />
#           <ErrorMessage
#             errors={errors}
#             name={'password'}
#             render={({ message }) => (
#               <p className='py-3 text-red-500'>{message}</p>
#             )}
#           />
#           {validation.password && (
#             <p className='py-3 text-red-500'>{validation.password}</p>
#           )}
#         </div>
#         <div className='text-center mt-12'>
#           {validation.loginFailed && (
#             <p className='py-3 text-red-500'>{validation.loginFailed}</p>
#           )}
#           <button
#             className='bg-gray-700 text-gray-50 py-3 sm:px-20 px-10 rounded-xl cursor-pointer drop-shadow-md hover:bg-gray-600'
#             onClick={handleSubmit(login)}
#           >
#             ログイン
#           </button>
#         </div>
#       </div>
#     </div>
#   );
# };

# export default Home;


# メモ登録画面と異なるところはバリデーションの内容を設定するために正規表現を使っているところです。（以下はコード抜粋）


# // メールアドレス
# {...register('email', {
#   required: '必須入力です。',
#   pattern: {
#     value: /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$/i,
#     message: '有効なメールアドレスを入力してください。',
# }

# // パスワード
# {...register('password', {
#   required: '必須入力です。',
#   pattern: {
#     value: /^([a-zA-Z0-9]{8,})$/,
#     message: '8文字以上の半角英数字で入力してください',
# }


# 正規表現によるバリデーションをかけるためにはpatternを使い、valueに正規表現を、messageにバリデーションメッセージを定義します。

# ここまで修正したら、メモ登録画面同様フロントエンドでのバリデーションが効いているか確認してください。


#・空の状態でログインしようとすると「必須入力です。」と表示される

#・メールアドレスの形式ではない値でログインしようとすると「有効なメールアドレスを入力してください。」と表示される

#・8文字以上の半角英数字以外のパスワードでログインしようとすると「8文字以上の半角英数字で入力してください」と表示される

# 上記仕様が満たせていたら実装は完了です。

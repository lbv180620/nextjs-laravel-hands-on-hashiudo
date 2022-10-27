# ==== 認証 ====


# Laravel 9.x 認証
# https://readouble.com/laravel/9.x/ja/authentication.html

# web
# Laravel Breeze, Laravel Jetstream, Laravel Fortify

# api
# Laravel Passport, Laravel Sanctum


# ------------------

# 本気で詳細を理解したい人向けのLaravelログイン認証
# https://reffect.co.jp/laravel/laravel-authentification-by-code-base


# ------------------

#? Laravel 認証済みユーザーの取得方法

# Laravel 認証済みユーザーの取得方法
# https://qiita.com/ucan-lab/items/a7441bff64ff1f173c10

#~ 認証済みユーザー取得

# Authファサード:
# use Illuminate\Support\Facades\Auth;

# // 現在認証しているユーザーを取得
# $user = Auth::user();

# // 現在認証しているユーザーのIDを取得
# $id = Auth::id();


# authヘルパー:
# // 現在認証しているユーザーを取得
# $user = auth()->user();

# // 現在認証しているユーザーのIDを取得
# $id = auth()->id();


# ............................

# Laravel8】usersテーブル以外でログイン&middleware実装
# https://zakkuri.life/laravel-auth-middleware/


# ............................

# Laravelのログイン認証の基本(Authentication)を完全理解する
# https://reffect.co.jp/laravel/laravel-authentication-understand


# ------------------

#? 認証関連のルーティングの追加

# https://www.techpit.jp/courses/11/curriculums/12/sections/108/parts/392

# ユーザー登録やログイン、ログアウトなどの認証関連のルーティングについてはゼロから自分で設計を考えて実装することもできます。

# ただ、Laravelではこうした認証関連のルーティングのひな形を用意してくれています。

# 今回はそのひな形を使うことにします。

# routes/web.phpを以下の通り編集してください。

# <?php

# Auth::routes(); //-- この行を追加
# Route::get('/', 'ArticleController@index');


# このAuth::routes()の追加によって、どのようなルーティングが定義されたのかを確認してみましょう。

# Laravelではルーティングの一覧を表示するコマンドphp artisan route:listが用意されているので、それを使います。


# +--------+----------+------------------------+------------------+------------------------------------------------------------------------+--------------+
# | Domain | Method   | URI                    | Name             | Action                                                                 | Middleware   |
# +--------+----------+------------------------+------------------+------------------------------------------------------------------------+--------------+
# |        | GET|HEAD | /                      |                  | App\Http\Controllers\ArticleController@index                           | web          |
# |        | GET|HEAD | api/user               |                  | Closure                                                                | api,auth:api |
# |        | GET|HEAD | login                  | login            | App\Http\Controllers\Auth\LoginController@showLoginForm                | web,guest    |
# |        | POST     | login                  |                  | App\Http\Controllers\Auth\LoginController@login                        | web,guest    |
# |        | POST     | logout                 | logout           | App\Http\Controllers\Auth\LoginController@logout                       | web          |
# |        | GET|HEAD | password/confirm       | password.confirm | App\Http\Controllers\Auth\ConfirmPasswordController@showConfirmForm    | web,auth     |
# |        | POST     | password/confirm       |                  | App\Http\Controllers\Auth\ConfirmPasswordController@confirm            | web,auth     |
# |        | POST     | password/email         | password.email   | App\Http\Controllers\Auth\ForgotPasswordController@sendResetLinkEmail  | web          |
# |        | GET|HEAD | password/reset         | password.request | App\Http\Controllers\Auth\ForgotPasswordController@showLinkRequestForm | web          |
# |        | POST     | password/reset         | password.update  | App\Http\Controllers\Auth\ResetPasswordController@reset                | web          |
# |        | GET|HEAD | password/reset/{token} | password.reset   | App\Http\Controllers\Auth\ResetPasswordController@showResetForm        | web          |
# |        | GET|HEAD | register               | register         | App\Http\Controllers\Auth\RegisterController@showRegistrationForm      | web,guest    |
# |        | POST     | register               |                  | App\Http\Controllers\Auth\RegisterController@register                  | web,guest    |
# +--------+----------+------------------------+------------------+------------------------------------------------------------------------+--------------+


# 3行目以降が、Auth::routes()によって追加されたルーティングです。


# ------------------

#? ログイン後のリダイレクト先の変更

# https://www.techpit.jp/courses/11/curriculums/12/sections/108/parts/393


# **** Laravel Breeze ****

# https://readouble.com/laravel/9.x/ja/starter-kits.html#laravel-breeze
# https://github.com/laravel/breeze

# InstallCommand.php
# https://github.com/laravel/breeze/blob/1.x/src/Console/InstallCommand.php


# Laravel Breeze ※Laravel 8以降
# composerでパッケージをインストール → Laravelアプリに雛形をインストール → Laravel Mixでコンパイル
#^ ※Laravel 9ではViteでコンパイル
install-breeze:
	docker compose exec $(ctr) php -d memory_limit=-1 /usr/bin/composer require --dev laravel/breeze
	docker compose exec $(ctr) php artisan breeze:install
	@make yarn-scaffold


# ------------------

#? パスワード確認のやり方

# https://readouble.com/laravel/9.x/ja/authentication.html

# ex)
# [get]
# Route::get('/settings', function () {
#     // ...
# })->middleware(['password.confirm']);

# [post]
# Route::post('/settings', function () {
#     // ...
# })->middleware(['password.confirm']);


#^ middleware(['password.confirm']) のミドルウェアをパスワード確認したいページのルーティングに追記
# → 一度パスワード確認すると、config/auth.phpのpassword_timeout で指定している秒数が経過するまで求められない。
# → デフォルトは3時間


# --------------------

#?  Laravel breezeのメールの確認について


# Laravel 9.x メール確認
# https://readouble.com/laravel/9.x/ja/verification.html

# 主流: ユーザー登録 → メールで確認 → ログイン可能
# Laravel Breezeのデフォルト: ユーザー登録 → そのままログイン


# ....................

# ⑴ モデルの準備

# Userモデルに「implements MustVerifyEmail」を追記

# use Illuminate\Contracts\Auth\MustVerifyEmail;

# class User extends Authenticatable implements MustVerifyEmail
# {
#     use Notifiable;

#     // …
# }

# → これを付けることでユーザー登録したらメールが飛んでくるようになる。

# → 承認すると、usersテーブルのemail_verified_atカラムに承認した時刻のタイムスタンプが入る。
# → email_verified_atに値がある間は、承認無しで承認が必要なページに飛べる。


# ....................


# ⑵ メール確認の通知

# メール確認したいページのルーティングに、 「middleware(['verified'])」を追記

# → ルーティングのところで、承認していない場合には表示させたくないページがあった場合に、そこを承認してもらう。

# → 「implements MustVerifyEmail」でメールを飛ばして、飛んだ先からメールでOKとクリックするといった警告。

# → 「middleware(['verified'])」を設定すると、routes/auth.phpのname('verification.notice')という名前が付いているルーティング先のページにリダイレクトされる。

# Route::get('verify-email', [EmailVerificationPromptController::class, '__invoke'])
#         ->name('verification.notice');


# --------------------

#? Laravel breezeの日本語化


# Laravel8の認証(Jetstream)を日本語化しよう
# https://zenn.dev/imah/articles/864ff0e1f25589

# Laravel-Lang/lang
# https://github.com/Laravel-Lang/lang

# config/app.php
# 'locale' => 'ja',

# 方法1: Laravel-Lang/langからzipファイルをダウンロード
# - locales/jaのディレクトリを丸ごと、lang/にコピペ

# 方法2: GitHub Editorを立ち上げて、locales/jaをlang配下にダウンロード



# ....................

#! Laravel-Lang/langの仕様変更

# ■原因

# Laravel-Langのバージョンが11系になってから仕様が変わったようです。

# 下記リリースノートの「11.0.0 - 2022-06-30」の箇所に記載がありました。

# https://github.com/Laravel-Lang/lang/releases



# ■対処方法

# 対処方法としては２つあります。

# 1. 10系の最新バージョン10.9.5を同様にzipファイルをダウンロードして利用する （こちらの方が簡単です）

# https://github.com/Laravel-Lang/lang/tree/10.9.5


# 2. 11系の導入方法を実施する。

# 1.ライブラリをインストールします。
# composer require laravel-lang/publisher laravel-lang/lang --dev

# 2.日本語ファイルを追加します。（日本語の場合なので引数は「ja」です）
# php artisan lang:add ja

# ちなみに、lang:addした場合には、追加しているパッケージ「Jetstream、Fortify、Cashier、Breeze、Nova、Spark、UIなど」のインストール状況を見て自動的に必要な言語ファイルを配置してくれます。
# 新しくパッケージを追加した場合は、下記コマンドを実施すれば情報が更新されるようです。
# php artisan lang:update


# ドキュメントに記載があるので、こちらも参考にして頂けたらと思います。

# https://laravel-lang.com/installation/

# https://publisher.laravel-lang.com/installation/


# ....................

#& デフォルトの送信メール本文を編集する方法

# 補足
# https://www.sejuku.net/plus/question/detail/3415
# https://qiita.com/usaginooheso/items/9d61361d449a521a5854
# https://chico-shikaku.com/2020/09/delete-laravel-logo-on-send-mail/

# 送信メール本文のソースのパスは以下の通り。
# vendor/laravel/framework/src/Illuminate/Notifications/resources/views/email.blade.php

#^ vendorフォルダ配下のソースは原則直接変更しない。
# 変更したい場合は、以下のコマンドを実行し、resources/vendor配下にソースをコピーし、それを編集する。

# 本文の内容を編集したい場合:
# Copying directory [vendor/laravel/framework/src/Illuminate/Notifications/resources/views] to [resources/views/vendor/notifications]
cpnotifications:
	docker compose exec $(ctr) php artisan vendor:publish --tag=laravel-notifications

# レイアウト等を編集したい場合:
# Copying directory [vendor/laravel/framework/src/Illuminate/Mail/resources/views] to [resources/views/vendor/mail]
cpmail:
	docker compose exec $(ctr) php artisan vendor:publish --tag=laravel-mail


#! インデントが崩れると表示がおかしくなる。
# 対処法1: Format on Saveをoffにしてから保存
# 対処法2: email.blade.phpの言語モードをMarkdownにして保存


# **** Laravel Sanctum ****

# Laravel 8.x Laravel Sanctum
# https://readouble.com/laravel/8.x/ja/sanctum.html

# Laravel Sanctum
# https://laravel.com/docs/8.x/sanctum


# --------------------------------

#? Laravel Sanctumの仕組み

#【Laravel8.x】Laravel Sanctumについて色々調べたのでまとめておく
# https://yutaro-blog.net/2021/08/18/laravel-sanctum/


# 以下2つの認証方式を提供する。

# ・APIトークン
# ・SPA認証


# ................................

# APIトークン:

# - ログインしたユーザーがAPIトークンを発行する
# - 発行したトークンはDBに保存する
# - GitHubのアクセストークン認証をインスパイアしている
# - トークンの発行（生成）や管理が容易にできる
# - トークンの有効期限はとても長いが、ユーザーはいつでも手動で消すことができる
# - 認証にはリクエストのヘッダーを使用するため、Cookieなどは一切利用しない


# Laravel SanctumのAPIトークンの認証の流れ:

# ①データベースにトークン保存用の単一のテーブル（personal_access_tokens）を作成する（※マイグレーションファイルはphp artisan vendor:publish --provider="Laravel\Sanctum\SanctumServiceProvider"のコマンド実行時に作成済み）

# ②ユーザーがログインに成功した時にトークンを発行（トークンはランダムの40桁の文字列をsha256のハッシュアルゴリズムでハッシュ化したもの）

# ③発行したトークンをpersonal_access_tokensテーブルに保存

# ④発行したトークンをユーザーに知らせる

# ⑤トークン認証が必要なルーティングには->middleware('auth:sanctum')を定義する

# ⑥リクエストが来た時にミドルウェアでリクエスト中のAuthorizationヘッダーに設定されたトークンとデータベースのトークンの値を照合しユーザーを識別する（トークンがそもそもない場合、一致するトークンがない場合は401エラーを返す）

# ⑦トークンの照合に成功したユーザーは->middleware('auth:sanctum')内のルーティング処理を続行する


# ................................

# SPA認証:

# - 認証にトークンは使用しない（トークン保存用のテーブルも作成する必要がない）
# - Laravelに標準搭載されているCookieベースのセッション認証を使用する
# - web認証ガードを利用することでCSRF、XSS等への対策ができる（セキュリティ対策）
# - SPA（フロント）から受信したリクエストのCookieを読み込んで認証を試す
# - Cookieをチェックし、存在しない場合はAuthorizationヘッダーのAPIトークンを調べる
# - SPA認証を行うSPAとAPIは同じトップレベルドメインであること（トップレベルドメインが同じであれば異なるサブドメインでも可）が条件


# Laravel SanctumのSPA認証の流れ:

# ①config/sanctum.phpにLaravelセッションクッキーを使用して「ステートフル」な認証を維持するドメインを定義する

# ②apiミドルウェアグループにsactumミドルウェアを追加する。→SPAからのリクエストをLaravelのセッションクッキーを使って認証できるようにする＆サードパーティまたはモバイルアプリケーションからのリクエストをAPIトークンを使用して認証できるようにする。

# ③SPAのログインページで初めに/sanctum/csrf-cookieにリクエストを送信して、アプリケーションのCSRF保護を初期化する。（この処理でLaravelは現在のCSRFトークンを含むXSRF-TOKENクッキーをセットする）

# ④ログイン成功後、Laravelがクライアントにセッションクッキーを発行し、後続の処理はこのセッションクッキーを介して自動的に認証される。（ログイン、後続の処理でのリクエスト時にはCSRF保護の初期化に発行されたXSRF-TOKENクッキーの値をX-XSRF-TOKENヘッダで送信する限り、後続のリクエストは自動的にCSRF保護が行える）

# ⑤セッションの期限切れになった状態で認証が必要なAPIエンドポイントにリクエストすると401 or 419エラーを返す。（SPAでログインページにリダイレクトさせる）


# --------------------------------

#? Laravel Sanctumの実装

#【Next.js×Laravel8】Laravel SanctumのSPA認証を実装
# https://yutaro-blog.net/2021/09/07/nextjs-laravel-sanctum-spa/

# Laravel API SanctumでSPA認証する
# https://qiita.com/ucan-lab/items/3e7045e49658763a9566

# Laravel7 + Sanctum でSPAログイン認証機能を実装
# https://qiita.com/XIGN/items/0152d66db9e1b2eb7c99


# ................................

#~ 前提:

# Next.js：http://localhost:3001
# Laravel(API)：http://localhost:8080


# ................................

#~ CORS設定:

# config/cors.php
# <?php

# return [

#     // 略

#     'paths' => ['api/*', 'sanctum/csrf-cookie'],

#     'allowed_methods' => ['*'],

#     'allowed_origins' => ['http://localhost:3001'],

#     'allowed_origins_patterns' => [],

#     'allowed_headers' => ['*'],

#     'exposed_headers' => [],

#     'max_age' => 0,

#     'supports_credentials' => false,

# ];


# ................................

#~ Laravel Sanctumを導入する:

# インストール
# composer require laravel/sanctum

# 設定ファイル自動作成
# php artisan vendor:publish --provider="Laravel\Sanctum\SanctumServiceProvider"

# 上記コマンドで作成されるファイル
# database/migrations/2019_12_14_000001_create_personal_access_tokens_table.php
# config/sanctum.php

#^ SPA認証の場合は生成されたマイグレーションファイルは使用しないので削除してOK


# ................................

#~ ファーストパーティドメインの設定

# APIにリクエストを行うときにLaravelセッションクッキーを使用して「ステートフル」な認証を維持するドメインを指定します。

# config/sanctum.php
# <?php

# return [

#     /*
#     |--------------------------------------------------------------------------
#     | Stateful Domains
#     |--------------------------------------------------------------------------
#     |
#     | Requests from the following domains / hosts will receive stateful API
#     | authentication cookies. Typically, these should include your local
#     | and production domains which access your API via a frontend SPA.
#     |
#     */

#     'stateful' => explode(',', env('SANCTUM_STATEFUL_DOMAINS', sprintf(
#         '%s%s',
#         'localhost,localhost:3000,127.0.0.1,127.0.0.1:8000,::1',
#         env('APP_URL') ? ','.parse_url(env('APP_URL'), PHP_URL_HOST) : ''
#     ))),

#     // 略
# ];


# .envに認証状態を保持したいNext.sjアプリのドメインとポート番号を指定します。
# .env
# SANCTUM_STATEFUL_DOMAINS=localhost:3001


#^ config/sanctum.phpでデフォルトで指定されているドメイン（＋ポート番号）（例えばlocalhostとかlocalhost:3000とか）の中に認証状態を維持したいアプリのドメイン＋ポート番号が含めれている場合は上記設定は不要ですが、設定しておくのが確実です。


# ................................

#~ Sanctumミドルウェアの設定

# apiミドルウェアグループにSanctumミドルウェアを追加します。

# app/Http/Kernel.php
# <?php

# namespace App\Http;

# use Illuminate\Foundation\Http\Kernel as HttpKernel;

# class Kernel extends HttpKernel
# {
#    // 略

#     /**
#      * The application's route middleware groups.
#      *
#      * @var array
#      */
#     protected $middlewareGroups = [
#         // 略

#         'api' => [
#             // この1行を追加
#             \Laravel\Sanctum\Http\Middleware\EnsureFrontendRequestsAreStateful::class,
#             'throttle:api',
#             \Illuminate\Routing\Middleware\SubstituteBindings::class,
#         ],
#     ];

#     // 略
# }


#^ これで/api/〜でルーティングされたAPIに対するリクエストでセッション・Cookieによる自動認証が可能となります。


# Sanctumミドルウェアの詳しい仕様
# https://qiita.com/ucan-lab/items/3e7045e49658763a9566#%E8%A3%9C%E8%B6%B3-sanctum%E3%83%9F%E3%83%89%E3%83%AB%E3%82%A6%E3%82%A7%E3%82%A2%E5%BF%85%E9%A0%88


# ................................

#~ CORSとCookieの設定

# ①config/cors.phpを以下の通り修正します。

# config/cors.php
# <?php

# return [

#     // 略

#     // trueに変更
#     'supports_credentials' => true,

# ];


#^ レスポンスヘッダの Access-Control-Allow-Credentials が true を返すようになります。
#^ falseのままだと、認証処理時にCORSエラーになります。


# ②次にアプリケーションのグローバルなaxiosインスタンスでwithCredentialsオプションを有効にする必要があります。

# LaravelにVue.js、Reactを組み込んだ構成の場合はresources/js/bootstrap.jsに以下を追記します。
# （今回はフロントエンドはNext.jsアプリで独立しているので、ログイン画面作成時にNext.js側で設定します）

# resources/js/bootstrap.js
# axios.defaults.withCredentials = true;


# ③アプリケーションのセッションクッキードメインを設定します。

# .env
# SESSION_DOMAIN=localhost


# 定義した環境変数はconfig/session.phpに使用されます。

# config/session.php
# <?php

# use Illuminate\Support\Str;

# return [
#     // 略

#     'domain' => env('SESSION_DOMAIN', null),

#     // 略
# ];


# ④これは任意ですが、セッションドライバーをfileからcookieに変更します。

# SESSION_DRIVER=cookie

# デフォルトのfileのままにしています。（Redis使った方がいいのかな？）


# ................................

#~ ログイン処理の実装

#^ SPA認証をするには、Next.jsアプリのログインページでログイン処理の前に必ず/sanctum/csrf-cookieエンドポイントにリクエストを送信して、アプリケーションのCSRF保護を初期化する必要があります。

# TypeScript
# axios.get('/sanctum/csrf-cookie').then(response => {
#     // ログイン処理を実装する
# });

#^ /sanctum/csrf-cookieへのルーティングはLaravel Sanctumをインストールした時点で自動的に追加されます。

#^ 上記ルーティングは/vendor/laravel/sanctum/src/SanctumServiceProvider.phpによって追加されているため、routes/web.php、routes/api.phpを探しても見つかりません。

# /vendor/laravel/sanctum/src/SanctumServiceProvider.php
# // 略
# protected function defineRoutes()
# {
#    // 略

#     Route::group(['prefix' => config('sanctum.prefix', 'sanctum')], function () {
#         Route::get(
#             '/csrf-cookie',
#             CsrfCookieController::class.'@show'
#         )->middleware('web');
#     });
# }


#^ ログイン処理は/loginルートにPOSTリクエストする必要があります。

# ドキュメント通りweb認証ガードを使用して手動実装していきます。
# ということでルーティングの追加、CORS設定の変更を行います。


# routes/web.php
# Route::post('/login', [LoginController::class, 'login']);


# config/cors.php
# return [
#     // 略

#     // 'login'を追加
#     'paths' => ['api/*', 'login', 'sanctum/csrf-cookie'],

#     // 略
# ];


# Next.js側で実装するログイン画面は記事用なので超簡易的ですがこのような感じです。

# pages/login.tsx
# // ログインページ

# import axios from 'axios'
# import { ChangeEvent, useState } from 'react'

# type LoginParams = {
#   email: string
#   password: string
# }

# export default function Login() {
#   const [email, setEmail] = useState('')
#   const [password, setPassword] = useState('')

#   const changeEmail = (e: ChangeEvent<HTMLInputElement>) => {
#     setEmail(e.target.value)
#   }
#   const changePassword = (e: ChangeEvent<HTMLInputElement>) => {
#     setPassword(e.target.value)
#   }

#   const handleClick = () => {
#     const loginParams: LoginParams = { email, password }
#     axios
#       // CSRF保護の初期化
#       .get('http://localhost:8080/sanctum/csrf-cookie', { withCredentials: true })
#       .then((response) => {
#         // ログイン処理
#         axios
#           .post(
#             'http://localhost:8080/login',
#             loginParams,
#             { withCredentials: true }
#           )
#           .then((response) => {
#             console.log(response.data)
#           })
#       })
#   }

#   // SPA認証済みではないとアクセスできないAPI
#   const handleUserClick = () => {
#     axios.get('http://localhost:8080/api/user', { withCredentials: true }).then((response) => {
#       console.log(response.data)
#     })
#   }

#   return (
#     <>
#       <div>
#         メールアドレス
#         <input onChange={changeEmail} />
#       </div>
#       <div>
#         パスワード
#         <input onChange={changePassword} />
#       </div>
#       <div>
#         <button onClick={handleClick}>ログイン</button>
#       </div>
#       <div>
#         <button onClick={handleUserClick}>ユーザー情報を取得</button>
#       </div>
#     </>
#   )
# }



# ログイン処理を担当するコントローラーはこちらも簡易的に以下の（最低限の）内容にしています。

# app/Http/Controllers/Auth/LoginController.php
# <?php

# namespace App\Http\Controllers\Auth;

# use App\Http\Controllers\Controller;
# use Exception;
# use Illuminate\Http\JsonResponse;
# use Illuminate\Http\Request;
# use Illuminate\Support\Facades\Auth;

# class LoginController extends Controller
# {
#     public function login(Request $request): JsonResponse
#     {
#         $credentials = $request->validate([
#             'email' => ['required', 'email'],
#             'password' => 'required',
#         ]);

#         if (Auth::attempt($credentials)) {
#             $request->session()->regenerate();
#             return response()->json(['name' => Auth::user()->email], 200);
#         }

#         throw new Exception('ログインに失敗しました。再度お試しください');
#     }
# }


# ここまでの状態でログインを行えば、ログインが成功してブラウザコンソールにログインユーザーのメールアドレスが表示されると思います。


# ................................

#~ ルートの保護

# Laravel Sanctumでの認証が必要なルーティングを設定する場合はsanctum認証ガードを指定します。

# routes/api.php
# <?php

# use App\Http\Controllers\Auth\LoginController;
# use App\Http\Controllers\QuestionnaireController;
# use App\Http\Controllers\SampleController;
# use Illuminate\Http\Request;
# use Illuminate\Support\Facades\Route;

# // auth:apiをauth:sanctumに変更
# Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
#     return $request->user();
# });


# 受信リクエストがNext.jsアプリからのステートフル認証済みリクエストとして認証されるか、リクエストがサードパーティからのものである場合は有効なAPIトークンヘッダを含むことを保証します。

# この修正によりログイン画面（pages/login.tsx）の以下の部分にはSPA認証後でないとリクエストできないようになります。
# （認証前だと401エラーになります）

# pages/login.tsx
#  // SPA認証済みではないとアクセスできないAPI
#   const handleUserClick = () => {
#     axios.get('http://localhost:8080/api/user', { withCredentials: true }).then((response) => {
#       console.log(response.data)
#     })
#   }


# ログイン後であれば、ブラウザコンソールにログインユーザーの情報が表示されます。

# ブラウザをリロードしても認証状態が維持されます。


# ................................

#~ 補足: CSRF保護初期化時にSRF-TOKENのCookieが保存されない

# /sanctum/csrf-cookieルートへのリクエスト後にブラウザにXSRF-TOKENのCookieが保存されなかったことです。

# 対応方法としてはAxiosの設定に{ withCredentials: true }を追加することで解決しました。

# pages/login.tsx
# // CSRF保護の初期化
# axios.get('http://localhost:8080/sanctum/csrf-cookie', { withCredentials: true })


#^ 上記ルーティングからのレスポンスヘッダーにSet-Cookieヘッダーが含まれていたのですが、{ withCredentials: true }を設定しないとブラウザにCookieが保存されないようです。以下の記事参考。

#【JavaScript】クロスオリジン（CORS）通信チェックポイントまとめ
# https://tkkm.tokyo/post-287/


# ................................

#~ 補足: ログイン後にsanctum認証ガードを設定したAPIにリクエストできない

# ログイン後に/api/userにGETすると、401エラーになりました。

# この原因は.envに設定していたSANCTUM_STATEFUL_DOMAINSの値をLaravel側のポート番号にしていたことでした。

# .env
# SANCTUM_STATEFUL_DOMAINS=localhost:8080

# 認証状態を維持するアプリケーションはNext.jsなのでLaravelにしたらダメですよね。。初めは上記環境変数の意味を正確に理解できていなかったのでここも結構詰まりました。（なお、localhostのみでも同様にエラーになります）


# ?--- SPA認証の実装 ---

# ①インストールとファイルの生成
install-sanctum:
	docker compose exec $(ctr) php -d memory_limit=-1 /usr/bin/composer require laravel/sanctum
  # Laravel Sanctum用の設定ファイルとトークン保存用のマイグレーションファイルの自動作成
	docker compose exec $(ctr) php artisan vendor:publish --provider="Laravel\Sanctum\SanctumServiceProvider"

#^ 後者のコマンド実行時に作成されるマイグレーションファイルはSPA認証では使用しない。

# ②APIトークンを使用する場合は、この後マイグレートする。
# make mig
# ※ APIトークンを使用しない場合、2019_12_14_000001_create_personal_access_tokens_table.phpを削除

# ③カーネルミドルウェアの設定 - １行目をコメントアウト
# app/Http/Kernel.php
# 'api' => [
#     \Laravel\Sanctum\Http\Middleware\EnsureFrontendRequestsAreStateful::class,
#     'throttle:api',
#     \Illuminate\Routing\Middleware\SubstituteBindings::class,
# ],

# ④config/sanctum.php の編集
# localhostのポートを8080に変更


# ?--- ユーザー認証設定 ----

# Authentication
# https://laravel.com/docs/8.x/authentication

# Manually Authenticating Users
# https://laravel.com/docs/8.x/authentication#authenticating-users

# Logging Out
# https://laravel.com/docs/8.x/authentication#logging-out

# ログイン用APIの作成
# ⑴ LoginController.phpの作成。
# ⑵ Manually Authenticating Users からLoginController.phpにペースト。
# ⑶ APIの場合、returnの部分がレスポンスになるよう、リダイレクトから修正。
# ログイン成功時は、ログインユーザー情報を返す。
# return response()->json(Auth::user());
# 失敗時は、401ステータスを返す。
# return response()->json([], 401);
# ⑷ PHPDocの修正
# ⑸ メソッド名をauthenticateからloginに変更

# ログアウト用APIの作成
# ⑴ Logging Out からLoginController.phpにペースト
# ⑵ APIの場合、returnの部分がレスポンスになるよう、リダイレクトから修正。
# ログアウトに成功したら、trueを返す。
# return response()->json(true);
# ⑶ PHPDocを修正

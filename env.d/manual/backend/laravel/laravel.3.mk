#? 毎回やる初期設定まとめ

# Laravelでの開発でいつもやってること
# https://zenn.dev/nrikiji/articles/d5b991402ea89c


#~ ログのローテーション
# デフォルトではstolage/logs/laravel.logの1ファイルに全て出力されるので特に本番環境などではローテーションとログの保存期間について注意する。また、permissionを環境に合わせて設定する

# .env
# LOG_CHANNEL=daily

# config/logging.php
# ・・・
# 'channels' => [
#     'daily' => [
#         'driver' => 'daily',
#         'days' => 90,
#         'permission' => 0664,
#     ],
# ],


# --------------------

#~ エラー通知

# 例外が発生したときに通知を送りたい。スキップしたい例外は$dontReportに追加する。

# app/Exceptions/Handler.php
# class Handler extends ExceptionHandler
# {
#     protected $dontReport = [
#         \Illuminate\Auth\AuthenticationException::class,
#         \Illuminate\Validation\ValidationException::class,
#         \Illuminate\Auth\Access\AuthorizationException::class,
#         \Illuminate\Database\Eloquent\ModelNotFoundException::class,
#         \Symfony\Component\HttpKernel\Exception\HttpException::class,
#     ];
#     ・・・
#     public function report(Throwable $e)
#     {
#         if ($this->shouldReport($e)) {
# 	    // 必要な情報をメールやSlackに通知する
#             // $e->getMessage()、$e->getCode()、$e->getFile()、$e->getLine();
#         }

#         parent::report($exception);
#     }
# }


# --------------------

#~ https対応

# httpsなサービスで、ロードバランサー配下にLaravelアプリがあってhttpでアクセスされる場合などは特に注意が必要。リンクやリダイレクト、authまわりの認証付きURLの挙動の確認が必要

# .env
# APP_SCHEME=https


# app/Providers/AppServiceProvider.php
# class AppServiceProvider extends ServiceProvider
# {
#     ・・・
#     public function boot(UrlGenerator $url)
#     {
#         if (env('APP_SCHEME') == 'https') {
#             $url->forceScheme('https');
#             $this->app['request']->server->set('HTTPS', true);
#         }
# }


# --------------------

#~ APIのエラーレスポンスのjson化

# 404エラー

# app/Exceptions/Handler.php
# class Handler extends ExceptionHandler
# {
#     ・・・
#     public function render($request, Throwable $exception)
#     {
#         if (!$request->is('api/*')) {
#             // API以外は何もしない
#             return parent::render($request, $exception);
#         } else if ($exception instanceof ModelNotFoundException) {
#             // Route Model Binding でデータが見つからない
#             return response()->json(['error' => 'Not found'], 404);
#         } else if ($exception instanceof NotFoundHttpException) {
#             // Route が存在しない
#             return response()->json(['error' => 'Not found'], 404);
#         } else {
#             return parent::render($request, $exception);
#         }
#     }
# }


# ........................

# その他エラー

# LaravelではhttpリクエストヘッダーAccept: application/jsonの有無でエラー時のレスポンス形式を判定しているのでapiへのリクエストでは強制的にこのヘッダーを付与する

# app/Http/Kernel.php
# class Kernel extends HttpKernel
# {
#     ・・・
#     protected $middlewareGroups = [
#         'api' => [
#             \App\Http\Middleware\AcceptJson::class,
# 	    ・・・
#         ],
#     ];
# }


# app/Http/Middleware/AcceptJson.php
# namespace App\Http\Middleware;

# use Closure;
# use Illuminate\Http\Request;

# class AcceptJson
# {
#     public function handle(Request $request, Closure $next)
#     {
#         $request->headers->set('Accept', 'application/json');
#         return $next($request);
#     }
# }


# --------------------

#~ APIのレスポンスはエスケープしない

# app/Http/Kernel.php
# class Kernel extends HttpKernel
# {
#     ・・・
#     protected $middlewareGroups = [
#         'api' => [
#             \App\Http\Middleware\UnescapeJsonResponse::class,
# 	    ・・・
#         ],
#     ];
# }


# app/Http/Middleware/UnescapeJsonResponse.php
# <?php

# namespace App\Http\Middleware;

# use Illuminate\Http\JsonResponse;

# class UnescapeJsonResponse
# {
#     public function handle($request, \Closure $next)
#     {
#         $response = $next($request);

#         // JSON以外は何もしない
#         if (!$response instanceof JsonResponse) {
#             return $response;
#         }

#         // エンコードオプションを追加して設定し直す
#         $newEncodingOptions = $response->getEncodingOptions() | JSON_UNESCAPED_UNICODE;
#         $response->setEncodingOptions($newEncodingOptions);

#         return $response;
#     }
# }


# --------------------

#~ 日本語化とタイムゾーン変更

# config/app.php
# 'timezone' => 'Asia/Tokyo',
# 'locale' => 'ja',


# Larvelドキュメントより
# $ php -r "copy('https://readouble.com/laravel/8.x/ja/install-ja-lang-files.php', 'install-ja-lang.php');"
# $ php -f install-ja-lang.php
# $ php -r "unlink('install-ja-lang.php');"


# --------------------

#~ 任意の時間でシミュレート

# この例ではシミュレートしたい日時を.envで管理。非プログラマーが検証するケースがある場合はテーブルで管理するのもあり

# .env
# DEBUG_DATE=2021-11-01

# ........................

# web用

# app/Http/Kernel.php
# class Kernel extends HttpKernel
# {
#     ・・・
#     protected $middlewareGroups = [
#         'web' => [
# 	    ・・・
#             \App\Http\Middleware\SetSimulationDateTime::class,
#         ],
#     ];
# }


# app/Http/Middleware/SetSimulationDateTime.php
# <?php

# namespace App\Http\Middleware;

# use Carbon\Carbon;
# use Closure;
# use Illuminate\Http\Request;

# class SetSimulationDateTime
# {
#     public function handle(Request $request, Closure $next)
#     {
#         if (env('APP_ENV') == 'local') {
#             if (env("DEBUG_DATE")) {
#                 // Too Many Request対策で時分秒は変わるように
# 		Carbon::setTestNow(new Carbon(
#                     env("DEBUG_DATE") . ' ' . date("H:i:s")
#                 ));
#             }
#         }
#         return $next($request);
#     }
# }

# ........................

# batch用

# baseクラスを作って、app/Console/Commands以下のクラスではこれを継承させる

# app/Console/Commands/BaseCommand.php
# <?php

# namespace App\Console\Commands;

# use Carbon\Carbon;
# use Illuminate\Console\Command;

# abstract class BaseCommand extends Command
# {
#     public function __construct()
#     {
#         parent::__construct();

#         if (env('APP_ENV') == 'local') {
#             if (env("DEBUG_DATE")) {
#                 Carbon::setTestNow(env("DEBUG_DATE"));
#             }
#         }
#     }
# }


# --------------------

#~ DBレプリケーション設定

# .env
# DB_MASTER_HOST=127.0.0.1
# DB_MASTER_USER=master_user
# DB_MASTER_PASS=master_password

# DB_SLAVE_HOST=127.0.0.1
# DB_SLAVE_USER=slave_user
# DB_SLAVE_PASS=slave_password


# config/database.php
# 'connections' => [
#     ・・・
#     'mysql' => [
#         'driver' => 'mysql',
#         'read' => [
#             'host' => [
# 	        env('DB_SLAVE_HOST'),
#             ],
#             'username' => env('DB_SLAVE_USER'),
#             'password' => env('DB_SLAVE_PASS'),
#             'port' => env('DB_PORT', '3306'),
#         ],
#         'write' => [
#             'host' => [
# 	        env('DB_MASTER_HOST'),
#             ],
#             'username' => env('DB_MASTER_USER'),
#             'password' => env('DB_MASTER_PASS'),
#             'port' => env('DB_PORT', '3306'),
#         ],
#         'sticky' => true,
# 	・・・
#     ],
#     ・・・
# ],


# --------------------

#~ エラーページ

# 以下のコマンドでresources/views/errorsにデフォルトで用意されているエラーページがコピーされる。特定のエラーコードの場合にLaravelデフォルトのエラーページが表示されてしまうことを避けるために最初にやってしまう

# $ php artisan vendor:publish --tag=laravel-errors


# --------------------

#~ アプリとマイグレーションでリポジトリを分ける

# 運用ルールによるが、私はgitのmasterブランチにマージしたものはいつでもデプロイ可能なものとしている。プログラムとマイグレーションをセットでデプロイしたいケースで、マイグレーション完了前に、プログラムが動くとエラーになる場合を回避するためにリポジトリを分けている


# デプロイのイメージ
# $ cd /path/to/マイグレーション用プロジェクト
# $ git pull
# $ php artisan migrate

# $ cd /path/to/アプリ用プロジェクト
# $ git pull


# --------------------

#~ デプロイ用にEnvoyをセットアップ

# .envは環境ごとに.env.develop .env.productionなどを準備する。

# インストール
# $ composer require laravel/envoy


# Envoy.blade.php
# @servers(['web' => ['web1', 'web2'], 'migrate' => ['web1']])

# @story('deploy', ['confirm' => true])
#     deploy_migrate
#     deploy_web
# @endstory

# @task('deploy_web', ['on' => 'web'])
#     cd /path/to/アプリ用プロジェクト
#     git pull
#     composer install
#     cp .env.production .env
# @endtask

# @task('deploy_migrate', ['on' => 'migrate'])
#     cd /path/to/マイグレーション用プロジェクト
#     git pull
#     cp .env.production .env
#     composer install
#     php artisan migrate
# @endtask


# デプロイ
# $ php vendor/bin/envoy run deploy


# --------------------

#~ 便利なプラグインの導入

# 必須じゃないけどこの辺は導入を検討。本番環境では無効化しなければいけないものは注意が必要


# N+1の検知
# beyondcode/laravel-query-detector
# https://github.com/beyondcode/laravel-query-detector


# httpリクエストのロギング
# spatie/laravel-http-logger
# https://github.com/spatie/laravel-http-logger


# sqlのロギング
# overtrue/laravel-query-logger
# https://github.com/overtrue/laravel-query-logger

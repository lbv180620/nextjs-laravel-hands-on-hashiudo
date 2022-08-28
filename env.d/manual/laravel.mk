#todo [Laravel Tips]

# https://laravel.com/
# https://laracasts.com/
# https://laravel-news.com/
# https://laracon.net/
# https://larajobs.com/


# Laravel 9
# https://laravel.com/docs/9.x
# https://readouble.com/laravel/9.x/ja/
# https://imanaka.me/laravel/create-books-app-install/


# **** マイグレートまでの流れ ****

# ⑴ ER図を見て、モデルとマイグレーションファイルを作成

# make mkmodel-m model=<モデル名>

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
#  $table->timestamp('created_at')->default('CURRENT_TIMESTAMP');
#  $table->timestamp('updated_at')->default(DB::raw('CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP'));

# ⑶ マイグレート

# make mig


# **** レイアウトの作成 ****

# layouts: @yield('content')
# auth: @extends('layouts.auth'), @section('content') @endsection
# モデル名: @extends('layouts.<モデル名>'), @section('content') @endsection


# **** リレーション ****

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


# **** N + 1 問題 ****

# Laravelのwithメソッド、loadメソッドでN+1問題を解決する
# https://migisanblog.com/laravel-with-load-n/


# LaravelでEloquentのリレーションを使ってみよう
# https://migisanblog.com/laravel-eloquent-relation/


# 【Laravel】N+1問題を完全理解！解消法も！
# https://tektektech.com/laravel-n1/


# ----------------

# 一覧表示箇所で発生する
# → リレーションの箇所が問題


# 解消箇所の特定
# → クエリ構造とコード場所が一致して重複している箇所


# リレーション = 外部キーに基づくSQL = where id = 数値
# リレーションは、外部キーとして指定された方のモデルに定義する。
# リレーションを使用するとN + 1問題が発生する。
# 1は全件取得クエリで、Nがリレーション。


# **** DI ****


# **** リファクタリング ****

#~ View表示用ロジックの分割 → ビューコンポーザ

#~ Fat Controller → ビジネスロジックをモデルに書く

#~ クエリの重複 → query()を使って、共通化


# **** Tips****

#? メモに画像を添付できる機能 → Laravelのストレージに画像を保存して、画像パスをDBに保存

#? メモの共有機能 → 自分以外の人にも見える共有URLを作る機能

#? クラウドサーバーを使ったインターネット公開 → おすすめはAWSのLightSailを使ってインターネットにメモアプリを公開


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

# resources/views/js/app.jsを書き替えます。

# importをrequireにします。

# // import './bootstrap';
# require('./bootstrap');


# resources/views/js/bootstrap.jsを書き替えます。

# // import _ from 'lodash';
# window._ = require('lodash');

# // import axios from 'axios';
# window.axios = require('axios');

# window.axios.defaults.headers.common['X-Requested-With'] = 'XMLHttpRequest';


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

# ② webpack.mixファイル作成

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

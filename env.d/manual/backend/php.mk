#todo [PHP Tips]

#? PHP Composerを使用してクラスのオートロードを行う

# https://reffect.co.jp/php/composer-autoload

# https://hara-chan.com/it/programming/php-autoload-composer/

# https://se-tomo.com/2018/12/19/%E3%80%90php%E3%80%91spl_autoload_register%E3%81%A8%E3%82%AA%E3%83%BC%E3%83%88%E3%83%AD%E3%83%BC%E3%83%89/


# ....................

# 注意点：
# 名前空間名にClassはNG!
# → T_Classエラーがでる


# ....................

# 名前空間がある場合に名前空間宣言していない場合、
# Undefined type 'Class\db\PDO'.
# となる問題

# →先頭にバックスラッシュをつけて完全修飾名にする

# \PDO

# 「\」 == グローバル空間

# \は名前空間のrootみたいなもの。これがデフォルト。
# 名前空間宣言した場合は、名前空間の外にあるクラスなどは、\に所属したまま。

# https://pointsandlines.jp/server-side/php/namespace

# https://teratail.com/questions/98491

# 名前空間に属さないクラスを使用する場合

# 名前空間が定義されたクラスから
# 名前空間を指定していない（いずれの名前空間にも属さない）クラスを使用する場合、
# 使用するクラス名の先頭に\（バックスラッシュ）を記述する。


# ....................

# PHPの標準クラスを利用する

# PHPにあらかじめ用意されているクラス、
# （例えばデータベースアクセスのPDOクラスなど）はグローバル空間という場所に所属するため
# 名前空間に属するクラスから使用する場合は、こちらも先頭に\（バックスラッシュ）を記述する必要がある。


# ....................ー

# ☆https://tadtadya.com/php-composer-lets-make-effective-use-of-autoload-function/

# ・"require vendor/autoload.php"をソースコードに1回だけ書く。
# ・use演算子でクラス、インタフェース、function、constがオートロードできる。
# ・設定はcomposer.json

# --------
# psr4というコーディング規約では、

# ・クラスファイルはnamespaceが必須。
# ・namespaceとディレクトリ構成、名称は一致させる。
# ・namespace名は大文字からはじめる。

# のルールがあります。

# PSR (PHP Standards Recommendations)


# ....................

# composer.jsonを直接編集したときは

# composer validate

# コマンドを必ず実行します。

# これは、composer.jsonの構文チェックコマンドです。

# エラーが出ると編集したところがまちがっています。

# composerコマンドが使えなくなるので気をつけましょう。


# ....................

# https://pointsandlines.jp/server-side/php/autoload-composer

# オートロードを利用する

# 1. composer.jsonを作成する
# composer.jsonというファイルをプロジェクト内に作成します。
# 手動、もしくはプロジェクトのパスでコマンド composer init を実行すると作成されます。


# $ composer init
# （Enterを押して行けば作成完了）


# .
# ├── Animal.php
# ├── composer.json
# ├── index.php
# └── model
#     ├── Cat.php
#     └── Dog.php


# 作成したcomposer.jsonに下記の記述を行います。


# {

#     "autoload": {
#         "psr-4": {
#             "app\\": "./"
#         }
#     }

# }


# 任意の記述箇所は5行目

# “名前空間を指定\\”: “（名前空間が指定される）ディレクトリ”

# 上記の例の場合、※composer.jsonと同じ階層配下を「app」という名前空間に指定しています。

# ※ 「./」 でカレントを表す

# composer.jsonのより下の階層、例えば「src」というディレクトリに名前空間を指定する場合は

# “app\\”: “src/”

# のように記述する。

# .
# ├── Animal.php
# ├── composer.json
# ├── index.php
# ├── src


# ....................

# 2. composer dump-autoloadを実行

# コマンド composer dump-autoloadを実行して必要な依存ライブラリを作成します。


# $ composer dump-autoload

# 実行後にオートロードを実現するために必要なライブラリと、vendorという新しいディレクトリが自動的に作成されています。


# .
# ├── Animal.php
# ├── composer.json
# ├── index.php
# ├── model
# │   ├── Cat.php
# │   └── Dog.php
# └── vendor
#     ├── autoload.php
#     └── composer
#         ├── ClassLoader.php
#         ├── LICENSE
#         ├── autoload_classmap.php
#         ├── autoload_namespaces.php
#         ├── autoload_psr4.php
#         ├── autoload_real.php
#         └── autoload_static.php


# ....................

# 3. クラスに名前空間を指定する

# オートロードで読み込む対象となるクラスファイルの先頭にnamespace句を使って名前空間を指定する必要があります。

# 各ファイルの名前空間

# Animal.php
# → app （composer.jsonと同じ階層）

# <?php
#     namespace app;

#     interface Animal {
#         public function bark();
#     }
# ?>


# Dog.php
# Cat.php
# → app\model （名前空間appから一つ下の階層modelに存在する）

# （注意）
# 実装するインターフェース名（implements文の後ろ）に名前空間を指定出来ないので、
# use句でAnimalインターフェースの名前空間を明示しています。
# （クラスの継承を表すextends文の場合も同様）

# <?php
#     namespace app\model;
#     use app\Animal;

#     class Dog implements Animal {
#         public function bark(){
#             print "bow!";
#         }
#     }
# ?>


# ....................

# 4. オートロードでクラスファイルを読み込む

# vendor/autoload.phpを実行ファイルから読み込むだけでクラスファイルを使用出来るようになります。

# 1. ソース内で使用しているDogクラス、Catクラスの前に名前空間を記述します。

# <?php

# require_once('vendor/autoload.php');

# $dog = new app\model\Dog();
# $cat = new app\model\Cat();

# print $dog -> bark()."<br>";
# print $cat -> bark()."<br>";

# ?>


# 2. use句に名前空間を記述する

# use句に名前空間を指定する事で、クラス名のみでの利用が可能となります。

# use 名前空間\クラス名


# <?php

# require_once('vendor/autoload.php');

# use app\model\Dog;
# use app\model\Cat;

# $dog = new Dog();
# $cat = new Cat();

# print $dog -> bark()."<br>";
# print $cat -> bark()."<br>";

# ?>


# ....................

# オートロードが効かない時

# オートロードの仕組みが期待通りに有効にならない時は
# 以下の点に注意して確認します。

# ・実行ファイルできちんと「vendor/autoload.php」を読み込んでいる事
# require_once(‘vendor/autoload.php’)

# ・名前空間を設定、または変更した場合「composer dump-autoload」コマンドを都度実行する。


# ....................

# https://rabbitfoot141.hatenablog.com/entry/2018/10/14/002210


# PSRとは

# PSRとは、PHP Standards Recommendations の事で PHP-FIG（PHP Framework Interop Group = PHPフレームワーク相互運用性グループ）が策定しているPHPコーディング規約のことを指す。
# The PHP League とか、PHPで使えるOSSをリリースしているところではPSRを厳守する様に書かれていて、これにはいくつかの種類がある。

# 現状で承認されているPSRは以下の通り

# PSR-1　Basic Coding Standard（基本的なコーディング標準）
# PSR-2　Coding Style Guide（コーディングスタイルガイド）
# PSR-3　Logger Interface（ロガーインタフェース）
# PSR-4　Autoloader（オートローダー）
# PSR-6　Caching Interface（キャッシングインターフェイス）
# PSR-7　HTTP Message Interface（HTTPメッセージインターフェイス）
# PSR-11　Container Interface（コンテナインタフェース）
# PSR-13　Hypermedia Links（ハイパーメディアリンク）
# PSR-15　HTTP Handlers（HTTPハンドラ）
# PSR-16　Simple Cache（シンプル・キャッシュ）
# PSR-17 HTTP Factories(HTTPファクトリー)


# ....................

# https://reffect.co.jp/php/composer-autoload


# -------------------

#? PHP Composer dotenvphpの導入


# dotenvphp

# https://qiita.com/suzu12/items/b2de7424770197794fd1

# https://qiita.com/zaburo/items/1dd2337c5f9281f7cc3a

# https://qiita.com/H40831/items/aaf8ffa727928661ad1d

# https://uiuifree.com/blog/develop/phpdotenv/

# https://qiita.com/zaburo/items/eacde522d36172d6d910



# ....................


# cd backend

# composer init

# or

# vim composer.json
# {
#   "require": {}
# }


# composer require vlucas/phpdotenv

# .gitignore
# vendor/
# .env


# <?php

# use Dotenv\Dotenv;

# require dirname(__FILE__, 4) . '/vendor/autoload.php';

# Dotenv::createImmutable(dirname(__FILE__, 5))->load();


# ....................

# make web

# vim /work/.env

# WEB_PORT=8080
# DB_PORT=3306
# DB_NAME=lamp
# DB_HOST=127.0.1.1
# DB_USER=phper
# DB_PASS=secret
# PMA_PORT=4040
# PMA_USER=phper
# PMA_PASS=secret
# UID=1000
# UNAME=vagrant
# GID=1000
# GNAME=vagrant

# これをしないと、ブラウザに表示されない

# ....................

# <?php

# // 自動で読み込み
# require './vendor/autoload.php';     // venderがあるところ

# // .envを使用する
# Dotenv\Dotenv::createImmutable(__DIR__)->load(); // .envがあるところ

# // .envファイルで定義したGREETINGを変数に代入
# $greeting = $_ENV['GREETING'];

# // 出力
# print($greeting) . PHP_EOL;

# // 出力結果
# // => こんにちは

# ....................

# 読み込み方の変遷

# https://qiita.com/sngazm/items/d27639f54e0abe723da9


# $dotenv = new Dotenv(__DIR__);
# $dotenv->load();

# $dotenv = Dotenv\Dotenv::create(__DIR__);
# $dotenv->load();

# $dotenv = Dotenv\Dotenv::createImmutable(__DIR__);
# $dotenv->load();


# ....................

# 違う階層の.envを読み込む


# https://hacknote.jp/archives/58385/

# https://agohack.com/going-levels-up-on-dirname/

# 違う階層にあるファイルを読み込むときはひとクセあります。

# 下記のような階層になっているとします

# .
# ├── composer.json
# ├── composer.lock
# ├── dir1
# │   ├── index.php
# └── vendor
# |
# └──.env

# この状況のindex.phpからvendorディレクトリと.envを読み込むときは以下のように書きます。

# require dirname(__FILE__).'/../vendor/autoload.php'; //vendorディレクトリの階層を指定する
# $dotenv = Dotenv\Dotenv::createImmutable(__DIR__. '/..'); //.envの階層を指定する
# $dotenv->load();


# ....................

# 5つ上の階層を取得
# ルートパス/htdocs/test/dir1/dir2/dir3/dir4/dir5/foo.phpから、 5つ上の階層にあるルートパス/htdocs/test/coo.phpをincludeで呼び出す場合、

# 方法１
# include_once(dirname(__FILE__) ."/../../../../../coo.php");

# 方法２
# require_once( dirname( __FILE__ , 6) . '/coo.php' );

# dirname()の第二引数に、どれだけ上に上がりたいか、階層の数を指定することができる。

# 方法３
# require_once( dirname(dirname(dirname( dirname( dirname( dirname( __FILE__ ) ) ) ) ) ) . '/coo.php' );


# -------------------

#? PHP | in_array()で配列・多次元配列のデータから値が存在するか判別する方法

# 記事
# https://1-notes.com/php-in-array/
# https://sossy-blog.com/useful/3882/
# https://qiita.com/yuzgit/items/a0cbf5372e4be394c4ef
# http://taustation.com/php-in_array/


# -------------------

#? トレイト

# トレイト - PHP公式マニュアル
# https://www.php.net/manual/ja/language.oop5.traits.php


# -------------------

#? final

# finalキーワード ¶
# https://www.php.net/manual/ja/language.oop5.final.php


# どんな時にクラスを final と宣言するのか
# https://qiita.com/sj-i/items/2c3d548079522da1b0e9

#^ まとめ：インタフェースを実装していて他のパブリックメソッドが定義されていない場合、いつもクラスを final にしてください。


# php finalを使用して継承を禁止する
# https://mebee.info/2020/11/22/post-17914/

# PHP　constによる定数定義とfinalについて
# https://tech.pjin.jp/blog/2013/02/12/php%E3%80%80%E3%82%AF%E3%83%A9%E3%82%B9%E3%80%80%E3%81%9D%E3%81%AE%EF%BC%91%EF%BC%92%E3%80%80%E3%80%90%E5%88%9D%E7%B4%9A%E7%B7%A8%E3%80%80%E7%AC%AC%EF%BC%95%EF%BC%90%E5%9B%9E%E3%80%91/


# -------------------

#? PHP $thisとselfの違い

# (PHP)「self::」と「$this」の違い【使い分け方なども紹介】
# https://hara-chan.com/it/programming/php-self-this-difference/

# 【PHP】$this と selfの違いとは？
# https://yuuu-daily.com/phpt-his-self-difference/

# PHP $thisとselfの違い
# https://qiita.com/miriwo/items/d33b63029217a675f440

# self::は、自クラスを示す。
# static変数はインスタンス化せずに使用します。この場合$thisは使用できません。

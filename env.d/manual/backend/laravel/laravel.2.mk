# ==== サービスコンテナ & サービスプロバイダ ====

# Laravel サービスコンテナの理解を深める
# https://reffect.co.jp/laravel/laravel-service-container-understand

# Laravel サービスプロバイダーついに理解
# https://reffect.co.jp/laravel/laravel-service-provider-understand

#【Laravel】Laravelのキモ、「サービスコンテナ」の仕組みを理解する〜後編〜
# https://yutaro-blog.net/2021/06/30/laravel-service-container-2/

#【Laravel】Laravelのキモ、「サービスコンテナ」の仕組みを理解する〜前編〜
# https://yutaro-blog.net/2021/06/30/laravel-service-container-1/

# Laravel 8.x サービスコンテナ
# https://readouble.com/laravel/8.x/ja/container.html

# Laravel 8.x サービスプロバイダ
# https://readouble.com/laravel/8.x/ja/providers.html


# ----------------

# Laravelのサービスコンテナとサービスプロバイダはどういうものなのか
# https://qiita.com/kunit/items/adee0a6aa449d53602c0

# Laravelのサービスコンテナとサービスプロバイダについて
# https://note.com/sasshiii/n/n554298c93077

# Laravelのサービスプロバイダーの仕組みやメリットとは
# https://www.geekfeed.co.jp/geekblog/laravel-service-providers

# Laravelにおけるサービスコンテナを理解しよう
# https://codezine.jp/article/detail/11865

# サービスプロバイダー＆サービスコンテナについて
# https://laraweb.net/practice/1960/

# サービスプロバイダーについて
# https://laraweb.net/practice/2051/

# サービスコンテナについて
# https://laraweb.net/practice/2029/

# サービスコンテナとサービスプロバイダーの要点
# https://www.wakuwakubank.com/posts/456-laravel-container-provider/

#【Laravel】 サービスプロバイダを理解して作る
# https://progtext.net/programming/laravel-service-provider/

#【Laravel】サービスコンテナとは？２つの強力な武器を持ったインスタンス化マシーン。簡単に解説。
# https://qiita.com/minato-naka/items/afa4b930a2afac23261b

#【Laravel】 サービスコンテナを使って自動で依存性を解決しよう
# https://progtext.net/programming/laravel-service-container/

#【学習メモ】Laravelのサービスコンテナについて調べたこと
# https://zenn.dev/honda/articles/39b1e1c2c58d1e


# ==== Mockery ====

# Mockery1.0 クイックリファレンス
# https://readouble.com/mockery/1.0/ja/quick_reference.html



# 【Laravel】MockeryでAPIをモック化してテストコードを書く
# https://awesome-linus.com/2020/01/22/laravel-mockery-api-mock-test/

# 【Laravel】Mockeryで外部APIをモック化してテストを実行できるようにする
# https://maasaablog.com/development/laravel/2805/

# 【Mockery】メソッドチェーンのモック、真面目にやるか？グータラやるか？
# https://zenn.dev/yumemi_inc/articles/b632e644ea3c37

# Mockeryでのモックの作り方を調べてみた
# https://toyo.hatenablog.jp/entry/2020/08/10/151148

# 【Laravel】テストで使える！DIのインスタンスをMockeryに差し替える方法
# https://public-constructor.com/laravel-change-dependency-injection-class/


# ................

#! Mockery mock() Expected type 'object'. Found 'string'.intelephense(1006)


# Splat based method definition - Expected type 'object'. Found 'string'. #2153
# https://github.com/bmewburn/vscode-intelephense/issues/2153

# Intelephense thinks Mockery::mock() returns a string #1784
# https://github.com/bmewburn/vscode-intelephense/issues/1784


# mockery/.phpstorm.meta.php
# https://github.com/mockery/mockery/blob/master/.phpstorm.meta.php

# phpunit/.phpstorm.meta.php
# https://github.com/sebastianbergmann/phpunit/blob/main/.phpstorm.meta.php


# ---------------------

# 解決策:

#^ src\vendor\mockery\mockery\.phpstorm.meta.phpの設定をsrc\vendor\phpunit\phpunit\.phpstorm.meta.phpに合うように上書きする。

# .src\vendor\mockery\mockery\.phpstorm.meta.php
# <?php

# namespace PHPSTORM_META;

# override(\Mockery::mock(0), map(["" => "@&\Mockery\MockInterface"]));
# override(\Mockery::spy(0), map(["" => "@&\Mockery\MockInterface"]));
# override(\Mockery::namedMock(0), map(["" => "@&\Mockery\MockInterface"]));
# override(\Mockery::instanceMock(0), map(["" => "@&\Mockery\MockInterface"]));
# override(\mock(0), map(["" => "@&\Mockery\MockInterface"]));
# override(\spy(0), map(["" => "@&\Mockery\MockInterface"]));
# override(\namedMock(0), map(["" => "@&\Mockery\MockInterface"]));


#! オーバーライドは上手行かない。
# vendor配下のファイルを書き換えるのは良くないので、以下の手順に沿ってオーバーライドさせる。

# src\app\Vendor\mockery\mockery\.phpstorm.meta.php
# <?php

# use function PHPSTORM_META\map;
# use function PHPSTORM_META\override;

# override(\Mockery::mock(0), map(["" => "@&\Mockery\MockInterface"]));
# override(\Mockery::spy(0), map(["" => "@&\Mockery\MockInterface"]));
# override(\Mockery::namedMock(0), map(["" => "@&\Mockery\MockInterface"]));
# override(\Mockery::instanceMock(0), map(["" => "@&\Mockery\MockInterface"]));
# override(\mock(0), map(["" => "@&\Mockery\MockInterface"]));
# override(\spy(0), map(["" => "@&\Mockery\MockInterface"]));
# override(\namedMock(0), map(["" => "@&\Mockery\MockInterface"]));


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


# ---------------------

# 推測:

#^ src\vendor\phpunit\phpunit\.phpstorm.meta.phpに対して、src\vendor\mockery\mockery\.phpstorm.meta.phpの設定が不十分であるためこのようなことが起きた？

# src\vendor\phpunit\phpunit\.phpstorm.meta.php
# <?php
# namespace PHPSTORM_META {

#     override(
#         \PHPUnit\Framework\TestCase::createMock(0),
#         map([
#             '@&\PHPUnit\Framework\MockObject\MockObject',
#         ])
#     );

#     override(
#         \PHPUnit\Framework\TestCase::createStub(0),
#         map([
#             '@&\PHPUnit\Framework\MockObject\Stub',
#         ])
#     );

#     override(
#         \PHPUnit\Framework\TestCase::createConfiguredMock(0),
#         map([
#             '@&\PHPUnit\Framework\MockObject\MockObject',
#         ])
#     );

#     override(
#         \PHPUnit\Framework\TestCase::createPartialMock(0),
#         map([
#             '@&\PHPUnit\Framework\MockObject\MockObject',
#         ])
#     );

#     override(
#         \PHPUnit\Framework\TestCase::createTestProxy(0),
#         map([
#             '@&\PHPUnit\Framework\MockObject\MockObject',
#         ])
#     );

#     override(
#         \PHPUnit\Framework\TestCase::getMockForAbstractClass(0),
#         map([
#             '@&\PHPUnit\Framework\MockObject\MockObject',
#         ])
#     );
# }


# src\vendor\mockery\mockery\.phpstorm.meta.php
# <?php

# namespace PHPSTORM_META;

# override(\Mockery::mock(0), type(0));
# override(\Mockery::spy(0), type(0));
# override(\Mockery::namedMock(0), type(0));
# override(\Mockery::instanceMock(0), type(0));
# override(\mock(0), type(0));
# override(\spy(0), type(0));
# override(\namedMock(0), type(0));

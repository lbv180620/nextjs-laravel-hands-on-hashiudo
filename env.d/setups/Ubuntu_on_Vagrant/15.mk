#todo 15. php.iniの設定


# https://www.javadrive.jp/php/install/index5.html

# https://webkaru.net/php/php-ini/#timezone

# https://webkaru.net/php/mbstring-php-ini/

# https://www.sejuku.net/blog/69296

# https://www.sejuku.net/blog/24522

# https://hapicode.com/php/phpini.html#error-reporting-%E8%A8%AD%E5%AE%9A

# https://qiita.com/ucan-lab/items/0d74378e1b9ba81699a9

# https://www.kenschool.jp/blog/?p=2347

# ☆https://affiwork.net/php-settings/

# https://zenn.dev/ksh2ksk4/articles/3cb75ed89ae662c1352d


# ・設定ファイルのバックアップ

# cd /etc/php/8.0/apache2
# sudo cp php.ini php.ini.bk

# ----------------------

# Apache：

# ・読み込まれているphp.iniファイルを確認する

# Loaded Configuration File	/etc/php/8.0/apache2/php.ini


# ・反映方法

# sudo systemctl restart apache2

# ---------------------

# ・拡張モジュールのディレクトリ設定(extension_dir)

# http://phpbook.s25.xrea.com/install/phpini/index3.html

# phpinfo()
# extension_dir	/usr/lib/php/20200930	/usr/lib/php/20200930

# php.ini
# extension_dir = ""


# ----------------------

# 日本語利用に関する設定(mbstring)

# http://phpbook.s25.xrea.com/install/phpini/index5.html

# php.ini
# extension=mbstring

# default_charset = "UTF-8"

# [mbstring]

# 注意：https://affiwork.net/php-settings/

# PHP5.6.0以降非推奨となっているので、コメントアウトし、使用しないようにします。
# ;mbstring.internal_encoding =
# ;mbstring.http_input =
# ;mbstring.http_output =



# その１：
# mbstring.language = Japanese
# mbstring.encoding_translation = Off
# mbstring.detect_order = UTF-8,SJIS,EUC-JP,JIS,ASCII
# mbstring.substitute_character = none
# mbstring.strict_detection = Off

# その２：
# mbstring.language = Japanese
# mbstring.internal_encoding = UTF-8
# mbstring.http_input = auto
# mbstring.http_output = UTF-8
# mbstring.encoding_translation = On
# mbstring.detect_order = auto

# その３：
# mbstring.language = Japanese
# mbstring.internal_encoding = UTF-8
# mbstring.http_input = auto
# mbstring.http_output = UTF-8
# mbstring.encoding_translation = On
# mbstring.detect_order = auto

# その４：
# mbstring.language = Japanese
# mbstring.internal_encoding = UTF-8
# mbstring.http_input = pass
# mbstring.http_output = pass
# mbstring.encoding_translation = Off
# mbstring.detect_order = UTF-8,SJIS,EUC-JP,JIS,ASCII
# mbstring.substitute_character = none
# mbstring.func_overload = 0
# mbstring.strict_detection = Off

# その５：
# mbstring.language = Japanese
# mbstring.encoding_translation = Off
# mbstring.detect_order = UTF-8,SJIS,EUC-JP,JIS,ASCII

# その６：
# mbstring.language = Japanese
# mbstring.detect_order = ASCII,ISO-2022-JP,UTF-8,eucJP-win,SJIS-win
# mbstring.substitute_character = none
# mbstring.func_overload = 0

# その７：
# mbstring.language = Japanese
# mbstring.encoding_translation = Off
# mbstring.detect_order = UTF-8,SJIS,EUC-JP,JIS,ASCII
# mbstring.substitute_character = none
# mbstring.strict_detection = Off

# 自分用：
# mbstring.language = Japanese
# mbstring.detect_order = UTF-8,SJIS,EUC-JP,JIS,ASCII
# mbstring.substitute_character = none
# mbstring.internal_encoding = UTF-8


# ----------------------

# インクルードパスの設定(include_path)

# http://phpbook.s25.xrea.com/install/phpini/index4.html

# phpinfo()
# include_path	.:/usr/share/php	.:/usr/share/php

# php.ini
# include_path =

# ----------------------

# ・エラーの設定

# https://www.sejuku.net/blog/24522

# error_reporting = E_ALL
# エラー表示のレベルの設定。左の例はすべてのエラーを表示します。

# display_errors = On
# Onの場合ブラウザ上にエラーを表示させる。

# ----------------------

# ・タイムゾーン設定

# php.ini
# date.timezone = "Asia/Tokyo"


# ----------------------

# ・セキュリティに関する設定

# expose_php = Off

# ----------------------

# ・パフォーマンスに関する設定

# memory_limit = 128M

# post_max_size = 128M

# upload_max_filesize = 128M


# ----------------------

# Nginx：

# ・反映方法

# systemctl restart php-fpm

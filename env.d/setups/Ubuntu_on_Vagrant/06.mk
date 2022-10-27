#todo 6. PHP環境構築

# https://tutorialcrawler.com/ubuntu-debian/ubuntu-20-04%E3%81%A7php-fpm%E3%82%92%E4%BD%BF%E7%94%A8%E3%81%97%E3%81%A6nginx%E3%82%92%E3%82%BB%E3%83%83%E3%83%88%E3%82%A2%E3%83%83%E3%83%97%E3%81%99%E3%82%8B%E6%96%B9%E6%B3%95/

# # PHPインストール

# sudo apt install  -y software-properties-common
# sudo add-apt-repository ppa:ondrej/php
# sudo apt update -y
# sudo apt install -y php7.4 php7.4-fpm
# //sudo apt install -y php8.0 php8.0-fpm

# php -v

# sudo apt install -y php7.4-mbstring php7.4-curl php7.4-xml php7.4-cli


# ---------------

# https://www.fenet.jp/dotnet/column/tool/9374/

# https://laboradian.com/use-php72-with-ubuntu1604/

# ・切り替え
# https://mebee.info/2020/08/17/post-16891/
# update-alternatives --list php
# sudo update-alternatives --config php
# php -v

# ・phpinfo()に反映（CGI版）
# https://www.suzu6.net/posts/202-apache-php-fpm/

# ApacheはPHP-FPMを通してphpを実行しています。 PHP-FPMがphp.iniの設定を読み込んでいなかったため、Apacheを再起動しても設定を読み込めなかったのです。 一方、モジュール版では、Apacheが直接phpを実行しているためApacheの再起動だけで良いようです。

# また、Nginxでは基本PHP-FPMを利用するため、同じくPHP-FPMの再起動をすると良いはずです。


# sudo systemctl status php7.4-fpm
# sudo systemctl status php8.0-fpm

# https://www.sejuku.net/blog/101654


# ・apache2 使用するphpのバージョンを変更する
# https://mebee.info/2021/08/02/post-29391/

# 有効
# sudo a2enmod php7.4
# ERROR: Module php7.4 does not exist!
# sudo apt install libapache2-mod-php7.4 libapache2-mod-php -y

# 無効
# sudo a2dismod php8.0


# ---------------

# # composerインストール

# curl -sSL https://getcomposer.org/installer | php

# sudo mv composer.phar /usr/local/bin/composer


# ---------------

# php --version

# composer --version


# ---------------

# peclインストール

# https://zenn.dev/dozo/articles/545ea424566fc3

# https://qiita.com/shizen-shin/items/0d6a9cbeb16047c7d47a

# さて、ローカルのUbuntuにはPECLはなく、
# phpizeとかも入っていない。

# pecl：
# sudo apt install -y php-pear

# phpize：
# sudo apt install -y php7.4-dev

# https://ll.just4fun.biz/?PHP/phpize%E3%81%AE%E3%82%A4%E3%83%B3%E3%82%B9%E3%83%88%E3%83%BC%E3%83%AB

# sudo pecl install xdebug

# 220811:
# Build process completed successfully
# Installing '/usr/lib/php/20200930/xdebug.so'
# install ok: channel://pecl.php.net/xdebug-3.1.0
# configuration option "php_ini" is not set to php.ini location
# You should add "zend_extension=/usr/lib/php/20200930/xdebug.so" to php.ini


# 230811:
# Build process completed successfully
# Installing '/usr/lib/php/20190902/xdebug.so'
# install ok: channel://pecl.php.net/xdebug-3.1.0
# configuration option "php_ini" is not set to php.ini location
# You should add "zend_extension=/usr/lib/php/20190902/xdebug.so" to php.ini


# php.ini
# https://www.tweeeety.blog/entry/20121218/1355802787
# https://pisuke-code.com/ubuntu-ways-to-get-php-ini-path/
# https://hydrocul.github.io/wiki/blog/2013/0625-php-ini-location-ubuntu.html
# php -i | grep php.ini

# diff /etc/php/7.4/apache2/php.ini /etc/php/7.4/cli/php.ini

# https://techtech-note.com/1030/
# https://zenn.dev/aibax/articles/vessel-configuration-for-xdebug3

# [xdebug]
# zend_extension=/usr/lib/php/20200930/xdebug.so
# xdebug.mode=debug, develop
# xdebug.discover_client_host=1
# xdebug.client_host=localhost
# xdebug.client_port=9003
# xdebug.start_with_request=yes
# xdebug.log=/tmp/xdebug.log
# xdebug.idekey="vscode"


# ---------------

# sudo apt install php-xdebug -y

# Reading package lists... Done
# Building dependency tree
# Reading state information... Done
# The following packages were automatically installed and are no longer required:
#   linux-image-5.4.0-80-generic linux-modules-5.4.0-80-generic
#   linux-modules-extra-5.4.0-80-generic
# Use 'sudo apt autoremove' to remove them.
# The following additional packages will be installed:
#   php8.0-xdebug
# The following NEW packages will be installed:
#   php-xdebug php8.0-xdebug
# 0 upgraded, 2 newly installed, 0 to remove and 0 not upgraded.
# Need to get 544 kB of archives.
# After this operation, 2,489 kB of additional disk space will be used.
# Get:1 http://ppa.launchpad.net/ondrej/php/ubuntu focal/main amd64 php8.0-xdebug amd64 3.0.4+2.9.8+2.8.1+2.5.5-1+ubuntu20.04.1+deb.sury.org+1 [537 kB]
# Get:2 http://ppa.launchpad.net/ondrej/php/ubuntu focal/main amd64 php-xdebug amd64 3.0.4+2.9.8+2.8.1+2.5.5-1+ubuntu20.04.1+deb.sury.org+1 [7,168 B]
# Fetched 544 kB in 3s (194 kB/s)
# Selecting previously unselected package php8.0-xdebug.
# (Reading database ... 164319 files and directories currently installed.)
# Preparing to unpack .../php8.0-xdebug_3.0.4+2.9.8+2.8.1+2.5.5-1+ubuntu20.04.1+deb.sury.org+1_amd64.deb ...
# Unpacking php8.0-xdebug (3.0.4+2.9.8+2.8.1+2.5.5-1+ubuntu20.04.1+deb.sury.org+1) ...
# Selecting previously unselected package php-xdebug.
# Preparing to unpack .../php-xdebug_3.0.4+2.9.8+2.8.1+2.5.5-1+ubuntu20.04.1+deb.sury.org+1_amd64.deb ...
# Unpacking php-xdebug (3.0.4+2.9.8+2.8.1+2.5.5-1+ubuntu20.04.1+deb.sury.org+1) ...
# Setting up php8.0-xdebug (3.0.4+2.9.8+2.8.1+2.5.5-1+ubuntu20.04.1+deb.sury.org+1) ...
# Setting up php-xdebug (3.0.4+2.9.8+2.8.1+2.5.5-1+ubuntu20.04.1+deb.sury.org+1) ...
# Processing triggers for php8.0-fpm (8.0.11-1+ubuntu20.04.1+deb.sury.org+1) ...
# NOTICE: Not enabling PHP 8.0 FPM by default.
# NOTICE: To enable PHP 8.0 FPM in Apache2 do:
# NOTICE: a2enmod proxy_fcgi setenvif
# NOTICE: a2enconf php8.0-fpm
# NOTICE: You are seeing this message because you have apache2 package installed.
# Processing triggers for libapache2-mod-php8.0 (8.0.11-1+ubuntu20.04.1+deb.sury.org+1) ...
# Processing triggers for php8.0-cli (8.0.11-1+ubuntu20.04.1+deb.sury.org+1) ...

# sudo find / -name "xdebug.so"


# ---------------

# 拡張モジュールインストール

# sudo apt -y install php7.4-curl php7.4-zip php-mysqli php7.4-xml php7.4-gd
# sudo apt -y install php7.4-intl php7.4-xmlrpc php7.4-soap php7.4-mbstring

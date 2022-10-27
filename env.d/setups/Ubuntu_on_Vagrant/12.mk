#todo 12. LAMP環境構築

#* PHPモジュール

# php7.4:
# sudo apt install -y libapache2-mod-php7.4 php7.4-fpm php7.4-common php7.4-mbstring php7.4-xmlrpc php7.4-gd php7.4-xml php7.4-mysql php7.4-cli php7.4-zip php7.4-curl php7.4-imagick php7.4-curl php7.4-json


# php8.0:
# sudo apt install -y libapache2-mod-php php-fpm php-common php-mbstring php-xmlrpc php-gd php-xml php-mysql php-cli php-zip php-curl php-imagick php-curl php-json

# ①sudo apt install -y php-cli php-mbstring php-curl php-xml

# ②sudo apt install -y libapache2-mod-php php-mysql

# ~ここまで必須~

# ③sudo apt install -y php-zip php-gd php-json

# ④sudo apt install -y php-fpm php-common php-imagick

# ⑤ sudo apt install -y php-tcpdf php-cgi php-pear php-phpseclib


# ----------------------------

#* Webサーバ + phpinfo()

#& Apache2

# https://www.pahoo.org/e-soul/webtech/php01/php39-01.shtm

# sudo apt install -y apache2

# ..........................

# sudo su -

# apt update

# ufw enable

# ufw allow 22

# ufw allow 80

#  ufw allow 110/tcp

# ufw reload

# 8080
# 3306
# 3000
# 4040

# sudo ufw allow 5432

# ..........................

# vim cdwww
# cd /var/www/html

# . cdwww

# ..........................

# # phpinfo()
# https://www.kagoya.jp/howto/rentalserver/apache/

# . cdwww
# sudo vim info.php

# <?php phpinfo(); ?>

# cd

# sudo apt install -y libapache2-mod-php
# sudo a2enmod php7.4
# sudo a2enmod php8.0


# 有効
# sudo a2enmod php7.4
# ERROR: Module php7.4 does not exist!
# sudo apt install libapache2-mod-php7.4 libapache2-mod-php -y

# 無効
# sudo a2dismod php8.0

# sudo systemctl start apache2
# 192.168.33.11/info.php


# WSL で Apache サーバを立ててみる
# https://neos21.net/blog/2021/03/28-01.html

# localhostでアクセス

# ----------------------------

#& Nginx

# sudo apt install -y nginx

# ..........................

# phpinfo()

# https://qiita.com/kotarella1110/items/634f6fafeb33ae0f51dc

# https://tutorialcrawler.com/ubuntu-debian/ubuntu-20-04%E3%81%A7php-fpm%E3%82%92%E4%BD%BF%E7%94%A8%E3%81%97%E3%81%A6nginx%E3%82%92%E3%82%BB%E3%83%83%E3%83%88%E3%82%A2%E3%83%83%E3%83%97%E3%81%99%E3%82%8B%E6%96%B9%E6%B3%95/

# https://self-development.info/nginx%E3%81%A7%E6%9C%80%E6%96%B0%E3%83%90%E3%83%BC%E3%82%B8%E3%83%A7%E3%83%B3%E3%81%AEphp%EF%BC%88php-fpm%EF%BC%89%E3%82%92%E5%8B%95%E3%81%8B%E3%81%99%E3%80%90ubuntu%E3%80%91/

# php-fpmを簡単に説明すると、Webサーバーから呼ばれて動く仕組みとなります。
# そのため、呼ばれればどのWebサーバーでもPHPが実行可能です。

# fpmの有無	実行可能Webサーバー
# なしのPHP	Apacheのみ
# ありのPHP	Apache・Nginx・IIS


# sudo apt install -y php-fpm
# sudo apt install -y php7.4-fpm

# sudo systemctl status php7.4-fpm
# sudo systemctl status php8.0-fpm

# ..........................

# NginxでPHPを動かすための設定

# まずは、設定の修正を行う前に情報収集です。
# 次のファイルの「listen」を確認します。

# /etc/php/7.4/fpm/pool.d/www.conf
# listen = /run/php/php7.4-fpm.sock

# /etc/php/8.0/fpm/pool.d/www.conf
# listen = /run/php/php8.0-fpm.sock

# このパスのファイルを通じて、NginxとPHP（php-fpm）がやり取り可能です。
# そのため、このパスをNginx側の設定ファイルに教えてやる必要があります。

# sudo vim /etc/nginx/sites-enabled/default

# /etc/nginx/sites-enabled/default
# location ~ \.php$ {
#         include snippets/fastcgi-php.conf;
#
#       # With php-fpm (or other unix sockets):
#         fastcgi_pass unix:/run/php/php7.4-fpm.sock;
# or     fastcgi_pass unix:/run/php/php8.0-fpm.sock;

#       # With php-cgi (or other tcp sockets):
#       fastcgi_pass 127.0.0.1:9000;
# }

# -> php8.0の場合が無い？
# https://minokamo.tokyo/2020/12/20/3097/

# では、この設定を反映させます。

# sudo systemctl reload nginx

# 確認しましょう。
# そのためには、defaultのドキュメントルート（初期では/var/www/html）にinfo.phpを設置します。

# info.php

# <?php phpinfo(); ?>
# info.phpを設置したら、アクセスします。
# http://○.○.○.○[サーバーIP]/info.phpへアクセス。

# ..........................

#! エラー：

# https://qiita.com/naota7118/items/4fe2578fec561795a960
# https://qiita.com/Takao_/items/6481f1a783423dce596c

# sudo systemctl reload nginx

# Job for nginx.service failed because the control process exited with error code.
# See "systemctl status nginx.service" and "journalctl -xe" for details.


# sudo journalctl -r -u nginx
# or
# sudo nginx -t

# nginx: [emerg] "fastcgi_pass" directive is duplicate in /etc/nginx/sites-enabled/default:62
# nginx: configuration file /etc/nginx/nginx.conf test failed

# sudo vim /etc/nginx/sites-enabled/default
# :set number
# -> 行番号表示

# #       fastcgi_pass 127.0.0.1:9000;
# ->ここをコメントアウトしてたのが原因

# ----------------------------

#* @DBサーバ + phpMyAdmin

#& MariaDB

# sudo apt install -y php-mysql
# sudo apt install -y php7.4-mysql

# sudo apt install  -y apt-transport-https

# curl -LsS https://downloads.mariadb.com/MariaDB/mariadb_repo_setup | sudo bash

# sudo apt update

# sudo apt install mariadb-server
# or
# sudo apt -y install mariadb-server mariadb-client mariadb-backup

# systemctl status mariadb

# ..........................

# vim /etc/mysql/mariadb.conf.d/50-server.cnf
# # 104行目：デフォルトの文字コードを確認
# # 絵文字等 4バイト長の文字を扱う場合は [utf8mb4]
# character-set-server  = utf8mb4
# collation-server      = utf8mb4_general_ci

# ..........................

# sudo mysql_secure_installation
# enter
# unix_socket n
# root パスワードを設定 lbv180620
# 他はy

# mariadb -u root -p


# ..........................

#? phpMyAdminの導入

# cd /downloads/
# sudo mkdir phpmyadmin
# cd phpmyadmin

# sudo wget https://files.phpmyadmin.net/phpMyAdmin/5.1.1/phpMyAdmin-5.1.1-all-languages.zip

# sudo unzip phpMyAdmin-5.1.1-all-languages.zip

# sudo mv phpMyAdmin-5.1.1-all-languages /usr/share/phpmyadmin

# sudo mkdir /usr/share/phpmyadmin/tmp
# sudo chown -R www-data:www-data /usr/share/phpmyadmin
# sudo chmod 777 /usr/share/phpmyadmin/tmp

# sudo vim /etc/apache2/conf-available/phpmyadmin.conf

# Alias /phpmyadmin /usr/share/phpmyadmin
# Alias /phpMyAdmin /usr/share/phpmyadmin
# <Directory /usr/share/phpmyadmin/>
#    Order deny,allow
#    Deny from all
#    Allow from 192.168.
#    AddDefaultCharset UTF-8
#    <IfModule mod_authz_core.c>
#       <RequireAny>
#       Require all granted
#      </RequireAny>
#    </IfModule>
# </Directory>
# <Directory /usr/share/phpmyadmin/setup/>
#    <IfModule mod_authz_core.c>
#      <RequireAny>
#        Require all granted
#      </RequireAny>
#    </IfModule>
# </Directory>

# sudo ln -s /etc/apache2/conf-available/phpmyadmin.conf /etc/apache2/conf-enabled/phpmyadmin.conf

# sudo mkdir /etc/phpmyadmin/
# sudo ln -s  /etc/apache2/conf-enabled/phpmyadmin.conf /etc/phpmyadmin/apache.conf
# -> 無くていいかも

# sudo a2enconf phpmyadmin

# sudo systemctl start apache2

# 192.168.33.22/phpmyadmin
# rootユーザ、rootパスワードでログイン

# ..........................

#! エラー：
# sudo systemctl restart apache2

# ->  Process: 10592 ExecStart=/usr/sbin/apachectl start (code=exited, status=1/FAILURE)
# https://column.prime-strategy.co.jp/archives/column_1834

# sudo journalctl -r -u apache2
# -> apache2: Syntax error on line 222 of /etc/apache2/apache2.conf: Syntax error on line 1 of /etc/apache2/conf-enabled/phpmyadmin.conf: Could not open configuration>

# sudo vim /etc/apache2/conf-available/phpmyadmin.conf
# -> Include /etc/phpmyadmin/apache.confを削除して解決

# ----------------------------

#& MySQL

# https://blog.tsukumijima.net/article/ubuntu-wsl2-docker-setup/#toc21

# sudo apt install mysql-server -y

# sudo systemctl start mysql

#  sudo mysql_secure_installation

# https://weblabo.oscasierra.net/mysql-57-init-setup/

# https://www.dbonline.jp/mysql/connect/index3.html

# # MySQLの完全削除
# https://qiita.com/King_kenshi/items/b6f217a8a3083c98904b


# ----------------------------

#&  PostgreSQL

# https://www.digitalocean.com/community/tutorials/how-to-install-postgresql-on-ubuntu-20-04-quickstart-ja

# https://qiita.com/SierSetup/items/041939690cea80c1b1d9

# https://wiki.postgresql.org/wiki/Apt

# https://postgresweb.com/install-postgresql-ubuntu2004

# https://tutorialcrawler.com/ubuntu-debian/ubuntu-20-04%E3%81%ABpostgresql%E3%82%92%E3%82%A4%E3%83%B3%E3%82%B9%E3%83%88%E3%83%BC%E3%83%AB%E3%81%99%E3%82%8B%E6%96%B9%E6%B3%95/

# # Ubuntu20.04にPostgreSQLをインストール

# sudo apt update && sudo apt install -y wget ca-certificates

# wget -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

# sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ focal-pgdg main" >> /etc/apt/sources.list.d/pgdg.list'

# sudo apt update && sudo apt-get install -y postgresql postgresql-contrib

# -> 13  main    5432 down   postgres /var/lib/postgresql/13/main
# /var/log/postgresql/postgresql-13-main.log

# 2021-07-26 07:11:27.685 UTC [7700] LOG:  starting PostgreSQL 13.3 (Ubuntu 13.3-1.pgdg20.04+1) on x86_64-pc-linux-gnu, compiled by gcc (Ubuntu 9.3.0-17ubuntu1~20.04) 9.3.0, 64-bit
# 2021-07-26 07:11:27.686 UTC [7700] LOG:  listening on IPv6 address "::1", port 5432
# 2021-07-26 07:11:27.686 UTC [7700] LOG:  listening on IPv4 address "127.0.0.1", port 5432
# 2021-07-26 07:11:27.687 UTC [7700] LOG:  listening on Unix socket "/var/run/postgresql/.s.PGSQL.5432"
# 2021-07-26 07:11:27.690 UTC [7701] LOG:  database system was shut down at 2021-07-26 07:11:26 UTC
# 2021-07-26 07:11:27.694 UTC [7700] LOG:  database system is ready to accept connections

# -> 対処：sudo ufw allow 5432
# -> 特に何もしなくても大丈夫かも
# https://www.fatyas.com/wiki/Ubuntu_21.04%E3%81%AEPostgresql_12%E3%82%9213%E3%81%B8%E3%83%90%E3%83%BC%E3%82%B8%E3%83%A7%E3%83%B3%E3%82%A2%E3%83%83%E3%83%97%E3%81%99%E3%82%8B

# sudo systemctl status postgresql

# sudo su - postgres

# psql
# -> psql (13.2 (Ubuntu 13.2-1.pgdg20.04+1)) Type "help" for help. postgres=#

# 上記の組み合わせ：
# sudo -u postgres psql
# -> psql (13.2 (Ubuntu 13.2-1.pgdg20.04+1)) Type "help" for help. postgres=#

# postgres=# \conninfo

# ..........................

# ＃PostgreSQLへの接続

# sudo passwd postgres
# -> lbv180620

# su - postgres
# -> lbv180620

# psql -c "ALTER USER postgres WITH PASSWORD 'secure_password_here';"

# exit

# sudo systemctl restart postgresql

# ..........................

# ログイン

# su - postgres
# -> lbv180620

# psql

# ..........................

#? pgAdminのインストール

# 方法①　失敗
# curl https://www.pgadmin.org/static/packages_pgadmin_org.pub | sudo apt-key add - sudo sh -c 'echo "deb https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/focal pgadmin4 main" > /etc/apt/sources.list.d/pgadmin4.list'


# sudo apt update && sudo apt install -y pgadmin4
# -> E: Package 'pgadmin4' has no installation candidate

# sudo /usr/pgadmin4/bin/setup-web.sh


# 方法②
# https://postgresweb.com/install-pgadmin4-ubuntu-20-04


# $ sudo curl https://www.pgadmin.org/static/packages_pgadmin_org.pub | sudo apt-key add

# $ sudo sh -c 'echo "deb https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/$(lsb_release -cs) pgadmin4 main" > /etc/apt/sources.list.d/pgadmin4.list && apt update'

# -> E: The repository 'https://dlm.mariadb.com/repo/mariadb-server/10.6/repo/ubuntu focal Release' no longer has a Release file.
# N: Updating from such a repository can't be done securely, and is therefore disabled by default.
# N: See apt-secure(8) manpage for repository creation and user configuration details.
# E: The repository 'https://dlm.mariadb.com/repo/maxscale/latest/apt focal Release' no longer has a Release file.
# N: Updating from such a repository can't be done securely, and is therefore disabled by default.
# N: See apt-secure(8) manpage for repository creation and user configuration details.
# N: Skipping acquire of configured file 'main/binary-i386/Packages' as repository 'http://apt.postgresql.org/pub/repos/apt focal-pgdg InRelease' doesn't support architecture 'i386'

# -> 無視してもいいかも？

# sudo apt install -y pgadmin4

# sudo /usr/pgadmin4/bin/setup-web.sh
# -> 0chlbv7420t18063263g7t20@gmail.com
# -> lbv180620
# -> y

# http://192.168.33.11/pgadmin4/login?next=%2Fpgadmin4%2F

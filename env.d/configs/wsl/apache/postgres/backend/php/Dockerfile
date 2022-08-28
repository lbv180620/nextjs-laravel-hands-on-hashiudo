FROM node:14-buster as node
FROM php:7.4-apache-buster
SHELL ["/bin/bash", "-oeux", "pipefail", "-c"]

# timezone environment
ENV TZ=Asia/Tokyo \
	# locale
	LANG=ja_JP.UTF-8 \
	LANGUAGE=ja_JP:ja \
	LC_ALL=ja_JP.UTF-8 \
	# composer environment
	COMPOSER_ALLOW_SUPERUSER=1 \
	COMPOSER_HOME=/composer

# composer command
COPY --from=composer:2.0 /usr/bin/composer /usr/bin/composer
# node command
COPY --from=node /usr/local/bin /usr/local/bin
# npm command
COPY --from=node /usr/local/lib /usr/local/lib
# yarn command
COPY --from=node /opt /opt

RUN apt-get update && \
	apt-get -y install --no-install-recommends git vim libicu-dev libonig-dev libzip-dev unzip locales sudo libpq-dev && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/* && \
	locale-gen ja_JP.UTF-8 && \
	localedef -f UTF-8 -i ja_JP ja_JP.UTF-8 && \
	a2enmod rewrite && \
	docker-php-ext-install intl opcache pdo pdo_pgsql pgsql zip bcmath && \
	composer config -g process-timeout 3600 && \
	composer config -g repos.packagist composer https://packagist.org && \
	# xdebug
	pecl install xdebug && \
	docker-php-ext-enable xdebug && \
	# redis
	pecl install redis && \
	docker-php-ext-enable redis

COPY ./infra/docker/backend/php/php.ini /usr/local/etc/php/php.ini
COPY ./infra/docker/backend/php/conf.d/xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini
COPY ./infra/docker/backend/apache/httpd.conf /etc/apache2/sites-available/000-default.conf

WORKDIR /work/backend

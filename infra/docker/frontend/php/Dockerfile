FROM node:14-buster as node
FROM php:7.4-apache-buster
SHELL ["/bin/bash", "-oeux", "pipefail", "-c"]

# timezone environment
ENV TZ=Asia/Tokyo \
    # locale
    LANG=ja_JP.UTF-8 \
    LANGUAGE=ja_JP:ja \
    LC_ALL=ja_JP.UTF-8

# node command
COPY --from=node /usr/local/bin /usr/local/bin
# npm command
COPY --from=node /usr/local/lib /usr/local/lib
# yarn command
COPY --from=node /opt /opt

RUN apt-get update && \
    apt-get -y install --no-install-recommends git vim libicu-dev libonig-dev libzip-dev unzip locales && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    locale-gen ja_JP.UTF-8 && \
    localedef -f UTF-8 -i ja_JP ja_JP.UTF-8 && \
    a2enmod rewrite

COPY ./infra/docker/frontend/php/php.ini /usr/local/etc/php/php.ini
COPY ./infra/docker/frontend/apache/httpd.conf /etc/apache2/sites-available/000-default.conf

WORKDIR /work/frontend

# FROM mariadb:10.3.34
FROM mariadb:10.4.13

# timezone environment
ENV TZ=Asia/Tokyo \
    # locale
    LANG=ja_JP.UTF-8 \
    LANGUAGE=ja_JP:ja \
    LC_ALL=ja_JP.UTF-8

RUN apt-get update && \
    apt-get -y install --no-install-recommends git vim libicu-dev libonig-dev libzip-dev unzip locales && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    locale-gen ja_JP.UTF-8 && \
    localedef -f UTF-8 -i ja_JP ja_JP.UTF-8

COPY ./infra/docker/backend/mysql/mariadb.conf.d /etc/mysql/mariadb.conf.d

WORKDIR /var/lib/mysql

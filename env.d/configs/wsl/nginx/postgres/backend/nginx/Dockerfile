FROM node:16-alpine as node
# FROM node:16-buster as node
# FROM node:14-buster as node
FROM nginx:1.20-alpine
SHELL ["/bin/ash", "-oeux", "pipefail", "-c"]

ENV TZ=Asia/Tokyo

RUN apk update && \
  apk add --update --no-cache --virtual=.build-dependencies g++

# node command
COPY --from=node /usr/local/bin /usr/local/bin
# npm command
COPY --from=node /usr/local/lib /usr/local/lib
# yarn command
COPY --from=node /opt /opt
# nginx config file
COPY ./infra/docker/backend/nginx/*.conf /etc/nginx/conf.d/

WORKDIR /work/backend

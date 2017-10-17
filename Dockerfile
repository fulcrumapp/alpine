FROM ruby:2.4.2-alpine3.6

ENV APP_PATH /app

RUN mkdir -p $APP_PATH \
 && apk update \
 && apk add --virtual .sni-nodejs \
      nodejs \
      nodejs-npm \
 && npm install -g yarn \
 && apk add --virtual .sni-build-tools \
      alpine-sdk \
 && apk add --virtual .sni-postgres-dev \
    postgresql-dev \
 && apk add --virtual .sni-development-tools \
      postgresql-client \
      postgresql \
      ca-certificates \
      wget \
      bash \
      gawk \
      sed \
      grep \
      bc \
      coreutils \
      git \
 && rm -rf /var/cache/apk/*

WORKDIR $APP_PATH

CMD ['bash']

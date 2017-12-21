FROM mhart/alpine-node:8 AS alpine-node

FROM ruby:2.4.2-alpine3.6

COPY --from=alpine-node /usr/bin/node /usr/bin/
COPY --from=alpine-node /usr/local/share/yarn /usr/local/share/yarn
COPY --from=alpine-node /usr/lib/libgcc* /usr/lib/libstdc* /usr/lib/
COPY --from=alpine-node /usr/lib/node_modules /usr/lib/node_modules

ENV APP_PATH /app

ADD . /sni

RUN mkdir -p $APP_PATH \
 && apk update \
 && apk add --virtual .sni-build-tools \
      alpine-sdk \
      linux-headers \
 && apk add --virtual .sni-postgres-dev \
      postgresql-dev \
 && apk add --virtual .sni-development-tools \
      ca-certificates \
      wget \
      bash \
      gawk \
      sed \
      grep \
      bc \
      coreutils \
      git \
      less \
 && /sni/setup-node.sh \
 && apk add postgresql \
   && cp /usr/bin/psql /usr/bin/pg_dump /usr/bin/pg_dumpall /usr/bin/pg_restore /usr/local/bin/ \
   && apk del postgresql \
 && rm -rf /var/cache/apk/*

WORKDIR $APP_PATH

CMD ['bash']

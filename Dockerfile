FROM mhart/alpine-node:8 as NODE

FROM ruby:2.4-alpine

ENV APP_PATH /app

# Keep in sync with uninstall-node.sh
COPY --from=NODE /usr/include/node /usr/include/node
COPY --from=NODE /usr/lib/libgcc* /usr/lib/libstdc* /usr/lib/
COPY --from=NODE /usr/lib/node_modules /usr/lib/node_modules
COPY --from=NODE /usr/local/share/yarn /usr/local/share/yarn
COPY --from=NODE /usr/bin/node /usr/bin/

COPY uninstall-node.sh /usr/bin/uninstall-node

RUN chmod +x /usr/bin/uninstall-node \
 && ln -s /usr/lib/node_modules/npm/bin/npm-cli.js /usr/bin/npm \
 && ln -s /usr/lib/node_modules/npm/bin/npx-cli.js /usr/bin/npx \
 && ln -s /usr/local/share/yarn/bin/yarn /usr/local/bin/yarn \
 && ln -s /usr/local/share/yarn/bin/yarnpkg /usr/local/bin/yarnpkg \
 && mkdir -p $APP_PATH \
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
      python \
 && apk add postgresql \
 && rm -rf /var/cache/apk/*

WORKDIR $APP_PATH

CMD ["bash"]

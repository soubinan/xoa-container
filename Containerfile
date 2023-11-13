# Build base
FROM node:21 as build_base

RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y build-essential libpng-dev git gettext libvhdi-utils \
        python3-minimal python3-jinja2 python3-vmdkstream lvm2 nfs-common cifs-utils curl ntfs-3g dmidecode \
        apt-transport-https ca-certificates gnupg && \
    apt-get clean


# Run base
FROM node:21-slim as run_base

RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y libpng-dev python3-minimal libvhdi-utils lvm2 cifs-utils nfs-common ntfs-3g tzdata && \
    apt-get clean

# Build stage
FROM build_base as build_xoa

RUN git clone -b master --depth 1 https://github.com/vatesfr/xen-orchestra /app

WORKDIR /app

# Send the issue to me in case of issue
RUN sed -i "s|<a href='https://github.com/vatesfr/xen-orchestra/issues/new/choose'>|<a href='https://github.com/soubinan/xen-orchestainer/issues/new/choose'>|" packages/xo-web/src/xo-app/about/index.js

RUN yarn install --non-interactive --network-timeout 1000000 && \
    npx sass-migrator division **/*.scss && \
    yarn build

# Cleanup
RUN rm -rf node_modules && \
    yarn install --non-interactive --prod && \
    npx sass-migrator division **/*.scss && \
    yarn autoclean --init && yarn autoclean --force && \
    yarn cache clean && rm -rf .yarn

# Run stage
FROM run_base as run_xoa
LABEL maintainer="https://github.com/soubinan"

COPY --from=build_xoa /app /app

# Set plugins links
RUN find /app/packages/ -maxdepth 1 -mindepth 1 -name "xo-server-*" -not -name "xo-server-test" -exec ln -s {} /app/packages/xo-server/node_modules \;
RUN mkdir -p /etc/xo-server &&\
    cp /app/packages/xo-server/config.toml /etc/xo-server/config.toml

ARG XOWEB=latest \
    XOSERVER=latest

ENV TZ=UTC

LABEL xo-server=$XOSERVER \
    xo-web=$XOWEB

# Send the logs to stdout
RUN ln -sf /proc/1/fd/1 /var/log/xo-server.log && \
    ln -sf /proc/1/fd/1 /var/log/syslog.log

RUN ln -fs /usr/share/zoneinfo/${TZ} /etc/localtime && \
    dpkg-reconfigure --frontend noninteractive tzdata

WORKDIR /app/packages/xo-server
VOLUME [ "/etc/xo-server", "/var/lib/xo-server", "/var/lib/xoa-backup" ]

EXPOSE 8080

CMD ["node", "dist/cli.mjs"]
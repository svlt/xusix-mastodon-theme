FROM ghcr.io/linuxserver/baseimage-alpine-nginx:3.22 AS build

ARG BUILD_DATE
ARG VERSION
ARG MASTODON_VERSION
LABEL build_version="Xusix version:- ${VERSION} Build-date:- ${BUILD_DATE}"

ENV RAILS_ENV="production" \
    NODE_ENV="production" \
    PATH="${PATH}:/app/www/bin" \
    S6_STAGE2_HOOK="/init-hook" \
    MASTODON_USE_LIBVIPS="true"

RUN \
    apk add --no-cache \
    ffmpeg \
    file \
    libpq \
    libidn \
    nodejs \
    ruby \
    ruby-bundler \
    ruby-rdoc \
    vips \
    yaml && \
    apk add --no-cache --virtual=build-dependencies \
    build-base \
    icu-dev \
    libidn-dev \
    libpq-dev \
    libxml2-dev \
    libxslt-dev \
    linux-headers \
    npm \
    openssl-dev \
    ruby-dev \
    vips-dev \
    yaml-dev && \
    echo "**** install mastodon ****" && \
    mkdir -p /app/www && \
    if [ -z ${MASTODON_VERSION+x} ]; then \
    MASTODON_VERSION=$(curl -sX GET "https://api.github.com/repos/mastodon/mastodon/releases/latest" \
    | awk '/tag_name/{print $4;exit}' FS='[""]'); \
    fi && \
    curl -s -o \
    /tmp/mastodon.tar.gz -L \
    "https://github.com/mastodon/mastodon/archive/${MASTODON_VERSION}.tar.gz" && \
    tar xf \
    /tmp/mastodon.tar.gz -C \
    /app/www/ --strip-components=1 && \
    rm -rf /tmp/* && \
    cd /app/www && \
    bundle config set --local deployment 'true' && \
    bundle config set --local without 'development test exclude' && \
    bundle config set silence_root_warning true && \
    bundle install -j"$(nproc)" --no-cache && \
    npm install -g corepack && \
    corepack enable && \
    yarn workspaces focus --production @mastodon/mastodon

# Add theme files
COPY --chown=1000:1000 app/javascript/ /app/www/app/javascript/
COPY --chown=1000:1000 public/ /app/www/public/
RUN echo 'xusix: styles/xusix.scss' >> /app/www/config/themes.yml

RUN \
    cd /app/www && \
    ACTIVE_RECORD_ENCRYPTION_DETERMINISTIC_KEY=precompile_placeholder \
    ACTIVE_RECORD_ENCRYPTION_KEY_DERIVATION_SALT=precompile_placeholder \
    ACTIVE_RECORD_ENCRYPTION_PRIMARY_KEY=precompile_placeholder \
    OTP_SECRET=precompile_placeholder \
    SECRET_KEY_BASE=precompile_placeholder \
    bundle exec rails assets:precompile && \
    bundle exec bootsnap precompile --gemfile app/ lib/ && \
    rm -rf /app/www/node_modules

FROM lscr.io/linuxserver/mastodon:latest AS production

LABEL org.opencontainers.image.source="https://github.com/svlt/xusix-mastodon-theme"

COPY --from=build /app/www/public/ /app/www/public/
COPY --from=build /app/www/config/themes.yml /app/www/config/themes.yml
COPY app/javascript/images/ /app/www/app/javascript/images/

FROM abiosoft/caddy as caddy

## Build our project
FROM composer as builder

WORKDIR /app
COPY composer.json composer.lock /app/

RUN composer install --no-autoloader

# Copy codebase
COPY . /app/

# Finish composer
RUN composer dump-autoload

## php-fpm image
FROM php:fpm-alpine

RUN apk add --no-cache \
    $PHPIZE_DEPS \
    curl-dev \
    imagemagick-dev \
    libtool \
    libxml2-dev \
    postgresql-dev \
    sqlite-dev \
    bash \
    curl \
    g++ \
    gcc \
    git \
    imagemagick \
    libc-dev \
    libpng-dev \
    make \
    mysql-client \
    openssh-client \
    postgresql-libs \
    rsync \
    zlib-dev \
    libzip-dev

# Install PECL and PEAR extensions
RUN pecl install \
    imagick

# Install and enable php extensions
RUN docker-php-ext-enable \
    imagick
RUN docker-php-ext-configure zip --with-libzip
RUN docker-php-ext-install \
    curl \
    iconv \
    mbstring \
    pdo \
    pdo_mysql \
    pdo_pgsql \
    pdo_sqlite \
    pcntl \
    tokenizer \
    xml \
    gd \
    zip \
    bcmath

WORKDIR /app
COPY --from=builder /app /app/
RUN chown -R www-data:www-data /app/bootstrap /app/storage

COPY --from=caddy /usr/bin/caddy /usr/bin/caddy
COPY ./deploy/config/Caddyfile /etc/Caddyfile
CMD caddy --conf /etc/Caddyfile

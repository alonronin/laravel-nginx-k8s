## Build our project
FROM composer as builder

WORKDIR /var/www/html
COPY composer.json composer.lock /var/www/html/

RUN composer install --prefer-dist --no-scripts --no-dev --no-autoloader && rm -rf /root/.composer

# Copy codebase
COPY . /var/www/html/

# Finish composer
RUN composer dump-autoload --no-scripts --no-dev --optimize

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

WORKDIR /var/www/html
COPY --from=builder /var/www/html /var/www/html/
RUN chown -R www-data:www-data /var/www/html # /{bootstrap,storage}

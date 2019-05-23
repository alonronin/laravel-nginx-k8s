FROM composer

WORKDIR /app

COPY . /app/

RUN composer install

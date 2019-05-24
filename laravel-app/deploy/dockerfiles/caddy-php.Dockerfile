FROM abiosoft/caddy:php as caddy

WORKDIR /app

COPY composer.json composer.lock /app/

RUN composer install --no-autoloader

COPY . /app/

RUN composer dump-autoload

COPY ./deploy/config/Caddyfile-php /etc/Caddyfile

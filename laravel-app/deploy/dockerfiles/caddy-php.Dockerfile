FROM abiosoft/caddy:php as caddy

WORKDIR /app

COPY composer.json composer.lock /app/

RUN composer install --no-autoloader

COPY . /app/

RUN composer dump-autoload
RUN chown -R www-user:www-user /app/bootstrap /app/storage

COPY ./deploy/config/Caddyfile-php /etc/Caddyfile

FROM abiosoft/caddy:php as caddy

COPY composer.json composer.lock /srv/app/

RUN composer install --no-autoloader

COPY . /srv/app/

RUN composer dump-autoload

COPY ./deploy/config/Caddyfile-php /etc/Caddyfile

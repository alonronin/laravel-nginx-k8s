FROM abiosoft/caddy:php as caddy

COPY composer.json composer.lock /srv/

RUN composer install --no-autoloader

COPY . /srv/

RUN composer dump-autoload

COPY ./deploy/config/Caddyfile-php /etc/Caddyfile

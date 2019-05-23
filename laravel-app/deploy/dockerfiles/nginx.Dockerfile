FROM nginx

COPY ./public /var/www/html/public/
COPY ./deploy/config/nginx.conf /etc/nginx/conf.d/default.conf

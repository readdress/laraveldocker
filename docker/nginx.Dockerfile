FROM nginx:1.18-alpine

COPY ./docker/nginx.conf /etc/nginx/conf.d/default.conf
COPY ./ /var/www

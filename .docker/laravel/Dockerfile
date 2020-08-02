#@version 3.7.5

FROM php:7.4.8-fpm-alpine3.12 as base
MAINTAINER Yuri Koster <yurikoster1@gmail.com>

RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

RUN apk add  --no-cache nodejs npm
RUN docker-php-ext-install mysqli pdo pdo_mysql && docker-php-ext-enable mysqli pdo_mysql pdo

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

EXPOSE 9000


RUN apk add --no-cache shadow
#RUN apk add mysql-client
RUN usermod -u 1000 www-data

USER www-data

ENTRYPOINT ["php-fpm"]

FROM base as develop
USER root
COPY .docker/laravel/entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh
RUN apk add --no-cache wait4ports
RUN apk add mysql-client
RUN usermod -u 1000 www-data

USER www-data

ENTRYPOINT ["/docker-entrypoint.sh"]

FROM develop as builder
COPY ./www /var/www/html

WORKDIR /var/www/html

RUN composer install \
    && cp .env.example .env \
    && php artisan key:generate \
    && php artisan config:clear \
    && npm install \
    && npm audit fix \
    && npm run prod

ENTRYPOINT ["php-fpm"]

FROM php:7.4.8-fpm-alpine3.12 as laravel_publish
RUN docker-php-ext-install pdo pdo_mysql && docker-php-ext-enable pdo_mysql pdo
EXPOSE 9000
WORKDIR /var/www/
COPY --from=builder /var/www/ .
WORKDIR /var/www/html
COPY ./.docker/laravel/entrypoint-prod.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
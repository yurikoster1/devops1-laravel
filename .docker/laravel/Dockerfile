#@version 3.7.5

FROM php:7.4.8-fpm-alpine3.12 AS base
MAINTAINER Yuri Koster <yurikoster1@gmail.com>

RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

RUN docker-php-ext-install mysqli pdo pdo_mysql && docker-php-ext-enable mysqli pdo_mysql pdo

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

EXPOSE 9000

COPY ./entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh
RUN apk add --no-cache shadow wait4ports
#RUN apk add mysql-client
RUN usermod -u 1000 www-data

USER www-data

ENTRYPOINT ["/docker-entrypoint.sh"]
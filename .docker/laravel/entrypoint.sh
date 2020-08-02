#!/bin/sh

echo "-- Running entrypoint";
echo "-- Running ls";
ls /var/www/html;

CONTAINER_ALREADY_STARTED="CONTAINER_ALREADY_RAN_ONCE"

if [ ! -e $CONTAINER_ALREADY_STARTED ]; then
    touch $CONTAINER_ALREADY_STARTED
    echo "-- Running composer install";

    cd /var/www/html;

    composer install;

    echo "-- Container first time for its first time"
    if [ ! -e ".env" ]; then
	    echo "-- Copying .env file from .env.example"
	    cp .env.example .env;
    fi
    echo "-- Generating key";

    if [[ -z "${APP_KEY}" ]]; then
        php artisan key:generate;
    fi
    php artisan config:cache;

    composer dump-autoload;
    DBHOST="${DB_HOST:-devops_1_app-database}"
    DBPORT="${DB_PORT:-3306}"
    wait4ports -t 200 -s 10 tcp://${DBHOST}:${DBPORT} && php artisan migrate && php artisan db:seed;

else
    echo "-- Container already run. No need to be reconfigured"
fi

php-fpm
#!/bin/sh

echo "-- Running entrypoint";

php artisan config:cache;

php-fpm
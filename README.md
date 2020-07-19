# devops1-laravel
Repository made for Course on https://code.education/cursos-online/

DevOps module, Docker unit, Exercise 1 of http://lancamento.fullcycle.com.br/

## Image Link for the exercise
https://hub.docker.com/repository/docker/yurikoster1/devops1_laravel

## Containers
This repository contains a docker-compose file that runs the following containers

### laravel_app
Based on the alpine version of php-fpm this container runs the php-fpm service mapping the 9000 port to the host.
It contains composer and wait4ports installed and both programs are use in the entry point script
The entry point script will check for the existence of a file named `"CONTAINER_ALREADY_RAN_ONCE"` to ascertain if this is the first time the container has run.
If the file does not exist, it will run composer install to install all dependencies,
 then it will check for the existence of the `.env` file, should it not exist it will create it based on a copy of the `.env.example` file.
Then the container will check if an environment variable named `"APP_KEY"` exists if it does not it runs the `php artisan key:generate` command to generate a key for the laravel application.
It will then cache the configurations using the `php artisan config:cache` command.
After that the script will recreate the composer autoload file.
Then using the `wait4ports` program and the DB_HOST and DB_PORT environment variables it will wait for the mysql container to finish starting before running the commands `php artisan migrate && php artisan db:seed` to create the tables and populate them with initial data.
This container expects the following environment variables to function correctly:
* DB_PASSWORD
* DB_HOST
* DB_PORT
* REDIS_HOST

These variables are set in the `.env` file used by the `docker-compose.yml` file located in the root of this repository.
Should one wish to run multiple instances of this container pointing to the same database one can use the `APP_KEY` environment variable to keep the laravel key the same between instances. 
### laravel_nginx
Based on the alpine version of nginx version 1.19.1 image, this container uses templates to parse several environment variables into its configuration files.
The expected variables are the following:
* NGINX_ROOT
* NGINX_HOST
* NGINX_PORT
* PHP_SERVICE_NAME
* PHP_SERVICE_PORT

Should these variables not be set the entry point script on this container will set some default values for these variables, and some behavior is changed.
When the  first three variables are not set they will have the following default values:
* NGINX_ROOT : "/var/www/html/"
* NGINX_HOST : "localhost"
* NGINX_PORT : "80"

Should the PHP related variables be missing the configuration file that deals with php will not be included in the active configuration files, thus disabling php entirely.
### laravel_mysql
This container simply uses the latest version of MySQL running with the user uid 1000 added to the mysql group.
The data for the database inside this container is mounted to a local volume in the `.docker/mysql/data` folder. This folder is added empty to this repository and is populated at runtime.
The password for both users and the database name are set in the `.env` file used by the `docker-compose.yml` file located in the root of this repository.
The `docker` user is added at runtime and used in the laravel configuration to access the database.

### laravel_redis
This container uses the `redis:alpine` image without modification

## Labels
All containers, volumes and networks created by this repository have the `yuri.project.name` label with its value being derived from the `.env` file used by the `docker-compose.yml` file located in the root of this repository.

## Down & Destory script
On the root of this repository there is a bash script that is used to facilitate the return of the containers to their initial state.
This script will run the `docker-compose down -v` command followed by `docker volume prune --filter label=yuri.project.name=laravel_app -f` to insure all containers, networks and volumes are deleted.
Then it will remove all data from the `.docker/mysql/data` folder deleting the MySQL database.
Finally, it will remove all log files from laravel and the  ` "CONTAINER_ALREADY_RAN_ONCE"` file to force the laravel container entry point script to re-run all tasks.
It will however *not* delete the vendor folder used by composer or the `.env` file or the cache files created by laravel itself.

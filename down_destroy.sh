#!/usr/bin/env bash

docker-compose down -v;

docker volume prune --filter label=yuri.project.name=laravel_app -f;
rm -R .docker/mysql/data/*

#sudo chmod a+rw -R .;

rm www/storage/logs/*.log || echo "no log files found in devops_1_app";

rm www/CONTAINER_ALREADY_RAN_ONCE || echo "no need to reset container devops_1_app";
#!/usr/bin/bash

cd db/

docker compose down --volumes

docker stop $(docker ps -q)

docker rm $(docker ps -aq)

docker network prune

docker volume prune

docker ps -a

docker network ls
docker volume ls
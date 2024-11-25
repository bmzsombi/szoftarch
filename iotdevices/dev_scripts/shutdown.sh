#!/usr/bin/bash


docker compose down --volumes

docker stop $(docker ps -q)

docker rm $(docker ps -aq)

docker network prune -f

docker volume prune -f

docker ps -a

docker network ls
docker volume ls

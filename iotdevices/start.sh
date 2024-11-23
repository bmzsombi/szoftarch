#!/usr/bin/bash

cd db/

docker compose up -d

sleep 5

cd ..

docker build -t device-simulator:latest .

docker build -t device-monitor:latest -f Dockerfile.monitor .

python3 validator.py test.yaml

python3 parsetodb.py test.yaml



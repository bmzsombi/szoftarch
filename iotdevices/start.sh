#!/usr/bin/bash

cd /home/adam/Documents/BME/MSc/felev2/szoftverarchritekturak/HF/iotdevices/db/

docker compose up -d

sleep 5

cd /home/adam/Documents/BME/MSc/felev2/szoftverarchritekturak/HF/iotdevices/

docker build -t device-simulator:latest .

docker build -t device-monitor:latest -f Dockerfile.monitor .

python3 validator.py test.yaml

python3 parsetodb.py test.yaml



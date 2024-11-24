#!/usr/bin/bash


docker build -t device-simulator:latest -f Dockerfile.device-simulator .

docker build -t device-monitor:latest -f Dockerfile.monitor .




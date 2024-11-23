#!/usr/bin/bash


docker build -t device-simulator:latest .

docker build -t device-monitor:latest -f Dockerfile.monitor .




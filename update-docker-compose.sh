#!/usr/bin/env sh
cd $(dirname $0)/../../autolab-docker
# Updating Your Docker Compose Deployment
sudo docker compose stop
sudo make update
sudo docker compose build
sudo docker compose up -d

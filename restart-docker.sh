#!/usr/bin/env sh
cd $(dirname $0)/../autolab-docker
sudo docker compose stop
sudo docker compose up -d

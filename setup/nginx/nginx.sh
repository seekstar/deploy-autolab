#!/usr/bin/env sh
sudo mkdir -p /etc/nginx/http.d/
sudo cp 80.conf /etc/nginx/http.d/
sudo mkdir -p /etc/nginx/location.d/80
sudo cp 301.conf /etc/nginx/location.d/80/

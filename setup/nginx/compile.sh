#!/usr/bin/env sh
ori=$(pwd)
mkdir -p ~/Downloads
cd ~/Downloads
latest=$(curl https://nginx.org/download/ | grep ".tar.gz\"" | awk -F\" '{print $2}' | sort -V | tail -n 1)
wget -c http://nginx.org/download/"$latest"
tar zxf "$latest"
cd $(basename "$latest" .tar.gz)
./configure --with-http_ssl_module --with-http_v2_module --with-stream --with-stream_ssl_preread_module
make
sudo make install

cd "$ori"
sudo mv /usr/local/nginx/conf/nginx.conf /usr/local/nginx/conf/nginx.conf.$(date +%Y%m%d%H%M%S)
sudo cp nginx.conf /usr/local/nginx/conf/nginx.conf
sudo cp nginx.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable nginx
sudo systemctl start nginx

#!/usr/bin/env sh
if [ $# -ne 2 ]; then
	echo Usage: $0 email autolab-domain
	exit 1
fi
email=$1
autolab_domain=$2
mydir=$(realpath $(dirname $0))

cd "$mydir"/setup
cd acme
./acme.sh $email
./req.sh "$autolab_domain"
res=$?
# 2 means the cert exists and is quite new
if [ $res -ne 0 -a $res -ne 2 ]; then
	exit $res
fi
cd ..
./docker.sh
cd nginx
./compile.sh
./nginx.sh
cd ../../..

# https://docs.autolabproject.com/installation/docker-compose/#installation
if [ ! -d autolab-docker ]; then
	git clone --recurse-submodules -j8 https://github.com/autolab/docker.git autolab-docker
fi
cd autolab-docker
sed "s/autolab_domain/$autolab_domain/g" "$mydir"/setup/app-template.conf > nginx/app.conf
sed "s/autolab_domain/$autolab_domain/g" "$mydir"/setup/docker-compose-template.yml > docker-compose.yml
sed "s/ec2-user/$USER/g" .env.template > .env
if [ ! -f ssl/ssl-dhparams.pem ]; then
	openssl dhparam -out ssl/ssl-dhparams.pem 2048
fi
sudo make update
sudo make
sudo docker compose build
sudo docker compose up -d
sudo make set-perms
sudo make db-migrate
sudo make create-user

cd Tango
sudo rm config.py
cp $mydir/setup/config.py .
cd ..

cd $mydir
./restart-docker.sh
cd setup
sudo sh -c "sed \"s/autolab_domain/$autolab_domain/g\" autolab-template.conf > /etc/nginx/http.d/autolab.conf"
sudo systemctl reload nginx
sudo cp restart-autolab.sh reload-nginx.sh /root/.acme.sh/autolab/autolab.db.iiis.io/renew-hooks/
cd ..

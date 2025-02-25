#!/usr/bin/env sh
if [ ! "$1" ]; then
	echo Usage: $0 email
	exit 1
fi
sudo bash -c "
	shopt -s expand_aliases
	curl https://get.acme.sh | sh
	cd ~
	. ~/.acme.sh/acme.sh.env
	acme.sh --register-account --server zerossl -m $1
	mkdir ~/.acme.sh/autolab
"

sudo mkdir -p /var/www/acme-challenge/
sudo cp acme.conf /etc/nginx/location.d/80/
sudo systemctl reload nginx

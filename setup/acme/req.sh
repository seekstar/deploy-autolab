#!/usr/bin/env sh
if [ ! "$1" ]; then
	echo Usage: $0 \<domain\>
	exit 1
fi
# Zerossl does not support autolab.db.iiis.io
sudo su -c "cd /root/.acme.sh && mkdir -p autolab/$1/{renew-hooks,post-hooks} && . acme.sh.env && ./acme.sh --server letsencrypt --issue --webroot /var/www/acme-challenge/ --standalone -d $1 --renew-hook \"
	cd /root/.acme.sh/autolab/$1/renew-hooks && find . -mindepth 1 -exec {} \;
\" --post-hook \"
	cd /root/.acme.sh/autolab/$1/post-hooks && find . -mindepth 1 -exec {} \;
\""
exit $?

#!/usr/bin/env sh
if [ ! $1 ]; then
	echo Usage: $0 domain-name
	exit 1
fi
ACME=/root/.acme.sh
cd $ACME
if [ -d $1_ecc ]; then
	echo $ACME/$1_ecc
elif [ -d $1 ]; then
	echo $ACME/$1
else
	echo Certificate of $1 not found 1>&2
	exit 1
fi

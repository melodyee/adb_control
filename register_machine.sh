#!/bin/bash

private=id_rsa
public=id_rsa.pub
srcdir=./
destdir=~/.ssh

if [ ! -z $1 ]; then
	srcdir=$1
fi

# create ssh directory
if [ ! -d ${destdir} ]; then
	mkdir -p ${destdir}
fi

# check key file
if [ ! -e ${srcdir}/${private} -o ! -e ${srcdir}/${public} ]; then
	echo key file is not found.
	exit
fi

# copy key file
cp -f ${srcdir}/${private} ${destdir}
cp -f ${srcdir}/${public} ${destdir}

# file atrribute
chmod 600 ${destdir}/${private}
chmod 644 ${destdir}/${public}
sync

# add key
ssh-add

echo ssh configuration is completed.

#!/bin/bash

echo login hover...

# control adb
echo ""
host_path=~/.ssh/known_hosts
ssh-keyscan -H 192.168.1.1 >> $host_path

read -p "Is adb enable ? [y/n] " data confirm
if [ "${data}" == "n" ]; then
	echo adb is disable.
	ssh root@192.168.1.1 '/home/linaro/adb/change_mode 0'
else
	echo adb is enable.
	ssh root@192.168.1.1 '/home/linaro/adb/change_mode 1'
fi

echo adb configuration is completed.

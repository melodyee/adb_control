#!/bin/sh


ack_no_or_yes(){
	local q="$1"
	while true; do
		read -p "$q" yn
		case $yn in
			[Yy]* ) return 1; ;;
			[Nn]* ) return 0; ;; 
			* ) echo "Please answer yes or no.";;
		esac
	done
}

echo "
Welcome to

##   ##   ####   ##  ##  ######  ######
##   ##  ##  ##  ##  ##  ##      ##   ##
##   ##  ##  ##  ##  ##  ##      ##   ##
#######  ##  ##  ##  ##  ######  #####
##   ##  ##  ##  ##  ##  ##      ##  ##
##   ##  ##  ##   ####   ##      ##   ##
##   ##   ####     ##    ######  ##    ##

This setup configures your system, so that you can use Hover camera with it.

"

if ack_no_or_yes "Continue setup?" ; then
	exit 1;
fi

SUDO=""
if [ `id -u` != "0" ] ; then
	if ack_no_or_yes "You are not root. I will try to use sudo. Continue?" ; then
		exit 1;
	fi
	SUDO="sudo "
fi

RULES_DIR=/etc/udev/rules.d
RULES_FILE=51.android.rules

if [ ! -d "$RULES_DIR" ] ; then
	echo "Udev rules directory '$RULES_DIR' does not exist. I don't know how to proceed.
You should manually ensure that the usb camera you want to use if accessible by the user.
Normally this is done by installing a udev rule link this one:
$(readlink -f $RULE_FILE)
"
	exit 1
fi

echo "
Installing udev rules to $RULES_DIR/$RULES_FILE"

$SUDO cp $RULES_FILE $RULES_DIR

if [ -f "/usr/share/hwdata/usb.ids" ] ; then
	FILE=/usr/share/hwdata/usb.ids
elif [ -f "/usr/share/usb.ids" ] ; then
	FILE=/usr/share/usb.ids
elif [ -f "/usr/share/misc/usb.ids" ] ; then
	FILE=/usr/share/misc/usb.ids
fi

if [ -f "$FILE" ] ; then
	echo ""
	echo "Checking if $FILE must be updated"
	LINE_START=`grep -n -m 1 ZEROZERO_START $FILE | cut -d: -f1`
	LINE_END=`grep -n -m 1 ZEROZERO_END $FILE | cut -d: -f1`

	if [ -n "$LINE_START" -a -n "$LINE_END" ] && [ "$LINE_START" -lt "$LINE_END" ] ; then
		echo "Remove old zerozero device entries from $FILE"
		cp $FILE usb.ids.old
		$SUDO sed -i -e "$LINE_START,$LINE_END d"
	fi

	FOUND=`grep -e '^2cc0' $FILE || true`

	if [ -n "$FOUND" ] ; then
		echo  "Your usb hardware database is up to data. Nothing to do."
	else
		echo "Add zerozero device entries to $FILE"
	$SUDO sh -c "echo \"###ZEROZERO_START ##################################################
# These lines were automatically added.

2cc0 Hangzhou ZeroZero Infinity Technology Co., Ltd.
	0101 Hover Camera
###ZEROZERO_END ##################################################\" >> $FILE"
	fi

else
	echo ""
	echo "Couldn't locate the usb-ids database."
fi

echo ""
echo "Installation successful"
echo ""


if ack_no_or_yes "Are you ZeroZero RD?" ; then
	exit 1;
fi

echo "
refresh adb config for new usb descriptor(after v.2016/3/24)"

ADB_INI_FILE=~/.android/adb_usb.ini

if [ -f "$ADB_INI_FILE" ] ; then
	echo "adb_usb.ini is exist."
else
	touch $ADB_INI_FILE 
	echo "I have create $ADB_INI_FILE."
fi

ADB_FOUND=`grep -e '^0x2cc0' $ADB_INI_FILE || true`

if [ -n "$ADB_FOUND" ] ; then
	echo  "Your usb hardware database is up to data. Nothing to do."
else
	echo "Add zerozero device entries to $ADB_INI_FILE."
	sh -c "echo \"0x2cc0\" >> $ADB_INI_FILE"
fi

adb kill-server
adb start-server
	echo "finish to config adb."

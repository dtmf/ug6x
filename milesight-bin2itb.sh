#!/bin/sh
#
# Convert Milesight UG65/UG67 proprietary BIN firmware format
# to "FIT" image that can be installed from U-Boot
#
# This script requires the 'u-boot-tools' package
#
# works on 60.0.0.38 through 60.0.0.41-r4 and maybe others
#

if [ $# -ne 1 ]
then
	echo "Usage: $0 file.bin"
	exit 1
fi

FILE=$(expr $1 : "\(.*\)\.bin$")

if [ ! "$FILE" ]
then
	echo "$0: file must have .bin extension"
	exit 1
fi

dd if=$FILE.bin bs=1024 skip=1 of=$FILE.zip
PW=$(echo cWF6eGN2dmZyZXdzZDMyMQo= | base64 -d)
unzip -P $PW -p $FILE.zip router.tar | tar xfz -
mkimage -f milesight-uImage.its $FILE.itb
rm -v uImage.itb rootfs.img firmware_info.txt $FILE.zip

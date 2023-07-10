#!/bin/sh
#
# Create GPT label (first 17408 bytes of eMMC)
#
# This script requires 'gdisk'
#

# values for ND67-L04AF-915M running 60.0.0.38
GPT_LEN=17408
MMC_LEN=3909091328

P1END=65569
P2END=589857
P3END=852001
P4END=884769

P1NAME="0:HLOS"
P2NAME="rootfs"
P3NAME="oem"
P4NAME="reset"
P5NAME="rootfs_data"

if [ $# -ne 1 ]
then
	echo "Usage: $0 file"
	exit 1
fi

FILE=$1

if [ -e $FILE ]
then
	echo "File $FILE already exists"
	exit 1
fi

# create sparse file the size of the MMC
dd if=/dev/zero of=$FILE bs=1 count=0 seek=$MMC_LEN

(
	# set sector alignment to 1
	echo "x\nl\n1\nd\nm"
	# partitions
	echo "n\n\n\n$P1END\n"
	echo "n\n\n\n$P2END\n"
	echo "n\n\n\n$P3END\n"
	echo "n\n\n\n$P4END\n"
	echo "n\n\n\n\n"
	# change names
	echo "c\n1\n$P1NAME"
	echo "c\n2\n$P2NAME"
	echo "c\n3\n$P3NAME"
	echo "c\n4\n$P4NAME"
	echo "c\n5\n$P5NAME"
	# display
	echo "p"
	# write
	echo "w\nY"
	# quit
	echo "q"
) | gdisk $FILE

truncate -s $GPT_LEN $FILE

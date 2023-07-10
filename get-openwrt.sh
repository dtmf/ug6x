#!/bin/sh

git clone https://github.com/dtmf/openwrt.git || exit

cd openwrt
./scripts/feeds update -a
./scripts/feeds install -a

# basicstation patches
for PATCH in ../patches-basicstation/*.patch
do
	patch -p1 < $PATCH
done

# sx1302_hal patches
cp -v ../patches-sx1302_hal/* feeds/packages/libs/sx1302_hal/patches/

# WIFI driver
cp -rv ../rtl8189fs package/kernel

# copy working config
cp -v ../ug6x.config .config

make defconfig

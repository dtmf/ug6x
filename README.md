# Install OpenWrt on Milesight UG65/UG67

This repo contains info and tools for installing OpenWrt (master branch) with
kernel 6.1 on a Milesight UG65/UG67 LoraWAN gateway.  (This has only been tested on a UG67.)

## What works

 - Semtech BasicStation (see notes.)

 - 4G, Ethernet, GPS, RTC, Temp/humidity sensor, Reset button, 4G LED, SYS LED

## Not working

 - WIFI. Uses old, out-of-tree driver. Requires custom scripts to work. Can't be configured with Luci.

## How to build

 This will create a FIT image (*uImage.itb) that can be installed from U-Boot, and a sysupgrade image (*sysupgrade.bin) that can be installed from the OpenWrt GUI or command line.

 - Install prerequisite packages for your build system.
   See [OpenWrt build system setup](https://openwrt.org/docs/guide-developer/toolchain/install-buildsystem)

 - Clone this repo
     ```
     git clone https://github.com/dtmf/ug6x.git
     cd ug6x
     ```

 - Run script to download OpenWrt and install patches
     ```
     ./get-openwrt.sh
     ```

 - Build OpenWrt
     ```
     cd openwrt
     make -j$(nproc)
     ```

## Create recovery image (optional - if you want to go back to OEM firmware)

 - Method 1 (Easy method)
   1. Download current OEM firmware
   2. Run script to convert OEM format (.bin extension) to a FIT image (.itb extension) that can be installed from U-Boot.
   3. Example: ./milesight-bin2itb.sh 60.0.0.41-r1.bin

 - Method 2
   1. Connect to console while running OEM firmware
   2. Copy GPT from eMMC: dd if=/dev/mmcblk0 bs=17408 count=1 of=/tmp/milesight-gpt.dat
   2. Copy kernel FIT image: dd if=/dev/mmcblk0p1 bs=64k of=/tmp/uImage.itb
   3. Copy rootfs: dd if=/dev/mmcblk0 bs=64k of=/tmp/rootfs.img
   4. Move above 3 files to computer where this repo is installed
   5. Use tools such as binwalk, hexdump to trim unused bytes at end of .itb and .img file.
   6. Run mkimage to create FIT image
      ```
      mkimage -f milesight-uImage.its output.itb
      ```

## Install

 OpenWrt must be installed from U-Boot. The Milesight UG6x gateways are running a
 fork of U-Boot with a feature to allow installing firmware using a web browser.

 - (Optional) Connect console cable to see status of upgrade process

 - While booting gateway, press and hold reset button for about 25 seconds, then let go. (SYS LED will be red.)

 - If you are watching on the console you will see:
   ```
   HTTP server is starting at IP: 192.168.23.150
   HTTP server is ready!
   ```

 - Set static IP on computer (example 192.168.23.2), and connect with browser to http://192.168.23.150

 - On the FIRMWARE UPDATE screen choose the new firmware and click "Update firmware"

## NOTES

  - sx1302_hal library 
     - This library tries to access a ST ts751 temperature sensor on the LoraWAN concentrator.
     - The UG67 doesn't have this sensor, but does have a SHT3x. I don't know if it's located on the concentrator.
     - For now a patch is used to create a "phantom sensor" which always returns 25(C).

  - luci-app-lorawan
     - The 'comif' option is set to USB (which is wrong) and cannot be changed in the GUI.
     - A patch is used to remove this option from the GUI.

  - Semtech BasicStation
     - Config file patches

  - CPU scaling? / DDR speed? / power save features?

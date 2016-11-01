#!/bin/bash

# Created by Neil Jubinville

# Script to prep the BeagleBoneBlack - Linux 4.1 Kernel with the PRU libs
# Currently test this with image https://debian.beagleboard.org/images/bone-debian-8.4-lxqt-4gb-armhf-2016-05-13-4gb.img.xz
# which is the latest on beagleboard.org

#update the kernel
cd /opt/scripts/tools && git pull && ./update_kernel.sh

# decompile the base device tree, note that after updating your kenel you will likely have an extra folder for the new kernel
# dtbs, at the time of writing this script my Jessie was updating to 4.4.27 so change it to match yours in the path.
cp /boot/dtbs/4.4.27-ti-r62/am335x-boneblack.dtb /boot/dtbs/4.4.27-ti-r62/am335x-boneblack.dtb_orig
dtc -I dtb -O dts /boot/dtbs/4.4.27-ti-r62/am335x-boneblack.dtb > /boot/dtbs/4.4.27-ti-r62/am335x-boneblack.dts_orig

apt-get update
apt-get install -y gcc-pru
apt-get install -y libelf-dev

# get interesting / supporting repos
git clone https://github.com/dinuxbg/pru-gcc-examples.git
git clone https://github.com/beagleboard/bb.org-overlays.git

#build the overlays
#git clone https://github.com/beagleboard/bb.org-overlays.git
#cd bb.org-overlays
#./dtc-overlay.sh
#./install.sh


#!/bin/bash

# Created by Neil Jubinville

# Script to prep the BeagleBoneBlack - Linux 4.1 Kernel with the PRU libs
# Currently test this with image https://debian.beagleboard.org/images/bone-debian-8.4-lxqt-4gb-armhf-2016-05-13-4gb.img.xz
# which is the latest on beagleboard.org

#prep the system
apt-get update
apt-get install -y gcc-pru
apt-get install -y libelf-dev

#update the kernel
cd /opt/scripts/tools && git pull && ./update_kernel.sh

#as per rnelson rebuild the dtbs with pru support as out ofthe box it is now longer supported, 
# the user needs to choose either uio_pruss or remote proc to enable otherwise it is in the blacklist.

#Essentially you need to edit one of the dts for the base dtb.  I am choosing to disable the HDMI for more pin access so that
#is why my overlay has just the emmc version.
git clone https://github.com/RobertCNelson/dtb-rebuilder 
export DTB=~/dtb-rebuilder/src/arm

sed -i -e 's/\/\* #include \"am33xx-pruss-rproc.dtsi\" \*\//#include \"am33xx-pruss-rproc.dtsi\"/'   $DTB/am335x-boneblack-emmc-overlay.dts
sed -i -e 's/#dtb=/dtb=am335x-boneblack-emmc-overlay.dtb/'  /boot/uEnv.txt

# get interesting / supporting repos
git clone https://github.com/dinuxbg/pru-gcc-examples.git
git clone https://github.com/beagleboard/bb.org-overlays.git

#build the overlays
#git clone https://github.com/beagleboard/bb.org-overlays.git
#cd bb.org-overlays
#./dtc-overlay.sh
#./install.sh




#!/bin/bash

# Created by Neil Jubinville

# Script to prep the BeagleBoneBlack - Linux 4.4.27 Kernel with the PRU libs and working PRU config
# Currently tested with image https://debian.beagleboard.org/images/bone-debian-8.4-lxqt-4gb-armhf-2016-05-13-4gb.img.xz
# which is the latest on beagleboard.org at the time of this script

#prep the system
apt-get update
apt-get install -y gcc-pru
apt-get install -y libelf-dev

#update the kernel
cd /opt/scripts/tools && git pull && ./update_kernel.sh --kernel 4.4.27-ti-r62

#setup an env variable.
echo "export slots=/sys/devices/platform/bone_capemgr/slots" >> ~/.bashrc

#as per rnelson rebuild the dtbs with pru support as out ofthe box it is now longer supported, 
# the user needs to choose either uio_pruss or remote proc to enable otherwise it is not enabled.  Strange that no pru support is enabled by default.

#Essentially you need to edit one of the dts for the base dtb.  Hear we edit the basic default dtb.
cd ~/ && git clone https://github.com/RobertCNelson/dtb-rebuilder 
export DTB=~/dtb-rebuilder/src/arm
sed -i -e 's/\/\* #include \"am33xx-pruss-uio.dtsi\" \*\//#include \"am33xx-pruss-uio.dtsi\"/'   $DTB/am335x-boneblack.dts
#sed -i -e 's/#dtb=/dtb=am335x-boneblack-emmc-overlay.dtb/'  /boot/uEnv.txt
cd /root/dtb-rebuilder/ && make
cd /root/dtb-rebuilder/ && make KERNEL_VERSION=4.4.27-ti-r62 install

#comment out the universal cape entry  for now... it causes problems with pru pins
sed -i -e 's/cmdline=coherent_pool=1M quiet cape_universal=enable/#cmdline=coherent_pool=1M quiet cape_universal=enable/' /boot/uEnv.txt


cd ~/pru
#build our testing overlay
dtc -O dtb -o /lib/firmware/BB-BONE-PRU-00A0.dtbo -b 0 -@ ~/pru/BB-BONE-PRU-00A0.dts

# get interesting / supporting repos
git clone https://github.com/dinuxbg/pru-gcc-examples.git
git clone https://github.com/beagleboard/bb.org-overlays.git


# Run the example and see if your led is blinking
cd ~/pru/pru-gcc-examples/blinking-led/pru && make 
cd ~/pru/pru-gcc-examples/blinking-led/host-uio && make

# Load the overlay for the example and run the example on startup.  Note you need an LED in I/O P9.27 for some blinky action.
sed -i -e 's/exit 0/ /' /etc/rc.local

# unfortunately these need to run after the reboot or the new kernel won't get referenced , may a command line var can be set for make
#echo "cd /root/dtb-rebuilder/ && make "  >> /etc/rc.local
#echo "cd /root/dtb-rebuilder/ && make install"  >> /etc/rc.local


echo "modprobe uio_pruss" >> /etc/rc.local
echo "config-pin overlay BB-BONE-PRU" >> /etc/rc.local
echo "cd /root/pru/pru-gcc-examples/blinking-led/host-uio && ./out/pload ../pru/out/pru-core0.elf ../pru/out/pru-core1.elf &" >>  /etc/rc.local


reboot
# oh and you will need to reboot once more after this.... sry :) 
# first reboot is for the kernel dtb build, second reboot handles the loading of it.

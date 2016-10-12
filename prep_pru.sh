#!/bin/bash

# Script to prep the BeagleBoneBlack - Linux 4.1 Kernel with the PRU libs

apt-get update
apt-get install gcc-pru
apt-get install libelf-dev

# get interesting / supporting repos
git clone https://github.com/dinuxbg/pru-gcc-examples.git
git clone https://github.com/beagleboard/bb.org-overlays.git

#build the overlays
git clone https://github.com/beagleboard/bb.org-overlays.git
cd bb.org-overlays
./dtc-overlay.sh
./install.sh


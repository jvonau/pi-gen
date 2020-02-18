#!/bin/bash -e
mkdir -p ${ROOTFS_DIR}/opt/iiab

on_chroot << EOF
# use the stock iiab
curl https://raw.githubusercontent.com/iiab/iiab-factory/master/iiab > /usr/sbin/iiab
chmod 0744 /usr/sbin/iiab

cd /opt/iiab/
git clone https://github.com/raspberrypi/rpi-eeprom
sed -i 's/python/python3/' rpi-eeprom/rpi-eeprom-config
rpi-eeprom/test/install

cd /opt/iiab/
git clone https://github.com/iiab/iiab-factory --depth 1

cd /opt/iiab/
git clone https://github.com/iiab/iiab --branch master

cd /opt/iiab/
git clone https://github.com/iiab/iiab-admin-console --branch master --depth 10

cd /opt/iiab/iiab/scripts
./ansible
EOF

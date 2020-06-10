#!/bin/bash -e
mkdir -p ${ROOTFS_DIR}/opt/iiab

on_chroot << EOF
# use the stock iiab
curl http://d.iiab.io/7.1/iiab > /usr/sbin/iiab
chmod 0744 /usr/sbin/iiab

cd /opt/iiab/
#git clone https://github.com/raspberrypi/rpi-eeprom
#sed -i 's/python/python3/' rpi-eeprom/rpi-eeprom-config
#rpi-eeprom/test/install

git clone https://github.com/iiab/iiab-factory --depth 1
git clone https://github.com/iiab/iiab --branch release-7.1
git clone https://github.com/iiab/iiab-admin-console --branch 0.4.2

#export DEBIAN_FRONTEND=noninteractive
#apt -y install python3-pip python3-setuptools python3-venv virtualenv
#python3 -m venv /usr/local/ansible
#source /usr/local/ansible/bin/activate
#sudo pip3 install ansible pymysql psycopg2 passlib
#deactivate
cd /opt/iiab/iiab/scripts
./ansible
EOF

install -m 755 iiab-refresh.sh "${ROOTFS_DIR}/usr/sbin/iiab-refresh"

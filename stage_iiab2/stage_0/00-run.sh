#!/bin/bash -e
mkdir -p ${ROOTFS_DIR}/opt/iiab

on_chroot << EOF

cd /opt/iiab/
git clone https://github.com/iiab/iiab-factory # --depth 1
cd /opt/iiab/iiab-factory
git checkout -b jv-pi-gen
git pull https://github.com/jvonau/iiab-factory.git pi-gen
ln -sf /opt/iiab/iiab-factory/iiab /usr/sbin/iiab

cd /opt/iiab/
git clone https://github.com/iiab/iiab --depth 10
cd /opt/iiab/iiab
git checkout -b jv-pi-gen
git pull https://github.com/jvonau/iiab.git installed2

cd /opt/iiab/
git clone https://github.com/iiab/iiab-admin-console --depth 1

cd /opt/iiab/iiab/scripts
./ansible
EOF

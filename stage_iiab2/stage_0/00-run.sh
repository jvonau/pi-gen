#!/bin/bash -e
mkdir -p ${ROOTFS_DIR}/opt/iiab

on_chroot << EOF
# use the stock iiab
curl https://raw.githubusercontent.com/iiab/iiab-factory/master/iiab > /usr/sbin/iiab
chmod 0744 /usr/sbin/iiab

# need the local_vars file
cd /opt/iiab/
git clone https://github.com/iiab/iiab-factory # --depth 1
cd /opt/iiab/iiab-factory
git checkout -b jv-pi-gen
git pull https://github.com/jvonau/iiab-factory.git pi-gen
#ln -sf /opt/iiab/iiab-factory/iiab /usr/sbin/iiab

cd /opt/iiab/
git clone https://github.com/iiab/iiab --branch master
cd /opt/iiab/iiab
#git checkout -b master
#git config branch.master.remote origin
#git config branch.master.merge refs/heads/master
git checkout -b imaging
git pull https://github.com/jvonau/iiab.git imaging

cd /opt/iiab/
git clone https://github.com/iiab/iiab-admin-console --branch master --depth 10

cd /opt/iiab/iiab/scripts
./ansible
EOF

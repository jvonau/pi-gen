#!/bin/bash -e
on_chroot << EOF
mkdir -p /etc/iiab/install-flags
cd /opt/iiab/iiab-factory
git checkout jv-pi-gen
git pull https://github.com/jvonau/iiab-factory.git pi-gen
cp /opt/iiab/iiab-factor/pi-gen/local_vars_min.yml /etc/iiab/local_vars.yml
cd /opt/iiab/iiab
git checkout release-7.0
git branch -D jv-pi-gen || true
git checkout -b jv-pi-gen
git pull https://github.com/jvonau/iiab.git installed2
./iiab-install
git checkout master
git pull
git checkout release-7.0
EOF
on_chroot << EOF2
#if [ ! -f /opt/iiab/iiab-factory/flags/iiab-admin-console-complete ]; then
#    cd /opt/iiab/iiab-admin-console
#    ./install
#    touch /opt/iiab/iiab-factory/flags/iiab-admin-console-complete
#fi
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get -y dist-upgrade
EOF2

rm ${ROOTFS_DIR}/etc/iiab/local_vars.yml
sed -i 's/^STAGE=.*/STAGE=2/' ${ROOTFS_DIR}/etc/iiab/iiab.env

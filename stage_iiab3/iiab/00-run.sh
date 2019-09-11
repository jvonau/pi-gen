#!/bin/bash -e
on_chroot << EOF
cd /opt/iiab/iiab-factory
git checkout jv-pi-gen
git pull https://github.com/jvonau/iiab-factory.git pi-gen
cp /opt/iiab/iiab-factor/pi-gen/local_vars_min.yml /etc/iiab/local_vars.yml
cd /opt/iiab/iiab
git checkout master
git branch -D jv-pi-gen || true
git checkout -b jv-pi-gen
git pull https://github.com/jvonau/iiab.git installed2
./iiab-install
#git checkout master
#git pull
EOF
on_chroot << EOF2
if [ ! -f /opt/iiab/iiab-factory/flags/iiab-admin-console-complete ]; then
    cd /opt/iiab/iiab-admin-console
    ./install
    touch /opt/iiab/iiab-factory/flags/iiab-admin-console-complete
fi
EOF2

rm ${ROOTFS_DIR}/etc/iiab/local_vars.yml
sed -i 's/^STAGE=.*/STAGE=5/' ${ROOTFS_DIR}/etc/iiab/iiab.env

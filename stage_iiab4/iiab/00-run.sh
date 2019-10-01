#!/bin/bash -e
on_chroot << EOF
mkdir -p /etc/iiab
cd /opt/iiab/iiab-factory
git checkout jv-pi-gen
git pull https://github.com/jvonau/iiab-factory.git pi-gen
cp /opt/iiab/iiab-factory/pi-gen/local_vars_medium.yml /etc/iiab/local_vars.yml
cd /opt/iiab/iiab
git checkout master
git branch -D jv-pi-gen || true
git checkout -b jv-pi-gen
git pull https://github.com/jvonau/iiab.git installed2
./iiab-install
git checkout release-7.0
git pull
EOF

on_chroot << EOF2
if [ ! -f /opt/iiab/iiab-factory/flags/iiab-admin-console-complete ]; then
    cd /opt/iiab/iiab-admin-console
    ./install
    touch /opt/iiab/iiab-factory/flags/iiab-admin-console-complete
    fi
EOF2

on_chroot << EOF3
    echo -e 'Now running kalite zone'
    kalite manage generate_zone
    touch /opt/iiab/iiab-factory/flags/kalite-zone-complete

    echo -e 'Now retreiving kalite en.zip'
    cd /opt/iiab/downloads
    wget http://pantry.learningequality.org/downloads/ka-lite/0.17/content/contentpacks/en.zip
    echo -e 'Now installing kalite en.zip'
    kalite manage retrievecontentpack local en en.zip
    touch /opt/iiab/iiab-factory/flags/kalite-en.zip-complete
    cd /opt/iiab/iiab-factory
    git checkout master
    sed -i 's|_installed|_installed: True|' /etc/iiab/config_vars2.yml
EOF3

rm ${ROOTFS_DIR}/etc/iiab/local_vars.yml
echo "cleaning out downloads"
rm -f ${ROOTFS_DIR}/opt/iiab/downloads/*
echo "reset stage counter"
sed -i 's/^STAGE=.*/STAGE=3/' ${ROOTFS_DIR}/etc/iiab/iiab.env

#!/bin/bash -e
on_chroot << EOF
mkdir -p /etc/iiab/install-flags
cd /opt/iiab/iiab-factory
git checkout jv-pi-gen
git pull https://github.com/jvonau/iiab-factory.git pi-gen
cp /opt/iiab/iiab-factory/pi-gen/local_vars_medium.yml /etc/iiab/local_vars.yml
cd /opt/iiab/iiab
git checkout master
git pull
git branch -D target || true
git checkout -b target
git pull https://github.com/jvonau/iiab.git target
./iiab-install
EOF

on_chroot << EOF2
if [ ! -f /etc/iiab/install-flags/iiab-admin-console-complete ]; then
    cd /opt/iiab/iiab-admin-console
    ./install
    touch /etc/iiab/install-flags/iiab-admin-console-complete
    fi
EOF2

on_chroot << EOF3
    if [ ! -f /etc/iiab/install-flags/kalite-zone-complete ]; then
        echo -e 'Now running kalite zone'
        kalite manage generate_zone
        touch /etc/iiab/install-flags/kalite-zone-complete
    else
        echo -e 'Already ran kalite zone'
    fi
    if [ ! -f /etc/iiab/install-flags/kalite-zip-complete ]; then
        echo -e 'Now retreiving kalite en.zip'
        cd /opt/iiab/downloads
        wget http://pantry.learningequality.org/downloads/ka-lite/0.17/content/contentpacks/en.zip
        echo -e 'Now installing kalite en.zip'
        kalite manage retrievecontentpack local en en.zip
        touch /etc/iiab/install-flags/kalite-en.zip-complete
    else
        echo -e 'Already ran kalite zip'
    fi
    cd /opt/iiab/iiab-factory
    git checkout master
EOF3

on_chroot << EOF4
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get -y dist-upgrade
EOF4

rm ${ROOTFS_DIR}/etc/iiab/local_vars.yml
echo "cleaning out downloads"
rm -f ${ROOTFS_DIR}/opt/iiab/downloads/*
#echo "reset stage counter"
#sed -i 's/^STAGE=.*/STAGE=2/' ${ROOTFS_DIR}/etc/iiab/iiab.env

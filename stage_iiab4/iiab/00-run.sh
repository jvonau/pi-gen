#!/bin/bash -e
mkdir -p ${ROOTFS_DIR}/etc/iiab/install-flags
cp ../../build_vars.yml "${ROOTFS_DIR}/etc/iiab/local_vars.yml"
on_chroot << EOF
cd /opt/iiab/iiab
git checkout master
git pull
# goes away when pi-gen in master start
git config user.name "pi-gen"
git config user.email "pi-gen@iiab.org"
git branch -D imaging || true # allows re-run if build is interrupted
git checkout -b imaging
git pull https://github.com/jvonau/iiab.git IIAB-test
# goes away when pi-gen in master end
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
    if [ ! -f /etc/iiab/install-flags/kalite-en.zip-complete ]; then
        echo -e 'Now retreiving kalite en.zip'
        cd /opt/iiab/downloads
        wget http://pantry.learningequality.org/downloads/ka-lite/0.17/content/contentpacks/en.zip
        echo -e 'Now installing kalite en.zip'
        kalite manage retrievecontentpack local en en.zip
        touch /etc/iiab/install-flags/kalite-en.zip-complete
    else
        echo -e 'Already ran kalite zip'
    fi
EOF3

on_chroot << EOF4
echo "Prep image"
echo "ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev" > /boot/wpa_supplicant.conf
echo "update_config=1" >> /boot/wpa_supplicant.conf
echo "country=US" >> /boot/wpa_supplicant.conf
echo "" >> /boot/wpa_supplicant.conf
rm /etc/iiab/uuid
systemctl enable iiab-mv-localvars
# Will add requrires= for above to below
systemctl enable iiab-setup-mysql
systemctl enable iiab-provision
# enabled in PR 2381 Can't hurt to run again

echo "saving build file"
cp /etc/iiab/local_vars.yml /etc/iiab/build_vars.yml
sed -i '/^imaging.*/d' /etc/iiab/local_vars.yml
echo "build iiab git hash imaging `git -C /opt/iiab/iiab/ log --pretty=format:'g%H' -n 1`" >> /etc/iiab/build_vars.yml
echo "build iiab git hash master `git -C /opt/iiab/iiab/ log master --pretty=format:'g%H' -n 1`" >> /etc/iiab/build_vars.yml
echo "build iiab-admin-console git hash `git -C /opt/iiab/iiab-admin-console/ log --pretty=format:'g%H' -n 1`" >> /etc/iiab/build_vars.yml
echo "build iiab-factory git hash `git -C /opt/iiab/iiab-factory/ log --pretty=format:'g%H' -n 1`" >> /etc/iiab/build_vars.yml
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get -y dist-upgrade
killall gpg-agent || true
killall dirmngr || true
EOF4

echo "staging medium vars in boot partition"
# keeps in sync with build_vars.yml
cp ${ROOTFS_DIR}/opt/iiab/iiab/vars/local_vars_medium.yml ${ROOTFS_DIR}/boot/local_vars.yml
sed -i 's/^bluetooth_enabled.*/bluetooth_enabled: True/' ${ROOTFS_DIR}/boot/local_vars.yml
sed -i 's/^bluetooth_install.*/bluetooth_install: True/' ${ROOTFS_DIR}/boot/local_vars.yml
sed -i 's/^kolibri_install.*/kolibri_install: True/' ${ROOTFS_DIR}/boot/local_vars.yml
sed -i 's/^elgg_install.*/elgg_install: True/' ${ROOTFS_DIR}/boot/local_vars.yml
sed -i 's/^gitea_install.*/gitea_install: True/' ${ROOTFS_DIR}/boot/local_vars.yml
sed -i 's/^lokole_install.*/lokole_install: True/' ${ROOTFS_DIR}/boot/local_vars.yml
sed -i 's/^mediawiki_install.*/mediawiki_install: True/' ${ROOTFS_DIR}/boot/local_vars.yml
sed -i 's/^nodered_install.*/nodered_install: True/' ${ROOTFS_DIR}/boot/local_vars.yml
sed -i 's/^minetest_install.*/minetest_install: True/' ${ROOTFS_DIR}/boot/local_vars.yml

echo "cleaning out downloads"
rm -rf ${ROOTFS_DIR}/opt/iiab/downloads/*

#echo "reset stage counter"
#sed -i 's/^STAGE=.*/STAGE=3/' ${ROOTFS_DIR}/etc/iiab/iiab.env
# assumes pi-gen is in /opt/iiab/pi-gen
echo "record pi-gen git hash"
echo "build pi-gen git hash `git -C /opt/iiab/pi-gen/ log --pretty=format:'g%H' -n 1`" >> ${ROOTFS_DIR}/etc/iiab/build_vars.yml

on_chroot << EOF
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get -y dist-upgrade
#mkdir -p /etc/iiab/install-flags
#cp /opt/iiab/iiab-factory/pi-gen/local_vars_base.yml /etc/iiab/local_vars.yml
#cd /opt/iiab/iiab
#./iiab-install
#cd /opt/iiab/iiab-admin-console
#./install
#touch /opt/iiab/iiab-factory/flags/iiab-admin-console-complete
#rm /etc/iiab/local_vars.yml
EOF

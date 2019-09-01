on_chroot << EOF
cp /opt/iiab/iiab/vars/local_vars_min.yml /etc/iiab/local_vars.yml
echo "installing: True" >> /etc/iiab/local_vars.yml
cd /opt/iiab/iiab-factory
git checkout jv-pi-gen
git pull https://github.com/jvonau/iiab-factory.git pi-gen
cd /opt/iiab/iiab
git checkout jv-pi-gen
git pull https://github.com/jvonau/iiab.git pi-gen
./iiab-install
git checkout master
cd /opt/iiab/iiab-admin-console
./install
touch /opt/iiab/iiab-factory/flags/iiab-admin-console-complete
rm /etc/iiab/local_vars.yml

EOF

on_chroot << EOF
mkdir -p /etc/iiab
cp /opt/iiab/iiab-factory/pi-gen/local_vars_base.yml /etc/iiab/local_vars.yml
cd /opt/iiab/iiab
./runrole 1-prep
./runrole 2-common
./runrole 3-base-server
#./runrole mysql
#./runrole homepage
#./runrole kiwix
#./runrole kalite
#./runrole osm-vector-maps
#git checkout master
#cd /opt/iiab/iiab-admin-console
#./install
#touch /opt/iiab/iiab-factory/flags/iiab-admin-console-complete
rm /etc/iiab/local_vars.yml
EOF

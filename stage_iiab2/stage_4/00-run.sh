on_chroot << EOF
mkdir -p /etc/iiab
cp /opt/iiab/iiab-factory/local_vars_base.yml /etc/iiab/local_vars.yml
cd /opt/iiab/iiab
./runrole 1-prep
./runrole 2-common
./runrole 3-base-server
./runrole kiwix
./runrole kalite
rm /etc/iiab/local_vars.yml
git checkout master
cd /opt/iiab/iiab-factory
git checkout master
EOF

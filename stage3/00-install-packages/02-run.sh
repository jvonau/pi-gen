on_chroot << EOF
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get -y dist-upgrade
EOF

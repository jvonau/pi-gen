on_chroot << EOF
export DEBIAN_FRONTEND=noninteractive
apt -y install python3-pip python3-setuptools python3-venv virtualenv
python3 -m venv /usr/local/ansible
source /usr/local/ansible/bin/activate
sudo pip3 install ansible pymysql psycopg2 passlib
deactivate
EOF

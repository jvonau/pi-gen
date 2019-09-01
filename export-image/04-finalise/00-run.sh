sed -i 's/^STAGE=.*/STAGE=2/' ${ROOTFS_DIR}/etc/iiab/iiab.env
rm -f ${ROOTFS_DIR}/opt/iiab/downloads/*

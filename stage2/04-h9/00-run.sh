#!/bin/bash -e

install -m 644 files/99-persistent-network.rules "${ROOTFS_DIR}/etc/udev/rules.d/99-persistent-network.rules"
install -m 644 files/80-can0.network "${ROOTFS_DIR}/etc/systemd/network/80-can0.network"

on_chroot << EOF
  adduser --system --no-create-home --group --disabled-login h9d
EOF



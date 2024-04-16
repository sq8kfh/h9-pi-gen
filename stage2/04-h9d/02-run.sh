#!/bin/bash -e

on_chroot << EOF
  su - ${FIRST_USER_NAME} -c "cd && git clone https://github.com/sq8kfh/h9.git && cd ~/h9 && git checkout v0.3-dev"
  su - ${FIRST_USER_NAME} -c "cd ~/h9 && mkdir build && cd build && cmake .. && make"
  cd /home/${FIRST_USER_NAME}/h9/build && make install
  
  systemctl enable h9d
EOF

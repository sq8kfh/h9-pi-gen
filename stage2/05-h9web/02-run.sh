#!/bin/bash -e

install -m 644 files/h9web "${ROOTFS_DIR}/etc/nginx/sites-available/h9web"
sed "${ROOTFS_DIR}/etc/nginx/sites-available/h9web" -i -e "s|FIRST_USER_NAME|${FIRST_USER_NAME}|"

install -m 644 files/h9web.conf "${ROOTFS_DIR}/etc/supervisor/conf.d/h9web.conf"
sed "${ROOTFS_DIR}/etc/supervisor/conf.d/h9web.conf" -i -e "s|FIRST_USER_NAME|${FIRST_USER_NAME}|"

on_chroot << EOF
  su - ${FIRST_USER_NAME} -c "cd && git clone https://github.com/sq8kfh/h9web.git&& cd ~/h9web && git checkout dev"
  rm /etc/nginx/sites-enabled/default
  ln -s /etc/nginx/sites-available/h9web /etc/nginx/sites-enabled/h9web

  npm install -g @angular/cli
  su - ${FIRST_USER_NAME} -c "cd ~/h9web/web && npm install"
  su - ${FIRST_USER_NAME} -c "cd ~/h9web/web && ng build"

  su - ${FIRST_USER_NAME} -c "cd ~/h9web/ && python3 -m venv venv"
  su - ${FIRST_USER_NAME} -c "cd ~/h9web/ && ~/h9web/venv/bin/pip install -r requirements.txt"

  systemctl enable nginx
  systemctl enable supervisor
EOF

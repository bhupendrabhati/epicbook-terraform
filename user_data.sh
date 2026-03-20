#!/bin/bash

# Update system
sudo apt update -y && sudo apt upgrade -y

# Install dependencies
sudo apt install -y nodejs npm nginx mysql-client git

# Clone repo
cd /home/ubuntu
if [ ! -d "theepicbook" ]; then
  git clone https://github.com/pravinmishraaws/theepicbook.git
fi

#Get into the project directory
cd /home/ubuntu/theepicbook

# Install node dependencies
npm install

# FIX config.json automatically
cat <<EOF > /home/ubuntu/theepicbook/config/config.json
{
  "development": {
    "username": "${db_user}",
    "password": "${db_password}",
    "database": "${db_name}",
    "host": "${db_host}",
    "dialect": "mysql"
  },
  "test": {
    "username": "root",
    "password": null,
    "database": "database_test",
    "host": "127.0.0.1",
    "dialect": "mysql"
  },
  "production": {
    "use_env_variable": "JAWSDB_URL",
    "dialect": "mysql"
  }
}
EOF

# WAIT FOR RDS TO BE AVAILABLE
echo "Waiting for RDS..."

until mysql -h ${db_host} -u ${db_user} -p${db_password} -e "SELECT 1" >/dev/null 2>&1; do
  echo "Waiting for DB..."
  sleep 10
done

echo "RDS is ready!"

# IMPORT SCHEMA + SEED DATA
mysql -h ${db_host} -u ${db_user} -p${db_password} ${db_name} < db/BuyTheBook_Schema.sql
mysql -h ${db_host} -u ${db_user} -p${db_password} ${db_name} < db/author_seed.sql
mysql -h ${db_host} -u ${db_user} -p${db_password} ${db_name} < db/books_seed.sql

# INSTALL PM2
npm install -g pm2

# START APP AS UBUNTU USER
sudo -u ubuntu bash <<EOF
cd /home/ubuntu/theepicbook
pm2 start server.js
pm2 save
EOF

# ENABLE PM2 AUTO START
env PATH=$PATH:/usr/bin pm2 startup systemd -u ubuntu --hp /home/ubuntu
systemctl enable pm2-ubuntu

# NGINX CONFIG
cat <<EOF > /etc/nginx/sites-available/default
server {
    listen 80;
    server_name _;

    location / {
        proxy_pass http://127.0.0.1:8080;
        proxy_http_version 1.1;

        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;

        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "upgrade";
    }
}
EOF

# Restart nginx
nginx -t && systemctl restart nginx
#!/usr/bin/env bash

sudo apt-get update
sudo apt-get install -y nginx
sudo rm /etc/nginx/sites-available/default
sudo rm /etc/nginx/sites-enabled/default
sudo tee -a /etc/nginx/sites-available/spartan > /dev/null <<EOT
upstream spartan_servers {
    server ${ip0}:8080;
    server ${ip1}:8080;
    server ${ip2}:8080;
}
server {
    listen 80;
    server_name _;
    location / {
        proxy_set_header Host \$host;
        proxy_set_header X-real-IP \$remote_addr;
        proxy_pass http://spartan_servers;
    }
}
EOT
sudo ln -s /etc/nginx/sites-available/spartan /etc/nginx/sites-enabled/spartan
sudo systemctl restart nginx
sudo systemctl enable nginx

#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

database_password=$(pwgen -s 32)

# Install Apache2 MySQL PHP and required modules
sudo apt update
sudo apt install apache2 mysql-server php libapache2-mod-php php-mysql git -y

# Restart Apache2 service
sudo systemctl restart apache2.service

# Create WordPress DB
if mysql -u root -e "SELECT 1 FROM information_schema.schemata WHERE schema_name = 'wordpress';"; then
    echo "The database already exists. Do you want to overwrite it?"
    read -p "(y/N) " response
    if [[ $response == "y" ]]; then
        mysql -u root <<EOF
        DROP DATABASE wordpress;
        CREATE DATABASE wordpress;
        CREATE USER 'wp_user'@'localhost' IDENTIFIED BY '$database_password';
        GRANT ALL PRIVILEGES ON wordpress.* TO 'wp_user'@'localhost';
        FLUSH PRIVILEGES;
        EOF
    else
        echo "The script is stopped."
        exit 0
    fi
else
    sudo mysql -u root <<EOF
    CREATE DATABASE wordpress;
    CREATE USER 'wp_user'@'localhost' IDENTIFIED BY '$database_password';
    GRANT ALL PRIVILEGES ON wordpress.* TO 'wp_user'@'localhost';
    FLUSH PRIVILEGES;
    EOF
fi

# Download and extract WordPress files
mkdir /tmp/wp_tmp && cd /tmp/wp_tmp
curl -O https://wordpress.org/latest.tar.gz
tar xzvf latest.tar.gz

# Copy WordPress files to Apache2 web root directory
sudo rsync -av /tmp/wp_tmp/wordpress/ /var/www/html/wordpress/
rm -r /tmp/wp_tmp

sudo chown -R www-data:www-data /var/www/html/wordpress/
sudo chmod -R 755 /var/www/html/wordpress/

# Create WordPress configuration file from sample file and set database details
cd /var/www/html/wordpress/
sudo mv wp-config-sample.php wp-config.php
sudo sed -i "s/{DB_NAME}/{wordpress}/g; s/{DB_USER}/{wp_user}/g; s/{DB_PASSWORD}/$database_password/g" wp-config.php

echo -e "\n +-----------------------------------------------+"
echo -e " |           Installation (Wordpress LAMP):      |"
echo -e " |   /\_/\    DB_NAME: wordpress                 |"
echo -e " |  ( o-o )   DB_USER: wp_user                   |"
echo -e " |   > ~ <    DB_PASSWORD: $database_password    "
echo -e " |           Installation is successful          |"
echo -e " +-----------------------------------------------+"
#!/bin/bash


# Set up error handling and exit on failure
set -o errexit
set -o nounset
set -o pipefail

# Random data generation
pass=$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-32};echo;)
rand=$RANDOM

# Update package list
sudo apt update

# Install Apache2 MySQL PHP and required modules
sudo apt install apache2 mysql-server php libapache2-mod-php php-mysql git -y

# Restart Apache2 service
sudo systemctl restart apache2.service

# Create MySQL database for WordPress
sudo mysql -u root <<EOF
CREATE DATABASE wordpress_$rand;
CREATE USER 'wp_$rand'@'localhost' IDENTIFIED BY '$pass';
GRANT ALL PRIVILEGES ON wordpress_$rand.* TO 'wp_$rand'@'localhost';
FLUSH PRIVILEGES;
EOF

# Download and extract WordPress files
mkdir /tmp/wp_$rand && cd /tmp/wp_$rand
curl -O https://wordpress.org/latest.tar.gz
tar xzvf latest.tar.gz

# Copy WordPress files to Apache2 web root directory
sudo cp -r /tmp/wp_$rand/wordpress/* /var/www/html/
rm -r /tmp/wp_$rand

# Set permissions for WordPress files and directories
sudo chown -R www-data:www-data /var/www/html/
sudo chmod -R 755 /var/www/html/

# Create WordPress configuration file from sample file and set database details
cd /var/www/html/
sudo mv wp-config-sample.php wp-config.php
sudo sed -i "/DB_NAME/s/'[^']*'/'wordpress_$rand'/2" wp-config.php
sudo sed -i "/DB_USER/s/'[^']*'/'wp_$rand'/2" wp-config.php
sudo sed -i "/DB_PASSWORD/s/'[^']*'/'$pass'/2" wp-config.php
sudo rm index.html


echo -e "\n=====================\nDB_NAME: wordpress_$rand\nDB_USER: wp_$rand\nDB_PASSWORD: $pass\n=====================\n"


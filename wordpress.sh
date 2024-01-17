#!/bin/bash

handle_error() {
    echo -e "\e[30m\e[41m ✘ An error occurred during execution at line $BASH_LINENO. \e[0m"
    exit 1
}
trap 'handle_error' ERR

database_password=$(openssl rand -base64 20)

echo -e "\e[30;44m ❍ Installing WordPress components. \e[0m"
sudo apt update
sudo apt install apache2 mysql-server php libapache2-mod-php php-mysql git -y
echo -e "\e[42m\e[30m ✔ WordPress components. \e[0m"

echo -e "\e[30;44m ❍ Restart service. \e[0m"
sudo systemctl restart apache2.service


if sudo mysql -uroot -e "use wordpress" > /dev/null 2>&1; then
    echo -e "\e[48;5;250m\e[30m ✎ Deleting an existing WordPress database. \e[0m"
    sudo mysql -uroot -e "DROP DATABASE IF EXISTS wordpress;"
fi
if sudo mysql -uroot -e "use mysql; select user from user where user='wp_user'" | grep wp_user > /dev/null 2>&1; then
    echo -e "\e[48;5;250m\e[30m ✎ Deleting an existing WordPress user. \e[0m"
    sudo mysql -uroot -e "DROP USER IF EXISTS 'wp_user'@'localhost';"
fi
echo -e "\e[30;44m ❍ Creating the WordPress database. \e[0m"
sudo mysql -u root <<EOF
CREATE DATABASE wordpress;
CREATE USER 'wp_user'@'localhost' IDENTIFIED BY '$database_password';
GRANT ALL PRIVILEGES ON wordpress.* TO 'wp_user'@'localhost';
FLUSH PRIVILEGES;
EOF
echo -e "\e[42m\e[30m ✔ WordPress database. \e[0m"

echo -e "\e[30;44m ❍ Downloading WordPress file. \e[0m"
mkdir /tmp/wp_tmp && cd /tmp/wp_tmp
curl -O https://wordpress.org/latest.tar.gz
tar xzvf latest.tar.gz
echo -e "\e[42m\e[30m ✔ WordPress file. \e[0m"

echo -e "\e[30;44m ❍ Copy WordPress files. \e[0m"
sudo rsync -av /tmp/wp_tmp/wordpress/ /var/www/html/wordpress/
rm -r /tmp/wp_tmp
echo -e "\e[42m\e[30m ✔ WordPress file. \e[0m"

sudo chown -R www-data:www-data /var/www/html/wordpress/
sudo chmod -R 755 /var/www/html/wordpress/

echo -e "\e[30;44m ❍ Create WordPress configuration. \e[0m"
cd /var/www/html/wordpress/
sudo mv wp-config-sample.php wp-config.php
sudo perl -pi -e "s%database_name_here%wordpress%g" /var/www/html/wordpress/wp-config.php
sudo perl -pi -e "s%username_here%wp_user%g" /var/www/html/wordpress/wp-config.php
sudo perl -pi -e "s%password_here%$database_password%g" /var/www/html/wordpress/wp-config.php

echo -e "\n=====================\nWordpress is successfully installed\n- http://host//wordpress\n- DB_NAME: wordpress\n- DB_USER: wp_user\n- DB_PASSWORD: $database_password\n=====================\n"

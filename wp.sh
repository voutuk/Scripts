#!/bin/bash

error_handler() {
    clear
    echo -e "\n +-----------------------------------------------+"
    echo -e " |                                               |"
    echo -e " |   /\_/\     Script                            |"
    echo -e " |  ( o-o )    execution                         |"
    echo -e " |   > ~ <     error                             |"
    echo -e " |                                               |"
    echo -e " +-----------------------------------------------+"
    exit 1
}

trap 'error_handler' ERR

pass=$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-32};echo;)
rand=$((10000 + RANDOM % 90000))

clear
echo -e "\n +-----------------------------------------------+"
echo -e " |           Installation (Wordpress LAMP):      |"
echo -e " |   /\_/\    - Install packages                 |"
echo -e " |  ( o-o )   - Configure mysql                  |"
echo -e " |   > ~ <    - Download wordpress               |"
echo -e " |           Installation is in progress         |"
echo -e " +-----------------------------------------------+"

sudo apt update > /dev/null 2>&1
sudo apt install apache2 mysql-server php libapache2-mod-php php-mysql git -y > /dev/null 2>&1
sudo systemctl restart apache2.service > /dev/null 2>&1

clear
echo -e "\n +-----------------------------------------------+"
echo -e " |           Installation (Wordpress LAMP):      |"
echo -e " |   /\_/\    + Install packages                 |"
echo -e " |  ( o-o )   - Configure mysql                  |"
echo -e " |   > ~ <    - Download wordpress               |"
echo -e " |           Installation is in progress         |"
echo -e " +-----------------------------------------------+"

sudo mysql -u root <<EOF > /dev/null
CREATE DATABASE wordpress_$rand;
CREATE USER 'wp_$rand'@'localhost' IDENTIFIED BY '$pass';
GRANT ALL PRIVILEGES ON wordpress_$rand.* TO 'wp_$rand'@'localhost';
FLUSH PRIVILEGES;
EOF

clear
echo -e "\n +-----------------------------------------------+"
echo -e " |           Installation (Wordpress LAMP):      |"
echo -e " |   /\_/\    + Install packages                 |"
echo -e " |  ( o-o )   + Configure mysql                  |"
echo -e " |   > ~ <    - Download wordpress               |"
echo -e " |           Installation is in progress         |"
echo -e " +-----------------------------------------------+"

mkdir /tmp/wp_$rand && cd /tmp/wp_$rand
curl -O https://wordpress.org/latest.tar.gz > /dev/null 2>&1
tar xzvf latest.tar.gz > /dev/null 2>&1
sudo cp -r /tmp/wp_$rand/wordpress/* /var/www/html/ > /dev/null 2>&1
rm -r /tmp/wp_$rand > /dev/null 2>&1
sudo chown -R www-data:www-data /var/www/html/ > /dev/null 2>&1
sudo chmod -R 755 /var/www/html/ > /dev/null 2>&1
cd /var/www/html/
sudo mv wp-config-sample.php wp-config.php > /dev/null 2>&1
sudo sed -i "/DB_NAME/s/'[^']*'/'wordpress_$rand'/2" wp-config.php > /dev/null 2>&1
sudo sed -i "/DB_USER/s/'[^']*'/'wp_$rand'/2" wp-config.php > /dev/null 2>&1
sudo sed -i "/DB_PASSWORD/s/'[^']*'/'$pass'/2" wp-config.php > /dev/null 2>&1
sudo rm index.html > /dev/null 2>&1

if [ -d "$HOME" ]; then
    echo "$pass" > "$HOME/wp_pass.key" || error_handler
else
    error_handler
fi

clear
echo -e "\n +-----------------------------------------------+"
echo -e " |           Installation (Wordpress LAMP):      |"
echo -e " |   /\_/\    DB_NAME: wordpress_$rand           |"
echo -e " |  ( o-o )   DB_USER: wp_$rand                  |"
echo -e " |   > ~ <    DB_PASSWORD: \$HOME/wp_pass.key     |"
echo -e " |           Installation is successful          |"
echo -e " +-----------------------------------------------+"

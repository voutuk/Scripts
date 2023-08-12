#!/bin/bash


# Set up error handling and exit on failure
set -o errexit
set -o nounset
set -o pipefail

# Data generation
pass=$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-32};echo;)
rand=$RANDOM
ub=$(lsb_release -rs)

# Download Zabbix repository package
wget https://repo.zabbix.com/zabbix/6.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.0-4+ubuntu${ub}_all.deb

# Install Zabbix repository package
sudo dpkg -i zabbix-release_6.0-4+ubuntu${ub}_all.deb
rm zabbix-release_6.0-4+ubuntu${ub}_all.deb

# Update the package list
sudo apt update

# Install Zabbix packages, MySQL, and dependencies
sudo apt install zabbix-server-mysql zabbix-frontend-php zabbix-apache-conf zabbix-sql-scripts zabbix-agent mysql-server pv -y

# Create a database and user for Zabbix in MySQL
echo "Enter system password"
sudo mysql -uroot -p <<EOF
create database zabbix_$rand character set utf8mb4 collate utf8mb4_bin;
create user user_$rand@localhost identified by '$pass';
grant all privileges on zabbix_$rand.* to user_$rand@localhost;
set global log_bin_trust_function_creators = 1;
EOF

# Load Zabbix database structure

echo -e "Password: $pass\nThe download will complete at 37.0MiB"
zcat /usr/share/zabbix-sql-scripts/mysql/server.sql.gz | pv | mysql --default-character-set=utf8mb4 -uuser_$rand -p zabbix_$rand

# Revert the log_bin_trust_function_creators property
echo "Enter system password"
sudo mysql -uroot -p <<EOF
set global log_bin_trust_function_creators = 0;
EOF

# Add the password to the Zabbix server configuration file
echo "DBPassword=$pass" | sudo tee -a /etc/zabbix/zabbix_server.conf
sudo sed -i "s/^DBName=.*/DBName=${db}/" /etc/zabbix/zabbix_server.conf
sudo sed -i "s/^DBUser=.*/DBUser=${dbuser}/" /etc/zabbix/zabbix_server.conf


# Restart Zabbix server, agent, and Apache
sudo systemctl restart zabbix-server zabbix-agent apache2

# Enable automatic startup for Zabbix server, agent, and Apache
sudo systemctl enable zabbix-server zabbix-agent apache2

echo -e "\n=====================\nhttp://host/zabbix\nDB_NAME: zabbix_$rand\nDB_USER: user_$rand\nDB_PASSWORD: $pass\nAdmin/zabbix\n=====================\n"
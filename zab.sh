#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

echo -e "\e[41m\e[30m Caution: Using this script is unsafe due to exposing the password openly. This will be addressed soon.\e[0m"
ub=$(lsb_release -rs)
echo -e "\e[44m\e[30m This script install Zabbix-server 6.4 on ubuntu $ub \e[0m"
if ! wget -q --spider https://repo.zabbix.com/zabbix/6.4/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.4-1+ubuntu${ub}_all.deb 2>&1 >/dev/null; then
    echo -e "\e[41m\e[30m An error occurred while attempting to download Zabbix 6.4 for Ubuntu ${ub}. \n Please verify your network connection and check Zabbix support for Ubuntu ${ub}. \e[0m"
    exit 1
fi

echo -e "\e[42m\e[30m Downloading and installing the Zabbix package. \e[0m"
wget https://repo.zabbix.com/zabbix/6.4/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.4-1+ubuntu${ub}_all.deb
sudo dpkg -i zabbix-release_6.4-1+ubuntu${ub}_all.deb
rm zabbix-release_6.4-1+ubuntu${ub}_all.deb

echo -e "\e[42m\e[30m Installing Zabbix components. \e[0m"
sudo apt update
sudo apt install zabbix-server-mysql zabbix-frontend-php zabbix-apache-conf zabbix-sql-scripts zabbix-agent mysql-server pv -y


echo -e "\e[42m\e[30m Creating the Zabbix database. \e[0m"
pass=$(openssl rand -base64 20)
echo -e "\033[44m\033[30m Enter root password \033[0m"
sudo mysql -uroot -p <<EOF
create database zabbix character set utf8mb4 collate utf8mb4_bin;
create user zabbix@localhost identified by '$pass';
grant all privileges on zabbix.* to zabbix@localhost;
set global log_bin_trust_function_creators = 1;
EOF

echo -e "\e[42m\e[30m Decompressing a sql file. \e[0m"
echo -e "\033[44m\033[30m The download will complete at 37.8MiB \033[0m"
zcat /usr/share/zabbix-sql-scripts/mysql/server.sql.gz | pv | mysql --default-character-set=utf8mb4 -uzabbix -p"$pass" zabbix

echo -e "\033[44m\033[30m Enter root password \033[0m"
sudo mysql -uroot -p <<EOF
set global log_bin_trust_function_creators = 0;
EOF

echo -e "\e[42m\e[30m Writing the password to the configuration file. \e[0m"
echo "DBPassword=$pass" | sudo tee -a /etc/zabbix/zabbix_server.conf > /dev/null

echo -e "\e[42m\e[30m Starting services. \e[0m"
sudo systemctl restart zabbix-server zabbix-agent apache2
sudo systemctl enable zabbix-server zabbix-agent apache2

echo -e "\n=====================\nhttp://host/zabbix\nDB_NAME: zabbix\nDB_USER: zabbix\nDB_PASSWORD: $pass\nAdmin/zabbix\n=====================\n"

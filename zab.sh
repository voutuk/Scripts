#!/bin/bash

set -euo pipefail

ub=$(lsb_release -rs)

echo -e "\e[30;44m ❍ Downloading and installing the Zabbix package \e[0m"
wget https://repo.zabbix.com/zabbix/6.4/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.4-1+ubuntu${ub}_all.deb
sudo dpkg -i zabbix-release_6.4-1+ubuntu${ub}_all.deb
rm zabbix-release_6.4-1+ubuntu${ub}_all.deb
echo -e "\e[42m\e[30m ✔ Installing the Zabbix package \e[0m"

echo -e "\e[30;44m ❍ Installing Zabbix components \e[0m"
sudo apt update
sudo apt install zabbix-server-mysql zabbix-frontend-php zabbix-apache-conf zabbix-sql-scripts zabbix-agent mysql-server pv -y
echo -e "\e[42m\e[30m ✔ Zabbix components \e[0m"

echo -e "\e[30;44m ❍ Creating the Zabbix database \e[0m"
pass=$(openssl rand -base64 20)
echo -e "\e[30;44m ✎ Enter root password \e[0m"
sudo mysql -uroot -p <<EOF
create database zabbix character set utf8mb4 collate utf8mb4_bin;
create user zabbix@localhost identified by '$pass';
grant all privileges on zabbix.* to zabbix@localhost;
set global log_bin_trust_function_creators = 1;
EOF
echo -e "\e[42m\e[30m ✔ Zabbix database \e[0m"

echo -e "\e[30;44m ❍ Decompressing a sql file \e[0m"
zcat /usr/share/zabbix-sql-scripts/mysql/server.sql.gz | pv | mysql --default-character-set=utf8mb4 -uzabbix -p"$pass" zabbix
echo -e "\e[42m\e[30m ✔ Decompressing a sql file \e[0m"

echo -e "\e[30;44m ✎ Enter root password \e[0m"
mysql -uroot -p <<EOF
set global log_bin_trust_function_creators = 0;
EOF

echo -e "\e[30;44m ❍ Writing the password to the configuration file \e[0m"
echo "DBPassword=$pass" | sudo tee -a /etc/zabbix/zabbix_server.conf > /dev/null

echo -e "\e[30;44m ❍ Starting services. \e[0m"
sudo systemctl restart zabbix-server zabbix-agent apache2
sudo systemctl enable zabbix-server zabbix-agent apache2

echo -e "\n=====================\nhttp://host/zabbix\nDB_NAME: zabbix\nDB_USER: zabbix\nDB_PASSWORD: $pass\nAdmin/zabbix\n=====================\n"

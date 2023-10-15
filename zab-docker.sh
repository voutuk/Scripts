wget https://voutuk.github.io/bash/docker.sh && bash docker.sh
git clone https://github.com/zabbix/zabbix-docker.git
cd zabbix-docker/
docker-compose -f ./docker-compose_v3_alpine_mysql_latest.yaml up -d

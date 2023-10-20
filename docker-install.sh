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

clear
echo -e "\n +-----------------------------------------------+"
echo -e " |           Installation (Docker and more):     |"
echo -e " |   /\_/\    - Install packages                 |"
echo -e " |  ( o-o )   - Download GPG                     |"
echo -e " |   > ~ <    - Add Docker to APT                |"
echo -e " |            - Install Docker packages          |"
echo -e " |           Installation is in progress         |"
echo -e " +-----------------------------------------------+"

sudo apt update > /dev/null 2>&1
sudo apt install ca-certificates curl gnupg -y > /dev/null 2>&1

clear
echo -e "\n +-----------------------------------------------+"
echo -e " |           Installation (Docker and more):     |"
echo -e " |   /\_/\    + Install packages                 |"
echo -e " |  ( o-o )   - Download GPG                     |"
echo -e " |   > ~ <    - Add Docker to APT                |"
echo -e " |            - Install Docker packages          |"
echo -e " |           Installation is in progress         |"
echo -e " +-----------------------------------------------+"

sudo install -m 0755 -d /etc/apt/keyrings > /dev/null 2>&1
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg > /dev/null 2>&1
sudo chmod a+r /etc/apt/keyrings/docker.gpg > /dev/null 2>&1

clear
echo -e "\n +-----------------------------------------------+"
echo -e " |           Installation (Docker and more):     |"
echo -e " |   /\_/\    + Install packages                 |"
echo -e " |  ( o-o )   + Download GPG                     |"
echo -e " |   > ~ <    - Add Docker to APT                |"
echo -e " |            - Install Docker packages          |"
echo -e " |           Installation is in progress         |"
echo -e " +-----------------------------------------------+"

echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update > /dev/null 2>&1

clear
echo -e "\n +-----------------------------------------------+"
echo -e " |           Installation (Docker and more):     |"
echo -e " |   /\_/\    + Install packages                 |"
echo -e " |  ( o-o )   + Download GPG                     |"
echo -e " |   > ~ <    + Add Docker to APT                |"
echo -e " |            - Install Docker packages          |"
echo -e " |           Installation is in progress         |"
echo -e " +-----------------------------------------------+"

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-compose -y > /dev/null 2>&1

clear
echo -e "\n +-----------------------------------------------+"
echo -e " |           Installation (Docker and more):     |"
echo -e " |   /\_/\    + Install packages                 |"
echo -e " |  ( o-o )   + Download GPG                     |"
echo -e " |   > ~ <    + Add Docker to APT                |"
echo -e " |            + Install Docker packages          |"
echo -e " |           Installation is successful          |"
echo -e " +-----------------------------------------------+"

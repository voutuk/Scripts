#!/bin/bash

handle_error() {
    echo -e "\e[30m\e[41m ✘ An error occurred during execution at line $BASH_LINENO. \e[0m"
    exit 1
}
trap 'handle_error' ERR

echo -e "\e[30;44m ❍ Installing packages. \e[0m"
sudo apt update
sudo apt install ca-certificates curl gnupg -y

echo -e "\e[30;44m ❍ Downloading GPG. \e[0m"
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo -e "\e[30;44m ❍ Adding Docker to APT. \e[0m"
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list
sudo apt-get update

echo -e "\e[48;5;183m\e[30m ✶ Installing Docker packages. \e[0m"
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-compose -y

echo -e "\e[42m\e[30m ✔ Docker is successfully installed. \e[0m"
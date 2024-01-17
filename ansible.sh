#!/bin/bash

handle_error() {
    echo -e "\e[30m\e[41m ✘ An error occurred during execution at line $BASH_LINENO. \e[0m"
    exit 1
}
trap 'handle_error' ERR

sudo apt update
sudo apt install software-properties-common -y
sudo add-apt-repository --yes --update ppa:ansible/ansible
echo -e "\e[30;44m ❍ Installing Ansible. \e[0m"
sudo apt install ansible -y

echo -e "\e[42m\e[30m ✔ Ansible is successfully installed. \e[0m"
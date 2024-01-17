#!/bin/bash

if [ "$(id -u)" != "0" ]; then
    echo -e "\e[30m\e[41m ✘ This script needs to be executed with administrator privileges (sudo). \e[0m"
    exit 1
fi

if [ ! -f /swapfile ]; then
    echo -e "\e[30;44m ❍ Swap file not found. Creating a swapfile... \e[0m"

    fallocate -l 2G /swapfile
    chmod 600 /swapfile
    mkswap /swapfile
    swapon /swapfile
    echo "/swapfile none swap sw 0 0" >> /etc/fstab
    echo -e "\e[42m\e[30m ✔ Swap created and activated successfully. \e[0m"
else
    echo -e "\e[48;5;183m\e[30m ✶ Swap file already exists. Exiting. \e[0m"
fi

echo -e "\e[30;44m ❍ Checking if swap is indeed added: \e[0m"
swapon --show
free -h

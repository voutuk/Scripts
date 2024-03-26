#!/bin/bash

SWAPFILE=/swapfile
SWAPSIZE=2G

function check_root {
    if [ "$(id -u)" != "0" ]; then
        echo -e "\e[30m\e[41m ✘ This script needs to be executed with administrator privileges (sudo). \e[0m"
        exit 1
    fi
}

function check_commands {
    for cmd in fallocate chmod mkswap swapon free; do
        if ! command -v $cmd &> /dev/null; then
            echo "Command $cmd could not be found"
            exit 1
        fi
    done
}

function check_disk_space {
    local available=$(df / | tail -1 | awk '{print $4}')
    local required=$(echo $SWAPSIZE | grep -o -E '[0-9]+')

    if [ $available -lt $required ]; then
        echo -e "\e[30m\e[41m ✘ Not enough disk space. \e[0m"
        exit 1
    fi
}

function create_swap {
    if [ ! -f $SWAPFILE ]; then
        echo -e "\e[30;44m ❍ Swap file not found. Creating a swapfile... \e[0m"

        fallocate -l $SWAPSIZE $SWAPFILE
        chmod 600 $SWAPFILE
        mkswap $SWAPFILE
        swapon $SWAPFILE
        echo "$SWAPFILE none swap sw 0 0" >> /etc/fstab
        echo -e "\e[42m\e[30m ✔ Swap created and activated successfully. \e[0m"
    else
        echo -e "\e[48;5;183m\e[30m ✶ Swap file already exists. Exiting. \e[0m"
    fi
}

function check_swap {
    echo -e "\e[30;44m ❍ Checking if swap is indeed added: \e[0m"
    swapon --show
    free -h
}

check_root
check_commands
check_disk_space
create_swap
check_swap
#!/bin/bash

handle_error() {
    echo -e "\e[30m\e[41m ✘ An error occurred during execution at line $BASH_LINENO. \e[0m"
    exit 1
}
trap 'handle_error' ERR

echo -e "\e[30;44m ❍ Installing JRE. \e[0m"
sudo apt update
sudo apt install default-jre -y

echo -e "\e[30;44m ❍ Downloading GPG. \e[0m"
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key

echo -e "\e[30;44m ❍ Adding Docker to APT. \e[0m"
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update -y
sudo dpkg --configure -a

echo -e "\e[48;5;183m\e[30m ✶ Installing Jenkins packages. \e[0m"
sudo apt-get install fontconfig openjdk-17-jre jenkins -y

echo -e "\e[42m\e[30m ✔ Jenkins is successfully installed. \e[0m"
echo -e "\e[30;44m ❍ Jenkins secret: $(sudo cat /var/lib/jenkins/secrets/initialAdminPassword) \e[0m"
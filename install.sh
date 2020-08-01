#!/bin/bash

ROOT_DIR=/var/lib/deployify
SCRIPTS=$ROOT_DIR/scripts
DATA=$ROOT_DIR/data
CONFIG=$DATA/config
CERTS=$DATA/certs
LOCAL_CONFIG=./config
CONNECTION_MANAGEMENT_VAR=""

write_error() {
    echo "$(tput setaf 1)$1 $(tput sgr 0)"
}

write_success() {
    echo "$(tput setaf 2)$1 $(tput sgr 0)"
}

check_apt_lock() {
    locked1=$(sudo lsof /var/lib/dpkg/lock-frontend)
    locked2=$(sudo lsof /var/lib/apt/lists/lock)

    if [ -z "$locked1" ] && [ -z "$locked2" ]; then
        write_success "apt-get OK."
    else
        write_error "apt-get is busy with other work, please try again later."
        exit 12
    fi
}

install_docker() {
    #sudo sh ./install_docker.sh
    check_apt_lock
    sudo apt-get update
    sudo apt-get -y install docker.io
    #sudo groupadd docker
    #sudo usermod -aG docker $USER
    #newgrp docker
    #sudo chown "$USER":"$USER" /home/"$USER"/.docker -R
    #sudo chmod g+rwx "$HOME/.docker" -R
    sudo systemctl unmask docker
    sudo systemctl start docker
    sudo systemctl enable docker
    sleep 5
}

exit_if_null() {
    if [ -z "$1" ]; then
        write_error "$2"
        exit 11
    fi
}

check_connection_management_var() {
    if [ -f "$CONFIG/connection.json" ]; then
        CONNECTION_MANAGEMENT_VAR=$(grep -oP '(?<="management": ")[^"]*' $CONFIG/connection.json)        
    else
        echo "$CONFIG/connection.json does not exist."
    fi
}

migrate_management_var() {
    if [ "$CONNECTION_MANAGEMENT_VAR" != '' ]; then
        echo "Migrating management connection var..."
        sudo sed -i 's/"management":.*"/"management": "$CONNECTION_MANAGEMENT_VAR"/g' $CONFIG/connection.json
    else
        echo "No management connection var, no migration needed."
    fi
}

check_docker() {
    docker --version | grep "Docker version"
    if [ $? -eq 0 ]; then
        write_success "Docker is installed."
        #sudo apt-get update
        #sudo apt-get upgrade docker.io
    else
        install_docker
    fi
}

exit_if_null "$1" "Missing parameter: domain (eg. deployify.io)"
check_docker

#echo "adding user deployify..."
#sudo useradd deployify
#echo "adding deployify to group docker..."
#sudo usermod -aG docker deployify

echo "creating docker deployify network..."
sudo docker network create deployify

echo "creating $ROOT_DIR..."

sudo mkdir -p $ROOT_DIR
chown :$(id -g) $ROOT_DIR
sudo chmod 775 $ROOT_DIR
sudo chmod g+s $ROOT_DIR

sudo mkdir -p $CONFIG
sudo mkdir -p $SCRIPTS
sudo mkdir -p $CERTS

echo "Getting management variable in $CONFIG/connection.json"
check_connection_management_var
echo "management variable: $CONNECTION_MANAGEMENT_VAR"

echo "copying config files..."
sudo cp $LOCAL_CONFIG/connection.json $CONFIG
migrate_management_var
sudo cp -n $LOCAL_CONFIG/mailer.json $CONFIG
sudo cp -n $LOCAL_CONFIG/main.json $CONFIG
sudo cp -n $LOCAL_CONFIG/security.json $CONFIG

sudo sed -i 's/"domainName":.*",/"domainName": "'$1'",/g' $CONFIG/main.json

echo "copying scripts..."
sudo cp ./scripts/* $SCRIPTS

echo "copying backup..."
sudo cp ./backup-linux $ROOT_DIR
sudo chmod 700 $ROOT_DIR/backup-linux
sudo chmod 700 $SCRIPTS/auto_updater.sh

(cd $SCRIPTS && sudo ./init.sh)
sudo $SCRIPTS/deploy_portainer_container.sh

echo "installing auto update service..."
sudo chmod 644 ./deployify-updater.service
sudo cp ./deployify-updater.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable deployify-updater
sudo systemctl restart deployify-updater

exit 0

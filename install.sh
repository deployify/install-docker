#!/bin/sh

ROOT_DIR=/var/lib/deployify
SCRIPTS=$ROOT_DIR/scripts
DATA=$ROOT_DIR/data
CONFIG=$DATA/config
LOCAL_CONFIG=./config

write_error() {
    echo "$(tput setaf 1)$1 $(tput sgr 0)"
}

write_success() {
    echo "$(tput setaf 2)$1 $(tput sgr 0)"
}

install_docker() {
    #sudo sh ./install_docker.sh
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

check_docker() {
    docker --version | grep "Docker version"
    if [ $? -eq 0 ]; then
        write_success "Docker is installed."
    else
        install_docker
        #write_error "Docker is not installed, aborting."
    fi
}

exit_if_null "$1" "Missing parameter: domain (eg. deployify.io)"
#install_docker
check_docker

echo "creating docker deployify network..."
sudo docker network create deployify

echo "creating $ROOT_DIR..."
mkdir -p $CONFIG
mkdir -p $SCRIPTS

echo "adding user deployify..."
sudo useradd deployify
echo "adding deployify to group docker..."
sudo usermod -aG docker deployify

echo "setting permissions for $ROOT_DIR..."
sudo chown -R deployify:deployify $ROOT_DIR

echo "copying config files..."
cp $LOCAL_CONFIG/connection.json $CONFIG
cp -n $LOCAL_CONFIG/mailer.json $CONFIG
cp -n $LOCAL_CONFIG/main.json $CONFIG
cp -n $LOCAL_CONFIG/security.json $CONFIG

sudo sed -i 's/"domainName":.*",/"domainName": "'$1'",/g' $CONFIG/main.json

echo "copying scripts..."
cp ./scripts/* $SCRIPTS

echo "copying backup..."
cp ./backup-linux $ROOT_DIR
sudo chmod 700 $ROOT_DIR/backup-linux
sudo chmod 700 $SCRIPTS/auto_updater.sh

sudo cp deployify-updater.service /etc/systemd/system/

sh $SCRIPTS/init.sh

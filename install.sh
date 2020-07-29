#!/bin/sh

ROOTDIR=$HOME/deployify
SCRIPTS=$ROOTDIR/scripts
DATA=$ROOTDIR/data
CONFIG=$DATA/config
LOCAL_CONFIG=./config

write_error () {
	echo "$(tput setaf 1)$1 $(tput sgr 0)"	
}

write_success () {
	echo "$(tput setaf 2)$1 $(tput sgr 0)"
}

install_docker () {
	#sudo sh ./install_docker.sh
	sudo apt-get update        
    sudo apt-get -y install docker.io    
    #sudo groupadd docker   
    #sudo usermod -aG docker $USER
    #newgrp docker 
    #sudo chown "$USER":"$USER" /home/"$USER"/.docker -R
    #sudo chmod g+rwx "$HOME/.docker" -R
    sudo systemctl start docker
    sudo systemctl enable docker
}

exit_if_null () {
	if [ -z "$1" ]
	then
		write_error "$2"
		exit 11
	fi	
}


check_docker(){
    docker --version | grep "Docker version"
    if [ $? -eq 0 ]
    then
        write_success "Docker is installed."
    else
        install_docker
        #write_error "Docker is not installed, aborting."
    fi
}

#install_docker
check_docker
exit_if_null "$1" "Missing parameter: domain (eg. deployify.io)"

echo creating docker deployify network
sudo docker network create deployify

mkdir -p $CONFIG
mkdir -p $SCRIPTS

echo copying config files...
cp $LOCAL_CONFIG/connection.json $CONFIG
cp -n $LOCAL_CONFIG/mailer.json $CONFIG
cp -n $LOCAL_CONFIG/main.json $CONFIG
cp -n $LOCAL_CONFIG/security.json $CONFIG

sudo sed -i 's/"domainName":.*/"domainName": "'$1'",/g' $CONFIG/main.json

echo copying scripts...
cp ./deploy_neo4j_container.sh $SCRIPTS
cp ./deploy_api_container.sh $SCRIPTS
cp ./deploy_proxy_container.sh $SCRIPTS
cp ./deploy_site_container.sh $SCRIPTS
cp ./deploy_vault_container.sh $SCRIPTS
cp ./init.sh $SCRIPTS

echo copying backup...
cp ./backup-linux $ROOTDIR
sudo chmod 700 $ROOTDIR/backup-linux

sh $SCRIPTS/init.sh
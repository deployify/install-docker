#!/bin/sh

CONTAINER=deployify_proxy
IMAGE=deployify/proxy:1.0.0
DATA=/var/lib/deployify/data
USER_GROUP=$(id -u):$(id -g)

echo "Updating $IMAGE..."
sudo docker pull $IMAGE

echo "Removing $CONTAINER..."
sudo docker rm $CONTAINER -v -f

echo "Initiating $CONTAINER..."
sudo docker run --name $CONTAINER --network deployify --user $USER_GROUP --restart=always -p80:80 -p81:81 -p443:443 -d -v $DATA/config:/config -v $DATA/certs:/certs -ti $IMAGE

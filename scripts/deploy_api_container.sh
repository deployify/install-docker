#!/bin/sh

CONTAINER=deployify_api
IMAGE=deployify/api:1.0.0
DATA=/var/lib/deployify/data
USER_GROUP=$(id -u):$(id -g)

echo "Stopping $CONTAINER..."
sudo docker stop $CONTAINER

echo "Removing $CONTAINER..."
sudo docker rm $CONTAINER -f

echo "Initiating $CONTAINER..."
sudo docker run --name $CONTAINER --network deployify --user $USER_GROUP --restart=always -d -v $DATA/config:/config -v $DATA/repos:/nugetserver/repos -v $DATA/vault:/vault $IMAGE

#!/bin/sh

CONTAINER=deployify_vault
IMAGE=deployify/vault:1.0.0
DATA=/var/lib/deployify/data
USER_GROUP=$(id -u):$(id -g)

echo "Stopping $CONTAINER..."
sudo docker stop $CONTAINER

echo "Removing $CONTAINER..."
sudo docker rm $CONTAINER -f

echo "Initiating $CONTAINER..."
sudo docker run --name $CONTAINER --network deployify --user $USER_GROUP --restart=always --cap-add=IPC_LOCK -p8200:8200 -d -it -v $DATA/vault/file:/vault/file $IMAGE server dev-kv-v1

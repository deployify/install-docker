#!/bin/sh

CONTAINER=deployify_vault
IMAGE=deployify/vault:1.0.0
DATA=/var/lib/deployify/data
USER_GROUP=$(id -u):$(id -g)

echo "Updating $IMAGE..."
docker pull $IMAGE

echo "Stopping $CONTAINER..."
docker stop $CONTAINER

echo "Removing $CONTAINER..."
docker rm $CONTAINER -v -f

echo "Initiating $CONTAINER..."
docker run --name $CONTAINER --network deployify --user $USER_GROUP --cap-add=IPC_LOCK -p8200:8200 -d -it -v $DATA/vault/file:/vault/file $IMAGE server dev-kv-v1

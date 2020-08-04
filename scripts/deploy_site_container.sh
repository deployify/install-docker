#!/bin/sh

CONTAINER=deployify_site
IMAGE=deployify/site:1.0.0
DATA=/var/lib/deployify/data

echo "Removing $CONTAINER..."
sudo docker rm $CONTAINER -f

echo "Initiating $CONTAINER..."
sudo docker run --name $CONTAINER --network deployify --restart=always -d $IMAGE

#!/bin/sh

CONTAINER=deployify_proxy
IMAGE=deployify/proxy:1.0.0
DATA=$HOME/deployify/data

echo Removing $CONTAINER...
docker rm $CONTAINER -v -f

echo Updating $IMAGE...
docker pull $IMAGE

echo Initiating $CONTAINER...
docker run --name $CONTAINER --network deployify -p80:80 -p81:81 -p443:443 -d -v $DATA/config:/config -ti $IMAGE
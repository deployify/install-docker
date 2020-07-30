#!/bin/sh

CONTAINER=deployify_api
IMAGE=deployify/api:1.0.0
DATA=$HOME/deployify/data

echo Removing $CONTAINER...
docker rm $CONTAINER -v -f

echo Updating $IMAGE...
docker pull $IMAGE

echo Initiating $CONTAINER...
docker run --name $CONTAINER --network deployify -d -v $DATA/config:/config -v $DATA/repos:/nugetserver/repos -v $DATA/vault:/vault -ti $IMAGE
#!/bin/sh

CONTAINER=deployify_api
IMAGE=deployify/api:1.0.0
DATA=/var/lib/deployify/data
USER_GROUP=$(id -u):$(id -g)

echo Updating $IMAGE...
docker pull $IMAGE

echo Removing $CONTAINER...
docker rm $CONTAINER -v -f

echo Initiating $CONTAINER...
docker run --name $CONTAINER --n deployify --user $USER_GROUP -d -v $DATA/config:/config -v $DATA/repos:/nugetserver/repos -v $DATA/vault:/vault -ti $IMAGE
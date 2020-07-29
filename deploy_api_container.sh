#!/bin/sh

CONTAINER=deployify_api
DATA=$HOME/deployify/data

echo Removing $CONTAINER...
docker rm $CONTAINER -v -f

echo Initiating $CONTAINER...
docker run --name $CONTAINER --network deployify -d -v $DATA/config:/config -v $DATA/repos:/nugetserver/repos -v $DATA/vault:/vault -ti deployify/api:1.0.0
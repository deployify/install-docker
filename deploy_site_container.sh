#!/bin/sh

CONTAINER=deployify_site
IMAGE=deployify/site:1.0.0
DATA=$HOME/deployify/data

echo Removing $CONTAINER...
docker rm $CONTAINER -v -f

echo Updating $IMAGE...
docker pull $IMAGE

echo Initiating $CONTAINER...
docker run --name $CONTAINER --network deployify -d -ti $IMAGE
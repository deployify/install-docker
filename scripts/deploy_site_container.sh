#!/bin/sh

CONTAINER=deployify_site
IMAGE=deployify/site:1.0.0
DATA=/var/lib/deployify/data

echo "Updating $IMAGE..."
docker pull $IMAGE

echo "Removing $CONTAINER..."
docker rm $CONTAINER -v -f

echo "Initiating $CONTAINER..."
docker run --name $CONTAINER --network deployify -d -ti $IMAGE

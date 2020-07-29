#!/bin/sh

CONTAINER=deployify_site
DATA=$HOME/deployify/data

echo Removing $CONTAINER...
docker rm $CONTAINER -v -f

echo Initiating $CONTAINER...
docker run --name $CONTAINER --network deployify -d -ti deployify/site:1.0.0
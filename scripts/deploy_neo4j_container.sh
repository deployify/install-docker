#!/bin/sh

CONTAINER=deployify_neo4j
IMAGE=neo4j:3.5
DATA=/var/lib/deployify/data
USER_GROUP=$(id -u):$(id -g)

echo Updating $IMAGE...
docker pull $IMAGE

echo Removing $CONTAINER...
docker rm $CONTAINER -v -f

echo Initiating $CONTAINER...
docker run --name $CONTAINER --network deployify --user $USER_GROUP -p7474:7474 -p7687:7687 -d -v $DATA/neo4j:/data  --env NEO4J_AUTH=neo4j/p@ssw0rd $IMAGE
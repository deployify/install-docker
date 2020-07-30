#!/bin/sh

CONTAINER=deployify_neo4j
IMAGE=neo4j:3.5
DATA=$HOME/deployify/data


echo Removing $CONTAINER...
docker rm $CONTAINER -v -f

echo Updating $IMAGE...
docker pull $IMAGE

echo Initiating $CONTAINER...
docker run --name $CONTAINER --network="deployify" -p7474:7474 -p7687:7687 -d -v $DATA/neo4j:/data  --env NEO4J_AUTH=neo4j/p@ssw0rd $IMAGE
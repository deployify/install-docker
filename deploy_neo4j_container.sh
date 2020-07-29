#!/bin/sh

CONTAINER=deployify_neo4j
DATA=$HOME/deployify/data

echo Removing $CONTAINER...
docker rm $CONTAINER -v -f

echo Initiating $CONTAINER...
docker run --name $CONTAINER --network="deployify" -d -v $DATA/neo4j:/data  --env NEO4J_AUTH=neo4j/p@ssw0rd neo4j:3.5
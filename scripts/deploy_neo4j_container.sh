#!/bin/sh

CONTAINER=deployify_neo4j
IMAGE=neo4j:3.5
DATA=/var/lib/deployify/data
USER_GROUP=$(id -u):$(id -g)

echo "Updating $IMAGE..."
sudo docker pull $IMAGE

echo "Stopping $CONTAINER..."
sudo docker stop $CONTAINER

echo "Removing $CONTAINER..."
sudo docker rm $CONTAINER -f

echo "Initiating $CONTAINER..."
sudo docker run --name $CONTAINER --network deployify --user $USER_GROUP -p7474:7474 -p7687:7687 -d -v $DATA/neo4j:/data --env NEO4J_AUTH=neo4j/p@ssw0rd $IMAGE

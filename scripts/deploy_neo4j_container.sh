#!/bin/sh

CONTAINER=deployify_neo4j
IMAGE=neo4j:4.1
DATA=/var/lib/deployify/data
USER_GROUP=$(id -u):$(id -g)

echo "Stopping $CONTAINER..."
sudo docker stop $CONTAINER

echo "Removing $CONTAINER..."
sudo docker rm $CONTAINER -f

echo "Initiating $CONTAINER..."
sudo docker run --name $CONTAINER --network deployify --user $USER_GROUP --restart=always -p7474:7474 -p7687:7687 -d -v $DATA/neo4j:/data --env NEO4J_AUTH=neo4j/p@ssw0rd --env NEO4J_dbms_allow__upgrade=true --env NEO4J_cypher_lenient__create__relationship=true $IMAGE

#!/bin/sh

CONTAINER=deployify_vault
DATA=$HOME/deployify/data

echo Removing $CONTAINER...
docker rm $CONTAINER -v -f

echo Initiating $CONTAINER...
docker run --name $CONTAINER --network deployify --cap-add=IPC_LOCK -p8200:8200 -d -it -v $DATA/vault/file:/vault/file deployify/vault:1.0.0 server dev-kv-v1
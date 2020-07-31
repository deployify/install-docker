#!/bin/sh

docker volume create portainer_data
CONTAINER=deployify_management
IMAGE=portainer/portainer

echo "Updating $IMAGE..."
docker pull $IMAGE

echo "Removing $CONTAINER..."
docker rm $CONTAINER -v -f

echo "Initiating $CONTAINER..."
docker run --network deployify -d -p 8000:8000 -p 9000:9000 --name=$CONTAINER --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data $IMAGE
docker image prune -af --filter "label!=portainer"

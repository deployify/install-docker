#!/bin/sh

docker volume create portainer_data
CONTAINER=deployify_management
IMAGE=portainer/portainer

echo "Updating $IMAGE..."
sudo docker pull $IMAGE

echo "Removing $CONTAINER..."
sudo docker rm $CONTAINER -f

echo "Initiating $CONTAINER..."
sudo docker run --network deployify -d -p 8000:8000 -p 9000:9000 --name=$CONTAINER --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data $IMAGE
sudo docker image prune -af --filter "label!=portainer"

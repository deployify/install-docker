#!/bin/sh

docker volume create portainer_data
docker pull portainer/portainer
docker rm -f portainer
docker run -d -p 8000:8000 -p 9000:9000 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer
docker image prune -af --filter "label!=portainer"
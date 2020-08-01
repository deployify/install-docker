#!/bin/sh

echo Initiating...

sudo sh ./deploy_site_container.sh
sudo sh ./deploy_vault_container.sh
sudo sh ./deploy_api_container.sh
sudo sh ./deploy_neo4j_container.sh
sudo sh ./deploy_proxy_container.sh
sudo docker image prune -af --filter "label!=deployify"

#!/bin/sh

echo Initiating...

sh ./deploy_neo4j_container.sh
sh ./deploy_site_container.sh
sh ./deploy_vault_container.sh
sh ./deploy_api_container.sh
sh ./deploy_proxy_container.sh

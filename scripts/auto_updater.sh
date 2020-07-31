#!/bin/bash

API=deployify/api:1.0.0
SITE=deployify/site:1.0.0
PROXY=deployify/proxy:1.0.0
VAULT=deployify/vault:1.0.0
NEO4J=neo4j:3.5

ROOT_DIR=/var/lib/deployify

CONFIG_MAIN=$ROOT_DIR/data/config/main.json
INIT_FILE=$ROOT_DIR/scripts/init.sh
BACKUP_FILE=$ROOT_DIR/backup-linux

MATCH=downloaded
SHOULD_UPDATE=false

check_update() {
	if [[ "$1" == *"$MATCH"* ]]; then
		echo "New image found, will update after image check."
		SHOULD_UPDATE=true
	fi
}

do_update() {
	SHOULD_UPDATE=false

	echo "Creating a new backup..."
	$BACKUP_FILE backup

	if [ "$?" == 0 ]; then
		#local DOMAIN_NAME=$(grep -oP '(?<="domainName": ")[^"]*' $CONFIG_MAIN)
		#curl -L https://raw.githubusercontent.com/deployify/install-docker/master/extractor.txt | sudo bash -s $DOMAIN_NAME
		sudo ./init.sh
	else
		echo "Backup failed, aborting update."
		exit $?
	fi

}

format_result() {
	local TEMP=$(echo "|$1|" | tr '\n' ' ')
	TEMP=$(echo $TEMP | tr '[:upper:]' '[:lower:]')
	echo $TEMP
}

while [ 1 ]; do
	RESULT=$(sudo docker pull $SITE)
	RESULT=$(format_result "$RESULT")
	check_update "$RESULT"

	RESULT=$(sudo docker pull $PROXY)
	RESULT=$(format_result "$RESULT")
	check_update "$RESULT"

	RESULT=$(sudo docker pull $VAULT)
	RESULT=$(format_result "$RESULT")
	check_update "$RESULT"

	RESULT=$(sudo docker pull $API)
	RESULT=$(format_result "$RESULT")
	check_update "$RESULT"

	RESULT=$(sudo docker pull $NEO4J)
	RESULT=$(format_result "$RESULT")
	check_update "$RESULT"

	if [ $SHOULD_UPDATE = true ]; then
		do_update
	fi

	sleep 30
done

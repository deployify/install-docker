#/bin/sh
set -e

echo "cleaning..."
rm ./install.zip || echo "nothing to remove"

BACKUP_DIR=../../MDC_all/dev/backup

if [ "$1" = "build-backup" ]; then
    echo "building backup..."
    (cd $BACKUP_DIR && sh build.sh)
    echo "copying backup..."
    cp $BACKUP_DIR/backup-linux ./
fi

sudo apt-get install zip
zip -r ./install.zip ./* -x *.git* -x *README* -x *LICENSE* -x *build.sh*

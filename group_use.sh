#!/bin/sh

# Script to set group use for a directory
USER=tools
GROUP=tools
DIR=/private
chown -R $USER:$GROUP $DIR
find $DIR -exec chmod g+u {} \;
find $DIR -exec chmod o-rwx {} \;
find $DIR -type d -exec chmod g+s {} \;
# svnadmin load /repos/SalarisRecover < /home/dump/Salaris.dump

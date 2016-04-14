# Script to create a SubVersion repository and set access rights.
USER=svn
GROUP=in4med
REPO=/repos/LeendersVanRielHuisartsen
rm -rf $REPO
svnadmin create $REPO
chown -R $USER:$GROUP $REPO
find $REPO -exec chmod g+u {} \;
find $REPO -exec chmod o-rwx {} \;
find $REPO -type d -exec chmod g+s {} \;
# svnadmin load /repos/SalarisRecover < /home/dump/Salaris.dump

#!/bin/bash

# A script to make a backup of all MySQL databases.

usage() {
  echo "Usage: $0 -u username -p password"
  echo
  echo "  -u USERNAME"
  echo "    The username to use for making the backup."
  echo "    Default: root."
  echo "    Values in /etc/my.cnf are considered, using this option takes presedence."
  echo "  -p PASSWORD"
  echo "    The password to use in combination with the username to make the backup."
  echo "    Values in /etc/my.cnf are considered, using this option takes presedence."
  echo "  -b BACKUPLOCATION"
  echo "    The location to store the backups to."
  echo "    Default: /tmp."
  echo "  -c"
  echo "    Indicated compression (.gz) should be used."
  echo "    Default: not set."
  echo "  -v"
  echo "    Show timestamps when starting and stopping."
  exit 1
}

readargs() {
  while [ "$#" -gt 0 ] ; do
    case "$1" in
      -u)
        if [ "$2" ] ; then
          username="$2"
          shift ; shift
        else
          echo "Missing a value for $1."
          echo
          shift
          usage
        fi
      ;;
      -p)
        if [ "$2" ] ; then
          password="$2"
          shift ; shift
        else
          echo "Missing a value for $1."
          echo
          shift
          usage
        fi
      ;;
      -b)
        if [ "$2" ] ; then
          backuplocation="$2"
          shift ; shift
        else
          echo "Missing a value for $1."
          echo
          shift
          usage
        fi
      ;;
      -c)
        compression="yes"
        shift
      ;;
      -c)
        verbose="yes"
        shift
      ;;

      *)
        echo "Unknown option or argument $1."
        echo
        shift
        usage
      ;;
    esac
  done
}

checkconf() {
  if [ ! "${username}" ] ; then
    if [ -f /etc/my.cnf ] ; then
      username=$(grep '^user=' /etc/my.cnf | cut -d= -f2)
    fi
  fi
  if [ ! "${password}" ] ; then
    if [ -f /etc/my.cnf ] ; then
      password=$(grep '^password=' /etc/my.cnf | cut -d= -f2)
    fi
  fi
}

checkargs() {
  if [ ! "${password}" ] ; then
    echo "Missing password."
    usage
  fi
}

setargs() {
  if [ ! "${username}" ] ; then
    username="root"
  fi
  if [ ! "${backuplocation}" ] ; then
    backuplocation="/tmp"
  fi
}

checkvalues() {
  if [ ! -d "${backuplocation}" ] ; then
    echo "${backuplocation} is not a directory."
    exit 1
  fi
}

main() {
  if [ "${verbose}" ] ; then echo "Starting: $(date)" ; fi
  mysql -u "${username}" -p"${password}" -B -N -e "show databases;" | while read -r database ; do
    echo "Backing up mysql database for ${database}"
    prefix=$(date +%Y%m%d_%H%M)
    if [ "${compression}" ] ; then
      mysqldump --extended-insert=FALSE -u "${username}" -p"${password}" "${database}" | sed '$ d' | gzip -9 > "${backuplocation}"/"${prefix}"_"${database}".mysql.gz 2> /dev/null
    else
      mysqldump --extended-insert=FALSE -u "${username}" -p"${password}" "${database}" | sed '$ d' > "${backuplocation}"/"${prefix}"_"${database}".mysql 2> /dev/null
    fi
 done
 if [ "${verbose}" ] ; then echo "Finishing: $(date)" ; fi
}

readargs "$@"
checkargs
setargs
checkvalues
main

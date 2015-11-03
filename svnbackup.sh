#!/bin/bash

# A script to make a backup of all MySQL databases.

usage() {
  echo "Usage: $0 -u username -p password"
  echo
  echo "  -r REPOSITORY"
  echo "    The repository to backup, this is a path to the repository."
  echo "  -b BACKUPLOCATION"
  echo "    The location to store the backups to."
  echo "    Default: /tmp."
  echo "  -z"
  echo "    Indicated compression (.zip) should be used."
  echo "    Default: not set."
  exit 1
}

readargs() {
  while [ "$#" -gt 0 ] ; do
    case "$1" in
      -r)
        if [ "$2" ] ; then
          repository="$2"
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
      -z)
        compression="yes"
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

checkargs() {
  if [ ! "${repository}" ] ; then
    echo "Missing repository."
    echo
    usage
  fi
}

setargs() {
  if [ ! "${backuplocation}" ] ; then
    backuplocation="/tmp"
  fi
}

checkvalues() {
  if [ ! -d "${backuplocation}" ] ; then
    echo "${backuplocation} is not a directory."
    echo
    usage
  fi
}

main() {
  if [ "${compression}" ] ; then
    svnadmin dump ${repository} | zip ${backuplocation}/$(basename ${repository}).zip -
  else
    svnadmin dump ${repository} > ${backuplocation}/$(basename ${repository})
  fi
}

readargs "$@"
checkargs
setargs
checkvalues
main

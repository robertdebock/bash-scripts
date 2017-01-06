#!/bin/bash

# A script to make a backup of all MySQL databases.

usage() {
  echo "Usage: $0 -u username -p password"
  echo ""
  echo "  -r REPOSITORY"
  echo "    The repository to backup, this is a path to the repository."
  echo "  -b BACKUPLOCATION"
  echo "    The location to store the backups to."
  echo "    Default: /tmp."
  echo ""
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
          echo ""
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
          echo ""
          shift
          usage
        fi
      ;;
      *)
        echo "Unknown option or argument $1."
        echo ""
        shift
        usage
      ;;
    esac
  done
}

checkargs() {
  if [ ! "${repository}" ] ; then
    echo "Missing repository."
    echo ""
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
    echo ""
    usage
  fi
}

main() {
  # Find the most recent revision.
  currentrevision=$(svnlook youngest "${repository}")
  # Find the last (dumped) revision.
  lastrevision="0"
  # Dump from the previousrevision until.
  svnadmin dump "${repository}" -r "${lastrevision}":"${currentrevision}" > "${backuplocation}"/$(basename "${repository}")-revs-"${lastrevision}":"${currentrevision}".dumpfile "${repository}")
  svnadmin dump "${repository}" > "${backuplocation}"/$(basename "${repository}").dump
}

readargs "$@"
checkargs
setargs
checkvalues
main

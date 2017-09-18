#!/bin/bash

# Description of the function of this script.

usage() {
  echo "Usage: $0 [-o option] -a argument"
  echo
  echo "  -o OPTION"
  echo "    Description of this option."
  echo "  -a ARGUMENT"
  echo "    Description of this argument."
  echo "  -s"
  echo "    A switch."
  exit 1
}

readargs() {
  while [ "$#" -gt 0 ] ; do
    case "$1" in
      -o)
        if [ "$2" ] ; then
          option="$2"
          shift ; shift
        else
          echo "Missing a value for $1."
          echo
          shift
          usage
        fi
      ;;
      -a)
        if [ "$2" ] ; then
          argument="$2"
          shift ; shift
        else
          echo "Missing a value for $1."
          echo
          shift
          usage
        fi
      ;;
      -s)
        switch="set"
        shift
      ;;
      *)
        echo "Unknown option, argument or switch: $1."
        echo
        shift
        usage
      ;;
    esac
  done
}

checkargs() {
  if [ ! "${argument}" ] ; then
    echo "Missing argument."
    exit 2
  fi
}

setargs() {
  if [ ! "${option}" ] ; then
    option="default"
  fi
}

checkvalues() {
  if [ "${option}" != "option" ] ; then
   echo "$option is not set to \"option\"."
   usage
  fi
}

main() {
  if [ "${switch}" ] ; then
    echo "Switch is set."
  fi
  # Enter the functional part of the script here.
  :
}

readargs "$@"
checkargs
setargs
checkvalues
main

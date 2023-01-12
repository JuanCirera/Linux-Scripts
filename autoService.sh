#!/bin/bash

#Param
while getopts ":n:" opt; do
  case $opt in
    n) name="$OPTARG"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    exit 1
    ;;
  esac

  case $OPTARG in
    -*) echo "Option $opt needs a valid argument"
    exit 1
    ;;
  esac
done
# Move file and start it
cp ./$name.service /etc/systemd/system/

systemctl daemon-reload
systemctl enable $name.service
systemctl start $name
systemctl status $name

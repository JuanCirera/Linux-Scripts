#!/bin/bash

#Param
# while getopts ":n:" opt; do
#   case $opt in
#     n) name="$OPTARG"
#     ;;
#     \?) echo "Invalid option -$OPTARG" >&2
#     exit 1
#     ;;
#   esac

#   case $OPTARG in
#     -*) echo "Option $opt needs a valid argument"
#     exit 1
#     ;;
#   esac
# done


#!/bin/bash

help_content="
Auto Service
This script creates and enable a service in systemd
Params:
	-n --name 		 [Service name without spaces]
	-d --description [Description for the service]
	-p --path 		 [The path of the script to execute by the service]
"

# script_path="$HOME/wol/enable_wol.sh"
# name="wol"
# description="Enable Wake On Lan"

name=$1
description=$2
script_path=$3
path="/etc/systemd/system/$service_name".service

while getopts ":n" opt; do
  case $opt in
    n)
      param=$OPTARG
      ;;
    *)
      echo "Unknown option: $opt"
      exit 1
      ;;
  esac
done

content="
[Unit]
Description= $description

[Service]
Type=oneshot
ExecStart = $script_path

[Install]
WantedBy=basic.target
"

# echo "$content" | tee "$path" > /dev/null

# if [ -e $path ]; then
#     echo "Servicio creado"

#     # Recarga systemd para que tome en cuenta el nuevo servicio
#     systemctl daemon-reload

#     # Habilita y comienza el servicio
#     systemctl enable "$name"
#     systemctl start "$name"
#         systemctl status "$name"
# else
#     echo "Error al crear el servicio"
# fi

help() {
	echo "$help_content"
}


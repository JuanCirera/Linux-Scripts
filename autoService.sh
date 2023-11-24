#!/bin/bash

serviceContent="
[Unit]
Description= $description

[Service]
Type=oneshot
ExecStart = $script_path

[Install]
WantedBy=basic.target
"

#paramMissing=false
path="/etc/systemd/system/$name".service


function showHelp() {
	echo "
Auto Service
This script creates and enable a service in systemd
Params:
    -n --name        [Service name without spaces]
    -d --description [Description for the service]
    -p --path        [The path of the script to execute by the service]
"
}

#Param
while [[ $# -gt 0 ]]; do
    key="$1"

    case $key in
        -n|--name)
			name="$2"
		shift
		;;
		-d|--description)
			description="$3"
        shift
        ;;
		-p|--path)
			scriptPath="$4"
        shift
        ;;
		-h|--help)
			showHelp
        shift
        ;;
        -*)
			echo "Invalid option. Use --help for options list."
        ;;
    esac
    shift

done

function createService(){
    
    # Service file creation  	
    touch $path
    echo $serviceContent > $path

    # Reload systemd to recognise the new service
    systemctl daemon-reload

    # Enables and starts service
    systemctl enable "$name"
    systemctl start "$name"
    systemctl status "$name"

    echo "Service created!"
}

if [[ -z "$name" ]] || [[ -z "$description" ]] || [[ -z "$scriptPath" ]]; then
	#paramMissing=true
	echo "Params -n, -d and -p must be set"
else
	createService
fi


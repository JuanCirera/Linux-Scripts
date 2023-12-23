#!/bin/bash

online=0
host=$(hostname)
chkCount=0
# Gotify params
readonly TEST_TOKEN=""
readonly TOKEN=""
readonly URL=""


function showHelp() {
	echo "
Auto Backup

This script starts a backup to remote PBS after doing some checks

Options:
    -p --path        The path of the pbs connection script
    -t -tittle       Tittle to show in the notification (Optional)
    -m -mac          MAC Address of the backup server (used for WOL)
    -a -address      IPv4 Address of the server
"

exit 0

}

# Terminate the script with a log message and code 1
function quit(){
    echo "$1"
    echo "[INFO] Exiting..."
    exit 1
}

#Params
while [[ $# -gt 0 ]]; do
    key="$1"

    case $key in
        -p|--path)
            backupScriptPath="$2"
        shift
        ;;
        -m|--mac)
            mac="$2"
        shift
        ;;
        -a|--address)
            ipv4="$2"
        shift
        ;;
        -t|--title)
            title="$2"
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

if [[ -z "$backupScriptPath" ]] || [[ -z "$mac" ]] || [[ -z "$ipv4" ]] || [[ -z "$title" ]]; then
    echo "Options --path, --mac, --address and --title must be set"
    exit 1
fi

# Wake up backup server
function wake() {
    echo "[INFO] Waking up remote server"

	# To ensure that correct MAC is passed, this code below quits the script if stderr is captured
	# 2>&1 redirect stderr to stdout and sends stdout to /dev/null
    local stderr=$(wakeonlan $mac 2>&1 > /dev/null)

    if [ -n "$stderr" ]; then
        quit "[ERROR] WOL failed! $stderr"
    fi
}

function backup() {
    echo "[INFO] Connecting to Proxmox Backup Server"
    bash $backupScriptPath
}

# Check if the server is online, if the server does not respond after 5 times the script continue and exits with code 1 
function isOnline(){

    ((chkCount++))

    for i in {1..5}
    do
        echo "[INFO] Checking server status..."

        if ping -c 3 $ipv4 &> /dev/null;
        then
            online=1
            echo "[INFO] Backup server ONLINE"
            break
        else
            echo "[WARNING] Backup server OFFLINE"
            echo "[INFO] Retrying..."
        fi
		
    done
}

# If server is power on, the backup process starts, if not the script ends
function checkStatus() {
    if [ $online -eq 1 ]; then
        backup
    elif [ $online -eq 0 ] && [ $chkCount -eq 1 ]; then
        wake
        echo "[INFO] Waiting for server start up"
        # Wait time to let pbs starts up
        sleep 40
        isOnline
        # Recursive call
        checkStatus 
    else
        curl -s -o /dev/null "$URL/message?token=$TOKEN" -F "title=$title" -F "message=Scheduled backup failed. Server not responding." -F "priority=5" 
        quit "[ERROR] Backup server not responding. Time out."
    fi
}

# Send notification
curl -s -o /dev/null "$URL/message?token=$TOKEN" -F "title=$title" -F "message=Scheduled backup started on $host" -F "priority=5" 

isOnline
checkStatus

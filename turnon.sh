#!/bin/bash

# Base URL and cookie directory
BASE_URL="http://192.168.20"
COOKIE_DIR="cookies"

# Function to perform the curl operations
perform_curl_operations() {
    local i=$1         # Loop index (1 to 5)
    local ip_offset=$2 # IP offset (200)
    local action=$3    # Action (start or stop)
    local cvar="${COOKIE_DIR}/cookie$i"
    local evar="${BASE_URL}.$((ip_offset + i))"

    # Login
    curl -s -b "$cvar" -c "$cvar" -X POST -d '{"username":"admin","password":"eve"}' "${evar}/api/auth/login"

    # Perform the action (start or stop)
    if [[ "$action" == "start" ]]; then
        curl -s -b "$cvar" -c "$cvar" -X GET -H 'Content-type: application/json' "${evar}/api/labs/jncis-dev.unl/nodes/start"
        echo "EVE $((ip_offset + i)) STARTED"
    elif [[ "$action" == "stop" ]]; then
        curl -s -b "$cvar" -c "$cvar" -X GET -H 'Content-type: application/json' "${evar}/api/labs/jncis-dev.unl/nodes/stop"
        echo "EVE $((ip_offset + i)) STOPPED"
    else
        echo "Invalid action: $action. Use 'start' or 'stop'."
        exit 1
    fi
}

# Validate action argument
if [[ "$1" != "start" && "$1" != "stop" ]]; then
    echo "Usage: $0 <start|stop>"
    exit 1
fi

# Main loop
for i in {1..5}; do
    # Pass the loop index, IP offset, and action to the function
    perform_curl_operations "$i" 200 "$1" &
done

# Wait for all background processes to finish
wait

echo "All operations completed."

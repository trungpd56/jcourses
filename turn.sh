#!/bin/bash

# Base URL and cookie directory
BASE_URL="http://192.168.20"
COOKIE_DIR="cookies"
action="stop"

perform_curl_operations() {
    local i=$1         # Loop index (1 to 5)
    local cvar="${COOKIE_DIR}/cookie$i"
    local evar="${BASE_URL}.$((50 + i))"
    curl -s -b "$cvar" -c "$cvar" -X POST -d '{"username":"admin","password":"eve"}' "${evar}/api/auth/login"
    curl -s -b "$cvar" -c "$cvar" -X GET -H 'Content-type: application/json' "${evar}/api/labs/jncia-sec.unl/nodes/${action}"
    echo "EVE $((ip_offset + i)) ${action^^}"
}

for i in {1..22}; do
    perform_curl_operations "$i"&
done

# Wait for all background processes to finish
wait
echo "All operations completed."

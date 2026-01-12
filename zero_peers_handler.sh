#!/bin/bash


URL=${1:?"Provide local prometheus metrics URL as the first argument"}
NETWORK=${2:?"Provide the systemd service name as the second argument"}
PEERS_THRESHOLD=${3:?"Provide the peers threshold"}

LOG_FILE="/var/log/"$NETWORK"_zero_peers_handler.log"

# Function to log messages with a timestamp
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

if systemctl is-active --quiet $NETWORK.service; then
    PEERS_COUNT="$(curl --silent $URL | grep substrate_sub_libp2p_peers_count\{chain=\"$NETWORK\"\} | awk '{print $2}')"

    if (( $PEERS_COUNT < $PEERS_THRESHOLD )); then
        log_message "Peers < $PEERS_THRESHOLD: restarting $NETWORK.service"
        systemctl restart $NETWORK.service
    else
        log_message $NETWORK"_peers_count=$PEERS_COUNT"
    fi
else
    echo "$NETWORK service is stopped or not exists"
fi

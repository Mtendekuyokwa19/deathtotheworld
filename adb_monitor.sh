#!/run/current-system/sw/bin/bash

PHONE_IP="192.168.177.159"
PORT="5555"
LOG_FILE="$HOME/adb_connection.log"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

check_connection() {
    adb devices | grep -q "${PHONE_IP}:${PORT}.*device"
}

connect_device() {
    log "Attempting to connect to ${PHONE_IP}:${PORT}..."
    adb connect "${PHONE_IP}:${PORT}"
    
    if check_connection; then
        log "Successfully connected to device"
        return 0
    else
        log "Failed to connect to device"
        return 1
    fi
}

# Main loop
log "Starting ADB connection monitor..."

while true; do
    if check_connection; then
        log "Device is connected"
    else
        log "Device connection lost, attempting to reconnect..."
        connect_device
    fi
    
    # Check every 30 seconds
    sleep 30
done
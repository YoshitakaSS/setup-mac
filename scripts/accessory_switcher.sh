# Function to pair or unpair a device based on its connection status
pair_or_unpair_device() {
    local DEVICE_ID="$1"
    local res=$(/usr/local/bin/blueutil --is-connected $DEVICE_ID)
    if [[ "$res" = '1' ]]; then
        /usr/local/bin/blueutil --unpair $DEVICE_ID
    else
        /usr/local/bin/blueutil --pair $DEVICE_ID
        sleep 1
        /usr/local/bin/blueutil --connect $DEVICE_ID
    fi
}

# Magic Keyboard ID and Magic Trackpad ID
MAGIC_TRACKPAD_ID="e0-eb-40-f2-65-cc"

# Call the function with the Magic Keyboard and Trackpad IDs
pair_or_unpair_device $MAGIC_TRACKPAD_ID

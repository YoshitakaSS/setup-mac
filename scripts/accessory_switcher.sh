# MacPorts は Intel / Apple Silicon とも /opt/local に入る
BLUEUTIL=$(command -v blueutil || echo /opt/local/bin/blueutil)

# Function to pair or unpair a device based on its connection status
pair_or_unpair_device() {
    local DEVICE_ID="$1"
    local res=$("$BLUEUTIL" --is-connected $DEVICE_ID)
    if [[ "$res" = '1' ]]; then
        "$BLUEUTIL" --unpair $DEVICE_ID
    else
        "$BLUEUTIL" --pair $DEVICE_ID
        sleep 1
        "$BLUEUTIL" --connect $DEVICE_ID
    fi
}

# Magic Keyboard ID and Magic Trackpad ID
MAGIC_TRACKPAD_ID="e0-eb-40-f2-65-cc"

# Call the function with the Magic Keyboard and Trackpad IDs
pair_or_unpair_device $MAGIC_TRACKPAD_ID

# Apple Silicon: Homebrew (/opt/homebrew) / Intel: MacPorts (/opt/local)
BLUEUTIL=$(command -v blueutil || ls /opt/homebrew/bin/blueutil /opt/local/bin/blueutil 2>/dev/null | head -1)
if [ -z "$BLUEUTIL" ]; then
    echo "blueutil が見つかりません (Apple Silicon: brew/bootstrap.sh、Intel: macports/bootstrap.sh で導入)" >&2
    exit 1
fi

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

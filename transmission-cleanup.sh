#!/bin/bash

# Disable history expansion (exclamation mark)
set +o histexpand

# Clears finished downloads from Transmission.
# Version: 1.0
#
# Based on this script:
# https://gist.github.com/pawelszydlo/e2e1fc424f2c9d306f3a

# Which torrent states should be removed at 100% progress.
DONE_STATES=("Stopped" "Finished" "Idle")

# Use transmission-remote to get the torrent list from transmission-remote.
echo "Retreiving torrent list"
TORRENT_LIST=$(transmission-remote $TRANSMISSION_SERVER --list | sed -e '1d' -e '$d' | awk '{print $1}' | sed -e 's/[^0-9]*//g')

# Wait 15 minutes to allow any last-minute processing by SickChill or CouchPotato
echo "Waiting 15 minutes after retrieval of torrent list"
sleep 15m

# Iterate through the torrents.
echo "Iterate through the torrent list"
for TORRENT_ID in $TORRENT_LIST
do
    INFO=$(transmission-remote $TRANSMISSION_SERVER --torrent "$TORRENT_ID" --info)
    echo -e "Processing #$TORRENT_ID: \"$(echo "$INFO" | sed -n 's/.*Name: \(.*\)/\1/p')\"..."
    # To see the full torrent info, uncomment the following line.
    # echo "$INFO"
    PROGRESS=$(echo "$INFO" | sed -n 's/.*Percent Done: \(.*\)%.*/\1/p')
    STATE=$(echo "$INFO" | sed -n 's/.*State: \(.*\)/\1/p')
    echo -e "Progress is $PROGRESS and STATE is $STATE"
    # If the torrent is 100% done and the state is one of the done states.
    if [[ "$PROGRESS" == "100" ]] && [[ "${DONE_STATES[@]}" =~ "$STATE" ]]; then
        echo "Torrent #$TORRENT_ID is done. Removing torrent from list."
        transmission-remote $TRANSMISSION_SERVER --torrent "$TORRENT_ID" --remove-and-delete
    else
        echo "Torrent #$TORRENT_ID is $PROGRESS% done with state \"$STATE\". Ignoring."
    fi
done

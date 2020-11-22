#!/usr/bin/env bash

# Root check
if [[ "${EUID}" -ne "0" ]]; then
    echo ""
    echo "You need root privileges to put something under 'bin' folder"
    exit 1
fi

apt-get update
apt-get install -y tcptraceroute
wget http://www.vdberg.org/~richard/tcpping -O /usr/bin/tcping
chmod 755 tcping

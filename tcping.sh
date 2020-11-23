#!/usr/bin/env bash

# Script to install tcping and make it executable under 'bin' folder

# Check if tcping is already installed
TCPING="$(command -v tcping)"
if [[ -n "${TCPING}" ]]; then
    echo "'tcping' is already installed!"
    exit 0
fi

# Root check
if [[ "${EUID}" -ne "0" ]]; then
    echo ""
    echo "You need root privileges to put something under 'bin' folder"
    exit 1
fi

TCPTRACEROUTE="$(command -v tcptraceroute)"
if [[ -z "${TCPTRACEROUTE}" ]]; then
    echo "'tcptraceroute' not installed, installing..."
    apt-get update
    apt-get install -y tcptraceroute
fi
wget http://www.vdberg.org/~richard/tcpping -O /usr/bin/tcping
chmod 755 /usr/bin/tcping
echo "tcping installed!"

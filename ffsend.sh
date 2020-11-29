#!/usr/bin/env bash

# Script to install ffsend

# Variables
VERSION="v0.2.68"
FNAME="ffsend-${VERSION}-linux-x64-static"

# Root check
if [[ "${EUID}" -ne "0" ]]; then
    echo "You need to run this script as root"
    exit 1
fi

echo "Downloading..."
wget -q https://github.com/timvisee/ffsend/releases/download/"${VERSION}"/"${FNAME}"
EXIT_CODE="${?}"
if [[ "${EXIT_CODE}" -ne "0" ]]; then
    echo "Download failed, exiting..."
    exit 1
else
    echo "Download OK"
fi
mv ./ffsend-* ./ffsend
chmod 755 ./ffsend
mv ./ffsend /usr/local/bin
echo "$(ffsend --version) installed!"

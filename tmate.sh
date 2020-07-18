#!/usr/bin/env bash

# Variables
VERSION="2.4.0"
NAME="tmate-${VERSION}-static-linux-amd64"

# Root check
if [[ "${EUID}" -ne "0" ]]; then
    echo ""
    echo "You need root privileges to put something under 'bin' folder"
    exit 1
fi

cd /tmp || exit 1
wget -q https://github.com/tmate-io/tmate/releases/download/"${VERSION}"/"${NAME}".tar.xz
tar -xf "${NAME}".tar.xz
cd "${NAME}" || exit 1
mv ./tmate /usr/bin
cd ..
rm -r "${NAME}" "${NAME}".tar.xz

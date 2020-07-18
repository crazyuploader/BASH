#!/usr/bin/env bash

# Variables
VERSION="2.4.0"
NAME="tmate-${VERSION}-static-linux-amd64"

cd /tmp || exit 1
wget https://github.com/tmate-io/tmate/releases/download/"${VERSION}"/"${NAME}".tar.xz
tar -xvf "${NAME}".tar.xz
cd "${NAME}" || exit 1
mv ./tmate /usr/bin
cd ..
rm -r "${NAME}" "${NAME}".tar.xz

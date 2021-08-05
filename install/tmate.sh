#!/usr/bin/env bash
set -eu
set -o pipefail

# Tmate Installer Script

# Variables
VERSION="2.4.0"

OS_ARCH="$(arch)"

case ${OS_ARCH} in

	x86_64)
		ARCH="amd64"
		;;
	
	aarch64)
		ARCH="arm64v8"
		;;
	
	*)
		echo "Unsupported Architecture"
		echo "Exiting..."
		exit 1
		;;
esac

NAME="tmate-${VERSION}-static-linux-${ARCH}"

# Root check
if [[ "${EUID}" -ne "0" ]]; then
	echo ""
	echo "You need root privileges to put something under 'bin' folder"
	exit 1
fi

cd /tmp || exit 1
wget --no-verbose https://github.com/tmate-io/tmate/releases/download/"${VERSION}"/"${NAME}".tar.xz
tar -xf "${NAME}".tar.xz
cd "${NAME}" || exit 1
mv ./tmate /usr/bin
cd ..
rm -r "${NAME}" "${NAME}".tar.xz

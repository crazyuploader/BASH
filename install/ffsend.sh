#!/usr/bin/env bash
set -eu
set -o pipefail

# Script to install ffsend

# Variables
VERSION="v0.2.77"
FNAME="ffsend-${VERSION}-linux-x64-static"

# Colors
NC="\033[0m"
RED="\033[0;31m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"

# Root check
if [[ "${EUID}" -ne "0" ]]; then
	echo "You need to run this script as root"
	exit 1
fi

# Arch Check
if [[ "$(arch)" != "x86_64" ]]; then
	echo "Architecture Not Supported!"
	echo "Exiting..."
	exit 0
fi

echo "Downloading ffsend ${VERSION}..."
wget -q https://github.com/timvisee/ffsend/releases/download/"${VERSION}"/"${FNAME}"
EXIT_CODE="${?}"
if [[ "${EXIT_CODE}" -ne "0" ]]; then
	echo -e "Download failed, ${RED}exiting...${NC}"
	exit 1
else
	echo -e "Download ${YELLOW}OK${NC}"
fi
mv ./ffsend-* ./ffsend
chmod 755 ./ffsend
mv ./ffsend /usr/local/bin
echo -e "${GREEN}$(ffsend --version) installed!${NC}"

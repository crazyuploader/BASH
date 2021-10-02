#!/usr/bin/env bash

set -eu
set -o pipefail

# Script to install Cloudflared
#
# https://github.com/cloudflare/cloudflared

# Colors
GREEN="\033[1;32m"
NC="\033[0m"
YELLOW="\033[1;33m"
RED="\033[0;31m"

# Root Check
if [[ "${EUID}" -ne "0" ]]; then
	echo -e "${YELLOW}Run this script as root!${NC}"
	echo -e "${RED}Exiting...${NC}"
	exit 1
else
	echo -e "${GREEN}Script running as root, continuing...${NC}"
	sleep 1
fi

# Function for Latest GitHub Release Version
get_latest_release() {
	curl --silent "https://api.github.com/repos/cloudflare/cloudflared/releases/latest" |
		grep '"tag_name":' |
		sed -E 's/.*"([^"]+)".*/\1/'
}

# Variable(s)
CLOUDFLARED_VERSION=$(get_latest_release)
OS_ARCH=$(arch)

case ${OS_ARCH} in

x86_64)
	CLOUDFLARED_ARCH=amd64
	;;

aarch64)
	CLOUDFLARED_ARCH=arm64
	;;

armv7l)
	CLOUDFLARED_ARCH=armv7
	;;

*)
	echo -e "Unsupported architecture: ${YELLOW}${OS_ARCH}${NC}"
	echo -e "${RED}Exiting...${NC}"
	exit 1
	;;
esac

URL="https://github.com/cloudflare/cloudflared/releases/download/${CLOUDFLARED_VERSION}/cloudflared-linux-${CLOUDFLARED_ARCH}.deb"

# Downloading and installing Cloudflared
cd /tmp
echo ""
echo -e "Downloading Cloudflared version ${YELLOW}${CLOUDFLARED_VERSION}${NC}"
echo ""
curl -sL "${URL}" -o cloudflared.deb
echo -e "Download ${GREEN}OK!${NC}"
echo ""
echo -e "${YELLOW}Installing Cloudflared...${NC}"
echo ""
dpkg -i cloudflared.deb
echo ""
echo -e "Cloudflared installed, version: ${GREEN}$(cloudflared --version)${NC}"

#!/usr/bin/env bash
set -eu
set -o pipefail

# Script to Install Brave Browser on System

# Colors
GREEN="\033[1;32m"
NC="\033[0m"
YELLOW="\033[1;33m"
RED="\033[0;31m"

if [[ -n "$(command -v brave-browser)" ]]; then
	echo "Brave Browser already seems to be installed on the system"
	echo -e "Version: ${GREEN}$(brave-browser --version)${NC}"
	echo -e "${YELLOW}Exiting...${NC}"
	exit 0
fi

# Root Check
if [[ "${EUID}" -ne "0" ]]; then
	echo -e "${YELLOW}Run this script as root!${NC}"
	echo -e "${RED}Exiting...${NC}"
	exit 1
else
	echo -e "${GREEN}Script running as root, continuing...${NC}"
	sleep 1
fi

apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install -y apt-transport-https curl
curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | tee /etc/apt/sources.list.d/brave-browser-release.list
apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install -y brave-browser
echo -e "${GREEN}$(brave-browser --version) installed!${NC}"

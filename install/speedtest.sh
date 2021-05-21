#!/usr/bin/env bash
set -eu
set -o pipefail

# Script to install official Speedtest.net CLI on Ubuntu/Debian

# Colors
GREEN="\033[1;32m"
NC="\033[0m"
YELLOW="\033[1;33m"
RED="\033[0;31m"

# Root check
if [[ "${EUID}" -ne "0" ]]; then
	echo ""
	echo -e "${YELLOW}Need root privileges, run this script as root${NC}"
	echo -e "${RED}Exiting...${NC}"
	exit 1
fi

curl -s https://install.speedtest.net/app/cli/install.deb.sh | bash

apt-get install -y speedtest

if [[ -n "$(command -v speedtest)" ]]; then
	echo -e "${GREEN}Speedtest CLI installed!${NC}"
	speedtest --version
else
	echo -e "${RED}Speedtest CLI not installed!${NC}"
fi

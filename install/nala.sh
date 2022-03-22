#!/usr/bin/env bash

# Nala Installer Script
#
# https://gitlab.com/volian/nala

# Colors
GREEN="\033[1;32m"
NC="\033[0m"
YELLOW="\033[1;33m"
RED="\033[0;31m"

# Check if Nala exists
if [[ -n "$(command -v nala)" ]]; then
	echo -e "${YELLOW}Nala $(nala --version)${NC} already exists!"
	echo "Exiting..."
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

# Adding Repository
echo "deb [arch=amd64,arm64,armhf] http://deb.volian.org/volian/ scar main" | tee /etc/apt/sources.list.d/volian-archive-scar-unstable.list
wget -qO - https://deb.volian.org/volian/scar.key | tee /etc/apt/trusted.gpg.d/volian-archive-scar-unstable.gpg > /dev/null

# Update apt packages & install Nala
apt-get update
apt-get install nala

echo -e "${GREEN} $(nala --version)${NC}"
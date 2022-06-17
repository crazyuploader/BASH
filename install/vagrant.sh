#!/usr/bin/env bash

# Vagrant installer script
#
# https://www.vagrantup.com/downloads

# Colors
GREEN="\033[1;32m"
NC="\033[0m"
YELLOW="\033[1;33m"
RED="\033[0;31m"

# Check if Nala exists
if [[ -n "$(command -v vagrant)" ]]; then
	echo -e "${YELLOW}Nala $(vagrant --version)${NC} already exists!"
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

# Add Vagrant Repository
curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp_com.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/hashicorp_com.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp-vagrant-stable.list

# Update apt packages & install Vagrant
apt-get update
apt-get install --y vagrant

echo -e "${GREEN} $(vagrant --version)${NC}"

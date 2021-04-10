#!/usr/bin/env bash
set -eu
set -o pipefail

# Docker Installer

# Setting Non-Interactive Environment Variable
export DEBIAN_FRONTEND=noninteractive

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

# Docker Check
if [[ -n "$(command -v docker)" ]]; then
	echo "Docker is Already Present on the System"
	echo ""
	echo -e "Docker Version: ${GREEN}$(docker --version | cut -d " " -f 3,4,5)${NC}"
	echo ""
	echo "Exiting..."
	exit 0
fi

# Installing Docker
echo "Installing Docker..."
echo ""
apt-get update
apt-get install -y \
	apt-transport-https \
	ca-certificates \
	curl \
	gnupg-agent \
	software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io
echo ""
echo -e "Docker Installed Version: ${GREEN}$(docker --version | cut -d " " -f 3,4,5)${NC}"

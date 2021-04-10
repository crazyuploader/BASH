#!/usr/bin/env bash
set -eu
set -o pipefail

# Docker Compose Installer Script

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

# Check Docker
if [[ -z "$(command -v docker)" ]]; then
	echo -e "${YELLOW}Docker is not installed on the system${NC}"
	echo ""
	echo "Install Docker by running -"
	echo ""
	echo -e "\tcurl -s https://raw.githubusercontent.com/crazyuploader/BASH/master/install/docker.sh | bash -"
	echo ""
	echo "Exiting..."
	exit 0
else
	echo -e "${GREEN}Docker Installed, continuing...${NC}"
fi

# Check Docker-Compose
if [[ -n "$(command -v docker-compose)" ]]; then
	echo -e "${YELLOW}Docker-Compose already installed, exiting...${NC}"
	exit 0
fi

# Function for Latest GitHub Release Version
get_latest_release() {
	curl --silent "https://api.github.com/repos/docker/compose/releases/latest" |
		grep '"tag_name":' |
		sed -E 's/.*"([^"]+)".*/\1/'
}

# Variables
VERSION="$(get_latest_release)"
URL="https://github.com/docker/compose/releases/download/${VERSION}/docker-compose-Linux-x86_64"

# Downloading Docker Compose
echo "Downloading Docker-Compose"
curl -sL "${URL}" -o /usr/local/bin/docker-compose
echo "Done!"
chmod +x /usr/local/bin/docker-compose
echo -e "Docker-Compose Version: ${GREEN}$(docker-compose --version | cut -d " " -f 3,4,5)${NC}"

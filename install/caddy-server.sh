#!/usr/bin/env bash
set -eu
set -o pipefail

# Caddy Server Installer Script

# Colors
GREEN="\033[1;32m"
NC="\033[0m"
YELLOW="\033[1;33m"
RED="\033[0;31m"

# Check if Caddy Server exists
if [[ -n "$(command -v caddy)" ]]; then
	echo -e "${YELLOW}Caddy Server $(caddy version)${NC} already exists!"
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

# Installing dependencies
echo "Running... apt-get install -y debian-keyring debian-archive-keyring apt-transport-https"
apt-get install -y debian-keyring debian-archive-keyring apt-transport-https

# Adding GPG Key and Setting Repository
echo "Running... curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | tee /etc/apt/trusted.gpg.d/caddy-stable.asc"
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | tee /etc/apt/trusted.gpg.d/caddy-stable.asc
echo "Running... curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | tee /etc/apt/sources.list.d/caddy-stable.list"
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | tee /etc/apt/sources.list.d/caddy-stable.list

# Update apt packages
echo "Running... apt-get update"
apt-get update

# Install Caddy Server
echo "Running... apt-get install -y caddy"
apt-get install -y caddy

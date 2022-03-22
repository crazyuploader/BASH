#!/usr/bin/env bash

# Script to install Nginx Server
# https://nginx.org/en/linux_packages.html#Ubuntu

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

# Installing prerequisites
apt-get install -y curl gnupg2 ca-certificates lsb-release ubuntu-keyring

# Import Nginx GPG Key
curl https://nginx.org/keys/nginx_signing.key | gpg --dearmor \
    | tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null

# Dry run to check if the key is imported
gpg --dry-run --quiet --import --import-options import-show /usr/share/keyrings/nginx-archive-keyring.gpg

# Add Nginx Official Repository
echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
http://nginx.org/packages/ubuntu $(lsb_release -cs) nginx" \
    | tee /etc/apt/sources.list.d/nginx.list

# Set up pinning repository
echo -e "Package: *\nPin: origin nginx.org\nPin: release o=nginx\nPin-Priority: 900\n" \
    | tee /etc/apt/preferences.d/99nginx

# Update apt packages & install Nginx
apt-get update
apt-get install -y nginx

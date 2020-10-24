#!/usr/bin/env bash

# Script to install official Speedtest.net CLI on Ubuntu
# NOTE: Only bionic, xeniel are supported as of now

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

# Check if "lsb_release" is installed, since this script relies on it
if [[ -z "$(command -v lsb_release)" ]]; then
    echo ""
    echo -e "${YELLOW}Need 'lsb_release' to be installed or this script won't work${NC}"
    echo -e "${RED}Exiting...${NC}"
    exit 1
fi

apt-get install -y \
     gnupg1 apt-transport-https dirmngr
INSTALL_KEY="379CE192D401AB61"
DEB_DISTRO="$(lsb_release -sc)"
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys ${INSTALL_KEY}
echo "deb https://ookla.bintray.com/debian ${DEB_DISTRO} main" | tee  /etc/apt/sources.list.d/speedtest.list
apt-get update
apt-get install -y speedtest 1> /dev/null
echo ""
SPEEDTEST="$(command -v speedtest)"
if [[ -n "${SPEEDTEST}" ]]; then
    echo -e "${GREEN}Speedtest Official CLI installed!${NC}"
fi
echo ""
speedtest --version

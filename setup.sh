#!/usr/bin/env bash
set -eu
set -o pipefail

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

# Installing Package(s)
apt-get update
apt-get install -y --no-install-recommends \
	git \
	curl \
	python3 \
	python3-pip \
	wget \
	nano \
	tar \
	zip \
	unzip \
	python-is-python3 \
	neofetch \
	gpg \
	ssh \
	xz-utils \
	iputils-ping \
	traceroute \
	mtr-tiny \
	net-tools \
	nmap \
	iftop \
	tmux \
	screen \
	gpg-agent \
	jq \
	python3-venv \
	tree \
	shellcheck 1>/dev/null

# Installing Docker and Docker Compose
curl -sL https://get.docker.com | bash -

# Installing Speedtest CLI
curl -sL https://raw.githubusercontent.com/crazyuploader/BASH/master/install/speedtest.sh | bash -

# Installing Brave Browser
curl -sL https://raw.githubusercontent.com/crazyuploader/BASH/master/install/brave-browser.sh | bash -

# Installing ffsend
curl -sL https://raw.githubusercontent.com/crazyuploader/BASH/master/install/ffsend.sh | bash -

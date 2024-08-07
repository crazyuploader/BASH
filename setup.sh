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

function add_user_to_docker_group() {
	USER="$(id -u jungle &>/dev/null)"
	EXIT_CODE="${?}"
	if [[ "${EXIT_CODE}" -eq "0" ]]; then
		echo "Adding user \"jungle\" to 'docker' group"
		usermod -aG docker jungle
		echo "Added 'jungle' to 'docker' group..."
	fi
}

# Installing Package(s)
apt-get update
apt-get install -y --no-install-recommends \
	bc \
	curl \
	git \
	gpg \
	gpg-agent \
	iftop \
	iputils-ping \
	jq \
	libssl-dev \
	make \
	mosh \
	mtr-tiny \
	nano \
	neofetch \
	net-tools \
	nmap \
	python3 \
	python3-pip \
	python3-venv \
	python-is-python3 \
	screen \
	shellcheck \
	ssh \
	tar \
	tmux \
	traceroute \
	tree \
	unzip \
	vim \
	wget \
	xz-utils \
	zip

# Installing Docker and Docker Compose
curl -sL https://get.docker.com | bash -
add_user_to_docker_group
curl -sL https://raw.githubusercontent.com/crazyuploader/BASH/master/install/docker-compose.sh | bash -

# Running Docker Container(s)
echo "Pulling adolfintel/speedtest..."
docker pull adolfintel/speedtest >/dev/null 2>&1
docker run --restart=unless-stopped --name=speedtest -e MODE=standalone -p 12345:80 --detach lscr.io/linuxserver/librespeed:latest

# Installing Speedtest CLI
curl -sL https://raw.githubusercontent.com/crazyuploader/BASH/master/install/speedtest.sh | bash -

# Installing Brave Browser
curl -sL https://raw.githubusercontent.com/crazyuploader/BASH/master/install/brave-browser.sh | bash -

# Installing ffsend
curl -sL https://raw.githubusercontent.com/crazyuploader/BASH/master/install/ffsend.sh | bash -

echo -e "${GREEN}Script Finished!${NC}"
echo ""
echo "================================================================"
echo ""
echo -e "Docker Version: ${YELLOW}$(docker --version)${NC}"
echo ""
echo -e "Docker Compose Version: ${YELLOW}$(docker-compose --version)${NC}"
echo ""
echo -e "Speedtest Version: ${YELLOW}$(speedtest --version)${NC}"
echo ""
echo -e "Brave Version: ${YELLOW}$(brave-browser --version)${NC}"
echo ""
echo -e "ffsend Version: ${YELLOW}$(ffsend --version)${NC}"

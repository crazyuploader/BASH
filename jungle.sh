#!/usr/bin/env bash
set -e
set -o pipefail

#
# Created by Jugal Kishore - 2021
#

# Colors
GREEN="\033[1;32m"
NC="\033[0m"
YELLOW="\033[1;33m"
RED="\033[0;31m"

# Variable(s)
export DEBIAN_FRONTEND=noninteractive
if [[ -z "${SKIP_PYTHON}" ]]; then
	SKIP_PYTHON=false
fi
if [[ -z "${INSTALL_ALL}" ]]; then
	INSTALL_ALL=true
fi

function print() {
	if ! [ -t 1 ]; then
		echo "${2}"
		return 0
	fi

	case "${1}" in
	green)
		echo -e "${GREEN}[INFO]${NC} ${2}"
		;;
	yellow)
		echo -e "${YELLOW}[WARN]${NC} ${2}"
		;;
	red)
		echo -e "${RED}[ERROR]${NC} ${2}"
		;;
	*)
		echo "${2}"
		;;
	esac
}

# Root Check
if [[ "${EUID}" -ne "0" ]]; then
	print yellow "Run this script as root!"
	print error "Exiting..."
	exit 1
else
	print green "Script running as root, continuing..."
fi

# Check if user 'jungle' exists
if id -u jungle >/dev/null 2>&1; then
	print yellow "User 'jungle' already exists!"
	print red "Exiting..."
	exit 1
else
	print green "User 'jungle' does not exist, continuing..."
fi

# Add sudo if not already present
if [[ -z "$(command -v sudo)" ]]; then
	print yellow "sudo not found, installing..."
	apt-get update
	apt-get install -y sudo
fi

# Random Password
PASSWORD=$(date +%s | sha256sum | base64 | head -c 32)

# Add user 'jungle' to the system
useradd --create-home --shell /usr/bin/bash jungle
usermod -aG sudo jungle
print yello "Using Password: ${PASSWORD}"
echo "jungle:${PASSWORD}" | chpasswd jungle
print yellow "Password for user 'jungle' set!"
echo "jungle ALL=(ALL) NOPASSWD:ALL" >>/etc/sudoers

# Check if curl is installed
if [[ -z "$(command -v curl)" ]]; then
	print yellow "curl not found, installing..."
	apt-get update
	apt-get install -y curl 1>/dev/null
fi

# Adding SSH Public Key(s)
sudo -i -u jungle bash <<EOF
mkdir ~/.ssh
curl -sL https://keys.devjugal.com/ssh >> /home/jungle/.ssh/authorized_keys
chmod 600 /home/jungle/.ssh/authorized_keys
EOF

# Installing Python3, and Pip3
if [[ "${SKIP_PYTHON}" == "true" ]] || [[ "${SKIP_PYTHON}" == "True" ]]; then
	print yellow "Skipping Python3 Installation..."
else
	apt-get update 1>/dev/null
	apt-get install -y python3 python3-pip python3-dev python3-setuptools 1>/dev/null
	print green "Python3 Installed!"
fi

# Upgrading Package(s)
print yellow "Upgrading package(s)..."
apt-get upgrade -y

# Installing package(s)
if [[ "${INSTALL_ALL}" == "true" ]] || [[ "${INSTALL_ALL}" == "True" ]]; then
	print yellow "Installing package(s)..."
	apt-get install -y --no-install-recommends \
		bc \
		ccze \
		dnsutils \
		git \
		gpg \
		gpg-agent \
		iftop \
		iputils-ping \
		jq \
		libssl-dev \
		lolcat \
		make \
		mtr-tiny \
		nano \
		neofetch \
		net-tools \
		nmap \
		screen \
		tar \
		tcpdump \
		tmux \
		traceroute \
		tree \
		unzip \
		vim \
		wget \
		xz-utils \
		zip
fi

print yellow "User Password: ${PASSWORD}"
print green "Script Finished!"

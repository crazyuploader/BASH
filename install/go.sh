#!/usr/bin/env bash

set -eu
set -o pipefail

# Script to install Go Lang
#
# https://golang.org/dl/

# Colors
GREEN="\033[1;32m"
NC="\033[0m"
YELLOW="\033[1;33m"
RED="\033[0;31m"

# Check if Go Lang is installed
if [[ -n "$(command -v go)" ]]; then
	echo -e "Go Lang is already ${GREEN}installed${NC}"
	exit 0
fi

# Variable(s)
VERSION="1.17.3"
OS_ARCH="$(arch)"

case ${OS_ARCH} in

x86_64)
	GO_ARCH=amd64
	;;

aarch64)
	GO_ARCH=arm64
	;;

*)
	echo -e "${YELLOW}${OS_ARCH}${NC} "
	echo -e "${RED}Exiting...${NC}"
	exit 1
	;;
esac

# Downloading Go Lang
echo -e "Downloading Go Lang ${YELLOW}${VERSION}${NC} for ${YELLOW}${GO_ARCH}${NC}..."
curl -sL "https://golang.org/dl/go${VERSION}.linux-${GO_ARCH}.tar.gz" | tar -xz -C /usr/local
echo ""
echo -e "${GREEN}Download completed...${NC}"
echo ""
if [[ -f "/home/jungle/.bashrc" ]]; then
	{
		echo "PATH=\"${PATH}:/usr/local/go/bin\""
		echo "export GOROOT=\"/usr/local/go"\"
		echo "export GOPATH==\"/home/jungle/go"\" 
	} >> /home/jungle/.bashrc
	echo ""
	echo -e "${GREEN}Go Lang $(go version) is now installed.${NC}"
else
	echo -e "${YELLOW}Go Binaries are available in /usr/local/go/bin directory...${NC}"
fi

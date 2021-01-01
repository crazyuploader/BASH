#!/usr/bin/env bash
set -e

clear
echo "Setting up Termux App"
echo ""

# Update local packages list
apt-get update

# Pretty much assumption
yes "Y" | apt-get upgrade -y

# Install packages
apt-get install -y openssh dnsutils nano \
	git python nodejs yarn \
	tracepath man

# Installing root repo
apt-get install -y root-repo

# Install sudo and mtr
apt-get install -y tsu mtr

echo ""
git --version
echo ""
python --version
echo ""
pip --version
echo ""
echo "Node Version: $(node --version)"
echo ""
echo "NPM: $(npm --version)"
echo ""
echo "Yarn: $(yarn --version)"
echo ""
echo "Done!"

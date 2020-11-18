#!/usr/bin/env bash
set -e

clear
echo "Setting up Termux App"
echo ""
apt-get update
yes "Y" | apt-get upgrade -y
apt-get install -y openssh dnsutils nano \
                   git python nodejs-lts yarn \
                   tracepath man
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

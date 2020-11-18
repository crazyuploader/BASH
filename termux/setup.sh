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
python --version
pip --version
node --version
npm --version
yarn --version
echo ""
echo "Done!"

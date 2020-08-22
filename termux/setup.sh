#!/usr/bin/env bash

echo "Setting your Termux App"
echo ""
apt-get update
apt-get upgrade -y
apt-get install -y openssh dnsutils nano \
                   git python nodejs-lts yarn
termux-setup-storage
echo "Done!"

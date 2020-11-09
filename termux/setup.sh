#!/usr/bin/env bash

clear
echo "Setting up Termux App"
echo ""
apt-get update
apt-get upgrade -y
apt-get install -y openssh dnsutils nano \
                   git python nodejs-lts yarn \
                   mtr traceroute
termux-setup-storage
echo "Done!"

#!/usr/bin/env bash

# Script to install official Speedtest.net CLI
# NOTE: Only bionic, xeniel are supported as of now

sudo apt-get install -y gnupg1 apt-transport-https dirmngr
INSTALL_KEY="379CE192D401AB61"
DEB_DISTRO=$(lsb_release -sc)
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys ${INSTALL_KEY}
echo "deb https://ookla.bintray.com/debian ${DEB_DISTRO} main" | sudo tee  /etc/apt/sources.list.d/speedtest.list
sudo apt-get update
sudo apt-get install -y speedtest

#!/usr/bin/env bash
set -e

# Script to install RIPE Atlas Software Probe

# Install Required Packages
apt-get update
apt-get -y install \
	git
tar
fakeroot
libssl-dev
libcap2-bin
autoconf
automake
libtool
build-essential

BRANCH="${1}"

if [[ -z "${BRANCH}" ]]; then
	git clone --recursive https://github.com/RIPE-NCC/ripe-atlas-software-probe.git
else
	git clone --recursive https://github.com/RIPE-NCC/ripe-atlas-software-probe.git -b "${BRANCH}"
fi

./ripe-atlas-software-probe/build-config/debian/bin/make-deb
sudo dpkg -i atlasswprobe*.deb
echo ""
echo -e "Public Key -\n\t$(cat /var/atlas-probe/etc/probe_key.pub)"
echo ""

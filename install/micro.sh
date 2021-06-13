#!/usr/bin/env bash
set -eu
set -o pipefail

# Install Script for Micro Text Editior
# https://github.com/zyedidia/micro

function move() {
	if [[ -z "$(command -v sudo)" ]]; then
		mv ./micro /usr/bin
	else
		sudo mv ./micro /usr/bin
	fi
}

curl https://getmic.ro | bash
move

echo "Micro Installed!"
micro --version

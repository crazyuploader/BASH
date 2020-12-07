#!/usr/bin/env bash

# Colors
GREEN="\033[1;32m"
NC="\033[0m"
YELLOW="\033[1;33m"
RED="\033[0;31m"

# Variable Check

if [[ -z "${GNUGPG}" ]]; then
	echo -e "${RED}FATAL: 'GNUGPG' variable not provided, exiting...${NC}"
	exit 0
fi

CURRENT_DIR="$(pwd)"
cd ~ || exit 1
rm -rf .gnupg
echo -e "${YELLOW}Old GNUGPG Directory Removed${NC}"
echo "${GNUGPG}" | base64 -d | tar --no-same-owner -xzvf -
cd "${CURRENT_DIR}" || exit 1
GPG_TTY=$(tty)
export GPG_TTY
echo -e "${GREEN}Done setting GPG Keys${NC}"
echo ""
echo -e "Confirm the same by running -\n\n\techo \"Test\" | gpg --clearsign"

echo ""
if [[ -z "${GPG_KEY}" ]]; then
	echo -e "${YELLOW}'GPG_KEY' variable not provided, won't setup GIT GPG${NC}"
else
	echo "'GPG_KEY' variable provided, setting up GIT GPG globably"
	git config --global user.signingkey "${GPG_KEY}"
	git config --global commit.gpgsign true
	echo -e "GPG Key for signing: ${GREEN}$(git config user.signingkey)${NC}"
	echo -e "GPG Commit Sign Status: ${GREEN}$(git config commit.gpgsign)${NC}"
	echo -e "Done!"
fi

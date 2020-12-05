#!/usr/bin/env bash

# Created By Jugal Kishore -- 2020
# Update Repositories Script

# Colors
NC="\033[0m"
RED="\033[0;31m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"

clear
echo -e "${YELLOW}Please wait, updating your repositories from GitHub${NC}"
echo ""
for f in */; do
	f="$(echo "$f" | cut -d "/" -f 1)"
	if [[ ${f} != "and" && ${f} != "temp" ]]; then
		cd "$f" || {
			echo -e "Error while changing directory to ${RED}${f}${NC}"
			exit 1
		}
		if [[ -d ".git" ]]; then
			echo -e "Updating Repository ---> ${GREEN}'${f}'${NC}"
			echo ""
			echo -e "Current Branch: ${GREEN}$(git rev-parse --abbrev-ref HEAD)${NC} at ${GREEN}$(git config --get remote.origin.url)${NC}"
			echo ""
			git pull
		else
			echo -e "${YELLOW}'${f}'${NC} is not a git repository, skipping."
		fi
		echo ""
		cd ..
	fi
done
echo "Done!"

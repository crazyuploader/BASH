#!/usr/bin/env bash

# Created By Jugal Kishore -- 2020
# Update Repositories Script

# Colors
NC='\033[0m'
RED='\033[0;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'

clear
echo -e "${YELLOW}Please wait, updating your repositories from GitHub${NC}"
echo ""
for f in */; do
    if [[ ${f} != "and/" ]]; then
        echo -e "Updating ${GREEN}${f}${NC}"
        cd "$f" || { echo -e "Error while changing directory to ${RED}${f}${NC}"; exit 1; }
        git pull
        echo ""
        cd ..
    fi
done
echo "Done!"

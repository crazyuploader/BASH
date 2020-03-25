#!/usr/bin/env bash

# Colors
GREEN="\033[1;32m"
NC="\033[0m"
YELLOW="\033[1;33m"

echo ""
echo -e "${GREEN}Checking all the files with Shellcheck${NC}"
for f in *.sh; do echo ""; echo "Checking '$f'"; shellcheck "$f"; done
echo ""
echo -e "${YELLOW}Done!${NC}"

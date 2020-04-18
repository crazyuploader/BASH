#!/usr/bin/env bash

# Colors
GREEN="\033[1;32m"
NC="\033[0m"
YELLOW="\033[1;33m"
MAGENTA="\033[1;35m"
RED="\033[0;31m"

echo ""
echo -e "${GREEN}" "Available File(s) -${NC}"
if [[ ! -d "temp" ]]; then
    mkdir temp
fi
LIST_FILES="$(find src/ -name '*.java')"
echo "${LIST_FILES}"
echo ""
FILES=0
ERROR_FILE=0
echo -e "${YELLOW}Compiling with Javac${NC}"
echo ""
for f in ${LIST_FILES}; do
    ((FILES = FILES + 1))
    echo "Compiling '${f}'";
    javac "${f}" -d ./temp
    ERROR_CODE="$?"
    if [[ ${ERROR_CODE} != "0" ]]; then
        echo ""
        echo -e "${RED}Error while compiling ${MAGENTA}'${f}'${NC}"
        echo ""
        ((ERROR_FILE = ERROR_FILE + 1))
    fi
done
echo ""
if [[ ${ERROR_FILE} != "0" ]]; then
    echo -e "${YELLOW}Error(s) in some file(s).${NC}"
    echo ""
    echo -e "No. of file(s) checked: ${GREEN}${FILES}${NC}"
    echo -e "No. of file(s) with error(s): ${RED}${ERROR_FILE}${NC}"
    exit 1
else
    echo -e "No. of file(s) checked: ${GREEN}${FILES}${NC}"
fi

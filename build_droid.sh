#!/usr/bin/env bash

# Colors
NC="\033[0m"
RED="\033[0;31m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"

echo -e "${YELLOW}Android App Builder${NC}"
echo ""
DIR_TB=""
NUM_TB=0
for dir in */; do
    cd "${dir}" || exit 1
    if [[ -f "build.gradle" ]]; then
        DIR_TB="${dir} ${DIR_TB}"
        ((NUM_TB = NUM_TB + 1))
    fi
	cd ..
done
echo -e "${GREEN}" "Available Directorie(s) -${NC}"
for f in ${DIR_TB}; do
    echo "${f}"
done
echo ""
echo -e "${GREEN}Gradle Version:${NC}\n$(gradle --version)"
echo ""
ERROR_DIR=0
for build in ${DIR_TB}; do
    cd "${build}" || exit 1
    echo "Trying ---> ${build}"
    BUILD_OUTPUT="$(gradle build)"
    ERROR_CODE="$?"
    if [[ "${ERROR_CODE}" != "0" ]]; then
        echo -e "${RED}---Error---${NC}"
        echo ""
        echo "${BUILD_OUTPUT}"
        echo ""
        echo -e "${RED}---Error---${NC}"
        ((ERROR_DIR = ERROR_DIR + 1))
    else
        echo ""
        echo "${BUILD_OUTPUT}"
        echo ""
    fi
    cd ..
done
if [[ "${ERROR_DIR}" != "0" ]]; then
    echo -e "${GREEN}Checked Directorie(s): ${NC}${YELLOW}${NUM_TB}${NC}"
    echo ""
    echo -e "${RED}Number of Directorie(s) with Error: ${NC}${YELLOW}${ERROR_DIR}${NC}"
    exit 1
else
    echo -e "${GREEN}Checked Directorie(s): ${NC}${YELLOW}${NUM_TB}${NC}"
fi

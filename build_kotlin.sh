#!/usr/bin/env bash

# Colors
GREEN="\033[1;32m"
NC="\033[0m"
YELLOW="\033[1;33m"
# MAGENTA="\033[1;35m"
RED="\033[0;31m"

echo ""
FILES=0
LIST_FILES="$(find src/ -name "*.kt")"
echo -e "${GREEN} Available File(s) -${NC}"
for file in ${LIST_FILES}; do
	((FILES = FILES + 1))
	echo "${file}"
done
echo ""
echo "Running Gradle Build"
GRADLE_OUTPUT=$(./gradlew build)
ERROR_CODE="$?"
if [[ ${ERROR_CODE} != 0 ]]; then
	echo ""
	echo -e "${RED}---G-R-A-D-L-E--O-U-T-P-U-T---\n\n${GRADLE_OUTPUT}${NC}"
	echo ""
	echo -e "${YELLOW}Error(s) in some file(s).${NC}"
	echo ""
	echo -e "No. of file(s) checked: ${GREEN}${FILES}${NC}"
	exit 1
else
	echo ""
	echo -e "${GRADLE_OUTPUT}"
	echo ""
	echo -e "No. of file(s) checked: ${GREEN}${FILES}${NC}"
fi

#!/usr/bin/env bash

# Colors
GREEN="\033[1;32m"
NC="\033[0m"
YELLOW="\033[1;33m"
RED="\033[0;31m"

# List all the .sh file(s)
echo -e "${GREEN}" "Available files -${NC}"
FILES=0
LIST_FILES="$(find . -path ./.git -prune -o -name '*.sh' -print | sed 's|^./||' | sort)"
for file in ${LIST_FILES}; do
	echo "$file"
	((FILES = FILES + 1))
done
echo ""

# Check file(s) with ShellCheck
echo -e "Checking file(s) with ${YELLOW}Shellcheck${NC}"
echo ""
ERROR_FILES=0
for file in ${LIST_FILES}; do
	echo "Checking '${file}'"
	shellcheck "${file}" >/dev/null 2>&1
	ERROR_CODE="${?}"
	if [[ "${ERROR_CODE}" -ne "0" ]]; then
		shellcheck "${file}"
		echo ""
		((ERROR_FILES = ERROR_FILES + 1))
	else
		echo "OK"
		echo ""
	fi
done

if [[ "${ERROR_FILES}" -eq "0" ]]; then
	echo -e "Number of file(s) checked: ${GREEN}${FILES}${NC}"
else
	echo -e "Number of file(s) checked: ${RED}${FILES}${NC}"
	exit 1
fi

#!/usr/bin/env bash

# Colors
NC="\033[0m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"

# Check Git Identity Variables
GIT_USERNAME="$(git config user.name)"
GIT_EMAIL="$(git config user.email)"

function GET_IDENTITY() {
    if [[ "${TEMP}" == "y" ]]; then
        echo ""
        echo -e "${YELLOW}Kindly enter your Git Email${NC}"
        read -r EMAIL
        echo ""
        echo -e "${YELLOW}Kindly enter your Git Name${NC}"
        read -r USERNAME
        echo ""
        echo -e "${YELLOW}Entered Details are: -${NC}"
        echo ""
        echo -e "${YELLOW}Email:${NC} ${GREEN}${EMAIL}${NC}"
        echo -e "${YELLOW}Name:${NC}  ${GREEN}${USERNAME}${NC}"
    fi
}

function SET_IDENTITY() {
    if [[ "${TEMP}" == "y" ]]; then
        echo ""
        echo -e "${YELLOW}Setting Git Identity${NC}"
        git config --global user.name "${USERNAME}"
        git config --global user.email "${EMAIL}"
        echo ""
        echo -e "${GREEN}Done!${NC}"
    else
        echo ""
        echo -e "${YELLOW}Nothing Changed${NC}"
    fi
}

if [[ -z "${GIT_USERNAME}" || -z "${GIT_EMAIL}" ]]; then
    echo -e "${YELLOW}Git Identity not found${NC}"
    echo ""
    echo "Add Git Identity?"
    echo "y for yes, anything else to exit"
    read -r TEMP
    GET_IDENTITY
    echo ""
    echo "Continue?"
    echo "y for yes, anything else to exit"
    read -r TEMP
    SET_IDENTITY
else
    echo -e "${GREEN}Git Identity found${NC}"
    echo ""
    echo -e "${YELLOW}Email:${NC} ${GREEN}${GIT_EMAIL}${NC}"
    echo -e "${YELLOW}Name:${NC}  ${GREEN}${GIT_USERNAME}${NC}"
    echo ""
    echo "Change Git Identity?"
    echo "y for yes, anything else to exit"
    read -r TEMP
    GET_IDENTITY
    echo ""
    echo "Continue?"
    echo "y for yes, anything else to exit"
    read -r TEMP
    SET_IDENTITY
fi

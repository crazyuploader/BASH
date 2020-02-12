#!/usr/bin/env bash

# Created By Jugal Kishore -- 2020
# Setup Helper v1.0

# Colors
NC="\033[0m"
RED="\033[0;31m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"

# Repositories
BASH="https://github.com/crazyuploader/Bash.git"
PYTHON="https://github.com/crazyuploader/Python.git"
CPP="https://github.com/crazyuploader/CPP.git"
C="https://github.com/crazyuploader/C.git"
COLLEGESTUFF="https://github.com/crazyuploader/CollegeStuff.git"
DATA="https://github.com/crazyuploader/Data.git"

# Custom Functions
# 'CD' changes the directory or throws an error, and exists.
function CD() {
    cd "$1" || { echo -e "${RED}Failure${NC}"; exit 1; }
}

# 'NEWLINE' prints a new line.
function NEWLINE() {
    echo ""
}

# 'MKD' makes a directory, and enters it.
function MKD() {
    if [[ ! -d "$1" ]]; then
        mkdir "$1"
        CD "$1"
        echo -e "${GREEN}'${1}' directory created.${NC}"
    else
        echo -e "${YELLOW}'${1}' already exists, nevermind.${NC}"
        CD "$1"
    fi
}

# 'CLONE' checks if the directory exists, if it doesn't git clone or else enters the directory git pull.
function CLONE() {
    if [[ ! -d "$2" ]]; then
        git clone "$1" "$2"
        NEWLINE
        echo "Done!"
    else
        echo -e "${YELLOW}'${2}' directory exists, pulling the latest changes instead.${NC}"
        CD "$2"
        NEWLINE
        git pull
        NEWLINE
        echo "Done!"
        CD ..
    fi
}

START=$(date +"%s")  # Start Time Reference
clear
GIT="$(command -v git)"
if [[ -z ${GIT} ]]; then  # Checking if git is installed or not, if it is not, ask to install or not.
    echo -e "${YELLOW}'git' not installed.${NC}"
    NEWLINE
    echo "Install?"
    echo "Press 'y' to yes and anything else to exit."
    read -r temp
    if [[ ${temp} = "y" ]]; then
        NEWLINE
        echo "Installing 'git'"
        NEWLINE
        sudo apt-get update
        sudo apt-get install -y git
    else
        NEWLINE
        echo -e "${RED}Script can't work without 'git'${NC} :("
        echo "Exiting..."
        sleep 3
        clear
        exit
    fi
else
    echo -e "${GREEN}'git' installed, good to go.${NC}"
fi
sleep 3
clear
echo "Setup Main Script"
NEWLINE
echo -e "Your OS:" "${GREEN}" "$(lsb_release -d | cut -d ':' -f 2 | sed -e 's/^[[:space:]]*//')${NC}"
echo -e "Your Bash: ${GREEN}${BASH_VERSION}${NC}"
sleep 3
CD ~
clear
echo "Making Working Directory"
NEWLINE
MKD Desktop
MKD work
NEWLINE
echo "Done!"
NEWLINE
echo -e "${YELLOW}Getting GitHub Repositories${NC}"
NEWLINE
sleep 1
clear
echo -e "Python at:${GREEN} ${PYTHON}${NC}\n"
CLONE "$PYTHON" python
sleep 1
clear
echo -e "CPP at:${GREEN} ${CPP}${NC}\n"
CLONE "$CPP" cpp
sleep 1
clear
echo -e "C at:${GREEN} ${C}${NC}\n"
CLONE "$C" c
sleep 1
clear
echo -e "Bash at:${GREEN} ${BASH}${NC}\n"
CLONE "$BASH" bash
sleep 1
clear
echo -e "CollegeStuff at:${GREEN} ${COLLEGESTUFF}${NC}\n"
CLONE "$COLLEGESTUFF" collegestuff
sleep 1
clear
echo -e "Data at: ${GREEN} ${DATA}${NC}\n"
CLONE "$DATA" data
sleep 1
clear
echo "Getting Update Helper in current directory"
curl -O https://raw.githubusercontent.com/crazyuploader/Bash/master/update.sh && chmod +x update.sh
GIT_NAME=$(git config user.name)
GIT_EMAIL=$(git config user.email)
if [[ -z ${GIT_NAME} ]] && [[ -z ${GIT_EMAIL} ]]; then
    echo "Your Git Credentials seems to be empty, wanna add?"
    NEWLINE
    echo "'y' for yes, anything else for no"
    echo "Choice?"
    read -r TEMP
    if [[ $TEMP = "y" ]]; then
        echo "Enter Your Name: "
        read -r G_NAME
        git config --global user.name "${G_NAME}"
        NEWLINE
        echo -e "Git Name set to: ${GREEN}${G_NAME}${NC}"
        clear
        echo "Enter Your Email: "
        read -r G_EMAIL
        git config --global user.email "${G_EMAIL}"
        NEWLINE
        echo -e "Git Email set to: ${GREEN}${G_EMAIL}${NC}"
        clear
        git config --global credential.helper "cache --timeout=7200"
        echo "${GREEN}Git Credentials Saved.${NC}"
    fi
fi
sleep 3
clear
END=$(date +"%s")  #Stop Time Reference
DIFF=$((END - START))  # Difference between 'start' and 'stop' time Reference
echo -e "Script ended in: ${YELLOW}$((DIFF / 60)) minute(s) and $((DIFF % 60)) second(s).${NC}"
NEWLINE
echo -e "Created by: ${GREEN}Jugal Kishore${NC}"

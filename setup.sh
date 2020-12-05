#!/usr/bin/env bash

# Created By Jugal Kishore -- 2020
# Setup Helper v1.0

# Colors
NC="\033[0m"
RED="\033[0;31m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"

# Git Identity
HUB_NAME="crazyuploader"
HUB_EMAIL="49350241+crazyuploader@users.noreply.github.com"

# Repositories
BASH="git@github.com:crazyuploader/Bash.git"
PYTHON="git@github.com:crazyuploader/Python.git"
CPP="git@github.com:crazyuploader/CPP.git"
C="git@github.com:crazyuploader/C.git"
COLLEGESTUFF="git@github.com:crazyuploader/CollegeStuff.git"
DATA="git@github.com:crazyuploader/Data.git"
DOCKER="git@github.com:crazyuploader/Docker-Builder.git"

# Custom Functions
# 'CD' changes the directory or throws an error, and exists.
function CD() {
	cd "${1}" || {
		echo -e "${RED}Failure${NC}"
		exit 1
	}
}

# 'NEWLINE' prints a new line.
function NEWLINE() {
	echo ""
}

# 'MKD' makes a directory, and enters it.
function MKD() {
	if [[ ! -d "${1}" ]]; then
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
	if [[ ! -d "${2}" ]]; then
		git clone "${1}" "${2}"
		NEWLINE
		echo "Done!"
	else
		echo -e "${YELLOW}'${2}' directory exists, pulling the latest changes instead.${NC}"
		CD "${2}"
		NEWLINE
		echo -e "${YELLOW}By Default Script will only pull from remote 'origin' & default branch${NC}"
		NEWLINE
		git pull
		NEWLINE
		echo "Done!"
		CD ..
	fi
}

function KSETUP() {
	clear
	if [[ "${1}" == "CLI" || "${1}" == "cli" ]]; then
		return 0
	fi
	echo -e "${GREEN}Kernel Environment Setup${NC}"
	NEWLINE
	echo "Install Kernel Building Dependencies?"
	echo "'y' for yes, and anything for no"
	read -r TEMP
	if [[ "${TEMP}" = "y" ]]; then
		sudo apt-get update
		NEWLINE
		sudo apt-get upgrade -y
		NEWLINE
		sudo apt-get install -y \
			curl \
			git \
			python3 \
			python3-pip \
			bc \
			tar \
			make \
			wget \
			gcc \
			python-is-python3 \
			clang \
			libssl-dev \
			zip \
			mplayer \
			shellcheck

	else
		echo "Installing nothing, off you go!"
		clear
	fi
}

function FUNCTIONS() {
	clear
	echo -e "${GREEN}Setting Bash Functions${NC}"
	NEWLINE
	if [[ -f "${HOME}/.bashrc" ]]; then
		echo "'.bashrc' exists"
		sed -i '/#<>/,$d' ~/.bashrc
	else
		echo "'.bashrc' doesn't exist, creating it"
		echo "# Script file executed whenever a user logs into bash" >~/.bashrc
	fi
	echo -e "\n" >>~/.bashrc
	curl -s https://raw.githubusercontent.com/crazyuploader/Misc/master/functions >>~/.bashrc
	NEWLINE
	echo -e "${YELLOW}'bashrc' file updated!${NC}"
}

START=$(date +"%s") # Start Time Reference
clear
if [[ "${1}" == "CLI" || "${1}" == "cli" ]]; then
	echo -e "${YELLOW}Running in CLI Mode\nWould skip kernel setup${NC}"
	echo ""
fi
GIT="$(command -v git)"
if [[ -z ${GIT} ]]; then # Checking if git is installed or not, if it is not, ask to install or not.
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
		NEWLINE
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
sleep 1
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
NEWLINE
MKD work
NEWLINE
echo "Done!"
NEWLINE
echo -e "${YELLOW}Getting GitHub Repositories${NC}"
NEWLINE
sleep 1
clear
echo -e "Python at:${GREEN} ${PYTHON}${NC}"
NEWLINE
CLONE "$PYTHON" python
sleep 1
clear
echo -e "CPP at:${GREEN} ${CPP}${NC}"
NEWLINE
CLONE "$CPP" cpp
sleep 1
clear
echo -e "C at:${GREEN} ${C}${NC}"
NEWLINE
CLONE "$C" c
sleep 1
clear
echo -e "Bash at:${GREEN} ${BASH}${NC}"
NEWLINE
CLONE "$BASH" bash
sleep 1
clear
echo -e "CollegeStuff at:${GREEN} ${COLLEGESTUFF}${NC}"
NEWLINE
CLONE "$COLLEGESTUFF" collegestuff
sleep 1
clear
echo -e "Data at: ${GREEN} ${DATA}${NC}"
NEWLINE
CLONE "$DATA" data
sleep 1
clear
echo -e "Docker at: ${GREEN} ${DOCKER}${NC}"
NEWLINE
CLONE "$DOCKER" docker
sleep 1
clear
echo "Getting Update Helper in current directory"
curl -O https://raw.githubusercontent.com/crazyuploader/Bash/master/update.sh && chmod +x update.sh
clear
GIT_NAME=$(git config user.name)
GIT_EMAIL=$(git config user.email)
if [[ -z ${GIT_NAME} ]] && [[ -z ${GIT_EMAIL} ]]; then
	echo "Your Git Identity seems to be empty, wanna add?"
	NEWLINE
	echo "'y' for yes, anything else for no"
	echo "Choice?"
	read -r TEMP
	if [[ $TEMP = "y" ]]; then
		echo "If 'Jugal Kishore' press 'j', anything else if not"
		NEWLINE
		echo "Choice?"
		read -r TEMP
		if [[ $TEMP = "j" ]]; then
			echo "Git Identity to be added:"
			NEWLINE
			echo -e "Username: ${GREEN}${HUB_NAME}${NC}"
			echo -e "Email: ${GREEN}${HUB_EMAIL}${NC}"
			NEWLINE
			echo "Save?"
			echo "Press 'y' for yes, anything else for no"
			git config --global user.name "${HUB_NAME}"
			git config --global user.email "${HUB_EMAIL}"
		else
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
		fi
		clear
		git config --global credential.helper "cache --timeout=7200"
		echo -e "${GREEN}Git Identity Saved.${NC}"
	fi
fi
echo -e "Git Identity -"
NEWLINE
echo -e "${GREEN}Saved Git Email:${NC} $(git config user.email)"
NEWLINE
echo -e "${GREEN}Saved Git Name:${NC} $(git config user.name)"
NEWLINE
sleep 2
KSETUP "${1}"
FUNCTIONS
sleep 2
NEWLINE
END=$(date +"%s")     #Stop Time Reference
DIFF=$((END - START)) # Difference between 'start' and 'stop' time Reference
echo -e "Script ended in: ${YELLOW}$((DIFF / 60)) minute(s) and $((DIFF % 60)) second(s).${NC}"
NEWLINE
echo -e "Created by: ${GREEN}Jugal Kishore${NC}"

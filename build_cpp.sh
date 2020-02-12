#!/usr/bin/env bash

# Colors
GREEN='\033[1;32m'
NC='\033[0m'
YELLOW='\033[1;33m'
MAGENTA='\033[1;35m'
RED='\033[0;31m'

echo "Clearing Object Files and Executable Files"
rm -r '*.exe' '*.o' '*.out'
echo "Done!"
sleep .5
clear
echo -e "${GREEN}" "Available Files -${NC}"
for f in *.cpp; do echo "$f"; done
echo ""
echo -e "Enter File Name -- ${YELLOW}Without Extension${NC}"
read -r fname
if [[ -f ${fname}.cpp ]]; then
    echo "What do you want to compile it with?"
    echo "Clang++ or G++"
    echo "Enter '1' for Clang++ and '2' for G++"
    read -r temp
    COMPILED_PROGRAM=a.out
    if [[ $temp = "1" ]]; then
        clear
        echo "Compiling ""$fname.cpp"" with Clang++"
        clang++ "$fname.cpp"
        if [[ -f ${COMPILED_PROGRAM} ]]; then
            echo ""
            echo "Build With Clang++ without any errors"
            sleep .5
            clear
        else
            echo ""
            echo -e "${RED}" "Check the Program Please"
            sleep 5
            clear
            exit
        fi
    else
        if [[ $temp = "2" ]]; then
            clear
            echo "Compiling ""$fname.cpp"" with G++"
            g++ "$fname.cpp"
            if [[ -f ${COMPILED_PROGRAM} ]]; then
                echo ""
                echo "Build With G++ without any errors"
                sleep .5
                clear
            else
                echo ""
                echo -e "${RED}" "Check the Program Please"
                sleep 5
                clear
                exit
            fi
        else
            if [ "$temp" != "1" ] && [ "$temp" != "2" ]; then
                echo -e "${RED}" "Wrong Compiler${NC}"
                echo "Exiting!"
                sleep 1
                clear
                exit
            fi
        fi
    fi
else
    echo -e "${RED}" "File Does not Exist!${NC}"
    echo "Exiting..."
    echo -e "${MAGENTA}" "K Thanks, Bye!${NC}"
    sleep 1
    clear
    exit
fi
echo "Running Compiled Program Now"
sleep 1
clear
./a.out
echo ""
echo -e "${YELLOW}" "Show Source Code?${NC}"
echo ""
echo "'y' for yes and anything else for no"
read -r temp
if [[ $temp = "y" ]]; then
    clear
    cat "${fname}.cpp"
    sleep 5
    echo ""
    echo "Press 'y' to Exit"
    read -r temp
    if [[ $temp = "y" ]]; then
        clear
        sleep 3
        echo -e "${MAGENTA}" "K Thanks, Bye!${NC}"
        exit
    fi
else
    if [[ $temp != "y" ]]; then
        clear
        echo -e "${MAGENTA}" "K Thanks, Bye!${NC}"
        sleep 2
        exit
    fi
fi

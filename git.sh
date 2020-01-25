#!/usr/bin/env bash

# Created By Jugal Kishore -- 2020
# Git Helper

function Status(){
    git status
}

function Update(){
    git fetch origin master
    git pull origin master
}

function Add(){
    git add "$Name"
}

function Commit(){
    git commit -m "$Message"
}

function Add_Commit(){
    git add "$Name"
    git commit -m "$Message"
}

function Push(){
    git push origin master
}

while [[ 'true' ]]
do
    clear
    echo "Git Helper"
    echo ""
    echo "Options -"
    echo ""
    echo "1. Git Status"
    echo "2. Git Update (Fetch & Pull)"
    echo "3. Git Add"
    echo "4. Git Commit"
    echo "5. Git Add & Commit"
    echo "6. Git Push"
    echo "7. Exit"
    echo ""
    echo "Your Choice?"
    read -r choice
    if [[ $choice == 1 ]]; then
        echo "Git Status"
        echo ""
        Status
        echo ""
        read -rp "Press enter to continue"
    fi
    if [[ $choice == 2 ]]; then
        echo "Git Update"
        Update
        echo ""
        read -rp "Press enter to continue"
    fi
    if [[ $choice == 3 ]]; then
        echo "Git Add"
        echo ""
        echo "Usage -"
        echo ""
        echo "All Files --> '.' (period)"
        echo "Single File --> 'File_Name'"
        echo ""
        echo "Your Choice?"
        read -r Name
        Add
        echo ""
        read -rp "Press enter to continue"
    fi
    if [[ $choice == 4 ]]; then
        echo "Git Commit"
        echo ""
        echo "Enter Commit Message"
        read -r Message
        Commit
        echo ""
        read -rp "Press enter to continue"
    fi
    if [[ $choice == 5 ]]; then
        echo "Git Add & Commit"
        echo "Usage for git add -"
        echo ""
        echo "All Files --> '.' (period)"
        echo "Single File --> 'File_Name'"
        echo ""
        echo "Your Choice?"
        read -r Name
        echo "Enter Commit Message"
        read -r Message
        Add_Commit
        echo ""
        read -rp "Press enter to continue"
    fi
    if [[ $choice == 6 ]]; then
        echo "Git Push"
        echo ""
        Push
        echo ""
        read -rp "Press enter to continue"
    fi
    if [[ $choice == 7 ]]; then
        echo "Have a nice day!"
        echo "Exiting..."
        clear
        exit
    fi
done

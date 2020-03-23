#!/usr/bin/env bash

# Created By Jugal Kishore -- 2020
# Git Helper

function NEWLINE() {
    echo ""
}

function Status() {
    git status
}

function Update() {
    git fetch origin master
    git pull origin master
}

function Add() {
    git add "$Name"
}

function Commit() {
    git commit -m "$Message"
}

function Add_Commit() {
    git add "$Name"
    git commit -m "$Message"
}

function Push() {
    git push origin master
}

function Remote_View() {
    git remote -v
}

function Remote_Add() {
    git remote add "$RNAME" "$RURL"
}

function Remote_Remove() {
    git remote remove "$RNAME"
}

while true
do
    clear
    echo "Git Helper"
    NEWLINE
    echo "Options -"
    NEWLINE
    echo "1.  Git Status"
    echo "2.  Git Update (Fetch & Pull)"
    echo "3.  Git Add"
    echo "4.  Git Commit"
    echo "5.  Git Add & Commit"
    echo "6.  Git Push"
    echo "7.  Git Remote View"
    echo "8.  Git Remote Add"
    echo "9.  Git Remote Remove"
    echo "10. Exit"
    NEWLINE
    echo "Your Choice?"
    read -r choice
    if [[ $choice == 1 ]]; then
        clear
        echo "Git Status"
        NEWLINE
        Status
        NEWLINE
        read -rp "Press enter to continue"
    fi
    if [[ $choice == 2 ]]; then
        clear
        echo "Git Update"
        NEWLINE
        echo "Note: - It always pull from 'origin/master'"
        NEWLINE
        Update
        NEWLINE
        read -rp "Press enter to continue"
    fi
    if [[ $choice == 3 ]]; then
        clear
        echo "Git Add"
        NEWLINE
        echo "Usage -"
        NEWLINE
        echo "All Files --> '.' (period)"
        echo "Single File --> 'File_Name'"
        NEWLINE
        echo "Changes:"
        NEWLINE
        git status -s
        NEWLINE
        echo "Your Choice?"
        read -r Name
        Add
        NEWLINE
        read -rp "Press enter to continue"
    fi
    if [[ $choice == 4 ]]; then
        clear
        echo "Git Commit"
        NEWLINE
        echo "Enter Commit Message"
        read -r Message
        Commit
        NEWLINE
        read -rp "Press enter to continue"
    fi
    if [[ $choice == 5 ]]; then
        clear
        echo "Git Add & Commit"
        echo "Usage for git add -"
        NEWLINE
        echo "All Files --> '.' (period)"
        echo "Single File --> 'File_Name'"
        NEWLINE
        echo "Your Choice?"
        read -r Name
        echo "Enter Commit Message"
        read -r Message
        Add_Commit
        NEWLINE
        read -rp "Press enter to continue"
    fi
    if [[ $choice == 6 ]]; then
        clear
        echo "Git Push"
        NEWLINE
        Push
        NEWLINE
        read -rp "Press enter to continue"
    fi
    if [[ $choice == 7 ]]; then
        clear
        echo "Git Remote View"
        NEWLINE
        Remote_View
        NEWLINE
        read -rp "Press enter to continue"
    fi
    if [[ $choice == 8 ]]; then
        clear
        echo "Git Remote Add"
        NEWLINE
        echo -e "Enter Remote Name"
        read -r RNAME
        NEWLINE
        echo "Enter Remote URL for '${RNAME}'"
        read -r RURL
        Remote_Add
        NEWLINE
        echo "Remote '${RNAME}' of URL '${RURL}' added."
        NEWLINE
        read -rp "Press enter to continue"
    fi
    if [[ $choice == 9 ]]; then
        clear
        echo "Git Remote Remove"
        NEWLINE
        echo "Available Remotes"
        NEWLINE
        Remote_View
        NEWLINE
        echo "Enter Remote Name to be Removed"
        read -r RNAME
        NEWLINE
        echo "Entered Remote to be Removed '${RNAME}'"
        Remote_Remove
        NEWLINE
        echo "Remote '${RNAME}' Removed."
        NEWLINE
        read -rp "Press enter to continue"
    fi
    if [[ $choice == 10 ]]; then
        clear
        echo "Have a Nice Day!"
        echo "Exiting..."
        clear
        exit
    fi
done

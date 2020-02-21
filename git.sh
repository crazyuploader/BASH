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

function Remote_View(){
    git remote -v
}

function Remote_Add(){
    git remote add "$RNAME" "$RURL"
}

function Remote_Remove(){
    git remote remove "$RNAME"
}

while true
do
    clear
    echo "Git Helper"
    echo ""
    echo "Options -"
    echo ""
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
    echo ""
    echo "Your Choice?"
    read -r choice
    if [[ $choice == 1 ]]; then
        clear
        echo "Git Status"
        echo ""
        Status
        echo ""
        read -rp "Press enter to continue"
    fi
    if [[ $choice == 2 ]]; then
        clear
        echo "Git Update"
        echo ""
        echo "Note: - It always pull from 'origin/master'"
        echo ""
        Update
        echo ""
        read -rp "Press enter to continue"
    fi
    if [[ $choice == 3 ]]; then
        clear
        echo "Git Add"
        echo ""
        echo "Usage -"
        echo ""
        echo "All Files --> '.' (period)"
        echo "Single File --> 'File_Name'"
        echo ""
        echo "Changes:"
        echo ""
        git status -s
        echo ""
        echo "Your Choice?"
        read -r Name
        Add
        echo ""
        read -rp "Press enter to continue"
    fi
    if [[ $choice == 4 ]]; then
        clear
        echo "Git Commit"
        echo ""
        echo "Enter Commit Message"
        read -r Message
        Commit
        echo ""
        read -rp "Press enter to continue"
    fi
    if [[ $choice == 5 ]]; then
        clear
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
        clear
        echo "Git Push"
        echo ""
        Push
        echo ""
        read -rp "Press enter to continue"
    fi
    if [[ $choice == 7 ]]; then
        clear
        echo "Git Remote View"
        echo ""
        Remote_View
        echo ""
        read -rp "Press enter to continue"
    fi
    if [[ $choice == 8 ]]; then
        clear
        echo "Git Remote Add"
        echo ""
        echo -e "Enter Remote Name"
        read -r RNAME
        echo ""
        echo "Enter Remote URL for '${RNAME}'"
        read -r RURL
        Remote_Add
        echo ""
        echo "Remote '${RNAME}' of URL '${RURL}' added."
        echo ""
        read -rp "Press enter to continue"
    fi
    if [[ $choice == 9 ]]; then
        clear
        echo "Git Remote Remove"
        echo ""
        echo "Available Remotes"
        echo ""
        Remote_View
        echo ""
        echo "Enter Remote Name to be Removed"
        read -r RNAME
        echo ""
        echo "Entered Remote to be Removed '${RNAME}'"
        Remote_Remove
        echo ""
        echo "Remote '${RNAME}' Removed."
        echo ""
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

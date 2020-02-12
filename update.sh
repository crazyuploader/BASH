#!/usr/bin/env bash

clear
echo "Please wait, updating your repositories from GitHub"
echo ""
cd c && git fetch origin master && git pull origin master && cd ..
echo ""
cd collegestuff && git fetch origin master && git pull origin master && cd ..
echo ""
cd cpp && git fetch origin master && git pull origin master && cd ..
echo ""
cd python && git fetch origin master && git pull origin master && cd ..
echo ""
cd bash && git fetch origin master && git pull origin master && cd ..
echo ""
cd data && git fetch origin master && git pull origin master && cd ..
echo ""
echo "Done!"
sleep 5
clear

#!/bin/bash

clear
#displays working directory and files to help
#prevent errors
echo "Working directory: $PWD"
echo
#displays 9 columns to help fit file names
#even when there are lots of files
ls | pr -9T

echo
echo -n "Do we need to initialize the repo? (y/n) " 
read ansr

#only respects main branch and force pushes everything
#to the repository
if [[ "$ansr" =~ ^[yY] ]]; then 
    git init
    # git add .
    # using -A instead also acknowledges file deletions
    git add -A
    git commit -m "First commit"
    echo -n "Copy/paste repo URL: "
    read url
    git remote add origin "$url"
    git branch -M main
    ssh-add
    git push -u origin main
#updates all changes    
elif [[ "$ansr" =~ ^[Nn] ]]; then
    # git add .
    git add -A
    echo -n "Enter commit message: "
    read message
    git commit -m "$message"
    ssh-add
    git push -f
else
    echo "Incorrect response, next time choose y or n."
    exit 1
fi    
    

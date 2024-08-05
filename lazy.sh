#!/bin/bash
# Script for automating changes made to a repository
#
#function to set up repo to connect with ssh
configure_ssh()
{
    #exits if not setup for SSH
    if ! ssh -T git@github.com 2>&1 | grep -q "successfully"; then
        echo "You have not created your SSH keys or pasted them to your github account. You can't connect via SSH"
        echo "without proper authentication!"
        echo
        echo "You can create your SSH keys with the \"--create-keys\" or \"--create\" option."
        exit 1
    fi

    echo -n "Enter username: "
    read username
    echo -n "Enter repo name [without username or url]: "
    read repo
    git remote set-url origin git@github.com:"$username"/"$repo"
    exit 0
}
#checks for bad arguments
if [ "$#" -eq 1 ]; then 
    if ! [ "$1" == "--configure-ssh" ] && ! [ "$1" == "--create-keys" ] && 
    ! [ "$1" == "--configure" ] && ! [ "$1" == "--create" ]; then
        echo -e "Usage: lazy.sh [--one-option]"
        echo
        echo -e "\tRun without options to initialize a repository or change its files"
        echo -e "\tAlso lets you configure it to connect with ssh."
        echo
        echo -e "\tlazy.sh --create-keys or --create: create SSH keys in your home directory and copy"
        echo -e "\tthem to your clipboard."
        echo
        echo -e "\tlazy.sh --configure-ssh or --configure: configure a repository to connect with ssh."
        echo -e "\tThe final step to make changes without a token."
        exit 1
    fi    
fi    
#checks for too many arguments
if [ "$#" -gt 1 ]; then
    echo -e "Usage: lazy.sh [--one-option]"
    echo
    echo -e "\tRun without options to initialize a repository or change its files"
    echo -e "\tAlso lets you configure it to connect with ssh."
    echo
    echo -e "\tlazy.sh --create-keys: create SSH keys in your home directory and copy"
    echo -e "\tthem to your clipboard."
    echo
    echo -e "\tlazy.sh --configure-ssh: configure a repository to connect with ssh."
    echo -e "\tThe final step to make changes without a token."
    exit 1
fi    

if [ "$1" == "--configure-ssh" ] || [ "$1" == "--configure" ]; then
    configure_ssh
fi

# Creates SSH keys and copies public key to clipboard
if [ "$1" == "--create-keys" ] || [ "$1" == "--create" ]; then
    cd ~
    echo "Would you like to leave a note to go with your key?"
    echo -n "(people typically use an email address, you can skip this by pressing enter):"
    read comment

    # Create the key
    if [ -z "$email" ]; then
        ssh-keygen -t rsa -b 4096 
    else
        ssh-keygen -t rsa -b 4096 -C "$comment"
    fi

    #launches commands generated by "ssh-agent -s"
    eval "$(ssh-agent -s)"

    # Adds your SSH info to the agent, used to authenticate with github
    ssh-add ~/.ssh/id_rsa

    # Check if the system is macOS and copy the key to the clipboard
    if [[ "$(uname)" == "Darwin" ]]; then
        pbcopy < ~/.ssh/id_rsa.pub
    else
        test=$(which xclip; echo "$?")

        if [ "$test" == 1 ]; then
            echo "Missing command \"xclip\". Install it first:"
            echo
            echo "Debian:"
            echo "sudo apt-get install xclip"
            echo "Fedora (and maybe CentOS):"
            echo "sudo dnf install xclip"
            echo "Arch:"
            echo "sudo pacman -S xclip"
            exit 1
        fi    

        xclip -sel clip < ~/.ssh/id_rsa.pub
    fi
    #doesn't return to command line until you've completed the process
    echo "Key copied to system clipboard"
    echo "Now, go to settings on GitHub, go to SSH and GPG keys,"
    echo "New SSH key, wqand paste the key in the box. After you're done, press enter"
    read input
    exit 0
fi

if ! [ -d ".git" ]; then
    clear
    # Displays working directory and files to help prevent errors
    echo "Files in working directory:"
    echo

    # Displays 9 columns to help fit file names even when there are lots of files
    ls | pr -9T
    #attempts to prevent you from comitting files you didn't intend or running the script
    #from a bad directory
    echo
    echo "This directory contains no .git directory. Do you want to initialize this directory"
    echo "and commit all the files in:"
    echo
    echo "$PWD"
    echo
    echo -n "to your github repository? (y/n) "
    read ansr

    if [[ "$ansr" =~ ^[yY] ]]; then
        git init
        git add -A
        git commit -m "First commit"
        echo -n "Copy/paste repo URL: "
        read url
        git remote add origin "$url"
        git branch -M main
        git push -u origin main
        echo "Repository initialized!"
        echo
        echo -n "Would you like to configure it to connect to use SSH for commits? (y/n)"
        read ssh_answer
        if [[ "$ssh_answer" =~ ^[yY] ]]; then
            configure_ssh
        else
            exit 0
        fi    
    elif [[ "$ansr" =~ ^[nN] ]]; then
        exit 0
    else
        echo "Incorrect response, next time choose y or n."
        exit 1
    fi    
else    
    # Updates all changes
    git add -A

    echo -n "Enter commit message: "
    read message

    git commit -m "$message"
    git push --force-with-lease
	# try this if you are having issues
    # git push -f
fi    

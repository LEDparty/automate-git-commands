#!/bin/bash
# Script for automating changes made to a repository

#TEST
SCRIPT=$0
#Allows for flexible script naming
SCRIPT_NAME=${SCRIPT##*/}

error_msg()
{
        echo -e "Usage: $SCRIPT_NAME [--one-option]"
        echo
        echo -e "\tRun without options to initialize a repostiroy and/or commit changes."
        echo -e "\tIt auto-detects if you have initialized the repository, and commits"
        echo -e "\tand pushes changes to your repository regardless."
		echo
        echo -e "\t$SCRIPT_NAME --create-keys or --create:"
        echo -e "\tcreate SSH keys in your home directory and copy them to github"
        echo
        echo -e "\t$SCRIPT_NAME --configure-ssh or --configure:"
        echo -e "\tconfigure the working directory for SSH changes over github" 
		echo
        echo -e "\t$SCRIPT_NAME --status:"
		echo -e "\tshows information about changes you have made to your local"
		echo -e "\trepository and also displays your git configurations."
		echo
        echo -e "\t$SCRIPT_NAME --message:"
		echo -e "\trun like normal, but make a short, inline commit message instead"
        echo -e "\tinstead of pulling up your configured text editor during commits."
        exit 1
}		

if [ "$#" -eq 1 ]; then 
    case "$1" in
		--create-keys)
			;;
		--create)
			;;
		--configure-ssh)
			;;
		--configure)
			;;
		--status)
			;;
		--message)
			;;
		*)
			echo "Invalid option \"$1\""
			echo
			error_msg
			;;
	esac		
elif [ "$#" -gt 1 ]; then
	echo "Only one command line argument at a time allowed."
	echo
    error_msg
fi    

if [ "$1" == "--status" ]; then
	git status
	echo
	echo "Configuration details: "
	git config --list --show-origin
	echo
	echo "Refs and branches:"
	git show-ref
	echo
	exit 0
fi	

if [ "$1" == "--configure-ssh" ] || [ "$1" == "--configure" ]; then
    echo -n "Enter username: "
    read username
    echo -n "Enter repo name [without username or url]: "
    read repo

    # Set remote origin with SSH URL
    git remote add origin git@github.com:"$username"/"$repo"

    # Check if the default branch is master or main
    branch_name=$(git symbolic-ref --short HEAD)
    git push -u origin "$branch_name"
	exit 0
fi

# Creates SSH keys and copies public key to clipboard
if [ "$1" == "--create-keys" ] || [ "$1" == "--create" ]; then
    cd ~
	echo "This will create a randomly generated SSH keys in your home directory"
	echo
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

    #doesn't return to command line until user completes process
    echo "Key copied to system clipboard: "
    echo "Go to your settings on GitHub -> SSH and GPG keys -> New SSH key"
    echo "and paste the key in the box. After you're done, press enter"
    read input
    exit 0
fi

if ! [ -d ".git" ]; then
    clear
    #attempts to prevent you from comitting files you didn't intend or running the script
    #from a bad directory
    echo "Files in working directory:"
    echo
    ls 
    echo
    echo "This directory contains no .git directory. Do you want to initialize this directory"
    echo "and commit all the files in:"
    echo
    echo "$PWD"
    echo
    read -p "to your github repository? (y/n) " ansr

    if ! [[ "$ansr" =~ ^[yY] ]]; then
		echo "Chose answer other than \"y\" or \"yes\". Exiting..."
        exit 0
	fi	
	#add if statement for inline message option
	if [ "$#" -eq 0 ]; then
        git init
        git add -A
		git commit 
	else	
        git init
        git add -A
		echo -n "Enter commit message: "
		read message
		git commit -m "$message"
	fi	

    echo -n "Would you like to configure this repository to use SSH? (y/n)"
    read ssh_answer
    if [[ "$ssh_answer" =~ ^[yY] ]]; then
		echo -n "Enter username: "
		read username
		echo -n "Enter repo name [without username or url]: "
		read repo

		git remote add origin git@github.com:"$username"/"$repo"

		# Check if the default branch is master or main
		branch_name=$(git symbolic-ref --short HEAD)
		git push --force-with-lease -u origin "$branch_name"
		exit 0
    elif [[ "$ssh_answer" =~ ^[nN] ]]; then
        echo -n "Copy/paste repo URL: "
        read url
        git remote add origin "$url"

        # Check if the default branch is master or main
        branch_name=$(git symbolic-ref --short HEAD)
        git push --force-with-lease -u origin "$branch_name"
    else
        echo "Incorrect response, next time choose y or n."
        exit 1
    fi
else
	echo "Here are your recent repository changes:"
	echo
	git status
	echo
	echo "Do you want to add the changes to the staging area and commit them to your"
	read -p "remote repository? (y/n) " update_answer

    if ! [[ "$update_answer" =~ ^[yY] ]]; then
		echo "Chose answer other than \"y\" or \"yes\". Exiting..."
        exit 0
	fi	
    # Add all changes to staging
    git add -A

	if [ "$#" -eq 0 ]; then
		git commit 
	else	
		echo -n "Enter commit message: "
		read message
		git commit -m "$message"
	fi	

    if git remote get-url origin | grep -q "git@github.com"; then
        git push
	else	
		branch_name=$(git symbolic-ref --short HEAD)

        echo -n "Copy/paste repo URL: "
        read url
        git remote set-url origin "$url"
        #git push -u origin "$branch_name"
        git push --force-with-lease -u origin "$branch_name"
	fi	
fi

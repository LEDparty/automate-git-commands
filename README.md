# About

This script executes the commands necessary for initializing a reporitory, making commits,
generating ssh keys for your github account, and also configuring your repository to connect
via ssh. Without options, it checks to see if you have initialized the current directory,
and proceeds to commit all your changes if you have. If you have not set up your computer and
your local repository to use SSH, then you will have to copy a token from the github website
when making commits (see "Usage" below to change this).

The <code>lazy.sh</code> currently works best for people creating their own repositories, I
cannot test it in a team or institutional setting. 

# Install 

The script should work on linux shells and mac shells alike, but if you are a macbook user,
you will probably need to omit the "install" command and find a different way to make this
script part of your path directories:

<pre><code>
git clone https://github.com/LEDparty/lazy-commit
cd lazy-commit
sudo install lazy.sh /usr/local/bin
#alternative, not needed if you use install command
#chmod +x rwg.sh
</pre></code>

# Usage

Just run <code>lazy.sh</code> from your local repository folder to initialize a repository
and commit your first files or commit changes to your files. Used this way, the script acts
out of your working directory.

If you want to name your first branch something other than  "main", then do not initialize
your repository with this script, or change the script for a new default
on this line:

<pre><code>
git branch -M main
</pre></code>

If there's already a <code>.git</code> directory and a different preferred branch, then 
the script will make the changes according to your preferences
(please report issues if it doesn't).

In order to set to configure SSH access for your computer (this will save a ton of effort in the
future if you regularly make github commits), use the <code>lazy.sh --create-keys
</code> or the <code>lazy.sh --create</code> option to:

-generate the needed SSH keys in your home directory

-setup your ssh agent to communicate with github

-copy the public key to your system/mouse clipboard to add to your github profile.

After that, you will then need to use <code>lazy.sh --configure-ssh</code> or <code>lazy.sh
--configure</code> within your locally stored repositories in order to complete this process.



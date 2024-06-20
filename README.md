# About

This script automates the basic commands for adding files and making changes to the files in
a github repository. With the way github is currently setup, you probably need to create the 
repo and get the access token from the website, but lazy commit executes all the git commands
for you once you have created the folder and files locally to make that part
a lot less effortless. It updates files all at once and forces pushes in order to ensure that
it works.

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

Just run <code>lazy.sh</code> from your local repository folder.

# Contributions

The script could still use a way to better manage branches and SSH key generation, but the
way this works currently, it does everything that a single person using a repository to share
their software and hacks could want.

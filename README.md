# About

This script is made for individuals who just want to publish their simple programs on github,
it is not intended for organizations or critical software that has multiple branches and is
maintained by several people. It uses the generic github configurations.

This script has saved me a lot of effort in updating this repository, I appreciate people
who are helpful, yet sometimes you have to do things entirely yourself. Gitkraken is much 
better suited for people who are working with teams, and the forced push used in this script
can cause big problems for people who need to work like this.

This script automates the basic commands for adding files and making changes to the files in
a github repository. With the way github is currently setup, you probably need to create the 
repo and get the access token from the website, but lazy commit executes the git commands
for you once you have created the folder and files locally.

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

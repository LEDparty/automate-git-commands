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

If you are working with a branch other than "main", first launch this command to check the
preferred branch (the current branch):

<code>git branch --show-current</code>

Use this to switch to a branch if it already exists:

<code>git switch branch-name</code>

"branch-name" being any name you choose.

You can use any one of these commands to create a branch and make it the preferred branch:

<pre><code>
git checkout -b branch-name
git switch -c branch-name
</pre></code>

Then, when you run <code>lazy.sh</code>, it will automatically recognize the preferred branch
you are pushing to when you select not to initialize the repository (you can't change branches
if you have not created an original one like "main" or "master").

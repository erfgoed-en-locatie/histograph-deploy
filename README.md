# histograph-deploy
Deploy scripts for Histograph

## Usage
### Debian/Ubuntu, possibly many other linux or even posix (Mac?)
Install docker through the main repository
```
apt-get install docker
```
Set up SSH key for Github, if you haven't already. This is necessary to be able to clone the private data repository
```
ssh-keygen -t rsa -C "your_email@example.com"
eval $(ssh-agent -s)
ssh-add ~/.ssh/id_rsa
clip < ~/.ssh/id_rsa.pub
```
Then paste the clipboard contents in github under [https://github.com/settings/ssh] as a new key.
Clone this repository, change to the cloned directory and start using:
```
git clone https://github.com/histograph/deploy
cd deploy
docker build .
```
### Windows
Unfortunately, Docker needs a virtual machine to run in, which complicates matters somewhat. 
- Install Docker for Windows using the instructions on [https://docs.docker.com/installation/windows/].
- Install Putty for Windows using the instructions on http://git-scm.com/download/win

Open putty and log into the virtual machine using the following settings:
- hostname: localhost
- port: 2022
Open the connection and provide the following credentials:
- user: docker
- pass: tcuser

Then set up the SSH key for Github. This is necessary to be able to clone the private data repository. In putty, type the following (make sure to insert your own mail adress). Make sure NOT to provide a passphrase, otherwise the procedure will fail.
```
ssh-keygen -t rsa -C "your_email@example.com"
eval $(ssh-agent -s)
ssh-add ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub
```
Then paste the clipboard contents, starting from "ssh-rsa" and including the email address at the end, past it in github under [https://github.com/settings/ssh] as a new key. Check the correct workings of this all with:
```
ssh -T git@github.com
```
and enter yes when asked to add the fingerprint.

Then, the installation can start!
Clone this repository, change to the cloned directory and start using:
```
git clone https://github.com/histograph/deploy
cd deploy
docker build .
```

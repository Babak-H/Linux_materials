#!/bin/bash

# Install Gitlab on Linux

# for virtualbox installation these ports are needed
# hostPort  guestPort
# 8022        22
# 8443        443
# 8081        80

# install dependancies
sudo apt-get update
sudo apt-get install ca-certificates curl openssh-server postfix

# install gitlab
cd /tmp || exit
curl -LO https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh

# make sure the script exists
if [[ ! -e '/tmp/script.deb.sh' ]]
then 
 exit 1
fi

# run the installer script
sudo bash /tmp/script.deb.sh

# install gitlab community edition (CE)
sudo apt-get install gitlab-ce

# initialize gitlab
sudo gitlab-ctl reconfigure

# Check firewall and allow openssh and http through it
if systemctl is-active --quiet ufw; then
 :
else
 sudo systemctl start ufw
fi

sudo ufw allow http
sudo ufw allow OpenSSH

# Edit external_url in the config file of gitlab
sudo vi /etc/gitlab/gitlab.rb

# ip address of your guest Ubuntu machine:
# external_url http://127.0.1.1/  
# change port address to prevent used port error on port 8080:
# unicorn['port'] = 8081  
# gitlab_workhorse['auth_backend'] = http://localhost:8081

# save and close the file, then reconfigure gitlab and restart the service
sudo gitlab-ctl reconfigure
sudo gitlab-ctl restart

# change the password for the first time

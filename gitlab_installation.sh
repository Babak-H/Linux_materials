# for virtualbox installation these ports are needed
# hostPort  guestPort
# 8022        22
# 8443        443
# 8081        80

# install dependancies
sudo apt-get update
sudo apt-get install ca-certificates curl openssh-server postfix

# install gitlab
cd /tmp
curl -LO curl -LO https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh

# make sure the script exists
less /tmp/script.deb.sh

# run the installer script
sudo bash /tmp/script.deb.sh

# install gitlab community edition (CE)
sudo apt-get install gitlab-ce

# initialize gitlab
sudo gitlab-ctl reconfigure

# Check firewall and allow openssh and http through it
sudo ufw status
sudo ufw allow http
sudo ufw allow OpenSSH

# Edit external_url in the config file of gitlab
sudo nano /etc/gitlab/gitlab.rb
external_url http://127.0.1.1/  # ip address of your guest Ubuntu machine
unicorn['port'] = 8081 # change port address to prevent used port error on port 8080
gitlab_workhorse['auth_backend'] = http://localhost:8081

# save and close the file, then reconfigure gitlab and restart the service
sudo gitlab-ctl reconfigure
sudo gitlab-ctl restart

# change the password for the first time
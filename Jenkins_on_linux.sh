# install jenkins on ubuntu through docker

# install docker
sudo apt-get update
sudo apt install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
apt-cache policy docker-ce
sudo apt install docker-ce
# this will run docker
sudo systemctl status docker

# create volume and run the jenkins docker image
sudo mkdir -p /var/jenkins_home
sudo chown -R 1000:1000 /var/jenkins_home/
docker run -p 8080:8080 -p 50000:50000 -v /var/jenkins_home:/var/jenkins_home --name jenkins -d jenkins/jenkins:lts
# this way we are allowing the jenkins image to access the docker engine on the main machine, through docker socket, so when we run "docker ps" inside the jenkins conrainer, it executes it in the main machine
sudo docker run -p 8080:8080 -p 50000:50000 -v /var/jenkins_home:/var/jenkins_home -v /var/run/docker.sock:/var/run/docker.sock --name jenkins-d -d jenkins-docker




ssh-keygen -t rsa -b 2048 -C 'key generated on 2022'
# copy ssh public key to the target machine
ssh-copy-id root@167.99.135.210

# disable password auth
sudo nano /etc/ssh/sshd_config
# inside the file
PasswordAuthentication nano

mkdir -p /opt/wordpress/database
mkdir -p /opt/wordpress/html
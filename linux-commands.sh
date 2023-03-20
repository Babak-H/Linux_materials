# superuser do , elevates user permission to do tasks
# sudo [command]
sudo apt-get install my-package # ubuntu
yum install my-package # centOS and RedHat
pacman -S my-package # Arch

# path of current working directory
pwd # print working directory

# cd , go to this folder
cd /home/username/Moveis

# ls, list current  directory's content
ls /home/username/Documents
ls -l    # show as list
ls -la   # show as list with hidden files
ls -lah  # also show the size of folders/files
ls -la >> ls.logs  

#  >>   appends
#  >    writes to file and over-writes the file

# cat , displays contents of a file in terminal
cat filename1.txt > filename3.txt
cat filename1.txt filename2.txt > filename3.txt

# less , similar to cat but allows you to go through file by pages, more human readable
less file1.txt
# show only lines that have word "Logarithm", page by page
cat my-thesis.txt | grep Logarithm | less

# cp , copy files and directories
cp filename1.txt /home/username/Documents
cp /usr/share/folder-x/domains.csv .  # copy the file to the current folder

# mv , move files or directories
mv old_filename.txt new_filename.txt

# mkdir , create a directory
mkdir Music/Songs
mkdir Music/2020/Songs

# rmdir  delete empty directory
rmdir -p mydir/personal1

# rm delete files
rm file1 file2

rm -r myfolder  # reccurently delete a folder and its content

# touch, create new file/ modify old file
touch /home/username/new_file.txt

# locate , look for a file in folder structure
locate file.txt
locate -i school*notes
locate my*.csv | less
locate csv | grep domain 

# before running locate, run this commnad, makes index of all files on your computer
sudo updatedb

# find [option] [path] [expression] , more advanced search to find a file
find /home -name notes.txt
find ./ -type d -name dir_name

# grep , Global Regular Expression Print
# grep [search string] [filename]
grep blue notepad.txt
grep Lord my-text.txt > jesus.log 

# df, Disk Free , system's disk usage
# df [option] [file]
df
df -h
df -m
df -h | grep media

# du, Disk Usage , how much space a folder or file is taking
du  # works on current folder
du /home/user/Documents

# head , truncate long outputs to first x lines of file
# head [option] [file]
head note.txt
head -n 5 notes.txt
cat my_file.txt | head

# tail , same as head but for end of file
# tail [option] [file]
tail -n colors.txt
cat my_recepie.txt | tail

# diff , compares two files and prints the difference
# dif [option] file1 file2
diff notes.txt new_notes.txt

# tar , helpes with compressing and un-compressing files
# tar [options] [archive_file] [file or directory to be archived]
tar -cvf newarchive.tar /home/user/Documents

# chmod , CHange MODe , change file or directory permissions
# chmod [option] [permission] [file_name]
chmod 777 notes.txt

# chown , CHange OWNership
# chown [option] owner[:group] file(s)
chown linuxuser2 filename.txt
sudo chown Bob file.txt

# jobs, shows all running processes
# jobs [options] jobID

# kill
# kill [signal_option] pid
# SIGTERM => requests a program to stop running and gives it some time to save all of its progress
# SIGKIL => forces programs to stop, and you will lose unsaved progress.
kill SIGKILL 63773

# ping , Packet INternet Groper
# ping [option] [hostname_or_IP_address]
ping google.com

# wget , WWWW GET , download files from the internet
# wget [option] [url]
wget https://wordpress.org/latest.zip

# uname, Unix NAME, print detailed information about linux system
# uname [option]
# -a : all  -s : kernel name -n : hostname
uname -a

# top, Table Of Processes , all runnig processes
top

# history, system will list up to 500 previously executed commands
history
history -c

# man, MANual , provides a user manual of any commands or utilities you can run in Terminal
man ls

# echo , prints arguments to the terminal
# can also use it to append text to files
echo my name is babak

# zip [zipped-file-name] file1 file2
zip archive.zip notes.txt bills.txt

# unzip
unzip archived.zip

# hostname, know the system’s hostname and ip address
hostname
hostname -i
hostname -a

# useradd , create new user and set its password
sudo useradd John

# passwd , change's your current password
passwd
passwd 123456789

# userdel
sudo userdel John

# apt-get
sudo apt-get update
sudo apt-get upgrade

# nano / vi
nano text.txt
vi text.txt

# su [options] [username [argument]], allows you to run a program as a different user
su -p babak

# htop
htop
htop -d

# ps , Process Status , lists currently running processes on the system
ps
ps -T

# file , provides information about a file
file my_file.py

# wc , Word Count , counts the number of lines, words, and bytes in a file
wc file.txt

# whoami , shows the currently logged in user
whoami

# ip , contains many useful networking functionalities
ip addr

# mount, allows attaching additional devices to the file system.
# mount ISO files, USB drives, NFS,..
# mount -t [type] [device] [directory]

# reboot, restarts the system immediately from the terminal
reboot

# which , shows the path of an executable program (command)
which cat
which htop

# alias , to show and set customized command shortcuts
# alias [name]=[command]
# you can write alias to .bashrc file, so it will be not removed after restarting the terminal
alias
alias meow=cat

# unalias, to remove an already existing alias
unalias meow

# clear , clean the contents of the terminal
clear


# SSH , Secure SHell,  a network protocol that enables secure remote connections between two systems
# ssh [username]@[hostname_or_ip] -p [port_number]
ssh my_user@my_hostname
ssh user1@test.server.com -p 3322
# first time tring to ssh, type "yes" to continue, then enter the password
# private_key => in your local machine
# public_key => in the remote machine

# to make the ssh password-less
# generate ssh key, -t : make sure using RSA, -b : byteSize
ssh-keygen -t rsa -b 4096
# press enter to save the key in default location (/Users/my_username/.ssh/id_rsa)
# press enter for passphrase (not needed)
# both public and private key has been created at ~/.ssh

# id_rsa => private key
# id_rsa.pub => public key
# known_hosts => list of hosts (ip addresses) that are allowed to access the private-key, via public-key

# create this folder on remote machine
mkdir .ssh 
# copy the public key to the remote machine, in the .ssh folder
scp ~/.ssh/id_rsa.pub username@remote_machine:/home/username/.ssh/uploaded_key.pub
# enter password and it is copied

# save that public key in this file on remote machine, this file is MANDATORY
cat ~/.ssh/uploaded_key.pub >> ~/.ssh/authorized_keys

# change the access rules for the ssh files/folder on remote machine
chmod 700 ~/.ssh/
chmod 600 ~/.ssh/*

# alternative way, without need to create .ssh folder or copy public-key
ssh-copy-id my_user@my_hostname

# now it will login without need for passowrd
ssh my_user@my_hostname

# edit ssh rules on remote machine, so it only accepts non-password based ssh connection
sudo nano /etc/ssh/sshd_config
# change the line inside the file to this and save the file
PasswordAuthentication no

# restart ssh service, for changes to take place
sudo service ssh restart


# .bash_profile  and  .bashrc
# this allows us to customize our terminal based on our liking
cd ~
ls -la  # should show both .bash_profile and .bashrc

# .bash_profile => login shell
# .bashrc => non-login shell, only works for subshell (when you run bash commands)

# to restart terminal after changing the .bashrc file
source .bashrc

# command substitution $()
echo "your username is $(whoami)"
echo "$(tput setaf 166)this is orange"

# cut
# divide the lines via "," and only show columns 2 and 3
cut -d, -f2,3 domains.csv

# tr , TRanslate
# replace all the "W" in the file with "j"
cat my-thesis.txt | tr W j
# replace all lowerCase characters to upperCase 
cat my-thesis.txt | tr "[:lower:]" "[:upper:]"

# curl, Clients for URLs , transferring data using various protocols
curl https://www.google.com
curl -I https://www.google.com  # only show header
curl -H "X-Header: value" https://www.example.com


# nslookup , Queries internet domain name servers interactively.
# nslookup [-option] [name] [server]
nslookup www.google.com
nslookup -type=ns google.com  # name server
nslookup -type=mx yahoo.com  #  Mail Exchange server data













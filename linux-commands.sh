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

# Strict Host Key Checking
# In host key checking, ssh automatically maintains and checks a database containing identification for all hosts it has ever been used with. Host keys 
# are stored in ~/.ssh/known_hosts in the user's home directory. Additionally, the /etc/ssh/ssh_known_hosts file is automatically checked for known hosts. 
# Any new hosts can be automatically added to the user's file. If a host's identification changes, ssh warns about this and disables password 
# authentication to prevent server spoofing or man-in-the-middle attacks, which could otherwise be used to circumvent the encryption. 

# As long as strict host key checking is enabled, the SSH client connects only to SSH hosts listed in the known host list. It rejects all other SSH hosts

# The ssh_config keyword "StrictHostKeyChecking" can be used to control logins to machines whose host key is not known or has changed
# to disable it while running ssh command
ssh -o StrictHostKeyChecking=no yourHardenedHost.com

# to do it ~/.ssh/config to make it permenant
Host *
    StrictHostKeyChecking no
    

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

# upload file from commandline via FTP or SSH
scp <file to upload> <username>@<hostname>:<destination path>

#!  is called bash SheBang, is used to tell the operating system which interpreter to use to parse the rest of the file.
#!/bin/bash - Uses bash to parse the file.
#!/usr/bin/python Executes the file using the python binary.
# If a shebang is not specified and the user running the Bash script is using another Shell the script will be parsed by whatever the default interpreter is used by that Shell

# journalctl saves all the logs that have been generated in the system
journalctl # shows all the logs, press shift+d to go to the end
journalctl --help
# show the last 5 lines of the logs
journalctl -n 5
# this is where the temporary logs are saved
cd /run/log/journal
# here you can edit to save the logs or delete them by each system restart
vi /etc/systemd/journal.conf
# set storage to persistent
[Journal]
Storage=persistent


firmware is the software on your hardware which runs it, its the lowest level software running on the hardware
BIOS was the old firmware of the computer hardware
UEFI the new version of firmware for computers, installed /boot folder in linux

/sys is the folder with all the operating system related stuff
            block  bus  class  dev  devices  firmware  fs  hypervisor  kernel  module  power
block => has all the hard drives
/sys/bus/cpu/devices => here you can see all the CPUs available to the OS

/dev contains all devices related folder, all added devices are visible here

/proc this directory contains info related to processes of the machine, the numbers in this folders are the processes being run

$ lsusb => how many usb devices are attached to this machine

$ lspci => what hardware devices (cpu, isa bridge, vga graphics card,..) are attached to this machine

$ lsblock => the hdd,sdd and ram that are attached to this device

$ lshw => shows all hardware and firmwares on this machine

when linux machine is booting up, you can see all the logs related to kernel booting up

$dmesg  => shows all the logs related to system booting up, they are located at /var/log/dmesg

each hard drive is divided to partitions, in linux devices are defined at /dev , /dev/sda1 , /dev/sda2 ,... 
the sda1 and sda2 partitions are mounted at /dev folder at /sda and /sdb folders.  
$ fdisk /dev/sda => this command will open sda hard disk in fdisk software to change or view partitions

$ sudo mount | grep sda  => shows all partitions for sda disk

LVM => Logical Volume Management, is used for cases when you need to resize the partitions.
via LVM you can add up several physical drives to one bigger virtual drive (Volume Group) that itself can be partitioned.

you have to put around 1GB of hard disk aside for the /boot folder, where kernel is located at.

partition design for server machine:

total : 1TB
swap: ram+2gb | /boot 1gb | /var 30 gb for server logs | /home 900gb | /usr 20 gb

$ jobs => shows all paused processes

Ctrl+C => aborts the current foreground process
Ctrl+Z => pauses/stops current foreground process, it can be resumed later

if a parent process dies, all the child processes die with it too.

nohup => allows your child process to live, even when parent process dies.

the process below wont die even when you close the shell:
$ nohup ping 4.4.5.1  => appending output to nohup.out

$ nohup script.sh > mynohup.out 2>&1 &

    nohup script.sh => run this script with nohup (don't kill it when we close the shell)
    > mynohup.out => put the output in the mynohup.out file
    2>&1 => also put the errors in mynohup.out file
    & => run it in the background


$ kill -1 PROCESS_ID  => HUP tell the process that the shell that is controlling it is dead
$ kill -15 PROCESS_ID => TERM ask process to terminate (this is default signal)
$ kill -9 PROCESS_ID  => KILL forcefully kills the process

$ pkill pyt => kill all processes that contain the word "pyt" in their name

$ ps => PID TTY TIME CMD
    PID => ID of the process
    TTY => from which terminal its running
    TIME => how much time it borrows from the cpu
    CMd => with what command it started running

$ ps -e => shows all processes currently running on this machine
$ ps -e | wc -l

$ pgrep calc | xargs kill => find all processes that contain the word "calc", then kill them all

$ top => shows all the processes, sorts them based on cpu usage, press "q" to quit top

$ free => shows total memory, used and free and total SWAP used and free

$ uptime => how long the system has been up (not restarted) : 16:12  up 16 days,  2:45, 2 users, load averages: 2.23 2.19 2.11

$ watch COMMAND
$ watch df -h => run this command every 2 seconds and show the new result
$ watch df -h | grep sda

** link in linux is similar to shortcut on windows OS
softLink => only points to the original file like shortcut, will not work if the main file is deleted,  it changes when you edit the original file

hardLink => is a full copy of the file, still works if you delete the original, it changes when you edit the original file.

$ ln myfile hard_link => creates a hard link named hard_link
$ ls -i => you can see both original and hard link point to same inode
$ unlink hard_link => delete the link 

$ ln -s myfile soft_link => creates a soft link
$ unlink soft_link

** softLink is much more common than hardLink

$ find / -type l => find all links in the whole system

as we can see when we run the command python3, it is a soft link to python3.10
$ which python3
    /Applications/miniconda3/bin/python3
$ ls -l /Applications/miniconda3/bin/python3
    lrwxr-xr-x  1 babakhabibnejad  staff  10 Mar 24 16:55 /Applications/miniconda3/bin/python3 -> python3.10

$ echo $PATH => this variable contains all locations that shell commands are saved at.
    /Applications/miniconda3/bin:/Applications/miniconda3/condabin:/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/System/Cryptexes/App/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin

export PATH=$PATH:/usr/new/dir => add a new directory to the PATH variable

$ which ping => this command shows where the command "ping" is saved at : /sbin/ping

$ find /etc -iname "*vmware*" => find all files and directories that contain "vmware" in their name, -iname is case insensitive

$ locate aws => find files that contain "aws" in their name, its faster than find, but is based on databse that is updated once per day

** the shell setting are usaually located at "/etc/profile" and at "/home/USERNAME/.bashrc"






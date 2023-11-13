#===============================================================
# linux file permissions
ls -l  
'
drwxrwxr-x 2 babak babak 4096 May 15 12:53 dir

  permissions: d rwx rwx r-x : 
                d : file type, d stands for directory
                rwx : user permissions
                rwx: group permissions
                r-x: others permissions

2 : number of hard links
babak : user (owner) name
babak : group name
4096 : size
May 15 12:53 : last update to this file
dir : file/folder name


-rw-rw-r-- 1 zhaleh dev-group 4 July 12 19:21 information.txt

- rw- rw- r--
- : it is a file
rw- : zhaleh user can read write
rw- : dev-group group can read write
r-- : anyone can read

Read Write eXecute
r    w      x
'

# chmod , CHange MODe , change file or directory permissions
# chmod [option] [permission] [file_name]
chmod 777 notes.txt

chmod -R 0777 /mydirectory # give access for read-write-execute to all files inside a directory

chmod u+s,o-rwx myUserGroup myFile
# o-rwx => removes read and wrirte and execute from others

# u+s => adds the SetUID bit
# when the program is executed, the process created will acquire all the privileges of the program's owner; the effective UID of the process will be the same as the UID 
# of the owner of the program (most likely, that will be root). This allows someone who would not normally be able to do something to do it via this program.

# chmod give access to only specific user
# This sets permissions for specific users, without changing the ownership of the directory.
setfacl -m u:<username>:rwx myfolder

# another way is to set that user as owner of the file/folder, then give him the access
sudo chown <username>: myfolder
sudo chmod u+w myfolder

# chown , CHange OWNership
# chown [option] owner[:group] file(s)
chown linuxuser2 filename.txt
sudo chown Bob file.txt

# make chown work recursively? change ownership file a specific file type in all sub-directories
# Recursive mode only works on directories, not files, 
find . -type f -name '*.pdf' | xargs chown <username>:<usergroup>

# in Bash 4 and later we can do this:
chown -R <username>:<usergroup> ./**/*.pdf

#===============================================================
# working with Files

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

# show linux folder in details
ls -lhrt /liveperson/data

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

# -p flags makes sure all the parent folders are created in case they don't exist
mkdir -p folder/subfolder/subsubfolder

# create several duirectories at once
mkdir dir_1 dir_2 dir_3

# when creating a directory in unix user "$variable" instead of $variable
mkdir -p "$deployDir"

# rmdir  delete empty directory
rmdir -p mydir/personal1

# rm delete files
rm file1 file2

rm -r myfolder  # reccurently delete a folder and its content

# how to install a .deb file
sudo dpkg -i /path/to/deb/file
sudo apt-get install -f
# or
sudo apt install ./name.deb

# touch, create new file/ modify old file
touch /home/username/new_file.txt

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

# apt-get
sudo apt-get update
sudo apt-get upgrade

# nano / vi
nano text.txt
vi text.txt

# wc , Word Count , counts the number of lines, words, and bytes in a file
wc file.txt

# tr , TRanslate
# replace all the "W" in the file with "j"
cat my-thesis.txt | tr W j
# replace all lowerCase characters to upperCase 
cat my-thesis.txt | tr "[:lower:]" "[:upper:]"

a="Hi all"
echo "$a" | awk '{print tolower($0)}'  # hi all

# cut
# divide the lines via "," and only show columns 2 and 3
cut -d, -f2,3 domains.csv

var = "apple orange"
# divide by space, then get column 2
echo $var | cut -d' ' -f2  # orange

var="apple orange"
echo $var    # apple orange
echo $var | awk '{print $1}'   # apple
echo $var | awk '{print $2}'   # orange

# man, MANual , provides a user manual of any commands or utilities you can run in Terminal
man ls

# echo , prints arguments to the terminal
# can also use it to append text to files
echo my name is babak

# clear , clean the contents of the terminal
clear

# command substitution $()
echo "your username is $(whoami)"
echo "$(tput setaf 166)this is orange"

#!  is called bash SheBang, is used to tell the operating system which interpreter to use to parse the rest of the file.
#!/bin/bash -        Uses bash to parse the file.
#!/usr/bin/python    Executes the file using the python binary.
# If a shebang is not specified and the user running the Bash script is using another Shell the script will be parsed by whatever the default interpreter is used by that Shell

#========================================================
# Linux Users

# uname, Unix NAME, print detailed information about linux system
# uname [option]
# -a : all  -s : kernel name -n : hostname
uname -a

# useradd , create new user and set its password
sudo useradd John

# passwd , change's your current password
passwd
passwd 123456789

# userdel
sudo userdel John

# creates a new user, creates new group with same name and adds user to that group and create homedir or /home/new_user
adduser new_user
# asks for password
# asks for person's name (can be set to default)

usermod -aG new_group username // add user to a new group
usermod -aG sudo my_user

usermod -L username  # lock account
usermod -U username  # unlock account

# add new group with gid of 1111, for normal users and groups, it usually starts from 1000 and upward for uid and gid
groupadd -g 1200 mynewgroup
# edit the group
groupmod -g 1345 mynewgroup
groupdel mynewgroup

# shows info about all users
$ head /etc/passwd  # username:group:password (here only shows x):gid:extra_info:/home/username:shell-format (for example /bin/bash)

$ cat /etc/shadow   # username:password (if it is * then user doesnt have a password):days_since_last_change:days_until_expire:days_until_expire_warning:days_until_disable:days_until_disable_warning

$ chage -l username # shows info about password expiration

$ id username # shows info about user and its groups
$ id -u ubuntu # 1000 show's the user's uid
$ id -nu 1000 # ubuntu, shows username from uid

# su [options] [username [argument]], allows you to run a program as a different user
su -p babak

sudo su -  # become root user without knowing root's password

# whoami , shows the currently logged in user
whoami

# show all mysql users
mysql
select user,host from mysql.user;

last # shows the latest logins to the system (which time and user)

# used to run the Bash shell with elevated privileges using the "sudo" command
# -E : option preserves the user environment variables when running the command as the superuser
# bash : indicates that the Bash shell should be launched
# - : is typically used to read commands from standard input
sudo -E bash - 

# the shell setting are usaually located at "/etc/profile" and at "/home/USERNAME/.bashrc"

#========================================================
# SSH

# SSH , Secure SHell,  a network protocol that enables secure remote connections between two systems
# ssh [username]@[hostname_or_ip] -p [port_number]
ssh my_user@my_hostname
ssh user1@test.server.com -p 3322
# first time tring to ssh, type "yes" to continue, then enter the password
# private_key # in your local machine
# public_key # in the remote machine
# the collection of public and private key are called host keys

# to make the ssh password-less
# generate ssh key, -t : make sure using RSA, -b : byteSize
ssh-keygen -t rsa -b 4096
# press enter to save the key in default location (/Users/my_username/.ssh/id_rsa)
# press enter for passphrase (not needed)
# both public and private key has been created at ~/.ssh

# id_rsa # private key
# id_rsa.pub # public key
# known_hosts # list of hosts (ip addresses) that are allowed to access the private-key, via public-key

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

# how to remove a trusted host from ssh
ssh-keygen -R 192.168.70.2

'''
jump server: you can ssh to a machine and from that machine you are allowed to ssh into several other systems.

local -> jump server -> remote machine
                     -> remote machine
                     -> remote machine

to use jumpp server we need ssh-agent and ssh-add commands so jump server can use our private ssh-key
to connect to target servers
'''

# use ssh to only run one command and then exit the remote host:
ssh root@5.161.75.09 uptime

# upload file from commandline via FTP or SSH
scp <file to upload> <username>@<hostname>:<destination path>

PSSH: Parallel SSH connections

# install pssh
sudo apt-get install pssh -y

# create a hosts file
vi sshhosts
'''
    192.168.1.70
    192.168.1.71
    192.168.1.72
    192.168.1.73
'''

# in case the usernames aren't same
'''
    user1@192.168.1.70
    user2@192.168.1.71
    userX@192.168.1.72
    user5@192.168.1.73
'''

# we want to run df -h on all hosts
# all of them need to have same username and password for ssh
# -A : prompts for remote password
# -i : Display standard output and standard error as each host completes, (inline)
# -h : Read hosts from the given host_file
# sshhosts : named of the host_file
parallel-ssh -A -i -h sshhosts df -h

# how to run os patching
./liveperson/code/lputils/linux/os_patches/lpospatching.sh -y
# run several server patches all at once:
pssh -h servers.in -t 600 -i '/liveperson/code/lpospatching.sh -y'

# how to do visual ssh into gui
# in target machine at "/etc/ssh/sshd_config" set "X11Forwarding" to "yes", then connect to ssh like this:
$ ssh -X server_ip.address.net
$ call_some_gui_app

#========================================================
#  SSL and OpenSSL


# ssl certificates are written in x509 standard
# certificate target, is the address of the website that the client will send data to, this should be predefined
        # DNS Name=hello-world.com
        # DNS Name=*.hello-world.com
        # DNS Name=sni.cloudflaressl.com

# certificate validation duration, defined via "Valid from" and "Valid to" parameters

# certificate chain, the order of the location of the certificate CA, you can find it in "certificate path"
# the browswer will check the certificate back to the root CA, to make sure it is trusted, usually public root certificates are saved on the device itself
        # Root CA
        # Intermediate CA
        # Server Certificate

# when you have a self-signed certificate, you should add it to the trusted root certificates on the device, so the device will trust it.


# genrate an RSA private key
# this will encrypt the private key with AES256, we can use this key to generate ssl certificates
# create a pass phrase for the pem file, it is needed when generateing the public keys later
openssl genrsa -out -aes256 ca-key.pem 4096

# generate a public CA certificate, using private certificate
# use the passphrase entered in the previous step
# it asks for some generic information, but it is not important what you enter here, Issuer Details
openssl req -new -x509 -days 3650 -sha256 -key ca-key.pem -out ca.pem

# view the public certificate
openssl x509 -in ca.pem -text -noout


# create the self-signed certificate private key, no need to encrypt it here
openssl genrsa -out cert-key.pem 4096

# create a certificate signing request, this is the file that you send to the CA to sign
openssl req -new -sha256 -subj "/CN=hello-world.com" -key cert-key.pem -out cert.csr

# in this configuration file, we eneter the DNS name and IP addresses that we want to be in the certificate target
echo "subjectAltName=DNS:*.hello-world.com,IP:10.0.0.5" >> extfile.cnf

# create the SSL certificate, using public/private CA keys, CA sign request, certificate config file, outputting it into "cert.pem" file
# enter the passphrase for the CA private key (from first step)
openssl x509 -req -sha256 -days 3650 -in cert.csr -CA ca.pem -CAkey ca-key.pem -out cert.pem -extfile extfile.cnf -CAcreateserial

# now add both CA and certificate to one file, the certificate chain file:
cat cert.pem >> fullchain.pem
cat ca.pem >> fullchain.pem

# now add the cert into trusted certificates of the client device, the process in linux:
cp ca.pem /usr/local/share/ca-certificates/ca.crt
sudo update-ca-certificates

#========================================================
# Searching

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

$ find / -type l # find all links in the whole system

export PATH=$PATH:/usr/new/dir # add a new directory to the PATH variable

$ which ping # this command shows where the command "ping" is saved at : /sbin/ping

$ find /etc -iname "*vmware*" # find all files and directories that contain "vmware" in their name, -iname is case insensitive

$ locate aws # find files that contain "aws" in their name, its faster than find, but is based on databse that is updated once per day

# which , shows the path of an executable program (command)
which cat
which htop

# find a file named 'elasticsearch.yml' in the whole machine (start from root /)
find / -type f -iname elasticsearch.yml
find / -type f -iname Prometheus.yaml

#==========================================
# Disk

# df, Disk Free , system's disk usage
# df [option] [file]
df
df -h
df -m
df -h | grep media

# du, Disk Usage , how much space a folder or file is taking
du  # works on current folder
du /home/user/Documents

# mount, allows attaching additional devices to the file system.
# mount ISO files, USB drives, NFS,..
# mount -t [type] [device] [directory]

# each hard drive is divided to partitions, in linux devices are defined at /dev , /dev/sda1 , /dev/sda2 ,... 
# the sda1 and sda2 partitions are mounted at /dev folder at /sda and /sdb folders.  

$ fdisk /dev/sda # this command will open sda hard disk in fdisk software to change or view partitions

# mount extrnal HDD to linux machine
# see if there is an entry in the disk list:
sudo fdisk -l 
# mount it: 
sudo mount -t ntfs /dev/sdb1 /media  # ntfs is name of the hdd drive

$ sudo mount | grep sda  # shows all partitions for sda disk

# *** LVM ***
# Logical Volume Management, is used for cases when you need to resize the partitions.
# via LVM you can add up several physical drives to one bigger virtual drive (Volume Group) that itself can be partitioned.

# in linux we have physical volumes, they add up to become a volume group and then we can divide the volume group
# into logical volumes (LVM) 

physical volume /dev/sda 200 GB =>                          => logical volume 50GB 
                                    Volume Group 1 400GB
physical volume /dev/sdb 200 GB =>                          => logical volume 50GB 

babak@DESKTOP-PN1RO4V:~$ lsblk
NAME MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
sda    8:0    0 363.3M  1 disk
sdb    8:16   0     2G  0 disk [SWAP]
sdc    8:32   0     1T  0 disk /snap
                               /mnt/wslg/distro
                               /

# create physical volumes
pvcreate /dev/xvdf1 /dev/xvdf2

# a physical volume is a collection of disk partitions used to store all server data. physical volumes have a maximum size of 16 TB, because physical volumes can contain any portion
# of one or more disks, you must specify several characteristics of a physical volume when creating it.
babak@DESKTOP-PN1RO4V:~$ pvdisplay /dev/sdb1
  “/dev/sdb1” is a new physical volume of “2.01 GiB”
  --- NEW Physical volume ---
  PV Name               /dev/sdb1
  VG Name
  PV Size               2.01 GiB
  Allocatable           NO
  PE Size               0
  Total PE              0
  Free PE               0
  Allocated PE          0
  PV UUID               0FIuq2-LBod-IOWt-8VeN-tglm-Q2ik-rGU2w7

# create a volume group from physical volume
vgcreate vol_group1 /dev/xvdf1 /dev/xvdf1

# show the details of the volume group
vgdisplay

# create a logical volume LVM, should be smaller size than the volume group
lvcreate -n lv01 -L 500MB vol_group1
# show the volume groups
lvdisplay

$ sudo lvdisplay Vol1
  --- Logical volume ---
  LV Path                 /dev/Vol1/lvtest
  LV Name                 lvtest
  VG Name                 Vol1
  LV UUID                 4W2369-pLXy-jWmb-lIFN-SMNX-xZnN-3KN208
  LV Write Access         read/write
  LV Creation host, time  … -0400
  LV Status               available
  # open                  0
  LV Size                 2.00 GiB
  Current LE              513
  Segments                1
  Allocation              inherit
  Read ahead sectors      auto
  - currently set to      256
  Block device            253:2

# *** Stratis ***
# In Stratis we have physical volumes, but instead of Volume groups we use volume Pools, and
# then use FileSystem on top of it.
# While LVM has defined size that needs to be changed, FileSystem’s min size is its current size
# and its max size is the size of Volume Pool.

physical volume /dev/sda 200 GB =>                          
                                    Volume Pool 400GB  => [Stratis File system, can change size]
physical volume /dev/sdb 200 GB =>                         

# to install Stratis
yum install stratis-cli stratisd -y
# start stratis
systemctl enable stratis Volume Pool
# show stratis pools
stratis pool list

# add more physical drives (/dev/xvdc) to stratis volume pool1
stratis pool add-data pool1 /dev/xvdc
# create filesystem on the pool
stratis filesystem create pool1 filesys1
# show all filesystems
stratis filesystem list

# mount stratis filesystem to a folder
mount /stratis/pool1/filesys1 /test

# get an snapshot of the filesystem drive
stratis filesystem snapshot pool1 filesys1 filesys1-copy


# you have to put around 1GB of hard disk aside for the /boot folder, where kernel is located at.

# partition design for server machine:
total : 1TB
swap: ram+2gb | /boot 1gb | /var 30 gb for server logs | /home 900gb | /usr 20 gb

'''
************  fstab File Basics  ************

The fstab file is used by the kernel to locate and mount file systems. It’s usually auto 
generated at install and users need not worry about it unless they plan on adding more storage 
to an existing system. The name fstab is a shortened version of File System Table; the format 
is actually quite simple and easy to manipulate.  Entries are separated by white space.

1. Device
Drive/partition to be mounted. It is usually identified by UUID but you can do it with device 
names (ex. /dev/sda1) or labels (ex. LABEL=OS.)

2. Mount Point
The directory where the device/partition will be mounted (ex. /home.)

3. File System Type
Tells the kernel what file system to use when mounting the drive/partition.
(ex. ext4, xfs, btrfs, zfs, ntfs, etc…)

4. File System Options
Tells the kernel what options to use with the mounted device. This can be used to instruct the 
system what to do in the event of an error or turn on specific options for the file system 
itself.

5. Backup Operations/Dump
This is a binary system where:
1 = dump utility backup of a partition. 
0 = no backup. This is mostly disused today.

6. File System Check Order
Sets the order in which devices/partitions will be checked at boot. 0 means no check, 1 means 
first check and 2 means second check. The "/" file system should be set to one and following 
systems to 2.
'''

# what is already mounted, list blocks
lsblk
# sda => hard drive  sro => dvd drive

# block id, show uuid for the blocks abd partitions
sudo blkid

# mount an extra drive
# the drive is named data_drive, it is locate at /data and its type is ext4 and we accept the defaults
LABEL=data_drive /data ext4 defaults 0 2

# mount more swap space (addition to ram from harddrive)
/swapfile1 none sw 0 0

#  after making a change, run this command
sudo mount -a

# the file that contains configuration for the fstab and the drives
sudo nano /etc/fstab

# backup the fstab file before making any change to it
sudo cp /etc/fstab  /etc/fstab.old
# how to restore the fstab file
sudo mv /etc/fstab.old /etc/fstab


# **** how to backup NFS drive *****
# We need to unmount existing NFS and mount cohesity drive on each data and master node of these clusters

# create new dir: 
mkdir -p /liveperson/data/elasticsearch_backup1

# unmount existing nfs:
umount /liveperson/data/elasticsearch_backup

# mount old nfs to new directory:
mount -t nfs 172.16.22.1:/vol/els_prod_backup/elasticsearch_intentanalyzer /liveperson/data/elasticsearch_backup1

# Verify the new mount:
df -h | grep elasticsearch_backup1

# Mount Cohecity NFS appliance to old dir and verify the mounts:
mount -t nfs va-cohesity.lpdomain.com:/es_va_prod_v7.8_intent /liveperson/data/elasticsearch_backup
# make sure it exists
df -h | grep elasticsearch_backup

# make new entry to fstab file (comment old nfs line):
vi etc/fstab
va-cohesity.lpdomain.com:/es_va_prod_v7.8_intent   /liveperson/data/elasticsearch_backup nfs defaults 0 0

#==========================================
# zip files 

# tar , helpes with compressing and un-compressing files
# tar [options] [archive_file] [file or directory to be archived]
tar -cvf newarchive.tar /home/user/Documents

# zip [zipped-file-name] file1 file2
zip archive.zip notes.txt bills.txt

# unzip
unzip archived.zip

#==========================================
# Linux Processes

# jobs, shows all running processes
# jobs [options] jobID

# kill
# kill [signal_option] pid
# SIGTERM # requests a program to stop running and gives it some time to save all of its progress
# SIGKIL # forces programs to stop, and you will lose unsaved progress.
kill SIGKILL 63773

# top, Table Of Processes , all runnig processes
top

# history, system will list up to 500 previously executed commands
history
history -c

# htop
htop
htop -d

# ps , Process Status , lists currently running processes on the system
ps
ps -T

# file , provides information about a file
file my_file.py

# reboot, restarts the system immediately from the terminal
reboot

$ jobs # shows all paused processes

Ctrl+C # aborts the current foreground process
Ctrl+Z # pauses/stops current foreground process, it can be resumed later

# if a parent process dies, all the child processes die with it too.

nohup # allows your child process to live, even when parent process dies.

# the process below wont die even when you close the shell:
$ nohup ping 4.4.5.1  # appending output to nohup.out

$ nohup script.sh > mynohup.out 2>&1 &

    nohup script.sh # run this script with nohup (don't kill it when we close the shell)
    > mynohup.out # put the output in the mynohup.out file
    2>&1 # also put the errors in mynohup.out file
    & # run it in the background


$ kill -1 PROCESS_ID  # HUP tell the process that the shell that is controlling it is dead
$ kill -15 PROCESS_ID # TERM ask process to terminate (this is default signal)
$ kill -9 PROCESS_ID  # KILL forcefully kills the process

$ pkill pyt # kill all processes that contain the word "pyt" in their name

$ ps # PID TTY TIME CMD
    PID   # ID of the process
    TTY   # from which terminal its running
    TIME  # how much time it borrows from the cpu
    CMd   # with what command it started running

$ ps -e # shows all processes currently running on this machine
$ ps -e | wc -l

$ pstree # is another way of visualizing processes. It displays them in tree format. So, for example, your X server and graphical environment would appear under the display manager that spawned them.

# Given a search term, pgrep returns the process IDs that match it
$ pgrep calc | xargs kill # find all processes that contain the word "calc", then kill them all

$ top # shows all the processes, sorts them based on cpu usage, press "q" to quit top

$ free # shows total memory, used and free and total SWAP used and free

$ uptime # how long the system has been up (not restarted) : 16:12  up 16 days,  2:45, 2 users, load averages: 2.23 2.19 2.11

#### Load Average : can help you detemine if your linux system is keeping up with its workload or becoming slow, it is based on how much cpu we are using (but also related to hard drive I/O metrics)

$ uptime  # shows how long the server has been up for and also gives you load average
$ cat /proc/loadavg  # also shows the system's current load average

'''
load average: 0.04, 0.05, 0.07

0.04 => over past one minute
0.05 => over the past 5 minutes
0.07 => over the past 15 minutes, this is the most important number

0.00 = server is not being used any hardware
1.00  = server is running at full capacity (if we have one cpu core), in case of 2 cup cores, the number 2.00 means 100% capacity of the server

$ cat /proc/cpuinfo  # see how many cpu cores we have (starts at 0)
'''

$ watch COMMAND
$ watch df -h # run this command every 2 seconds and show the new result
$ watch df -h | grep sda

command 1 && command 2  # => This command will execute command 1, and if command 1 exits successfully (returns a zero exit status), it will then execute command 2. In other words, command 2 will only run if command 1 is successful.
command 1 & command 2  # => This command will run command 1 in the background (as a separate process) and immediately start running command 2 in the foreground. command 2 does not wait for command 1 to finish; they run concurrently.

# && ensures that the second command only runs if the first one is successful.
# & runs both commands concurrently, without waiting for the first to finish.

ulimit # shows how much cpu, ram, memory a user can have inside a machine
ulimit -a  # show all

cat /etc/security/limits.conf  # how to change resource limits for users

# show all services that are available
# + service is working
# - service not used
sudo service --status-all
# same as
systemctl status

# PROC
# Proc file system (procfs) is a virtual file system created on the fly when the system boots and is dissolved at the time of system shutdown. 
# It contains useful information about the processes that are currently running, it is regarded as a control and information center for the kernel. 
# The proc file system also provides a communication medium between kernel space and user space.

# If we list the directories, you will find that for each PID of a process, there is a dedicated directory.
ls -l /proc | grep '^d'

# If we want to check information about the process with PID 3151, we can use the following command.
ls -ltr /proc/3151

# INIT process
# init is parent of all Linux processes with PID or process ID of 1. It is the first process to start when a computer boots up and runs until 
# the system shuts down. init stands for initialization. In simple words the role of init is to create processes from script 
# stored in the file /etc/inittab

/etc/inittab  # Specifies the init command control file

# Stopping a postgresql instance
sudo systemctl stop postgresql
# only as last resort
killall postgresqld

#==========================================
# CRON

# cron can be installed from crontab package, each user has his own crons
M (minute)  H (hour) DOM (day of month) MON (month) DOW (day of week) command
42          3        1                  *           *                 /root/backup.sh  # run it first day of each month at 3:42 am
42          3        *                  *           *                 /root/backup.sh  # run it everyday at 3:42 am
*/15        */2      *                  *           *                  /root/backup.sh  # run it everyday 0:0 0:15, 0:30, 0:45, 2:0 2:15,...
30          *        *                  *            1,7              /root/backup.sh # run it on sunday and saturday, at middle of every hour
$ crontab -l # shows all crons 
$ crontab -r # remove all crons

$ crontab -e # create crons in the file that opens:

        42    3     1   *   *   /root/backup.sh >> $HOME/tmp/backup.log 2>&1
        */15  */2   *   *   *   /root/backup.sh >> $HOME/tmp/daily/backup.log 2>&1
        1      0    30  *   *   /var/www/check-server.sh >> /dev/null 2>&1   # throws the logs away

# cron files are saved at: /var/spool/cron/tabs/username

# only use one of these files:
/etc/cron.allow # if you add a user here, only that user can use cron.
/etc/cron.deny  # the user that is added here can't use cron.

#==========================================
# Logs

rsyslog     # the most recent log server on linux machines
/dev/log    # applications always write to dev/log their information
/var/log/   # almost all the logs go here

$ dmesg | less   # shows the logs for when the machine is booting up

$ cd /var/log
$ ls -ltrh    # shows the logs by time order, to see the last one that was created

logrotate   # it can optimize logs, you can create new log file, delete previous logs and zip log files
$ vi /etc/logrotate.conf

$ cd /etc/cron.daily/   # here you can see that logrotate is being run everyday

/var/log/auth.log   # all logs related to authentication
/var/log/lastlog    # date and time of all recent user logins

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

$ journalctl -e      # automatically go to the end of the logs
$ journalctl -f      # goes to the last line of the logs and updates it if new log is added
$ journalctl -u ssh  # shows all logs related to ssh
$ journalctl -u ssh --since yesterday
$ journalctl --since "09:00:00" --until "11:00:00" 

# how reduce the size of a log file without losing recent logs (truncate it)

# sets size of the file to zero, makes it empty
truncate -s 0 logfile
# this will also empty the file
cat /dev/null > file.log
$ tail -c 10M logfile > newlogfile

#=============================
# Networking

# ping , Packet INternet Groper
# ping [option] [hostname_or_IP_address]
ping google.com

# wget , WWWW GET , download files from the internet
# wget [option] [url]
wget https://wordpress.org/latest.zip
# To save the downloaded file under a different name, pass the -O option
wget -O latest-hugo.zip https://github.com/gohugoio/hugo/archive/master.zip
# download a file to a specific directory
wget -P /mnt/iso http://mirrors.mit.edu/centos/7/isos/x86_64/CentOS-7-x86_64-Minimal-1804.iso
# Limiting the Download Speed, m is for megabyte
wget --limit-rate=1m https://dl.google.com/go/go1.10.3.linux-amd64.tar.gz

# hostname, know the system’s hostname and ip address
hostname
hostname -i
hostname -a

# ip , contains many useful networking functionalities
ip addr

# curl, Clients for URLs , transferring data using various protocols
curl https://www.google.com
curl -I https://www.google.com  # only show header
curl -H "X-Header: value" https://www.example.com

# nslookup , Queries internet domain name servers interactively.
# nslookup [-option] [name] [server]
nslookup www.google.com
nslookup -type=ns google.com  # name server
nslookup -type=mx yahoo.com  #  Mail Exchange server data

# NIC : network interface card
# wlan0 , eno1 , ens1, enp3s2  : linux detects several nic cards on a machine.
ip link show # view all network cards
apt install net-tools # install ifconfig
ifconfig # detailed info about each network card
ifconfig NETWORK_CARD down  # shuts down the nic from hardware level

cd /etc/network/interfaces  # networking settings are here
ip addr show
ip route add default via 192.168.1.1  # add the default gateway to connect to outside world
nmcli general status  # shows the status of the network connections
nmcli device  # shows all network devices

hostname  # shows name of the machine
cat /etc/hostname
hostnamectl set-hostname babak  # change the machines name

vim /etc/hosts  # how to set another machines ip to custom name

    172.167.2.45 dummyhost
    127.0.0.1 gaming.ir  # if some user tries to access that website, it will fail, since we set it to local address

ping dummyhost

cat /etc/resolv.conf  # local DNS file

cat /etc/nsswitch.conf  # the order of how the command will access different processes
    passwd:  files systemd  # first ask files, then systemd for passwd command
    
ping x.x.x.x -i 5 # ping the ip address each 5 seconds
ip route # shows the routing table of the system (works same as AWS route tables)
traceroute 4.2.2.4  # trace from which ip it starts to end up connecting to this ip (for example for ping)

netstat -nr # shows the routing table

netstat -na # shows all the active ports on the machine (for both internet connections and unix sockets)

netstat -l # shows all currently listening (using) ports

netstat -tulnp | grep <port no> # If it shows some process its used. Its closed(not used) if there is no output

nc -l 1337 # nc : netcat , shows all the connections on port 1377 on this machine

sudo fuser 22/tcp  # find out which user is using port 22 (on tcp layer) on this machine

# dig : is a DNS lookup tool, checks how a domain name can be resolved to IPs
dig google.com
tcpdump  # shows all the tcp connections passing through this machine

tcpflow -c port 80  # shows all connections to port 80 of this machine

# A-Record : An A record maps a domain name to the IP address (Version 4) of the computer hosting the domain. An A record uses a domain name to find the IP address of a computer connected to the internet
# The A in A record stands for Address. Whenever you visit a web site, send an email, connect to Twitter or Facebook, or do almost anything on the Internet, the address you enter is a series of words connected with dots.
#  to access the DNSimple website you enter www.dnsimple.com. At our name server, there’s an A record that points to the IP address 208.93.64.253
# DNS record types
# A-record => ipv4 address for a host
# AAAA-record => ipv6 address for a host
# MX-record => mail server address for a host

# this is same as 'cat /etc/hosts' , shows the localhost,...
$ getent hosts localhost
$ getent hosts

$ cat /etc/services  # shows all the ports (and their related services) that the linux machine is using

# DHCP
# DHCP, abbreviation of "Dynamic Host Control Protocol", is a network protocol that assigns IP addresses automatically to 
# client systems in the network. This reduces the tedious task of manually assigning IP addresses in a large network that has 
# hundreds of systems. We can define the IP range (Scopes) in the DHCP server, and distribute them across the network. 
# The client systems in the network will automatically get the IP address.
# https://help.ubuntu.com/community/Internet/ConnectionSharingDHCP3

# to install DHCP server on ubuntu
sudo apt-get install isc-dhcp-server

#==========================================
# LINKS

** link in linux is similar to shortcut on windows OS
softLink # only points to the original file like shortcut, will not work if the main file is deleted,  it changes when you edit the original file

hardLink # is a full copy of the file, still works if you delete the original, it changes when you edit the original file.

$ ln myfile hard_link # creates a hard link named hard_link
$ ls -i # you can see both original and hard link point to same inode
$ unlink hard_link # delete the link 

$ ln -s myfile soft_link # creates a soft link
$ unlink soft_link

** softLink is much more common than hardLink

# as we can see when we run the command python3, it is a soft link to python3.10
$ which python3
    /Applications/miniconda3/bin/python3

$ ls -l /Applications/miniconda3/bin/python3
    lrwxr-xr-x  1 babakhabibnejad  staff  10 Mar 24 16:55 /Applications/miniconda3/bin/python3 -> python3.10

$ echo $PATH # this variable contains all locations that shell commands are saved at.
    /Applications/miniconda3/bin:/Applications/miniconda3/condabin:/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/System/Cryptexes/App/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin

# alias , to show and set customized command shortcuts
# alias [name]=[command]
# you can write alias to .bashrc file, so it will be not removed after restarting the terminal
alias
alias meow=cat

# unalias, to remove an already existing alias
unalias meow

#==========================================
# create Service with Systemd

# first create a shell script (it will be our service)
$ touch pointless.sh 

        #!/bin/bash
        while true
        do
            echo current time is $(date)
            sleep 1
        done

# make it executable
$ chmod =X pointless.sh

# create a service file in specific folder:
$ cd /etc/systemd/system
# create the service file, it should end with .service extension
$ sudo vim pointless.service

        [UNIT]
        Description=My Pointless Service # some description about the service
        After=network.target # only run the service when network connection exists

        [Service]
        ExecStart = /home/babak/pointless.sh   # where executable service exists
        Restart=always   # in case of error restart the service 
        WorkingDirectory=/home/babak   # user,group, home address for who runs this service
        User=babak
        Group=babak
        Environment=GOPATH=/home/babak/go USERNAME=babak_g  # environment variables, separate them with space

        [Install]
        WantedBy=multi-user.target  # this will allow service to be installed on all users

# first enable the service and then start it
$ sudo systemctl enable pointless

$ sudo systemctl start pointless

# check it's status
$ sudo systemctl status pointless

$ tail /var/log/syslog

# check the logs for the service
$ sudo journalctl -u pointless
$ sudo journalctl -u pointless -f

$ sudo systemctl stop pointless

$ sudo systemctl disable pointless

# if you change the service file, you have to do daemon reload
$ sudo systemctl daemon-reload


# systemd  and  systemd-run
# to run a service located at /etc/systemd/system/backup.service we add this file: /etc/systemd/system/backup.timer:

    [Unit]
    Description=run the backup service first saturday of every month

    [Timer]
    onCalendar=Sat *-*-1..7 2:42:00  # Day-of-week, Month, Year, which day of month, hour:minute:second
    Persistent=true

    [Install]
    WantedBy=timers.target

# the result of systemd (logs) are saved at journalctl

# to check all systemd timers:
systemctl list-timers

# you can also run systemd timers via a terminal command
# run the test-serv service every two hours
systemd-run --on-active="2hours" --unit="my-test-serv.service"

# run the test-script.sh every three hours
systemd-run --on-active="3hours" /usr/local/bin/test-script.sh

#==========================================
# Encode and Decode

# encode an image with base64
myImgStr=$(base64 image1.jpg)
# decode the encoded file
base64 -d <<< "$myImgStr" > image2.jpg

#==========================================
# LINUX OS System

# Linxu folder Structure

     /bin  essentail user binaries
     /sbin system binaries
     /etc  configuration files
     /dev  device file
     /proc process information
     /var  variable files
     /tmp  temporary files
/
     /user user programs
     /home home directories    /home/student   /home/linuxgym
     /boot static files of bootloader
     /lib system libraries
     /opt optional add-on apps
     /mnt mount directories, mount point for temporary mounted file systems
     /media removable devices
     /srv service data

# Linux file types
- ordinary files => these are regular files
- directories => files that contain other files and directories, provide pointers
- symbolic links => files that link to other files in different locations
- block and character device files => all physical devices on linux are represented by device files, /dev/sda
- socket files => provides protected inter-processing networking
- named pipe files => like socket files but doesnt user network socket semantics

# indicate all these types 
$ ls -l 

# firmware is the software on your hardware which runs it, its the lowest level software running on the hardware
# BIOS was the old firmware of the computer hardware
# UEFI the new version of firmware for computers, installed /boot folder in linux

/sys is the folder with all the operating system related stuff

block  bus  class  dev  devices  firmware  fs  hypervisor  kernel  module  power
block # has all the hard drives
/sys/bus/cpu/devices # here you can see all the CPUs available to the OS

/dev contains all devices related folder, all added devices are visible here

/proc this directory contains info related to processes of the machine, the numbers in this folders are the processes being run

$ lsusb # how many usb devices are attached to this machine

$ lspci # what hardware devices (cpu, isa bridge, vga graphics card,..) are attached to this machine

$ lsblock # the hdd,sdd and ram that are attached to this device

$ lshw # shows all hardware and firmwares on this machine

# when linux machine is booting up, you can see all the logs related to kernel booting up

$dmesg  # shows all the logs related to system booting up, they are located at /var/log/dmesg


# how the GUI in linux works:
Hardware # Kernel # Display Server # Desktop Manager, (Gnome, KDE,..) # User
                                        Window Manager, OpenBox, i3,.. (this is smaller in size) # User

KDE # Arch linux, RedHat 
Gnone # Ubuntu

# time in linux systems
# each computer itself has an internal clock that works even when it is shut down, that is called the hardware clock
# NTP # Network Time Protocol , there are servers for computer to connect to and get the correct time

# set the system clock
sudo ntpdate pool.ntp.org 
# set the hardware clock of the computer
sudo hwclock -w -u
# another way
apt install ntp
systemctl start ntp

cat /etc/ntp.conf

# chrony is another implementation of NTP, for less serious machines 
chronyc tracking # shows you whats happening
# change system's date
sudo date -s "Jan 22 22:22:22 2022"
# show what timezone we are using
cat /etc/timezone
# change your timezone to Tokyo
sudo ln -s /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

#  stop GUI in ubuntu
sudo service lightdm stop

# How to uninstall programs in ubuntu if they are not in Software Center?
sudo apt-get remove --purge <package-name>

# The host name or computer name is usually at system startup in /etc/hostname file
# to change the hostname
sudo nano /etc/hostname # Delete the old name and setup new name
sudo nano /etc/hosts # Replace any occurrence of the existing computer name with your new one
sudo reboot # Reboot the system to changes take effect

#==========================================
# HTTP STATUS Codes

Sucessful
# 200 => ok 
# 201 => post created
# 204 => no content

Redirection
# 301 => moved permanently
# 302 => found (temporarily)

Client Error (incorrect request)
# 400 => Bad Request, the server cannot or will not process the request due to something that is perceived to be a client error (for example, malformed request syntax, invalid request message framing, or deceptive request routing).
# 401 => Unauthorized
# 403 => Forbidden
# 404 => Not Found

Server Errors
# 500 => Internal server error
# 501 => Not implemented
# 502 => Bad Gateway
# 503 => Service Unavailable
# 504 => Gateway Timeout

#==========================================
# Different Server Types

Web server
# client --[http request]--> Server
# client <--[http response]-- Server

Mail server
# sender --[SMTP]--> Mail server --[SMTP]--> another Mail server --> reciever

DNS server
# client sends DNS name to dns server
# dns server sends back ip address
# client accesses the target server via it's ip address

Proxy server
# user connects to proxy server, then proxy server sends request to target server
# target server sends response to proxy server, then proxy server sends response to user.
# so user is NOT directly connected to target server

#==========================================
# HTTP Request Methods

GET
# GET /v1/products/iphone  => retuns an http or json response, retrieve a sinlge item or a list of items
# RESPONSE :
# <HTML>
#   <HEAD> iphone </HEAD>
#   <BODY>
#     ...
#     ...
#   </BODY>
# </HTML>


HEAD
# HEAD /v1/products/iphone => Identical to Get but no Message Body in response

# RESPONSE : 200 OK


POST
# POST /v1/users  => creates a new record, sends data via json (in older cases via http meta-data). 

# request body:
# {
#   "name": "bob",
#    "last_name" : "alexanderis",
#   "email": "bob@gmail.com"
# }

# RESPONSE : 201 Created


PUT 
# PUT /v1/users/123 => updates an item (similar to post but changes the whole record with new info). 

# request body: 
# {
#   "name": "bob",
#   "email": "bob@gmail.com"
# }

# RESPONSE : 200 OK


PATCH
# PATCH /v1/users/123  => Partially modify a record (only one specific field like name or email, similar to POST)

# request body: 
# {
#   "email": "bob@gmail.com"
# }

# RESPONSE : 200 OK


DELETE
# DELETE /v1/users/123  => deletes a record

# RESPONSE : 200 OK, 204 NO CONTENT


CONNECT
# CONNECT xxx.com:80  => creates atwo-way connection with a proxy server

# request
# Host: xxx:80
# proxy-authorization: basic
# SDFGJOldskfn=12312

# RESPONSE : 200 OK


OPTIONS
# OPTIONS /v1/users  => retuns a list of supported HTTP Methods

# RESPONSE : 200 OK
# Allow: GET, POST, DELETE, HEAD, OPTIONS


TRACE
# TRACE /index.html  => performs a message loop-back test, providing a debugging mechanism

# RESPONSE: 
# Host: xxxxx
# via: 1.1.xxxxx:3221
# X-forwarded-for: xx.xxxxx.x

#==========================================
# Network Protocol

HTTP
# for web browsing
# - tcp connection
# - http request
# - http response

HTTPS
# for web browsing
# - tcp connection
# - public key
# - private key
# - encrypted data

WebSocket
# for livechat and real-time data transmission
# - HTTP upgrade
# - full duplex

TCP (NO data loss)
# for web browsing and email protocols
# - syn
# - syn+ack
# - ack

UDP (with data loss)
# for vide conferencing
# - request
# - response

SMTP
# for sending/receiving emails
# - smpt server

FTP
# for upload and download files
# - control channel
# - data channel

#==========================================
API Gateway
# client --> API Gateway(single entry point) --> API I
                                           --> API II
                                           --> API III
Reverse Proxy
# client --> Reverse Proxy (hides server's address) --> Server

Load Balancer
# client --> LoadBalancer (divides traffic between identical server instances) --> nginx 1
#                                                                              --> nginx 2
#                                                                              --> nginx 3

#==========================================
# Install Jenkins (and Docker) Server on Linux 

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

#==========================================
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

#==========================================
# Install Squid Proxy 

# Squid Proxy
# proxy is a middle man that processes outgoing requests on your behalf.
# there are two types of proxy:
# HTTP Proxy
# Socket Secure Proxy (SOCKS)

# Https proxy benefits:
    # anonymity
    # access region locked content
    # monitor web traffic
    # can block content on proxy's config
    # won't expose client metadata to the server

# 1. Install squid
sudo apt install squid

# 2. Make copy of squid.conf 
sudo cp /etc/squid/squid.conf /etc/squid/squid.conf.default

# 3. Edit squid.conf 
sudo code /etc/squid/squid.conf, uncomment "http_access allow localnet", save file

# 4. Restart Squid 
sudo systemctl restart squid

# 5. Check if its running 
sudo systemctl status squid => Should see "running" and "active"

# 6. Configure Proxy in Postman and test (Settings, then Proxy tab). Add IP of Proxy Server, then default port (3128)

# 7. Check Access log for entries
sudo code /var/log/squid/access.log

# 8. Add basic user / password for authentication
# add these lines to the acl section of "squid.conf" file
auth_param basic program /usr/lib/squid/basic_ncsa_auth /etc/squid/htpasswd
auth_param basic realm Squid Proxy Caching Web Server
acl authenticated proxy_auth REQUIRED
acl authenticated_ips src {{CLIENT_IP_ADDRESS}}/32
# replace http_access allow localnet" with the code line below:
http_access allow authenticated authenticated_ips

# 9. Run the following replacing “username” and “password” accordingly, they will be saved in this file => /etc/squid/htpasswd
sudo printf "USERNAME:$(openssl passwd PASSWORD)\n" | sudo tee -a /etc/squid/htpasswd

# 10. Restart Squid
sudo systemctl restart squid

# 11. Configure Postman to use Proxy Auth (Settings then Proxy). Fill in Username and Password, then repeat the step 6

#==========================================
# rsync

apt-get install rsync

# will copy all the files from original directory to the backup one
# if you run this command several times, it doesnt re-copy files, since it checks if the files exist in second directory or not
# it will keep the two folders in sync with eachother
rsync original/* backup/

# this will also copy folders inside the main folder and the files inside them (recursive copy)
rsync -r original/ backup/

# this will copy the whole orginal directory and put it INSIDE the backup directory
rsync -r original backup/

# dryrun doesnt actually copy the data, but shows you what will be copied
# -v : shows what will be copied
rsync -rv --dry-run original/ backup/

# if there are files in backup that do not exist in the original folder, it will delete them.
rsync -r --delete original/ backup/

# sync a folder in one machine to another folder in another machine (similar to sftp)
# -z : zip target folder  -P : show the progress of sync
rsync -zrP ~/folder1/folder2 username@xxx.xxx.xx.xxx:~/destination/folder/

# sync from a remote original folder to our local machine (while we are on local machine)
rsync -zrP username@xxx.xxx.xx.xxx:~/original/folder ~/destination/folder

# BashRC

# .bash_profile  and  .bashrc
# this allows us to customize our terminal based on our liking
cd ~
ls -la  # should show both .bash_profile and .bashrc

# .bash_profile # login shell
# .bashrc # non-login shell, only works for subshell (when you run bash commands)

# to restart terminal after changing the .bashrc file
source .bashrc

#==========================================

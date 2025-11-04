#!/bin/bash

# linux file permissions
ls -l  

# d rwx rwx r-x 2 babak babak 4096 May 15 12:53 dir

#   permissions: d rwx rwx r-x : 
#                 d : file type, d stands for directory  | - stands for file
#                 rwx : user permissions
#                 rwx: group permissions
#                 r-x: others permissions

# 2 : number of hard links
# babak : user (owner) name
# babak : group name
# 4096 : size
# May 15 12:53 : last update to this file
# dir : file/folder name


# -rw-rw-r-- 1 Alex dev-group 4 July 12 19:21 information.txt

# - rw- rw- r--
# - : it is a file
# rw- : Alex user can read write
# rw- : dev-group group can read write
# r-- : anyone can read
# 1  : number of hard links
# 4 : size in bytes
# July 12 19:21  : last modified date

# Read   Write   eXecute
# r      w       x

# 755
# 7 = 4+2+1 = r+w+x   Owner
# 5 = 4+1 = r+x  Group
# 5 = 4+1 = r+x  Others

# chmod , CHange MODe , change file or directory permissions
# chmod [option] [permission] [file_name]
chmod 777 notes.txt

chmod -R 0777 /mydirectory # give access for read-write-exe cute to all files inside a directory

chmod u+s,o-rwx myUserGroup myFile
# u+s => adds the SetUID bit
# when the program is executed, the process created will acquire all the privileges of the program's owner; the effective UID of the process will be the same as the UID 
# of the owner of the program (most likely, that will be root). This allows someone who would not normally be able to do something to do it via this program.

# o-rwx => removes read and wrirte and execute from others

sudo chmod u+w myfolder

# chmod give access to only specific user
# This sets permissions for specific users, without changing the ownership of the directory.
setfacl -m u:<username>:rwx myfolder

# another way is to set that user as owner of the file/folder, then give him the access
sudo chown <username>: myfolder

# chown , CHange OWNership
# chown [option] owner[:group] file(s)
chown linuxuser2 filename.txt
sudo chown Bob file.txt

# make chown work recursively? change ownership file a specific file type in all sub-directories
# Recursive mode only works on directories, not files, 
find . -type f -name '*.pdf' | xargs chown <username>:<usergroup>

# in Bash 4 and later we can do this:
chown -R <username>:<usergroup> ./**/*.pdf

sudo echo test >> /etc/hosts  # this will give "permission denied" error
# sudo only applies to the echo command.
# The >> redirection (append operator) is handled by your current shell, before sudo even runs

# how t o fix it:
# This runs the whole redirection inside a root shell.
sudo bash -c 'echo test >> /etc/hosts'

#===============================================================
# working with Files and String

# echo , prints arguments to the terminal
# can also use it to append text to files
echo my name is babak

# command substitution $()
echo "your username is $(whoami)"
echo "$(tput setaf 166)this is orange"

# superuser do , elevates user permission to do tasks
# sudo [command]
sudo apt-get install my-package # ubuntu
yum install my-package # centOS and RedHat
pacman -S my-package # Arch

# path of current working directory
pwd # print working directory

# cd , go to this folder
cd /home/username/Movies

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

# copying a file also copies its permissions to the new file
chmod 755 my-file.txt
# new.txt also has the 755 permissions
cp my-file.txt new.txt

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

echo "testing" | head -c 2

date +%s | shar256sum | head -c 8

date +%s%N | sha256sum | head -c 4

# tail , same as head but for end of file
# tail [option] [file]
tail -n colors.txt
cat my_recepie.txt | tail

# show details of last 3 created accounts
tail -3 /etc/passwd

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
wc file.txt  # 34  34  348  lslog.log

# -l flag counts lines instead of words
wc -l /etc/passwd

# get all the lines in /etc/passwd that contain the word "bash" , then count the lines
grep bash /etc/passwd | wc -l

# tr , TRanslate
# replace all the "W" in the file with "j"
cat my-thesis.txt | tr W j
# replace all lowerCase characters to upperCase 
cat my-thesis.txt | tr "[:lower:]" "[:upper:]"


# AWK, scans each input file for lines (this commands goes through a file line-by-line) that match any of the set patterns
# print matched lines
# Search through the file test.log and print every line that contains the text byego
# {print} Action to take when the pattern matches — here: print the line

# Print only the first column (field) in each line of the file
awk '{ print $1 }' file.txt

awk '/byego/ {print}' test.log

# splits a line into two fields
awk '{print $1,$3}' test.log

a="Hi all"
echo "$a" | awk '{print tolower($0)}'  # hi all, Prints the result, Converts the whole input line ($0) to lowercase

# print lines with more than 10 characters
awk 'length($0)>10' test.log

var="apple orange"
echo $var    # apple orange
echo $var | awk '{print $1}'   # apple
echo $var | awk '{print $2}'   # orange

# change field separator
awk -F',' '{ print $1 }' file.csv

# This tells awk that the field separator (delimiter) for each line is a colon :
# /etc/passwd  =>  username:x:UID:GID:comment:home_dir:shell
# '{print "UID: "$3 ";LOGIN: "$1}'  => $1 → first field (the username / login name)    $3 → third field (the user ID number (UID))
# result format: UID: <value_of_$3> ;LOGIN: <value_of_$1>    =>  root:x:0:0:root:/root:/bin/bash => UID: 0 ;LOGIN: root
awk -F ':' '{print "UID: "$3 ";LOGIN: "$1}' /etc/passwd

awk '{print $7}' access_log

# cut, cuts out selected portions of each line from each file and writes them to the standard output

# divide the lines via "," and only show columns 2 and 3
cut -d, -f2,3 domains.csv
# cut first 3 bytes
cut -b 1,2,3 file.log
# select second column delimited by a space
cut -d" " -f 2 test.log
# specify a character's position
cut -c 1-8 test.log

echo 'one\two\three' | cut -d '\' -f 3   # three

var="apple orange"
# divide by space, then get column 2
echo $var | cut -d' ' -f2  # orange

cut -d ':' -f 1,3 --output-delimiter=',' /etc/passwd
#  1           3
# usertest:x:1000:1000:usertest:/home/usertest:/bin/bash  =>  usertest:1000


# SED, sed reads the specific files, modifying the input as specified by a list of commands
# sed = Stream EDitor
# sed 's/search-pattern/replacement-string/<FLAG>' <FILE>
# substitute a string, change bytego to go
sed 's/bytego/go/g' test.log   # the /g at the end means "replace all occurrences on each line" (global)
# replace second occurance
sed 's/bytego/go/2' test.log
# replace the string on the fourth line
sed '4 s/bytego/go/' test.log
# replace string on a range of lines
sed '2-4 s/bytego/go/' test.log

sed 's/my wife/sed/g' diary.txt > new-diary.txt
 
cat my-logs.log | sed 's/failure/failed/g' > my-new-logs.txts

# in sed commands, we can use other delimiters instead of /, for example #
cat '/home/jason' | sed 's#/home/json#/export/users/jasonc#g'

sed '/This/d' love.txt  # deletes all lines that contain the word "This"

sed '/^#/d' config.cfg  # deletes all lines that start with # , so all the comments
sed '/^$/d' config.cfg  # deletes all empty lines, ^ : line start , $ : line end => empty line

# combine the two above commands into one (and replace apache with httpd)
sed '/^#/d ; /^$/d ; s/apache/httpd/g' config.cfg
# another way to do same thing
sed -e '/^#/d' -e '/^$/d' -e 's/apache/httpd/g' config.cfg

# only replace apache with httpd on lines that contain the word Group
sed '/Group/ s/apache/httpd/' config.cfg  


# SORT, sorts text and binary files by line
# output to a file
sort -o output.txt input.txt
# sort in reverse order
sort -r test.log
# sort numerically
sort -n test.log
# sort based on the third column
sort -k -3n test.log
# sort and remove duplicates
sort -u test.log

sort /etc/passwd | less
sort -r /etc/passwd | less

cut -d ':' -f 3 /etc/passwd | sort -n

# divide the contents of access_log by "  then select the second field
cat access_log | cut -d '"' -f 2

# du = Disk Usage  for /var directory and its subdirectories
# sort -n , sorts directories numerically from smallest to largest size
sudo du /var | sort -n

# -s → summarize total per directory (don't show every subfolder)
# -h → human-readable (MB/GB instead of KB)
# /var/* → only top-level subfolders
sudo du -sh /var/* | sort -h

# sort -t ':' uses : (colon) as the field separator, then sorts by the third field
# -n => then sort by the numerical value of third field
# -r => then sort from largest to smallest value (reverse) of third field
cat /etc/passwd | sort -t ':' -k 3 -n -r

# UNIQ, reads the specified input file comparing adjecent lines and writes a copy of each unique input line to the output file

# tell how many times a line is repeated
uniq -c test.log
# print repeated lines
uniq -d test.log
# print unique lines
uniq -u test.log
# compare case-insensitive
uniq -i test.log

netstat -nutl | grep ':' | awk '{print $4}' | awk -F ':' '{print $NF}' | sort -n | uniq -c

# show the contents of the /var/log/messages
# in each line select the fifth column separated by space
# then sort results by alphabetical order
# only show unique results
sudo cat /var/log/messages | awk '{print $5}' | sort | uniq

# man, MANual , provides a user manual of any commands or utilities you can run in Terminal
man ls

# clear , clean the contents of the terminal
clear

#!  is called bash SheBang, is used to tell the operating system which interpreter to use to parse the rest of the file.
#!/bin/bash -        Uses bash to parse the file.
#!/usr/bin/python    Executes the file using the python binary.
# If a shebang is not specified and the user running the Bash script is using another Shell the script will be parsed by whatever the default interpreter is used by that Shell

# to find the sum encryption files in linux 
ls -l /usr/bin/*sum
    # /usr/bin/cksum
    # /usr/bin/sha1sum
    # /usr/bin/sha256sum


jq -sr ".[] ${FAILURE_CONDITION} | .account_id"

# uses jq, a command-line JSON processor, to extract and process data from a JSON file
# processes the JSON data using jq. Here's what each part does:
# -s: This option tells jq to read the entire input as a single JSON array. This is useful when the input consists of multiple JSON objects, one per line.
# -r: This option tells jq to output raw strings instead of JSON-encoded strings. This is useful when you want to use the output in shell scripts.
# .[]: This part iterates over each element in the JSON array.
# | .account_id: This part extracts the account_id field from each element that matches the FAILURE_CONDITION.
# uniq: This command removes duplicate lines from the output. It assumes that the account_id values are sorted, or it will only remove consecutive duplicates.

# {"name":"Babak","age":30,"skills":["bash","python","aws"]}

cat data.json | jq '.name'  # "Babak"
cat data.json | jq '.skills[1]' # "python"

export VTOKEN=`curl -k -s --request POST \
  --data '{"jwt": "'$K8T'", "role": "vt-operate-role"}' \
  https://ht.1020-core-vt.svc.cluster.local:8200/v3/auth/kubernetes/login | jq -r '.auth.client_token'`

# -k → Ignores SSL certificate verification (useful for self-signed certificates in internal Kubernetes services).
# -s → Runs silently (hides progress/output unless there's an error).
# --request POST → Sends a POST request.
# --data '{"jwt": "'$K8T'", "role": "vt-operate-role"}'
# Sends JSON payload to authenticate with Vault's Kubernetes authentication backend.
# "$K8T" → Uses the value of the shell variable K8T, which holds a Kubernetes service account token.
# "role": "vt-operate-role" → Specifies the Vault role to use (vt-operate-role), which determines permissions inside Vault.
# https://ht.1020-core-vt.svc.cluster.local:8200/v3/auth/kubernetes/login
# The Vault Kubernetes authentication endpoint.
# this Vault service (ht.1020-core-vt.svc.cluster.local) is running inside a Kubernetes cluster.
# Port 8200 is Vault's default API port.
# | jq -r '.auth.client_token'
# jq → A command-line JSON processor.
# -r → Outputs raw strings (removes quotes around the extracted value).
# .auth.client_token → Extracts the client_token from Vault’s JSON response.


# What's the difference between <<, <<< and < < in bash?
# << is known as "here-document structure". You let the program know what will be the ending text, and whenever that delimiter is seen, the program will read all the stuff you've given to the 
# program as input and perform a task upon it.
wc << EOF
one two three
four five
EOF

# In this example we tell wc program to wait for EOF string, then type in five words, and then type in EOF to signal that we're done giving input.

# <<< is known as "here-string". Instead of typing in text, you give a pre-made string of text to a program. For example, with such program as "bc" we can do bc <<< 5*4 to just get output for 
# that specific case, no need to run bc interactively. Think of it as the equivalent of echo '5*4' | bc
ls -l /proc/self/fd/ <<< "TEST"

# < "Process substitution" feeds the output of a process (or processes) into the stdin of another process.So in effect this is similar to piping stdout of one command to the other , 
# e.g. echo foobar barfoo | wc
echo <$(echo bar)

#========================================================
# Linux Users

# uname, Unix NAME, print detailed information about linux system
# uname [option]
# -a : all | -s : kernel name | -n : hostname
uname -a

# root user always has uid of 0
id -u root  # shows 0

# useradd , create new user and set its password
sudo useradd John

# passwd , change's your current password
passwd
passwd 123456789

# userdel
sudo userdel John
id John  # shows that user John does not exist
ls -l /home/  # John's home directory still exists

userdel -r Alex  # delete user Alex and his home directory

# creates a new user, creates new group with same name and adds user to that group and create homedir or /home/new_user
adduser new_user
# asks for password
# asks for person's name (can be set to default)

usermod -aG new_group username  # add user to a new group
usermod -aG sudo my_user  # add user to sudo group, which gives admin rights

usermod -L username  # lock account
usermod -U username  # unlock account

# add new group with gid of 1200, for normal users and groups, it usually starts from 1000 and upward for uid and gid
groupadd -g 1200 mynewgroup
# edit the group
groupmod -g 1345 mynewgroup
# delete the group
groupdel mynewgroup

# shows info about all users
head /etc/passwd  # username:group:password (here only shows x):gid:extra_info:/home/username:shell-format (for example /bin/bash)

cat /etc/shadow   # username:password (if it is * then user doesnt have a password):days_since_last_change:days_until_expire:days_until_expire_warning:days_until_disable:days_until_disable_warning

chage -l username  # shows info about password expiration

id username  # shows info about user and its groups
id -u ubuntu # 1000 show's the user's uid
id -nu 1000 # ubuntu, shows username from uid

# su [options] [username [argument]], allows you to run a program as a different user
su -p babak
# another way
su - Phil

# become root user without knowing root's password
sudo su -  

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

# we can see min and max allowed uid for creation of users
cat /etc/login.defs
    # UID_MIN    1000
    # UID_MAX    60000
# deleting accounts with UID of less than 1000 might cause system issues, as those accounts are usually reserved for system users
    # SYS_UID_MIN    100
    # SYS_UID_MAX    999

# locking linux user accounts
# however, this will not lock user if they use ssh to login with ssh-keys, use chage instead
sudo passwd -l john  # lock user john

# immediately expires the user account alex by setting its expiration date to day 0
# alex will no longer be able to log in. The account is considered disabled / expired, but not deleted.
# chage => Change user password aging/account expiration
# -E 0 => Sets the account expiration date to 0 = 1970-01-01, meaning already expired
sudo chage -E 0 alex 
# If you want to re-enable the account later, you can set expiration to -1
sudo chage -E -1 alex

#========================================================
# SSH

# SSH , Secure SHell, a network protocol that enables secure remote connections between two systems
# ssh [username]@[hostname_or_ip] -p [port_number]
ssh my_user@my_hostname

ssh user1@test.server.com -p 3322
# first time tring to ssh, type "yes" to continue, then enter the password
# private_key => in your local machine
# public_key => in the remote machine
# the collection of public and private key are called host keys

# to make the ssh password-less
# generate ssh key
# -t : make sure using RSA algorithm
# -b : byteSize
ssh-keygen -t rsa -b 4096
# press enter to save the key in default location (/Users/my_username/.ssh/id_rsa)
# press enter for passphrase (not needed)
# both public and private key has been created at ~/.ssh

# id_rsa : private key
# id_rsa.pub : public key
# known_hosts : list of hosts (ip addresses) that are allowed to access the private-key, via public-key

# create this folder on remote machine
mkdir .ssh 
# copy the public key to the remote machine, in the .ssh folder
scp ~/.ssh/id_rsa.pub username@remote_machine:/home/username/.ssh/uploaded_key.pub
# enter password and it is copied

# save that public key in this file on remote machine, this file is MANDATORY
cat ~/.ssh/uploaded_key.pub >> ~/.ssh/authorized_keys
# ~/.ssh/authorized_keys is the file on a Linux/Unix server that stores public keys allowed to log in via SSH without a password

# change the access rules for the ssh files/folder on remote machine
chmod 700 ~/.ssh/ # sets the permissions of the ~/.ssh directory so that only the owner can read, write, and access it.
# 7	Owner: read + write + execute (rwx)
# 0	Group: no permissions
# 0	Others: no permissions

# owner can read and write, no one else can read/write/execute
chmod 600 ~/.ssh/*
# 6	Owner: read + write (rw-)
# 0	Group: no permissions
# 0	Others: no permissions

# alternative way, without need to create .ssh folder or copy public-key
ssh-copy-id my_user@my_hostname

# now it will login without need for password
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


# jump server: you can ssh to a machine and from that machine you are allowed to ssh into several other systems.

# local -> jump server -> remote machine
#                      -> remote machine
#                      -> remote machine

# to use jump server we need ssh-agent and ssh-add commands so jump server can use our private ssh-key to connect to target servers

# use ssh to only run one command and then exit the remote host:
ssh root@5.161.75.09 uptime

# upload file from commandline via FTP or SSH
scp <file to upload> <username>@<hostname>:<destination path>

# PSSH: Parallel SSH connections

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
./MyCompany/code/lputils/linux/os_patches/lpospatching.sh -y
# run several server patches all at once:
pssh -h servers.in -t 600 -i '/MyCompany/code/lpospatching.sh -y'

# how to do visual ssh into gui
# in target machine at "/etc/ssh/sshd_config" set "X11Forwarding" to "yes", then connect to ssh like this:
ssh -X server_ip.address.net
# call_some_gui_app

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

# Uses OpenSSL crypto toolkit
# Generate an RSA private key
# -out ca-key.pem => Output file name (the key will be stored here)
# Encrypts the private key with AES-256 and protects it with a passphrase
# Key size in bits (4096-bit RSA)
openssl genrsa -out -aes256 ca-key.pem 4096

# generate a public CA certificate, using private certificate
# use the passphrase entered in the previous step
# it asks for some generic information, but it is not important what you enter here, Issuer Details
openssl req -new -x509 -days 3650 -sha256 -key ca-key.pem -out ca.pem

# view the public certificate
openssl x509 -in ca.pem -text -noout

openssl x509 -in ca.crt -text -noout

# Check Certificate Fingerprint: To get the fingerprint of the certificate, which is a unique identifier, you can use
openssl x509 -in ca.crt -noout -fingerprint
# This command checks if the certificate can be verified against itself, which is typical for a root CA certificate.
openssl verify -CAfile ca.crt ca.crt

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

# The ca.crt file is typically a PEM-encoded X.509 certificate, which is a text file containing base64-encoded data. You can decode and view the contents of this certificate using various tools. Using OpenSSL: OpenSSL is a widely 
# used tool for working with SSL/TLS certificates. You can use it to decode and display the contents of a certificate file.

#========================================================
# Searching

# locate , look for a file in folder structure
locate file.txt
locate -i school*notes
  my*.csv | less
locate csv | grep domain 

locate userdel | grep bin
# /usr/bin/userdel
 
# before running locate, run this commnad, makes index of all files on your computer
sudo updatedb

# find is similar to locate, but it searches in real-time, while locate uses a pre-built database
# find [option] [path] [expression] , more advanced search to find a file
find /home -name notes.txt
find ./ -type d -name dir_name

# 2>/dev/null  => this part is to hide permission denied errors
find / -name userdata.csv 2>/dev/null

# Delete matching files in all subdirectories
# Remove all *.swp files underneath the current directory, use the find command in one of the following forms:
find . -name \*.swp -type f -delete # The -delete option means find will directly delete the matching files. This is the best match


# grep, Global Regular Expression Print, searches any given input file, returning lines that match one or more patterns
# grep [search string] [filename]
grep blue notepad.txt   
grep Lord my-text.txt > jesus.log 
# find file names that match
grep -l "bytego" *.log
# case insensitive word match in a file
grep -wi "bytego" test.log
# show line numbers
grep -n "bytego" test.log
# show file lines that do NOT match (don't contain the keyword)
grep -v "bytego" test.log
# search recursively in all files in a directory
grep -R "bytego" /home

# / => root directory, it goes through the whole system and finds all links
find / -type l 

export PATH=$PATH:/usr/new/dir # add a new directory to the PATH variable

which ping # this command shows where the command "ping" is saved at : /sbin/ping

find /etc -iname "*vmware*" # find all files and directories that contain "vmware" in their name, -iname is case insensitive

locate aws  # find files that contain "aws" in their name, its faster than find, but is based on databse that is updated once per day

# which, shows the path of an executable program (command)
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
df -h  # -h stands for “human-readable”, With -h, it automatically converts them to KB / MB / GB / TB depending on size
df -m  # -m = “show sizes in MB (megabytes)”
df -h | grep media

# du, Disk Usage , how much space a folder or file is taking
du  # works on current folder
du /home/user/Documents

# mount, allows attaching additional devices to the file system.
# mount ISO files, USB drives, NFS,..

# mount -t [type] [device] [directory]

# each hard drive is divided to partitions, in linux devices are defined at /dev , /dev/sda1 , /dev/sda2 ,... 
# the sda1 and sda2 partitions are mounted at /dev folder at /sda and /sdb folders.  

fdisk /dev/sda  # this command will open sda hard disk in fdisk software to change or view partitions

# mount extrnal HDD to linux machine
# see if there is an entry in the disk list:
sudo fdisk -l 
# mount it: 
# -t ntfs => Filesystem type is NTFS (Windows filesystem)
# /dev/sdb1 => The device/partition you are mounting
# /media => The directory (mount point) where it will be accessible
sudo mount -t ntfs /dev/sdb1 /media 

sudo mount | grep sda  # shows all partitions for sda disk

# *** LVM ***
# Logical Volume Management, is used for cases when you need to resize the partitions.
# via LVM you can add up several physical drives to one bigger virtual drive (Volume Group) that itself can be partitioned.

# in linux we have physical volumes, they add up to become a volume group and then we can divide the volume group
# into logical volumes (LVM) 

# physical volume /dev/sda 200 GB =>                           => logical volume 50GB 
#                                      Volume Group 1 400GB
# physical volume /dev/sdb 200 GB =>                           => logical volume 50GB 

lsblk
    # NAME MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
    # sda    8:0    0 363.3M  1 disk
    # sdb    8:16   0     2G  0 disk [SWAP]
    # sdc    8:32   0     1T  0 disk /snap
    #                                /mnt/wslg/distro
    #                                /

# create physical volumes
pvcreate /dev/xvdf1 /dev/xvdf2

# a physical volume is a collection of disk partitions used to store all server data. physical volumes have a maximum size of 16 TB, because physical volumes can contain any portion
# of one or more disks, you must specify several characteristics of a physical volume when creating it.

pvdisplay /dev/sdb1
    #   “/dev/sdb1” is a new physical volume of “2.01 GiB”
    #   --- NEW Physical volume ---
    #   PV Name               /dev/sdb1
    #   VG Name
    #   PV Size               2.01 GiB
    #   Allocatable           NO
    #   PE Size               0
    #   Total PE              0
    #   Free PE               0
    #   Allocated PE          0
    #   PV UUID               0FIuq2-LBod-IOWt-8VeN-tglm-Q2ik-rGU2w7

# create a volume group from physical volume
vgcreate vol_group1 /dev/xvdf1 /dev/xvdf1

# show the details of the volume group
vgdisplay

# This command creates a logical volume inside a volume group in LVM.
# lvcreate	Create a new logical volume
# -n lv01	Name of the logical volume will be lv01
# -L 500MB	Size of the volume = 500 megabytes
# vol_group1	The volume group in which it will be created
lvcreate -n lv01 -L 500MB vol_group1

# show the logical volumes
lvdisplay

sudo lvdisplay Vol1
    #   --- Logical volume ---
    #   LV Path                 /dev/Vol1/lvtest
    #   LV Name                 lvtest
    #   VG Name                 Vol1
    #   LV UUID                 4W2369-pLXy-jWmb-lIFN-SMNX-xZnN-3KN208
    #   LV Write Access         read/write
    #   LV Creation host, time  … -0400
    #   LV Status               available
    #   # open                  0
    #   LV Size                 2.00 GiB
    #   Current LE              513
    #   Segments                1
    #   Allocation              inherit
    #   Read ahead sectors      auto
    #   - currently set to      256
    #   Block device            253:2


# *** Stratis ***
# In Stratis we have physical volumes, but instead of Volume groups we use volume Pools, and then use FileSystem on top of it.
# While LVM has defined size that needs to be changed, FileSystem’s min size is its current size and its max size is the size of Volume Pool.

# physical volume /dev/sda 200 GB =>                          
#                                      Volume Pool 400GB  => [Stratis File system, can change size]
# physical volume /dev/sdb 200 GB =>                         

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
    # total : 1TB
    # swap: ram+2gb | /boot 1gb | /var 30 gb for server logs | /home 900gb | /usr 20 gb



# ************  fstab File Basics  ************

# The fstab file is used by the kernel to locate and mount file systems. It’s usually auto generated at install and users need not worry about it unless they plan on adding more storage 
# to an existing system. The name fstab is a shortened version of File System Table; the format is actually quite simple and easy to manipulate. Entries are separated by white space.

# 1. Device
# Drive/partition to be mounted. It is usually identified by UUID but you can do it with device names (ex. /dev/sda1) or labels (ex. LABEL=OS.)

# 2. Mount Point
# The directory where the device/partition will be mounted (ex. /home.)

# 3. File System Type
# Tells the kernel what file system to use when mounting the drive/partition. (ex. ext4, xfs, btrfs, zfs, ntfs, etc…)

# 4. File System Options
# Tells the kernel what options to use with the mounted device. This can be used to instruct the system what to do in the event of an error or turn on specific options for the file system itself.

# 5. Backup Operations/Dump
# This is a binary system where:  1 = dump utility backup of a partition.  0 = no backup. This is mostly disused today.

# 6. File System Check Order
# Sets the order in which devices/partitions will be checked at boot. 0 means no check, 1 means first check and 2 means second check. The "/" file system should be set to 1 and following systems to 2.

UUID=1234-5678  /home   ext4    defaults   0   2

# what is already mounted, list blocks
lsblk
    # sda => hard drive
    # sro => dvd drive

# block id, show uuid for the blocks abd partitions
sudo blkid

# mount an extra drive
# the drive is named data_drive, it is locate at /data and its type is ext4 and we accept the defaults
LABEL=data_drive /data ext4 defaults 0 2

# mount more swap space (addition to ram from harddrive)
/swapfile1 none sw 0 0

# after making a change, run this command
# tells Linux to mount all filesystems listed in /etc/fstab (except those marked “noauto”). After you edit /etc/fstab, instead of rebooting to test if your entry is correct, you run it
sudo mount -a

# the file that contains configuration for the fstab and the drives
sudo vi /etc/fstab

# backup the fstab file before making any change to it
sudo cp /etc/fstab  /etc/fstab.old
# how to restore the fstab file
sudo mv /etc/fstab.old /etc/fstab


# **** how to backup NFS drive *****
# We need to unmount existing NFS and mount cohesity drive on each data and master node of these clusters

# create new dir: 
mkdir -p /MyCompany/data/elasticsearch_backup1

# unmount existing nfs:
umount /MyCompany/data/elasticsearch_backup

# mount old nfs to new directory:
mount -t nfs 172.16.22.1:/vol/els_prod_backup/elasticsearch_intentanalyzer /MyCompany/data/elasticsearch_backup1

# Verify the new mount:
df -h | grep elasticsearch_backup1

# Mount Cohecity NFS appliance to old dir and verify the mounts:
mount -t nfs va-cohesity.mcdomain.com:/es_va_prod_v7.8_intent /MyCompany/data/elasticsearch_backup
# make sure it exists
df -h | grep elasticsearch_backup

# make new entry to fstab file (comment old nfs line):
vi etc/fstab
va-cohesity.mcdomain.com:/es_va_prod_v7.8_intent  /MyCompany/data/elasticsearch_backup nfs defaults 0 0

#==========================================
# zip files 

# tar , helpes with compressing and un-compressing files
# tar [options] [archive_file] [file or directory to be archived]
# -c	Create a new archive | -v  Verbose – show files as they are being added  | -f  File – specify the archive filename that follows
tar -cvf newarchive.tar /home/user/Documents

# how to restore via tar
# -x	Extract files from an archive  | -v  Verbose – show files as they are being extracted  | -f  File – specify the archive filename that follows
tar -xvf newarchive.tar

# zip [zipped-file-name] file1 file2
zip archive.zip notes.txt bills.txt

# unzip
unzip archived.zip

# archive the contents of /etc folder, it needs sudo permission.
# -z : compress the archive using gzip
# -c : create a new archive
# -f : specify the archive filename
sudo tar -zcf etc.tgz /etc

#==========================================
# Linux Processes

# jobs, shows all running processes
# jobs [options] jobID
jobs -l  # shows the background jobs running in your current shell, with their process IDs
jobs # shows all paused processes

# kill
# kill [signal_option] pid
# SIGTERM => requests a program to stop running and gives it some time to save all of its progress
# SIGKILL => forces programs to stop, and you will lose unsaved progress.

kill -SIGKILL 63773
# same as
kill -9 63773

kill -1 PROCESS_ID  # HUP tell the process that the shell that is controlling it is dead
kill -15 PROCESS_ID # TERM ask process to terminate (this is default signal, SIGTERM)
kill -9 PROCESS_ID  # KILL forcefully kills the process, SIGKILL

pkill pyt  # kill all processes that contain the word "pyt" in their name

# top, Table Of Processes , all runnig processes
top
# shows all the processes, sorts them based on cpu usage, press "q" to quit top
top 

# history, system will list up to 500 previously executed commands
history
history -c

# htop, similar to top but more visual and interactive
htop
# The -d option in htop is used to set the delay (refresh rate) between updates.
# 10 seconds refresh delay
htop -d 10

# file , provides information about a file
file my_file.py

# reboot, restarts the system immediately from the terminal
reboot

Ctrl+C # aborts the current foreground process
Ctrl+Z # pauses/stops current foreground process (moves it to background), it can be resumed later

# if a parent process dies, all the child processes die with it too.

nohup # allows your child process to live, even when parent process dies.

# the process below wont die even when you close the shell:
nohup ping 4.4.5.1  # appending output to nohup.out

nohup script.sh > mynohup.out 2>&1 &

    # nohup script.sh => run this script with nohup (don't kill it when we close the shell)
    # > mynohup.out => put the output in the mynohup.out file
    # 2>&1 => also put the errors in mynohup.out file, redirecting error messages (stderr) to the same place as standard output (stdout)
    # & => run it in the background


# 0 = stdin (standard input)
# 1 = stdout (standard output)
# 2 = stderr (standard error)

# 2>  => Means “redirect stderr (2) to somewhere.”
# 2>&1  => The &1 means “send it to the same place as file descriptor 1 (stdout).”
# So 2>&1 makes errors go to the same output as normal output.

# ps , Process Status , lists currently running processes on the system
ps
# -T: shows threads (LWP — Light Weight Processes) for processes attached to the current terminal
ps -T

ps  # PID TTY TIME CMD
    # PID   => ID of the process
    # TTY   => from which terminal its running
    # TIME  => how much time it borrows from the cpu
    # CMD   => with what command it started running

# $ ps
#   PID TTY      TIME     CMD
#  1234 pts/0    00:00:00 bash
#  5678 pts/0    00:00:00 ps

ps -e  # shows all processes currently running on this machine
# counts how many lines are there, which is equal to number of processes
ps -e | wc -l

# a detailed list of all running processes on a Unix-based system, e → Shows all processes (not just those belonging to the current user), -f → Displays a full-format listing with more details
ps -ef 

pstree  # is another way of visualizing processes. It displays them in tree format. So, for example, your X server and graphical environment would appear under the display manager that spawned them.

# Given a search term, pgrep returns the process IDs that match it
pgrep calc | xargs kill # find all processes that contain the word "calc", then kill them all

free # shows total memory, used and free and total SWAP used and free

uptime # how long the system has been up (not restarted) => 16:12  up 16 days,  2:45, 2 users, load averages: 2.23 2.19 2.11
uptime  # shows how long the server has been up for and also gives you load average

#### Load Average : can help you detemine if your linux system is keeping up with its workload or becoming slow, it is based on how much cpu we are using (but also related to hard drive I/O metrics)

cat /proc/loadavg  # also shows the system's current load average


# load average: 0.04, 0.05, 0.07

# 0.04 => over past one minute
# 0.05 => over the past 5 minutes
# 0.07 => over the past 15 minutes, this is the most important number

# 0.00 = server is not being used any hardware
# 1.00  = server is running at full capacity (if we have one cpu core), in case of 2 cup cores, the number 2.00 means 100% capacity of the server

cat /proc/cpuinfo  # see how many cpu cores we have (starts at 0)

watch COMMAND
watch df -h  # run this command every 2 seconds and show the new result
watch df -h | grep sda

# This command will execute command 1, and only if command 1 exits successfully (returns a zero exit status), it will then execute command 2. In other words, command 2 will only run if command 1 is successful.
command 1 && command 2  
# This command will run command 1 in the background (as a separate process) and immediately start running command 2 in the foreground. command 2 does not wait for command 1 to finish; they run concurrently.
command 1 & command 2  

# && ensures that the second command only runs if the first one is successful.
# & runs both commands concurrently, without waiting for the first to finish.

ulimit  # shows how much cpu, ram, memory a user can have inside a machine
ulimit -a  # show all

# prints the maximum number of file handles (i.e., open files) the Linux kernel will allow system-wide at once.
cat /proc/sys/fs/file-max

# how to change resource limits for users
cat /etc/security/limits.conf  
    # <username> soft nofile 4096
    # <username> hard nofile 4096

# show all services that are available
# +  : service is working
# -  : service not used
sudo service --status-all
# same as
systemctl status

# PROC
# Proc file system (procfs) is a virtual file system created on the fly when the system boots and is dissolved at the time of system shutdown. It contains useful information about the processes that are 
# currently running, it is regarded as a control and information center for the kernel. The proc file system also provides a communication medium between kernel space and user space.

# If we list the directories, you will find that for each PID of a process, there is a dedicated directory
# lists only the directory entries inside /proc.  grep '^d' => filters the output to only lines that start with d → meaning directories
ls -l /proc | grep '^d'

# If we want to check information about the process with PID 3151, we can use the following command.
# -l : long listing format   | -t : sort by modification time (newest first)    | -r : reverse the sort order(so oldest first)
ls -ltr /proc/3151

# INIT process
# init is parent of all Linux processes with PID or process ID of 1. It is the first process to start when a computer boots up and runs until the system shuts down. init stands for initialization.
# In simple words the role of init is to create processes from script stored in the file /etc/inittab

/etc/inittab  # Specifies the init command control file

# Stopping a postgresql instance
sudo systemctl stop postgresql
# only as last resort
killall postgresqld

# killall is a Linux command used to terminate processes by name, rather than by PID.
# killall process_name


# The part tee -a in the command echo 1.1.1.1 | sudo tee -a /etc/hosts specifies an operation to be performed on the output it receives
# tee => This is a command that reads standard input and writes it both to standard output (usually the terminal) and to one or more files. Think of it like a T-junction in plumbing
# -a => This is an option or flag for the tee command. It stands for append.
# the reason we use this command instead of just echo directly to the file, is that we want to use sudo/root privilage when adding data to that file
echo 1.1.1.1 | sudo tee -a /etc/hosts

# These commands adjust the inotify limits on a Linux system (inotify is a Linux kernel subsystem that provides a mechanism for monitoring file system events in real time)
# Helps applications that track changes in a large number of files, such as editors, IDEs, or file indexing services.
# Increases the maximum number of inotify instances a user can create from its default (usually 128 or 1024) to 8192
systemctl fs.inotify.max_user_instances=8192
# Increases the maximum number of files a user can watch with inotify from its default (usually 8192 or 65536) to 524288
systemctl fs.inotify.max_user_watches=524288

lsof 
# The lsof command is an acronym for "list open files," but its potential isn't limited to just that role. It's commonly said that in Linux, everything is a file. In many ways, that's true, 
# so a utility that lists open files is actually pretty useful. The lsof utility is a robust interface for the information inside the /proc virtual filesystem.

# what process is using a particular directory:
lsof /run

# what files a particular process has open:
lsof -p 890

# discover what files a particular user has open:
lsof -u admin
lsof /proc/{USER-ID}/fd | wc -l
lsof -u {USER} | wc -l


auditctl
# a utility to assist controlling the kernel's audit system. The Audit system operates on a set of rules that define what is to be captured in the log files.
# The "auditctl" command allows you to control the basic functionality of the Audit system and to define rules that decide which Audit events are logged.
# sets the maximum amount of existing Audit buffers in the kernel:
auditctl -b 8192
# sets the rate of generated messages per second:
auditctl -r 0

#  file descriptor (FD) 
# A file descriptor (FD) is a unique identifier assigned by the operating system to track open files, sockets, or other I/O resources. It acts like a reference number that applications use to 
# interact with files and network connections, Used for More Than Just Files:
# Regular files (e.g., logs, config files) | Network sockets (e.g., TCP, UDP connections) | Pipes and FIFOs (inter-process communication) | Device files (e.g., /dev/null, /dev/random)
# Each Process Has a Limit
# A process can only open a limited number of file descriptors, This limit is set by the OS (e.g., ulimit -n on Linux). If exceeded, errors like "Too many open files" occur.

#==========================================
# CRON

# cron can be installed from crontab package, each user has his own crons
#   M (minute)  H (hour) DOM (day of month) MON (month) DOW (day of week) command-to-execute
    42          3        1                  *           *                 /root/backup.sh  # run it first day of each month at 3:42 am
    42          3        *                  *           *                 /root/backup.sh  # run it everyday at 3:42 am
    */15        */2      *                  *           *                  /root/backup.sh # run it Every 15 minutes (00, 15, 30, 45) Of every 2nd hour (00:00–1:59, 02:00–3:59, 04:00–5:59, etc.) => 00:00, 00:15, 00:30, 00:45, 02:00, 02:15, 02:30, 02:45
    30          *        *                  *            1,7              /root/backup.sh  # run it At minute 30 of every hour (e.g. 00:30, 01:30, 02:30, etc.) only on Sunday and Monday

# */15      */2      *      *      *      /root/backup.sh
# ┬         ┬        ┬      ┬      ┬
# │         │        │      │      └─ Day of week (any)
# │         │        │      └──────── Month (any)
# │         │        └─────────────── Day of month (any)
# │         └──────────────────────── Hour: every 2 hours
# └────────────────────────────────── Minute: every 15 minutes

crontab -l # shows all crons 

# remove all crons
crontab -r

# create crons in the file that opens:
crontab -e 

    # 42    3     1   *   *   /root/backup.sh >> $HOME/tmp/backup.log 2>&1
    # */15  */2   *   *   *   /root/backup.sh >> $HOME/tmp/daily/backup.log 2>&1
    # 1      0    30  *   *   /var/www/check-server.sh >> /dev/null 2>&1   

# >> : means append standard output (stdout) to a file.
# /dev/null : is a "black hole" — anything sent there is discarded.
# 2>&1 : means redirect standard error (stderr) to the same place as standard output (stdout).
/var/www/check-server.sh >> /dev/null 2>&1

# cron files are saved at: 
/var/spool/cron/tabs/username

# only use one of these files:
/etc/cron.allow  # if you add a user here, only that user can use cron.
/etc/cron.deny  # the user that is added here can't use cron.

# create a cron schedule that runs every night at 3:30 am
# To create a cron schedule that runs every night at 3:30 AM, you would use the following cron expression:
30 3 * * *

# 30 3 * * *
# ┬  ┬ ┬ ┬ ┬
# │  │ │ │ │
# │  │ │ │ └─ Day of week: any
# │  │ │ └─── Month: any
# │  │ └───── Day of month: any
# │  └─────── Hour: 3 AM
# └───────── Minute: 30

#==========================================
# Logs

# rsyslog => the most recent log server on linux machines
systemctl status rsyslog

/dev/log    # applications always write to /dev/log their information
/var/log/   # almost all the logs go here

dmesg | less   # shows the logs for when the machine is booting up

cd /var/log
ls -ltrh    # shows the logs by time order, to see the last one that was created

# logrotate is a Linux utility that automatically manages log file size by rotating, compressing, and deleting old logs. It prevents /var/log from filling up your disk
sudo logrotate -f /etc/logrotate.conf

vi /etc/logrotate.conf

cd /etc/cron.daily/   # here you can see that logrotate is being run everyday

/var/log/auth.log   # all logs related to authentication
/var/log/lastlog    # date and time of all recent user logins

# journalctl saves all the logs that have been generated in the system
journalctl  # shows all the logs, press shift+d to go to the end

journalctl --help

# show the last 5 lines of the logs
journalctl -n 5

# this is where the temporary logs are saved
cd /run/log/journal

# here you can edit to save the logs or delete them by each system restart
vi /etc/systemd/journal.conf
# set storage to persistent

    # [Journal]
    # Storage=persistent

journalctl -e      # automatically go to the end of the logs
journalctl -f      # goes to the last line of the logs and updates it if new log is added
journalctl -u ssh  # shows all logs related to ssh
journalctl -u ssh --since yesterday
journalctl --since "09:00:00" --until "11:00:00"  # 9 to 11am logs for today

# how reduce the size of a log file without losing recent logs (truncate it)
# sets size of the file to zero, makes it empty
truncate -s 0 logfile
# this will also empty the file
cat /dev/null > file.log

# takes the last 10 megabytes of logfile and writes them into newlogfile
tail -c 10M logfile > newlogfile

#=============================
# Networking

# ping , Packet INternet Groper
# When you run ping , the ICMP protocol sends a datagram to the host you specify, asking for a response. ICMP is the protocol responsible for error handling on a TCP/IP network.
# ping [option] [hostname_or_IP_address]
ping google.com

# ping the ip address each 5 seconds
ping x.x.x.x -i 5 

# trace from which ip it starts to end up connecting to this ip (for example for ping)
traceroute 4.2.2.4 

# wget , WWWW GET , download files from the internet
# wget [option] [url]
wget https://wordpress.org/latest.zip
# To save the downloaded file under a different name, pass the -O option
wget -O latest-hugo.zip https://github.com/gohugoio/hugo/archive/master.zip
# download a file to a specific directory
wget -P /mnt/iso http://mirrors.mit.edu/centos/7/isos/x86_64/CentOS-7-x86_64-Minimal-1804.iso
# Limiting the Download Speed, m is for megabyte
wget --limit-rate=1m https://dl.google.com/go/go1.10.3.linux-amd64.tar.gz

# The hostname command in Linux shows or sets the system’s host name (the machine name on the network).
hostname
# prints the IP address(es) associated with the hostname of the machine
hostname -i
# shows the alias names for the hostname, i.e: myalias1 myalias2
hostname -a

# prints the persistent hostname of your Linux system (the one that stays after reboot)
cat /etc/hostname
# change the machines name
hostnamectl set-hostname babak  

vim /etc/hosts  # how to set another machines ip to custom name

    172.167.2.45 dummyhost
    127.0.0.1 gaming.ir  # if some user tries to access that website, it will fail, since we set it to local address, this is a way to block websites

ping dummyhost

# ip address command , contains many useful networking functionalities
ip addr
# shows the routing table of the system (works same as AWS route tables)
ip route 

# curl, Clients for URLs , transferring data using various protocols
curl https://www.google.com
# curl -I sends an HTTP HEAD request and shows only the response headers (no body/content)
curl -I https://www.google.com  
    # HTTP/1.1 200 OK
    # Date: Tue, 24 Oct 2025 17:30:12 GMT
    # Content-Type: text/html; charset=UTF-8
    # Content-Length: 1256
    # Server: nginx

# add a custom HTTP header to your request
curl -H "X-Header: value" https://www.example.com

curl -X POST \
  -H "Content-Type: application/json" \
  -H "X-Custom: abc" \
  -d '{"name": "John"}' \
  https://example.com/api


curl -fsSL https://pkgs.k8s.io/core:/stable/v1.31/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
# -f => tells curl to fail silently on server errors, show no messages
# -s => operate in silent mode, supress any messages
# -S => show errors if the occur (works together with -s )
# -L => follow any redirects
# gpg => Gnu Privacy Guard, tool for encryption and signing, here used to handle downloading gpg key
# --dearmor => tells gpg to convert gpg key from ASCII-armored to binary format to use with APT package manager
# -o => output to the specified file in specific location

# nslookup , Queries internet domain name servers interactively.
# nslookup [-option] [name] [server]
nslookup www.google.com
nslookup -type=ns google.com  # name server
nslookup -type=mx yahoo.com  #  Mail Exchange server data

# NIC : network interface card
# wlan0 , eno1 , ens1, enp3s2 : linux detects several nic cards on a machine.

ip link show  # view all network cards
apt install net-tools # install ifconfig
ifconfig # detailed info about each network card
ifconfig <NETWORK_CARD> down  # shuts down the nic from hardware level

# networking settings are here
cd /etc/network/interfaces  

ip addr show

# add the default gateway to connect to outside world
ip route add default via 192.168.1.1  

# shows the status of the network connections
nmcli general status  
nmcli device  # shows all network devices

cat /etc/resolv.conf  # local DNS file

# the order of how the command will access different processes to resolve names
cat /etc/nsswitch.conf  

    passwd: files systemd  # first ask files, then systemd for passwd command

# shows the routing table
netstat -nr 
# shows all the active ports on the machine (for both internet connections and unix sockets)
netstat -na 
# shows all currently listening (using) ports
netstat -l 
# check which process is listening on a specific TCP/UDP port
netstat -tulnp | grep <PORT NUMBER> 

# netstat	Shows network connections, routing tables, interface stats
# -t	Show TCP connections only
# -u	Show UDP connections only
# -l	Show listening sockets only
# -n	Show numeric addresses/ports instead of resolving names
# -p	Show PID and process name using the port

# remove the first two lines (not the data itself) from the result
netstat -nutl | grep -v '^Active' | grep -v '^Proto'

# $NF => The last field in that colon-separated line
# {print $NF} => Print that last field
# 127.0.0.0.:22 => 22
netstat -nutl | grep ':' | awk '{print $4}' | awk -F ':' '{print $NF}'

# nc => netcat , shows all the connections on port 1377 on this machine
nc -l 1337 

# fuser => shows which process is using a specific port
# find out which user is using port 22 (on tcp layer) on this machine
sudo fuser 22/tcp 

# dig => is a DNS lookup tool, checks how a domain name can be resolved to IPs
dig google.com

# shows all the tcp connections passing through this machine
tcpdump  

# is used to capture and log TCP traffic on port 80 (HTTP) and display it in a continuous, human-readable format
# -c : capture mode
tcpflow -c port 80  

# A-Record : An A record maps a domain name to the IP address (Version 4, ipv4) of the computer hosting the domain. An A record uses a domain name to find the IP address of a computer connected to the 
# internet. The A in A record stands for Address. Whenever you visit a web site, send an email, connect to Twitter or Facebook, or do almost anything on the Internet, the address you enter is a series 
# of words connected with dots. to access the website you enter "www.dnsimple.com". At our name server, there is an A record that points to the IP address 208.93.64.253
# DNS record types:
# A-record => ipv4 address for a host
# AAAA-record => ipv6 address for a host
# MX-record => mail server address for a host

# this is same as 'cat /etc/hosts' , shows the localhost,...
getent hosts localhost
# is used to look up hostnames and IP addresses using the system’s configured name services, such as /etc/hosts, DNS, or LDAP
getent hosts

getent hosts google.com   # result:  142.250.190.78  google.com

cat /etc/services  # shows all the ports (and their related services) that the linux machine is using

# DHCP
# DHCP, abbreviation of "Dynamic Host Control Protocol", is a network protocol that assigns IP addresses automatically to client systems in the network. This reduces the tedious task of manually 
# assigning IP addresses in a large network that has hundreds of systems. We can define the IP range(Scopes) in the DHCP server, and distribute them across the network. The client systems in the network 
# will automatically get the IP address => https://help.ubuntu.com/community/Internet/ConnectionSharingDHCP3

# to install DHCP server on ubuntu
sudo apt-get install isc-dhcp-server

#==========================================
# Encode and Decode

# encode an image with base64
myImgStr=$(base64 image1.jpg)

# decode the encoded file
base64 -d <<< "$myImgStr" > image2.jpg

#==========================================
# create Service with Systemd

# first create a shell script (it will be our service)
touch pointless.sh 

    #!/bin/bash
    while true
    do
        echo current time is $(date)
        sleep 1
    done

# make it executable
chmod +x pointless.sh

# create a service file in this folder:
cd /etc/systemd/system
# create the service file, it should end with .service extension
sudo vi pointless.service

        [UNIT]
        Description=My Pointless Service # some description about the service
        After=network.target # only run the service when network connection exists

        [Service]
        ExecStart = /home/babak/pointless.sh   # where executable service exists
        Restart=always   # in case of error restart the service 
        # user,group,home address for who runs this service
        WorkingDirectory=/home/babak   
        User=babak
        Group=babak
        Environment=GOPATH=/home/babak/go USERNAME=babak_g  # environment variables, separate them with space

        [Install]
        WantedBy=multi-user.target  # this will allow service to be installed for all users

# first enable the service and then start it
sudo systemctl enable pointless
sudo systemctl start pointless

# check it's status
sudo systemctl status pointless
# can find the service logs here
sudo tail /var/log/syslog

# check the logs for the service
sudo journalctl -u pointless
sudo journalctl -u pointless -f

sudo systemctl stop pointless
sudo systemctl disable pointless  # opposite of enable command

# if you change the service file, you have to do daemon reload
sudo systemctl daemon-reload


# systemd  and  systemd-run => to run a service located at /etc/systemd/system/backup.service we add this file: /etc/systemd/system/backup.timer:
# works similar to cron, but more advanced
sudo vi /etc/systemd/system/backup.timer

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

# you can also run systemd timers via a terminal command, run the test-serv service every two hours
systemd-run --on-active="2hours" --unit="my-test-serv.service"

# run the test-script.sh every three hours
systemd-run --on-active="3hours" /usr/local/bin/test-script.sh

#==========================================
# LINUX OS System

# Linxu folder Structure

    /bin  # essentail user binaries
    /sbin # system binaries
    /etc  # configuration files
    /dev  # device file
    /proc # process information
    /var  # variable files
    /tmp  # temporary files
/
    /user # user programs
    /home # home directories    /home/student   /home/linuxgym
    /boot # static files of bootloader
    /lib # system libraries
    /opt # optional add-on apps
    /mnt # mount directories, mount point for temporary mounted file systems
    /media # removable devices
    /srv # service data

# Linux file types
# ordinary files => these are regular files
# directories (folders) => files that contain other files and directories, provide pointers
# symbolic links => files that link to other files in different locations
# block and character device files => all physical devices on linux are represented by device files, /dev/sda
# socket files => provides protected inter-processing networking
# named pipe files => like socket files but doesnt user network socket semantics

# shows the type of each file in the current directory
ls -l 

# firmware is the software on your hardware which runs it, its the lowest level software running on the hardware. BIOS was the old firmware of the computer hardware
# UEFI the new version of firmware for computers, installed /boot folder in linux

/sys # is the folder with all the operating system related stuff

# /sys contains several important sub-directories:
block  bus  class  dev  devices  firmware  fs  hypervisor  kernel  module  power

# has all the hard drives attached to this machine
block 
# here you can see all the CPUs available to the OS
/sys/bus/cpu/devices 
# contains all devices related folder, all added devices are visible here
/dev 
# this directory contains info related to processes of the machine, the numbers in this folders are the processes being run
/proc 

 # how many usb devices are attached to this machine
lsusb
# what hardware devices (cpu, isa bridge, vga graphics card,..) are attached to this machine
lspci 
# the hdd,sdd and ram that are attached to this device
lsblk
# shows all hardware and firmwares on this machine
lshw 

# when linux machine is booting up, you can see all the logs related to kernel booting up
# shows all the logs related to system booting up, they are located at /var/log/dmesg
dmesg  

# how the GUI in linux works:
# Hardware # Kernel # Display Server # Desktop Manager, (Gnome, KDE,..) # User
                                     # Window Manager, OpenBox, i3,.. (this is smaller in size) # User

# KDE => Arch linux, RedHat 
# Gnome => Ubuntu

# time in linux systems
# each computer itself has an internal clock that works even when it is shut down, that is called the hardware clock
# NTP: Network Time Protocol , there are servers for computer to connect to and get the correct time

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
# ln -s : Creates a symbolic link (soft link). A symbolic link is like a shortcut that points to another file.
sudo ln -s /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

#  stop GUI in ubuntu
sudo service lightdm stop

# How to uninstall programs in ubuntu, via terminal
sudo apt-get remove --purge <PACKAGE_NAME>

# The host name or computer name is usually at system startup in /etc/hostname file, to change the hostname
sudo vi /etc/hostname  # Delete the old name and setup new name
sudo vi /etc/hosts  # Replace any occurrence of the existing computer name with your new one
sudo reboot  # Reboot the system to changes take effect

# systemctl
# systemctl is the main command-line tool to manage systemd, the init system and service manager used in most modern Linux distributions (Ubuntu, Debian, RHEL, CentOS, Fedora).
# It’s used to start, stop, enable, disable, check status, and manage services, as well as control system state like rebooting or shutting down.
systemctl status sshd
sudo systemctl start sshd
sudo systemctl stop sshd
sudo systemctl restart sshd
sudo systemctl enable sshd   # enable the service to start on boot
sudo systemctl disable sshd  # disable the service from starting on boot
sudo systemctl daemon-reload  # reload systemd manager configuration

#==========================================
# LINKS
# link in linux is similar to shortcut on windows OS

# softLink => only points to the original file like shortcut, will not work if the main file is deleted, it changes when you edit the original file
# softLink is much more common than hardLink

# hardLink => is a full copy of the file, still works if you delete the original, it changes when you edit the original file.

ln myfile hard_link # creates a hard link named hard_link
ls -i # you can see both original and hard link point to same inode
# each file and directory is connected to an Inode. 
# when you can't save anything on your machine, even when "df -h" shows you have empty space, you can check to see how much Inode is free, if inodes are full, doesn't matter how much free space you 
# have, it can happen when you have many small cache files.
df -i

unlink hard_link # delete the link 

# creates a soft link, default is hardlink, -s makes it a softlink
ln -s myfile soft_link 
unlink soft_link

# as we can see when we run the command python3, it is a soft link to python3.10
which python3
    /Applications/miniconda3/bin/python3

ls -l /Applications/miniconda3/bin/python3
    lrwxr-xr-x  1 babak  staff  10 Mar 21 16:55 /Applications/miniconda3/bin/python3 -> python3.10

# this variable contains all locations that shell commands are saved at.
echo $PATH
    /Applications/miniconda3/bin:/Applications/miniconda3/condabin:/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/System/Cryptexes/App/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin

# alias, to show and set customized command shortcuts
# alias [name]=[command]
# you can write alias to .bashrc file, so it will be not removed after restarting the terminal
alias k8s=kubectl get pods -n dev
alias meow=cat

# unalias, to remove an already existing alias
unalias meow

# On a Unix-like system, running type -a uptime will show all locations where the uptime command is found, including aliases, functions, or executables in the PATH.
type -a uptime

#==========================================
# BashRC

# .bash_profile and .bashrc
# this allows us to customize our terminal based on our liking
cd ~
ls -la  # should show both .bash_profile and .bashrc

# .bash_profile => login shell
# .bashrc => non-login shell, only works for subshell (when you run bash commands)

# to restart terminal after changing the .bashrc file
source .bashrc

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

#==========================================

# what is the difference between "sudo apt update" and "sudo apt-get update"?

# The commands 'sudo apt update' and 'sudo apt-get update' are both used to update the package index on Debian-based systems like Ubuntu. However, there are some differences between apt and apt-get :
# 1. Command Line Interface: 'apt' is a newer command-line interface that was introduced to provide a more user-friendly experience. It combines functionalities from apt-get and apt-cache and provides a more consistent and concise set of commands.
# apt-get is the older, more established command-line tool for managing packages.
# 2. Output and User Experience: apt provides a more polished output with progress bars and colored text, making it easier to read and understand, apt-get provides more verbose output, which can be useful for scripting and debugging.
# 3. Functionality: Both 'apt update' and 'apt-get update' perform the same function: they update the local package index with the latest information about available packages from the repositories. This is necessary before installing or upgrading packages to ensure you have the latest package information.
# apt includes some additional features and commands that are not available in apt-get, such as apt list, apt show, and apt edit-sources.
# 4. Intended Use: apt is intended for interactive use by end-users who want a simpler and more intuitive interface, apt-get is more suitable for scripts and automation, where consistent behavior and output are important.

#==========================================

# I have a docker container that does not contain vim or nano for editing files. how can I create a shell file inside it and add a small 3 line script to that file? after executing that file I will need to edit it and add another 2 lines to the end of the file

# If your Docker container doesn't have vim or nano for editing files, you can still create and edit files using basic shell commands like echo, cat, and printf. Here's how you can create a shell script, add content to it, and then modify it:
# Create a Shell Script and Add Initial Content:
# You can use cat with a here-document to create a file and add multiple lines to it. For example, to create a file named script.sh with 3 lines:
cat << 'EOF' > my-script.sh
#!/bin/bash
echo "Line 1"
echo "Line 2"
echo "Line 3"
EOF

chmod +x script.sh

echo 'echo "Line 4"' >> script.sh
echo 'echo "Line 5"' >> script.sh

#==========================================

# You can use" operating system tools" to run scripts in the background:
# Cron Jobs: Schedule scripts to run at specific intervals.
# Systemd Services: Create a service that runs your script as a background process.
# nohup: Run a command that continues executing after you log out.
nohup psql -d mydb -c "SELECT * FROM my_table" > output.log &

#==========================================
# Sleep

sleep
# If you want to introduce a delay after executing a script in a piped command, you can use the "sleep" command to pause the execution for a specified amount of time. However, when dealing with piped commands, you need to ensure that the delay is applied correctly in the sequence of commands.
# Here's how you can achieve a 3-minute delay after executing a script in a piped command:
# Using a Subshell: You can use a subshell to execute the script and then introduce a delay before continuing with the next command in the pipeline.
# In this example, the script is executed, and then sleep 180 introduces a 3-minute delay (180 seconds) before the output is piped to grep.
(kubectl exec v-tools-1 -n v-operators-1 -- ./scripts/posting_failures.sh; sleep 180) | grep '"id":'

# Using a Temporary File: Another approach is to redirect the output to a temporary file, introduce a delay, and then process the file.
# This method captures the output in a file, waits for 3 minutes, processes the file with grep, and then removes the temporary file.
kubectl exec v-tools-1 -n v-operators-1 -- ./scripts/posting_failures.sh > temp_output.txt
sleep 180
grep '"id":' temp_output.txt

# To add a sleep command to wait 300 seconds between each curl request without changing anything else in your script, you can simply insert the sleep command right after the curl command within the xargs loop. Here's how you can do it:
cat $EXPORTED_FAILURES | jq -sr ".[] ${FAILURE_CONDITION} | .account_id" | uniq | xargs -I '{}' -n1 \
 bash -c 'curl -k "${REPOSTING_URL}:republish" -X POST -H "X-Auth-Token: ${REPOSTING_TOKEN}" \
 "Content-Type: Application/Json" \--data-binary "{\"account_id\": \"{}\",\"republish_type\": \"REPUBLISH_TYPE_REPUBLISH_FAILURES\"}"; \
 sleep 300'
# I've wrapped the curl command and the sleep command in a bash -c block. This allows both commands to be executed as part of the same xargs iteration. The sleep 300 command will pause execution for 300 seconds after each curl request.

# another way
# Extract account IDs into an array
account_ids=$(cat "$EXPORTED_FAILURES" | jq -sr ".[] ${FAILURE_CONDITION} | .account_id" | uniq)
# Iterate over each account ID
for account_id in $account_ids; do
  # Execute the curl command for each account ID
  curl -k "${REPOSTING_URL}:republish" -X POST -H "X-Auth-Token: ${REPOSTING_TOKEN}" -H "Content-Type: Application/Json" --data-binary "{\"account_id\": \"${account_id}\",\"republish_type\": \"REPUBLISH_TYPE_REPUBLISH_FAILURES\"}"
  # Sleep for 300 seconds between requests
  sleep 300
done

#==========================================
# ** KeyStore ** 

# A keystore is a secure storage mechanism used to hold cryptographic keys and certificates. In Java and many security-related applications, a keystore is used to manage keys and certificates for authentication, encryption, and secure communication.

# Types of Keystores
# Java supports different types of keystores, including:

# JKS (Java KeyStore) – The traditional keystore format used by Java applications.
# PKCS12 (Public-Key Cryptography Standards #12) – A more widely accepted format that can store both private and public keys.
# BKS (Bouncy Castle Keystore) – Used for Android applications.
# What a Keystore Contains
# A keystore can store:

# Private keys – Used in encryption and authentication.
# Public key certificates – Issued by Certificate Authorities (CAs) to verify identities.
# Secret keys – Used for symmetric encryption.

# Common Uses of a Keystore
# SSL/TLS Configuration – Java applications use keystores to store SSL/TLS certificates for secure communication.
# Code Signing – Used to sign JAR files and APKs (for Android apps).
# Authentication – Securely storing API keys and authentication credentials.
# Keystore Management Using keytool
# Java provides the keytool utility to create, manage, and manipulate keystores.

# Create a new keystore:
keytool -genkeypair -alias mykey -keyalg RSA -keystore mykeystore.jks -storepass changeit
# List the contents of a keystore:
keytool -list -keystore mykeystore.jks -storepass changeit
# Import a certificate into a keystore
keytool -importcert -file mycert.crt -keystore mykeystore.jks -alias mycert -storepass changeit



# 127.0.0.1:xxxx is the normal loopback address, and localhost:xxxx is the hostname for 127.0.0.1:xxxx
# localhost is a special virtual network interface, just like your ethernet or wifi each have a special interface.
# 0.0.0.0 is slightly different, it's an address used to refer to all IP addresses on the same machine. Or no specific IP address.

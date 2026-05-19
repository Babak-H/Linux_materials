# write this at the top of your script to specify the interpreter that should be used to run the script, in this case bash
#!/bin/bash

# how to run an script

# execute your script in the current shell using .(dot) notion
. hello.sh

# execute your script in a sub-shell with the sh command
sh hello.sh

# assign execute permission to your script file, ensure it is stored in a directory within $PATH and has #!/bin/sh at top:
hello.sh

# create a bin directory in your home ($HOME/bin is included in $PATH by default)
mkdir $HOME/bin
# then reset the shell to make sure it is changed
exec $SHELL
# create hardlink between script and $HOME/bin
ln myscript.sh ~/bin/myscript
# give it execution access
chmod u+x ~/bin/myscript
# run the script from anywhere
myscript

# execute the script in trace mode
sh -x myscript

#===============================================================
# working with Files and String

# echo , prints arguments to the terminal
# can also use it to append text to files
echo "my name is babak"

# command substitution $()
echo "your username is $(whoami)"
echo "$(tput setaf 166)this is orange"

# echo has -e option which enables interpretation of backslash escapes
echo -e "\tThis is indented\n"
echo -e "the current directory is\n \t $(pwd)"

echo "As of $(date), the number of Tasks remaining is $(ls -d tasks/cl/{6..8} | wc -w)" > tasks/cl/5/checklist

echo "As of $(date), the number of Tasks completed is $(find tasks/cl/ -mindepth 1 -type d ! -empty | wc -l), there are $(grep -E "^[0-9]{4}\-[0-9]{2}\-[0-9]{2}" tasks/cl/6/changelog.csv | wc -l) entries in the change log, and the number of Tasks remaining is $(find tasks/cl/ -mindepth 1 -type d -empty | wc -l)" >> tasks/cl/7/babak.details

var=FDM
echo $var # FDM
echo "$var" # FDM
echo '$var' # FDM
echo \$var # $var

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
# add two files to the third file
cat filename1.txt filename2.txt > filename3.txt

# less , similar to cat but allows you to go through file by pages, more human readable
less file1.txt
# show only lines that have word "Logarithm", page by page
cat my-thesis.txt | grep Logarithm | less

# cp , copy files and directories
cp filename1.txt /home/username/Documents
cp /usr/share/folder-x/domains.csv .  # copy the file to the current folder
# copy directories recursively, (dir and all its content will be copied)
cp -r dir newdir

# copying a file also copies its permissions to the new file
chmod 755 my-file.txt
# new.txt also has the 755 permissions
cp my-file.txt new.txt
# copy all files from /student_files that end with .date
cp /student_files/*.date ~

# mv , move files or directories
mv old_filename.txt new_filename.txt

# mkdir , create a directory
mkdir music/songs
# creates both the parent and the child directories if they don't exist
mkdir music/2020/songs

# -p flags makes sure all the parent folders are created in case they don't exist
# nested directories
mkdir -p folder/subfolder/subsubfolder
# -v (verbose) option displays when directories are created
mkdir -pv dir_a/dir_b/dir_c

# both create multiple folders at once
mkdir -p tasks/cl/{1,2,3,4,5,6}
mkdir -p tasks/cl/{1..6}

ls tasks/cl/{2..8}
ls tasks/cl/*

# -d option makes sure that only the directories are listed, not their content
ls -d tasks/cl/*

# create several duirectories at once
mkdir dir_1 dir_2 dir_3

# when creating a directory in unix use "$variable" instead of $variable in case the variable contains spaces, otherwise it will be treated as multiple arguments and mkdir will try to create multiple directories instead of one
mkdir -p "$deployDir"

# rmdir  delete empty directory
rmdir -p mydir/personal1
# remove a nested directory (empty or not)
rmdir -r dir/subdir/subdir2

# rm delete files
rm file1 file2

rm -r myfolder  # reccurently delete a folder and its content

# after removing a file or directory, it is still there for a period of time, use shred command to overwrite a file to destory its content
shred filename
# to shred a file and remove it, use -u option
shred -u filename

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

# get first two characters of the string
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

# -y option will show side by side comparison
diff -y file_test1 file_test2
# -W  put 50 spaces between two columns
diff -y -W 50 file_test1 file_test2

# cmp (compare) will note when two files differ from each other
cmp users1 users2

# apt-get
sudo apt-get update
sudo apt-get upgrade

# nano and vim are both file editors, but Vim us more common and powerful
nano text.txt
vi text.txt

# wc , Word Count , counts the number of lines, words, and bytes in a file
wc file.txt  # 34  34  348  lslog.log

# -l flag counts lines instead of words
wc -l /etc/passwd
# displays the count of words (divided by spaces)
wc -w /etc/passwd 
# displays the count in bytes / characters
wc -c /etc/passwd

# Globbing => refers to file and directory pattern expansion using wildcard characters
# *       match zero or more of any characters
# ?       match one character
# []      match anything in the [] for one position
# [abc]   match a OR b OR c for one character position
# [a-c]   match one character in a-c range
# [a-z]   match any character in alphabet
# [!abc]  match any character that is NOT a,b or c for 1 character position
# [0-9]   match any number for one position
# [!0-9]  !=negate, match anything except 0 to 9 (no numericals)

ls .*rc
wc /etc/pa*
# tty0 tty1 ...
ls /dev/tty[0-9]
# ttyS0, ttyUSB1
ls /dev/tty?[0-9]

# [:alnum:]  all letters or numbers
# [:alpha:]  all letters
# [:digit:]   all numbers
# [:lower:]   all lowercase letters
# [:upper:]   all uppercase letters
# [:punct:]   all punctuation marks

ls /dev/*[[:digit:]]
ls /student_files/*[[:punct:]]*

# matches broker_exchange.dat, brokers.dat, companies.dat, currency.dat
wc -l [cb]*.date

# > >> < ~ # |   are metacharacters and have special meaning in shell

# qutation removes special significance by converting metacharacter to literal character
''
""
\

# Brace Expantion
# create characters sequentially instead of typing all of them

# 1 to 9
{1..9}
# 1 to 100 with step of 5
{1..100..5}
{x..z}

# get all the lines in /etc/passwd that contain the word "bash" , then count the lines
grep bash /etc/passwd | wc -l

# tr , TRanslate
# since tr doesn't support reading a file directly,we need to pipe the file content to the command or use input redirection
# replace all the "W" in the file with "j"
cat my-thesis.txt | tr W j
# replace all lowerCase characters to upperCase 
cat my-thesis.txt | tr "[:lower:]" "[:upper:]"
# same as above
tr '[a-z]' '[A-Z]' < my-thesis.txt
# turn all numerics to *
tr '[:digit:]' '*' < /student_files/accounts

echo $PATH | tr ':' '\n' | grep '/home/babak.habibnejad' | grep 'bin' >> tasks/cl/8/babak.habibnejad.doc

# tr -d option deletes the specified characters
# removes string 'PIN' from each line
cut -d ":" -f 1 /student_files/accounts | tr -d "PIN"

# tr -s removed repeated instances of a character
# 6666 => 6
# "      " => " "
who | tr -s " " | cut -d " " -f 1,6

# AWK, scans each input file for lines (this commands goes through a file line-by-line) that match any of the set patterns
# print matched lines
# Search through the file "test.log" and print every line that contains the text "byego"
# {print} Action to take when the pattern matches — here: print the line
# AWK. PATTERN {ACTION} FILE
awk '/byego/ {print}' test.log

# Print only the first column (field) in each line of the file
awk '{print $1}' file.txt

# print first and third columns of the file, separated by a space
awk '{print $1,$3}' test.log

a="Hi all"
echo "$a" | awk '{print tolower($0)}'  # hi all, Prints the result, Converts the whole input line ($0) to lowercase

# print lines with more than 10 characters
awk 'length($0)>10' test.log

var="apple orange"
echo $var    # apple orange
echo $var | awk '{print $1}'   # apple
echo $var | awk '{print $2}'   # orange

# -F option allows you to specify a different field separator (delimiter) instead of the default space. For example, if you have a CSV file where 
# fields are separated by commas, you can use -F',' to tell awk to treat commas as field separators. Then, $1 will refer to the first field (the text before the first comma), 
# $2 will refer to the second field (the text between the first and second commas), and so on.
awk -F',' '{ print $1 }' file.csv

# This tells awk that the field separator (delimiter) for each line is a colon :
# /etc/passwd  =>  username:x:UID:GID:comment:home_dir:shell
# '{print "UID: "$3 ";LOGIN: "$1}'  => $1 → first field (the username / login name)    $3 → third field (the user ID number (UID))
# result format: UID: <value_of_$3> ;LOGIN: <value_of_$1>    =>  root:x:0:0:root:/root:/bin/bash => UID: 0 ;LOGIN: root
awk -F ':' '{print "UID: "$3 ";LOGIN: "$1}' /etc/passwd

# print the seventh column of this file
awk '{print $7}' access_log

# cut, cuts out selected portions of each line from each file and writes them to the standard output

# divide the lines via "," and only show columns 2 and 3
cut -d ',' -f2,3 domains.csv
# cut first 3 bytes from each line of the file
cut -b 1,2,3 file.log
# select second column delimited by a space
cut -d " " -f2 test.log
# cut characters from position 1 to 8 from each line of the file
cut -c 1-8 test.log

echo 'one\two\three' | cut -d '\' -f 3   # three

var="apple orange"
# divide by space, then get column 2
echo $var | cut -d' ' -f2  # orange

cut -d ':' -f 1,3 --output-delimiter=',' /etc/passwd
#  1           3
# usertest:x:1000:1000:usertest:/home/usertest:/bin/bash  =>  usertest:1000

who | cut -d " " -f 1 | sort | uniq -u

# SED, sed reads the specific files, modifying the input as specified by a list of commands
# sed = Stream EDitor
# sed is similar to tr , but tr can only work on characters one to one, while sed doesnt have this limit

# sed 's/search-pattern/replacement-string/<FLAG>' <FILE>

# substitute a string, change "bytego" to "go"
# the /g at the end means "replace all occurrences on each line" (global)
sed 's/bytego/go/g' test.log   
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

sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# -n tells sed do not print anything by default
# /.../   is regex
# ^uid=   line that starts with uid=
# ,       is range
# $       means the last line of the file
# p       means print the lines in this range
# From the first line that starts with uid=, all the way to the end of the file, print everything
sed -n '/^uid=/,$p' tasks/cl/7/babak.details >> tasks/cl/8/babak.habibnejad.doc


# SORT, sorts text and binary files by line, based on first character of each line, then second character if the first characters are the same, and so on
# output to a file
sort -o output.txt input.txt
# sort in reverse order
sort -r test.log
# sort numerically
sort -n test.log
# sort based on the third column
# -k option is used to specify the key (column) to sort by. In this case, -k -3 means to sort based on the third column from the end of the line. The -n option is used to sort numerically, so it will sort the values in that column as numbers rather than as strings.
sort -k -3n test.log
# sort and remove duplicates
sort -u test.log

sort /etc/passwd | less
sort -r /etc/passwd | less

# if the file cotent is delimited, you can specify a delimiting character with the -t option and then sort by a specific column with the -k option
sort -t ":" -k 2 /student_files/day2/accounts

cut -d ':' -f 3 /etc/passwd | sort -n

# UNIQ, reads the specified input file comparing adjecent lines and writes a copy of each unique input line to the output file

# tell how many times a line is repeated
uniq -c test.log
# print repeated lines
uniq -d test.log
# count of duplicate lines
uniq -dc test.log
# print unique lines
uniq -u test.log
# compare case-insensitive
uniq -i test.log

# sort piped to uniq
# the uniq command expects Adjacent Comparison Lines, so it is often combined with the sort command
sort /student_files/uniq_file | uniq

sort /student_files/uniq_file | uniq -d


# show the contents of the /var/log/messages
# in each line select the fifth column separated by space
# then sort results by alphabetical order
# only show unique results
sudo cat /var/log/messages | awk '{print $5}' | sort | uniq

# man, MANual , provides a user manual of any commands or utilities you can run in Terminal
man ls
man history
# another way is using whatis
whatis ls
whatis grep

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

# XARGS 
# xargs (short for extended arguments) is used for building and executing commands from standard input

cat /student_files/pincodes
# PIN53 
# PIN75 
# PIN21

xargs < /student_files/pincodes   
# PIN53 PIN75 PIN21

# -I  : argument placeholder
xargs -I % mkdir % < /student_files/pincodes 
# same as
mkdir PIN53
mkdir PIN75
mkdir PIN21

# xargs with shell trick, for more advanced commands
# get all .dat files, then run head -2 and tail -1 to get second line of each file
ls /student_files/*.dat | xargs -I % sh -c 'head -2 % | tail -1'


# -n1 tells xargs to pass one argument at a time to the command
echo "a b c" | xargs echo
# → echo a b c   (all at once)
# output: a b c

echo "a b c" | xargs -n1 echo
# → echo a, echo b, echo c   (separate calls)
# output:
# a
# b
# c


# uses jq, a command-line JSON processor, to extract and process data from a JSON file
# processes the JSON data using jq , Here's what each part does:
# -s: This option tells jq to read the entire input as a single JSON array. This is useful when the input consists of multiple JSON objects, one per line
# -r: This option tells jq to output raw strings instead of JSON-encoded strings , This is useful when you want to use the output in shell scripts
# .[]: This part iterates over each element in the JSON array
# | .account_id: This part extracts the account_id field from each element that matches the FAILURE_CONDITION
# uniq: This command removes duplicate lines from the output. It assumes that the account_id values are sorted, or it will only remove consecutive duplicates

jq -sr ".[] ${FAILURE_CONDITION} | .account_id"


# {"name":"Babak","age":30,"skills":["bash","python","aws"]}

cat data.json | jq '.name'  # "Babak"
cat data.json | jq '.skills[1]' # "python"

# d.json content:
# {
#     "user": {
#         "name": "Kevan",
#         "age": 28,
#         "dog": "Mika"
#     },
#     "apiVersion": "v2",
#     "apiName": "users"
# }

jq '.apiName' d.json  # "users"

jq '.user.name' d.json  # "Kevan"


cat min.json | jq '.'  # pretty print the JSON content

cat min.json | jq '.[]'  # get all values in the JSON object (array iteration)

cat min.json | jq '.[0]'  # get the first element in the JSON array

cat min.json | jq '.[2:4]'  # get elements from index 2 to 4 in the JSON array

cat min.json | jq '.[-2:]'  # get the last two elements in the JSON array

cat min.json | jq '.[5].title, .[5].id'  # get title and id of the 6th element in the JSON array

cat min.json | jq '.[] | .title, .id'  # get title and id of all elements in the JSON array

cat min.json | jq '.[] | .subject = "Math"'  # modify subject field of all elements in the JSON array to "Math"

cat min.json | jq '.[] | {todo: .title, status: .completed}'  # create new objects with only title and completed fields from all elements in the JSON array 

cat min.json | jq '.[] | keys'  # get keys of all objects in the JSON array

cat min.json | jq '.[] | length'  # get length of all objects in the JSON array

cat min.json | jq '. | map(.title="override title")'  # modify title field of all elements in the JSON array to "override title"

cat min.json | jq '. | select(.age >= 30)' # Selects objects with age greater than or equal to 30

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
# jq → A command-line JSON processor
# -r → Outputs raw strings (removes quotes around the extracted value)
# .auth.client_token → Extracts the client_token from Vault’s JSON response


# What's the difference between <<, <<< and < < in bash?
# << is known as "here-document structure". You let the program know what will be the ending text, and whenever that delimiter is seen, the program will read all the stuff you've given to the 
# program as input and perform a task upon it.
wc << EOF
one two three
four five
EOF

# In this example we tell wc program to wait for EOF string, then type in five words, and then type in EOF to signal that we're done giving input

# <<< is known as "here-string". Instead of typing in text, you give a pre-made string of text to a program. For example, with such program as "bc" we can do bc <<< 5*4 to just get output for 
# that specific case, no need to run bc interactively. Think of it as the equivalent of echo '5*4' | bc
ls -l /proc/self/fd/ <<< "TEST"

# < "Process substitution" feeds the output of a process (or processes) into the stdin of another process.So in effect this is similar to piping stdout of one command to the other , 
# e.g. echo foobar barfoo | wc
echo <$(echo bar)

#===============================================================
# Searching

# locate , look for a file in folder structure
# locate searches a pre-built database of file locations, so it is much faster than find, but it may not reflect the most current state of the filesystem 
# if the database has not been updated recently
locate file.txt

locate -i school*notes

my*.csv | less

locate csv | grep domain 

# finds all the files that have "userdel" in their name and have "bin" in their path
locate userdel | grep bin
# /usr/bin/userdel
 
# before running locate, run this commnad, makes index of all files on your computer
sudo updatedb

# find is similar to locate, but it searches in real-time, while locate uses a pre-built database
# find [path] [option] [Expression] and search to find a file
find /home -name notes.txt
find . -type d -name dir_name

# 2>/dev/null  => this part is to hide permission denied errors (throws away all the error messages)
find / -name userdata.csv 2>/dev/null

# Delete matching files in all subdirectories
# Remove all *.swp files underneath the current directory, use the find command in one of the following forms:
find . -name '*.swp' -type f -delete # The -delete option means find will directly delete the matching files. This is the best match
# delete option can be used on find too, [^\.] => Match any single character that is NOT a dot (.) , * => Match zero or more of the preceding pattern , ends with string 'file'
find ~ -name '[^\.]*file' -delete

# find all regular files in /var with size bigger than 100kb
find /var -size +100k -type f -print

# find all files in the current directory that have been accessed within the last day
find . -atime -1 -print
# all filed edited in last day seconds in current dir
find . -mtime -1 -print

# finds and force-deletes .gz files older than 30 days under /var/logs/
find /var/logs/ -name "*.gz" -mtime +30 | xargs rm -rf

# \ can be used to prevent wildcard characters being interpreted by the shell, instead find will read them
# find all files in home directory ending in *.txt
find ~ -name \*.txt -print
# same thing
find ~ -name '*.txt' -print

# by default find will search recursively through all subdirectories, maxdepth limits how deep we can go
find dir1 -maxdepth 1 -name "file*"
# dir1/file0

find dir1 -maxdepth 2 -name "file*"
# dir1/file0
# dir1/sub1/file1

# find /path -mindepth N [other options]  , Skip the starting directory itself:
find . -mindepth 1 -name '*.txt'

# all files of any type with name containing letters 're'
find /student_files/ -name '*re*' -print 2> /dev/null
# all files of any type with name NOT containing letters 're'
find /student_files/ -not -name '*re*' -print
# all regular files in /var with a size greater than 10 megabytes
find /var/ -type f -size +10M -print

# we can also used regex with find with -regex option
# find all regular files in /etc with name ending in x,y or z: .x or .454x or .aBEcx
find /etc/ -type f -regex '.*[xyz]$' -print

# to execute command on all matching files use -exec option , apply byte count (wc -c) on all matches
find /student_files/ -type f -size -100c -exec wc -c {} \;
# -ok option performs actions interactively (asks user before applying)
find /student_files/ -type f -size -100c -ok wc -c {} \;
# this is same as -delete
find ~ -empty -type f -exec rm {} \;
# same as above, but asks to delete files one by one
find ~ -type f -empty -ok rm {} \;

# find all files (of type file) that have "changelog" or "checklist" in their name and move them to tasks/cl/6/ directory
find tasks/ -type f -iregex ".*\(changelog\|checklist\).*" -exec mv {} tasks/cl/6/ \;

find tasks/cl/ -mindepth 1 -type d -empty | wc -l

find tasks/cl/ -type f -name history  ! -path "tasks/cl/history" | sort | xargs -I % cat % >> tasks/cl/history

# grep, Global Regular Expression Print, searches any given input file, returning lines that match one or more patterns
# grep [-options] [search string] [filename]

grep blue notepad.txt   
grep Lord my-text.txt > jesus.log 
grep hall /students_files/day1/grepFile

# -i : case insensitive
grep -i hall /students_files/day1/grepFile
# find file names that match,  -l => List filenames only (don't show the matching lines themselves)
grep -l "bytego" *.log
# case insensitive word match in a file
grep -wi "bytego" test.log
# show line numbers
grep -n "bytego" test.log
# show file lines that do NOT match (don't contain the keyword)
grep -v "bytego" test.log
grep -v "Unknown" tasks/cl/2/mysysinfo | tee tasks/cl/6/babak.info
# search recursively in all files in a directory
grep -r "bytego" /home
# search for string hall and include the line numbers where it has been found
grep -n hall /student_files/day1/grepFile
# shows the count of how many time hall was found
grep -c hall /student_files/day1/grepFile

# grep can also work with regular expressions (regex)
# basic : used with grep
# Extended : used with grep -E or egrep

# Regular Expressions
# ^       match at start of the line
# $       match at end of the line
# []      match anything in the [] for 1 character position
# .       match a single character
# [^ ]    match a single character with any character NOT mentioned inside []
# *       match zero or more occurances of the preceding character
# .*      match with any number of characters
# \       Escape the following metacharacter and treat it as literal

# match all lines starting with a number
grep '^[0-9]' /student_files/day1/grepTest
# same thing
grep '^[[:digit:]]' /student_files/day1/grepTest
# match all lines that do Not start with a number
grep '^[^0-9]' /student_files/day1/grepTest

# match all lines containing 2 followed by Any character
grep '2.' /student_files/day1/grepTest
# match all lines that contain 2 followed by a dot (escaped with \)
grep '2\.' /student_files/day1/grepTest

# match all lines containing 19, followed by zero or more '2',followed by zero
# 1920 , 192220, 190
grep '192*0' /student_files/day1/grepTest
# match all lines containing 192, followed by zero or more of Any character, followed by 0
# 192A0 , 1920, 192880
grep '192.*0' /student_files/day1/grepTest
# match all lines starting with a number and ending with a number
grep '^[0-9].*[0-9]$' /student_files/day1/grepTest
# match all lines containing hill, hell or hull
grep 'h[ieu]ll' /student_files/day1/grepTest



# Extended Regex
# +       match one or more occurences of the preceding character
# ?       match zero or one occurences of the preceding character
# (a|b)   match a or b
# (ar|br) match ar or br
# {n}     match the preceding character n times
# {m,n}   match the preceding character at least m times but not more than n times

# match l one times or more
grep -E 'l+' /student_files/day1/grepTest
match digit '2' once or more
grep -E '2+' /student_files/day1/grepTest
# match digit 6. followed by zero or one occurence of 5
grep -E '65?' /student_files/day1/grepTest
# match anyline containing ho or hu
grep -E 'h(o|u)' /student_files/day1/grepTest
# match lines containing ha or ta
grep -E '(ha|ta)' /student_files/day1/grepTest
# match lines containing ll
grep -E 'l{2}' /student_files/day1/grepTest
# match lines containing ll or lll
grep -E 'l{2,3}' /student_files/day1/grepTest
# grep -F treats all characters as literal values
grep -F . /student_files/day1/grepTest

grep -E "RAM|HDD" tasks/cl/2/sysinfo | tee -a tasks/cl/6/babak.habibnejad.info

grep -E '^[0-9]{4}\-[0-9]{2}\-[0-9]{2}' tasks/cl/6/changelog.csv

grep -E '^As' tasks/cl/6/checklist >> tasks/cl/7/babak.details

# / => root directory, it goes through the whole system and finds all links
find / -type l 

export PATH=$PATH:/usr/new/dir # add a new directory to the PATH variable

which ping # this command shows where the command "ping" is saved at : /sbin/ping

find /etc -iname "*vmware*" # find all files and directories that contain "vmware" in their name, -iname is case insensitive

locate aws  # find files that contain "aws" in their name, its faster than find, but is based on databse that is updated once per day

# which, shows the path of an executable program (command)
which cat
which htop

which ls cp | xargs -d '\n' echo >> tasks/cl/7/babak.details

type cd ls cp | xargs -d '\n' echo >> tasks/cl/7/babak.details

# find a file named 'elasticsearch.yml' in the whole machine (start from root /)
find / -type f -iname elasticsearch.yml
find / -type f -iname Prometheus.yaml

# divide the contents of access_log by "  then select the second field
cat access_log | cut -d '"' -f 2

# ----------------------------------------------------

# show all the files in the current directory and all subdirectories
ls -R
# find all .txt files in the current directory and all subdirectories, then concatenate their contents, search for lines containing "ERROR", sort the results based on the fourth column, and append unique lines (ignoring the first three columns) to errors.log
find . -type f -name "*.txt" | xargs cat | grep "ERROR" | sort -k4 | uniq -f3 >> errors.log

# create a backup folder called backup in the home directory
mkdir /Users/babak/backup
# find all .txt files in the current directory and all subdirectories, then copy them to the backup folder, preserving the directory structure
find . -type f -name "*.txt" -exec cp {} /Users/babak/backup \;

# same as above but with rsybc, which is good for backup processes, it only copies the files that have been modified since the last backup, and it can also preserve file permissions and timestamps
# the -R option in rsync preserves the directory structure of the source files when copying them to the destination
find . -type f -name "*.txt" -exec rsync -R {} /Users/babak/backup \;

# ----------------------------------------------------

# show all files in the current directory with their permissions
ls -la

# read the error.log file, find all mentions of the "Database" keyword and forward the lines containing that to the file database_errors.txt
cat error.log | grep Database >> database_errors.txt

# now check that file and calculate how many lines contain the phrase "connection refused"
cat database_errors.txt | grep "connection refused" | wc -l

# find in the whole machine (starting from root /) all files that have ".conf" in theur name and then filter on the results that contain "db" in the name
find / -name "*.conf*" | grep db 

# we found the file
# now check the contents of db.conf and db.conf.backup and see if there are any differences
diff db.conf db.conf.backup

# after fixing the issue in the config file test the database connection
# check if the database is running by sending a request to the port it's running on (5432 for postgres)
curl -I http://localhost:5432

# now edit the config file and only allow owner to read and write it, so that no one else can read the database credentials
chmod 644 db.conf

#========================================================
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

#=============================================
# Encode and Decode

# encode an image with base64
myImgStr=$(base64 image1.jpg)

# decode the encoded file
base64 -d <<< "$myImgStr" > image2.jpg

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

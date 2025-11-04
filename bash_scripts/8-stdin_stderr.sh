#!/bin/bash

FILE="/tmp/data"

# redirect standard output to a file
head -n1 /etc/passwd > ${FILE}

id -un > /tmp/id


# throw what is inside the file into the variable $LINE
read LINE < ${FILE}
echo "LINE variable contains: ${LINE}"

# same as above
read LINE 0< ${FILE}

echo "this is a secret" > PASSWORD_FILE
cat PASSWORD_FILE
# throw contents of a file into the function passwd
sudo passwd --stdin BABAK_USER < PASSWORD_FILE

# >  empties the file/variable and the puts the data inside it
# >> appends the data to whatever exists inside the file/variable
head -n 3 /etc/passwd >> ${FILE}
# will NOT delete the current contents of the file
date | sha256sum | head -c 10 >> ${FILE}

# here we only redirect standard output, standard error goes to the terminal
head -n 1 /etc/passwd /fake/file > head.out
# here we only redirect standard error, standard output goes to the terminal
# 2> means redirect file descriptor 2 (standard error)
# 1> means redirect file descriptor 1 (standard output)
# 0 is standard input
head -n 1/etc/passwd /fake/file 2> head.err
# mix of both standard output and standard error redirection
head -n 1 /etc/passwd /fake/file > head.out 2> head.err

# this way we append not overwrite
# put the standard output to head.out and standard error to head.err
head -n 1 /etc/passwd /fake/file >> head.out 2>> head.err

# add both srtandard output and standard error to the same file
# 2>&1 means redirect standard error (2) to wherever standard output (1) is going
head -n 1 /etc/passwd /fake/file > head.both 2>&1
# another way of doing the same
# can also use &>> for appending instead of rewrite
head -n 1 /etc/passwd /fake/file &> head.both

# >&2  and 1>&2  redirect to standard error
echo "This is an error message" >&2

# this will only recieve the first 5 lines of the standard output
head -n 1 /etc/passwd /fake/file | cat -n 5
# this will only recieve the both output and error in the cat command
head -n 1 /etc/passwd /fake/file 2>&1 | cat -n 10
# same as above
head -n 1 /etc/passwd /fake/file |& cat -n 10

# disregard standard output
head -n 1 /etc/passwd > /dev/null
# disregard standard error
head -n 1 /etc/passwd 2> /dev/null
# disregard both standard output and standard error
head -n 1 /etc/passwd &> /dev/null

# clean up 
rm ${FILE} /tmp/id PASSWORD_FILE head.out head.err head.both &> /dev/null

exit 0

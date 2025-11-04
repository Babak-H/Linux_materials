#!/bin/bash

# run it as root user

# In read, the -p flag means "prompt", It lets you display a message before waiting for user input.
read -p 'Enter the username to create: ' USERNAME

read -p 'Enter the name of the account owner: ' COMMENT

read -p 'Enter password for this account: ' PASSWORD

# -c : adding a comment
# -m : forcing linux to create a home directory for this user
useradd -c "${COMMENT}" -m ${USERNAME}

# --stdin : what comes from standard input (here the echo command)
echo ${PASSWORD} | passwd --stdin ${USERNAME}

# force user to change password on first login
# -e : expire
passwd -e ${USERNAME}

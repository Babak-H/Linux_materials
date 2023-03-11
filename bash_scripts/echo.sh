!/bin/sh

a=babak
b="Habibnejad"
c=125

echo $a
echo $b
echo $c

declare -i d=123      # d is an integer
declare -r e=1000     # e is an read-only and can not be modified


echo $MACHTYPE      # shows type of the system
echo $HOSTNAME      # shows the host name
echo $BASH_VERSION  # shows current version of bash software
echo $0             # shows name of the running script

# Command substitution : save commands inside a variable
d=$(pwd)
echo $d

s=$(ls -l)
echo $s

# this command is for getting ping from a website :
a=$(ping -c 1 google.com | grep 'bytes from' | cut -d = -f 4)
echo $a
# Linux Permissions, Ownership, and Users Tutorial

## Read File Permissions with `ls -l`

Use `ls -l` to view file and directory permissions:

```bash
ls -l
```

Example output:

```text
drwxrwxr-x 2 babak babak 4096 May 15 12:53 dir
```

Each part has a meaning:

| Part | Meaning |
| --- | --- |
| `d` | File type. `d` means directory, `-` means regular file |
| `rwx` | Owner permissions |
| `rwx` | Group permissions |
| `r-x` | Others permissions |
| `2` | Number of hard links |
| `babak` | Owner username |
| `babak` | Group name |
| `4096` | Size in bytes |
| `May 15 12:53` | Last modified date |
| `dir` | File or directory name |

Another example:

```text
-rw-rw-r-- 1 Alex dev-group 4 July 12 19:21 information.txt
```

This means:

| Part | Meaning |
| --- | --- |
| `-` | Regular file |
| `rw-` | Owner `Alex` can read and write |
| `rw-` | Group `dev-group` can read and write |
| `r--` | Everyone else can only read |
| `1` | Number of hard links |
| `4` | Size in bytes |
| `July 12 19:21` | Last modified date |

## Permission Values

Linux permissions use three basic access types:

| Permission | Letter | Number |
| --- | --- | --- |
| Read | `r` | `4` |
| Write | `w` | `2` |
| Execute | `x` | `1` |

Numeric permissions are created by adding these values together.

For example, `755` means:

| Value | Calculation | Meaning |
| --- | --- | --- |
| `7` | `4 + 2 + 1` | Owner can read, write, and execute |
| `5` | `4 + 1` | Group can read and execute |
| `5` | `4 + 1` | Others can read and execute |

## Change Permissions with `chmod`

`chmod` means change mode. It changes permissions for files and directories.

Syntax:

```bash
chmod [option] [permission] [file_name]
```

Example:

```bash
chmod 777 notes.txt
```

This gives read, write, and execute access to the owner, group, and others.

## Change Permissions Recursively

Use `-R` to apply permissions to a directory and everything inside it:

```bash
chmod -R 0777 /mydirectory
```

Be careful with `777`. It gives everyone full access.

## Symbolic Permissions

You can also use symbolic permission syntax.

```bash
chmod u+s,o-rwx my_file
```

Explanation:

| Part | Meaning |
| --- | --- |
| `u+s` | Adds the SetUID bit |
| `o-rwx` | Removes read, write, and execute permissions from others |

The SetUID bit causes a program to run with the privileges of the file owner. If the owner is `root`, this can allow users to run that program with elevated privileges, so use it carefully.

## Give Write Permission to the Owner

To give the file owner write permission:

```bash
sudo chmod u+w myfolder
```

Explanation:

| Part | Meaning |
| --- | --- |
| `u` | User, meaning the file owner |
| `+w` | Add write permission |
| `sudo` | Needed if you do not own the file or directory |

## Manage Access with ACLs

ACLs, or Access Control Lists, let you grant permissions to specific users or groups without changing the main owner or group.

Give a user read, write, and execute access:

```bash
setfacl -m u:jdoe:rwx myfile
```

Give a group read and execute access:

```bash
setfacl -m g:fish:r-x myfile
```

Remove an ACL entry for a group:

```bash
setfacl -x g:fish myfile
```

View detailed permissions, including ACL entries:

```bash
getfacl myfile
```

## Change Ownership with `chown`

`chown` means change ownership.

Syntax:

```bash
chown [option] owner[:group] file
```

Change the owner:

```bash
sudo chown Bob: file.txt
```

Change the owner of a folder:

```bash
sudo chown <username>: myfolder
```

Change only the group:

```bash
sudo chown :<groupname> myfolder
```

## Change Group with `chgrp`

`chgrp` means change group.

Example:

```bash
sudo chgrp root .bash_history
```

This changes the group ownership of `.bash_history` to `root`

## Change Ownership for Specific File Types

To change ownership of all PDF files in subdirectories:

```bash
find . -type f -name '*.pdf' -print0 | xargs -0 chown <username>:<usergroup>
```

The `-print0` and `xargs -0` combination safely handles filenames with spaces.

You can also use `-exec`:

```bash
find . -type f -name '*.pdf' -exec chown <username>:<usergroup> {} +
```

In Bash 4 and later, globstar can also work if enabled:

```bash
chown -R <username>:<usergroup> ./**/*.pdf
```

## Why `sudo echo` Can Fail with Redirection

This command may fail:

```bash
sudo echo test >> /etc/hosts
```

The reason is that `sudo` only applies to `echo`. The `>>` redirection is handled by your current shell before `sudo` runs.

Use this instead:

```bash
sudo bash -c 'echo test >> /etc/hosts'
```

This runs the whole redirection inside a root shell.

## Check Logged-In Users

Show logged-in users:

```bash
who
users
```

Show information about a specific user:

```bash
finger USERNAME
id USERNAME
```

## Default Permissions with `umask`

`umask` controls the default permissions for newly created files and directories.

Linux starts with these default permissions:

| Type | Default |
| --- | --- |
| Files | `666`, or `rw-rw-rw-` |
| Directories | `777`, or `rwxrwxrwx` |

The `umask` value removes permission bits from those defaults.

### Common `umask` Values

```bash
umask 022
```

Result:

| Type | Permission |
| --- | --- |
| Files | `644`, or `rw-r--r--` |
| Directories | `755`, or `rwxr-xr-x` |

```bash
umask 002
```

Result:

| Type | Permission |
| --- | --- |
| Files | `664`, or `rw-rw-r--` |
| Directories | `775`, or `rwxrwxr-x` |

```bash
umask 077
```

Result:

| Type | Permission |
| --- | --- |
| Files | `600`, or `rw-------` |
| Directories | `700`, or `rwx------` |

Check the current `umask`:

```bash
umask
```

To make a `umask` permanent, add it to `~/.bashrc` or `~/.profile`.

## System Information with `uname`

`uname` means Unix name. It prints system information.

```bash
uname -a
```

Useful options:

| Option | Meaning |
| --- | --- |
| `-a` | Show all information |
| `-s` | Show kernel name |
| `-n` | Show hostname |

## User IDs

The `root` user always has UID `0`.

```bash
id -u root
```

Show information about a user:

```bash
id username
```

Show a user's UID:

```bash
id -u ubuntu
```

Show a username from a UID:

```bash
id -nu 1000
```

## Delete Users

Delete a user:

```bash
sudo userdel John
```

Check that the user no longer exists:

```bash
id John
```

By default, `userdel` does not delete the user's home directory:

```bash
ls -l /home/
```

Delete a user and their home directory:

```bash
sudo userdel -r Alex
```

## Create Users

Create a new user interactively:

```bash
adduser new_user
```

This creates a user, creates a group with the same name, adds the user to that group, and creates a home directory under `/home/new_user`.

Create a user with `useradd`:

```bash
sudo useradd John
```

Set or change a password:

```bash
sudo passwd username
```

Create a user with a comment, primary group, and default shell:

```bash
sudo useradd -c "User Comment" -g groupname -s /bin/bash username
sudo passwd username
```

## Modify User Groups

Change a user's primary group:

```bash
sudo usermod -g newgroup username
```

Add a user to a secondary group:

```bash
sudo usermod -aG new_group username
```

Add a user to the `sudo` group on Debian or Ubuntu-based systems:

```bash
sudo usermod -aG sudo my_user
```

Add sudo capability on many RHEL-based systems:

```bash
sudo usermod -aG wheel username
```

## Lock, Unlock, and Expire Accounts

Lock an account:

```bash
sudo usermod -L username
```

Unlock an account:

```bash
sudo usermod -U username
```

Lock a user's password:

```bash
sudo passwd -l john
```

Password locking may not block SSH-key logins. To expire the whole account, use `chage`.

Expire an account immediately:

```bash
sudo chage -E 0 alex
```

This sets the account expiration date to day `0`, which means `1970-01-01`, so the account is already expired.

Re-enable the account:

```bash
sudo chage -E -1 alex
```

View password aging and expiration information:

```bash
chage -l username
```

## Manage Groups

Create a group with a specific GID:

```bash
sudo groupadd -g 1200 mynewgroup
```

Modify a group's GID:

```bash
sudo groupmod -g 1345 mynewgroup
```

Delete a group:

```bash
sudo groupdel mynewgroup
```

Normal user and group IDs often start at `1000` and go upward.

## Inspect User and Group Files

Show groups:

```bash
cat /etc/group
cat /etc/group | tail -n1
```

Show recent users:

```bash
tail -3 /etc/passwd
```

Example `/etc/passwd` entry:

```text
john:x:1001:1001:John Doe:/home/john:/bin/bash
```

The format is:

```text
username:password-placeholder:uid:gid:extra-info:home-directory:shell
```

Show password and account aging data:

```bash
sudo tail -3 /etc/shadow
sudo tail -3 /etc/gshadow
```

`/etc/shadow` is readable only by root.

The `/etc/shadow` format includes:

```text
username:password:last-change:min-age:max-age:warning:inactive:expire
```

If the password field contains `*`, the user does not have a usable password.

## Switch Users and Become Root

Run a shell as another user while preserving environment variables:

```bash
su -p babak
```

Log in as another user temporarily:

```bash
su - Phil
```

Become root using `sudo`:

```bash
sudo -i
```

Another common form:

```bash
sudo su -
```

Show the currently logged-in user:

```bash
whoami
```

## Check Login History

Show recent logins:

```bash
last
```

## Start a Root Bash Shell with Environment Variables

Run Bash with elevated privileges while preserving environment variables:

```bash
sudo -E bash -
```

Explanation:

| Part | Meaning |
| --- | --- |
| `sudo` | Run as superuser |
| `-E` | Preserve user environment variables |
| `bash` | Launch the Bash shell |
| `-` | Read commands from standard input |

Shell settings are usually stored in files such as:

```text
/etc/profile
/home/USERNAME/.bashrc
```

## UID Ranges

You can check UID and GID ranges in:

```bash
cat /etc/login.defs
```

Common values:

```text
UID_MIN      1000
UID_MAX      60000
SYS_UID_MIN  100
SYS_UID_MAX  999
```

Accounts with UID values below `1000` are often system accounts. Deleting them can break system services.

## MySQL User Check

To show MySQL users:

```sql
SELECT user, host FROM mysql.user;
```

You usually run this after entering the MySQL shell:

```bash
mysql
```

input redirection
```bash
wc -l /etc/passwd  
```
37 /etc/passwd


same thing, but does  not show the file name in the results
```bash
wc -l < /etc/passwd  
```
37


sort -t ':' uses : (colon) as the field separator, then sorts by the third field
-k => then sort by the numerical value of third field
-r => then sort from largest to smallest value (reverse) of third field
```bash
cat /etc/passwd | sort -t ':' -k 3 -n -r
```


## Quick Reference

| Task | Command |
| --- | --- |
| Show permissions | `ls -l` |
| Change permissions | `chmod 755 file.txt` |
| Change permissions recursively | `chmod -R 0755 directory` |
| Change owner | `sudo chown user: file.txt` |
| Change group | `sudo chgrp group file.txt` |
| Add ACL for user | `setfacl -m u:jdoe:rwx myfile` |
| View ACLs | `getfacl myfile` |
| Check current user | `whoami` |
| Show user info | `id username` |
| Create user | `sudo useradd username` |
| Create user interactively | `adduser username` |
| Delete user and home directory | `sudo userdel -r username` |
| Add user to group | `sudo usermod -aG group username` |
| Lock user | `sudo usermod -L username` |
| Unlock user | `sudo usermod -U username` |
| Expire account | `sudo chage -E 0 username` |
| Create group | `sudo groupadd groupname` |
| Check login history | `last` |
| Check default permissions | `umask` |


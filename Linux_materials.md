# Linux Materials

A consolidated edition of the root-level Linux tutorial notes in this repository.

<!-- Source: cron_crontab.md -->

# Cron Command Tutorial

This tutorial explains how to schedule recurring Linux commands with `cron` and `crontab`.

## 1. What Is Cron?

`cron` is a Linux/Unix scheduling service. It runs commands or scripts automatically at specific times.

Each user can have their own cron jobs, managed through `crontab`.

Cron jobs are commonly used for tasks like:

- Running backups.
- Checking server health.
- Cleaning temporary files.
- Sending reports.
- Running maintenance scripts.

## 2. Cron Schedule Format

A cron schedule has five time fields followed by the command to run:

```text
M H DOM MON DOW command-to-execute
```

| Field | Meaning | Example |
| --- | --- | --- |
| `M` | Minute | `0` to `59` |
| `H` | Hour | `0` to `23` |
| `DOM` | Day of month | `1` to `31` |
| `MON` | Month | `1` to `12` |
| `DOW` | Day of week | `0` to `7`, where both `0` and `7` can mean Sunday |
| `command-to-execute` | Command or script path | `/root/backup.sh` |

Example layout:

```text
M            H        DOM                MON         DOW               command
42           3        1                  *           *                 /root/backup.sh
```

This runs `/root/backup.sh` on the first day of every month at `3:42 AM`.

## 3. Common Cron Examples

Run a backup on the first day of each month at `3:42 AM`:

```cron
42 3 1 * * /root/backup.sh
```

Run a backup every day at `3:42 AM`:

```cron
42 3 * * * /root/backup.sh
```

Run a backup every 15 minutes during every second hour:

```cron
*/15 */2 * * * /root/backup.sh
```

This runs at times like:

```text
00:00, 00:15, 00:30, 00:45
02:00, 02:15, 02:30, 02:45
04:00, 04:15, 04:30, 04:45
```

Run a backup at minute `30` of every hour on Sunday and Monday:

```cron
30 * * * 1,7 /root/backup.sh
```

## 4. Reading a Cron Expression

Example:

```cron
*/15 */2 * * * /root/backup.sh
```

Breakdown:

```text
*/15      */2      *      *      *      /root/backup.sh
┬         ┬        ┬      ┬      ┬
│         │        │      │      └─ Day of week: any
│         │        │      └──────── Month: any
│         │        └─────────────── Day of month: any
│         └──────────────────────── Hour: every 2 hours
└────────────────────────────────── Minute: every 15 minutes
```

## 5. View Existing Cron Jobs

Show all cron jobs for the current user:

```bash
crontab -l
```

## 6. Edit Cron Jobs

Open the current user's crontab file in an editor:

```bash
crontab -e
```

Example entries:

```cron
42   3   1    *   *   /root/backup.sh >> $HOME/tmp/backup.log 2>&1
*/15 */2 *    *   *   /root/backup.sh >> $HOME/tmp/daily/backup.log 2>&1
1    0   30   *   *   /var/www/check-server.sh >> /dev/null 2>&1
```

## 7. Remove Cron Jobs

Remove all cron jobs for the current user:

```bash
crontab -r
```

Use this carefully because it deletes the user's entire crontab.

## 8. Redirect Cron Output

Cron jobs should usually redirect their output somewhere. Otherwise, output may be emailed to the local user account depending on the system setup.

Example:

```bash
/var/www/check-server.sh >> /dev/null 2>&1
```

Output redirection pieces:

| Syntax | Meaning |
| --- | --- |
| `>> file.log` | Append standard output, also called `stdout`, to a file. |
| `/dev/null` | Discard anything sent there. |
| `2>&1` | Redirect standard error, also called `stderr`, to the same place as standard output. |

Example with a log file:

```cron
42 3 * * * /root/backup.sh >> $HOME/tmp/backup.log 2>&1
```

Example that discards all output:

```cron
1 0 30 * * /var/www/check-server.sh >> /dev/null 2>&1
```

## 9. Where Cron Files Are Stored

User crontab files are commonly stored under:

```text
/var/spool/cron/tabs/username
```

In normal use, edit cron jobs with `crontab -e` instead of editing files in this directory manually.

## 10. Allowing or Denying Cron Access

Cron access can be controlled with these files:

```text
/etc/cron.allow
/etc/cron.deny
```

Use only one of these files for access control.

| File | Behavior |
| --- | --- |
| `/etc/cron.allow` | If this file exists, only users listed in it can use cron. |
| `/etc/cron.deny` | Users listed in this file cannot use cron. |

## 11. Schedule a Job Every Night at 3:30 AM

Cron expression:

```cron
30 3 * * *
```

Breakdown:

```text
30 3 * * *
┬  ┬ ┬ ┬ ┬
│  │ │ │ └─ Day of week: any
│  │ │ └─── Month: any
│  │ └───── Day of month: any
│  └─────── Hour: 3 AM
└────────── Minute: 30
```

Full example:

```cron
30 3 * * * /root/backup.sh >> $HOME/tmp/backup.log 2>&1
```

This runs `/root/backup.sh` every night at `3:30 AM` and appends output to `backup.log`.

---

<!-- Source: disk_storage_mount.md -->

# Linux Disk, Mounting, LVM, Stratis, and fstab Tutorial

## Check Disk Space with `df`

`df` means disk free. It shows filesystem disk usage.

```bash
df
```

Show disk sizes in a human-readable format:

```bash
df -h
```

Show sizes in megabytes:

```bash
df -m
```

Filter mounted filesystems that contain `media`:

```bash
df -h | grep media
```

Useful options:

| Option | Meaning |
| --- | --- |
| `-h` | Human-readable sizes such as KB, MB, GB, and TB |
| `-m` | Show sizes in megabytes |

## Check Directory Usage with `du`

`du` means disk usage. It shows how much space files or directories are using.

Check the current directory:

```bash
du
```

Check a specific directory:

```bash
du /home/user/Documents
```

## Understand Mounting

The `mount` command attaches a device, partition, network share, or image file to the Linux filesystem.

Common examples include:

- USB drives
- External hard drives
- ISO files
- NFS shares
- Additional disk partitions

General syntax:

```bash
mount -t [type] [device] [directory]
```

In Linux, disks and partitions are represented under `/dev`, such as:

```text
/dev/sda
/dev/sda1
/dev/sda2
/dev/sdb1
```

## View and Manage Partitions

Open a disk with `fdisk` to view or change partitions:

```bash
sudo fdisk /dev/sda
```

List detected disks and partitions:

```bash
sudo fdisk -l
```

## Mount an External Hard Drive

First, check whether the drive appears in the disk list:

```bash
sudo fdisk -l
```

Mount an NTFS partition:

```bash
sudo mount -t ntfs /dev/sdb1 /media
```

Explanation:

| Part | Meaning |
| --- | --- |
| `-t ntfs` | Filesystem type is NTFS |
| `/dev/sdb1` | Device or partition being mounted |
| `/media` | Directory where the drive will be accessible |

Show mounted partitions for an `sda` disk:

```bash
sudo mount | grep sda
```

## List Block Devices with `lsblk`

Use `lsblk` to view block devices, partitions, sizes, and mount points:

```bash
lsblk
```

Example output:

```text
NAME MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
sda    8:0    0 363.3M  1 disk
sdb    8:16   0     2G  0 disk [SWAP]
sdc    8:32   0     1T  0 disk /snap
                               /mnt/wslg/distro
                               /
```

Common device names:

| Device | Meaning |
| --- | --- |
| `sda` | First disk |
| `sdb` | Second disk |
| `sr0` | Optical or DVD drive |

## LVM Basics

LVM means Logical Volume Management. It is useful when you need flexible storage that can be resized more easily than traditional partitions.

With LVM, several physical disks or partitions can be combined into a larger storage pool called a volume group. That volume group can then be divided into logical volumes.

The basic LVM layers are:

| Layer | Description |
| --- | --- |
| Physical Volume | A disk or partition prepared for LVM |
| Volume Group | A storage pool made from one or more physical volumes |
| Logical Volume | A usable virtual partition created from a volume group |

Example layout:

```text
/dev/sda 200 GB \
                 > Volume Group 400 GB > Logical Volume 50 GB
/dev/sdb 200 GB /
```

## Create Physical Volumes

Create LVM physical volumes:

```bash
sudo pvcreate /dev/xvdf1 /dev/xvdf2
```

Display physical volume information:

```bash
sudo pvdisplay /dev/sdb1
```

Example output:

```text
"/dev/sdb1" is a new physical volume of "2.01 GiB"
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
```

## Create a Volume Group

Create a volume group from physical volumes:

```bash
sudo vgcreate vol_group1 /dev/xvdf1 /dev/xvdf2
```

Show volume group details:

```bash
sudo vgdisplay
```

## Create a Logical Volume

Create a logical volume inside a volume group:

```bash
sudo lvcreate -n lv01 -L 500MB vol_group1
```

Explanation:

| Part | Meaning |
| --- | --- |
| `lvcreate` | Create a new logical volume |
| `-n lv01` | Name the logical volume `lv01` |
| `-L 500MB` | Set the size to 500 MB |
| `vol_group1` | Volume group where the logical volume will be created |

Show logical volumes:

```bash
sudo lvdisplay
```

Show details for a specific volume group:

```bash
sudo lvdisplay Vol1
```

Example output:

```text
--- Logical volume ---
LV Path                 /dev/Vol1/lvtest
LV Name                 lvtest
VG Name                 Vol1
LV UUID                 4W2369-pLXy-jWmb-lIFN-SMNX-xZnN-3KN208
LV Write Access         read/write
LV Status               available
LV Size                 2.00 GiB
Current LE              513
Segments                1
Allocation              inherit
Read ahead sectors      auto
Block device            253:2
```

## Stratis Basics

Stratis is another Linux storage management tool. It uses physical volumes, pools, and filesystems.

Compared with LVM, Stratis focuses on storage pools and filesystems that can grow inside the pool.

Basic Stratis layout:

```text
/dev/sda 200 GB \
                 > Stratis Pool 400 GB > Stratis Filesystem
/dev/sdb 200 GB /
```

## Install and Start Stratis

Install Stratis tools:

```bash
sudo yum install stratis-cli stratisd -y
```

Enable and start the Stratis service:

```bash
sudo systemctl enable --now stratisd
```

List Stratis pools:

```bash
sudo stratis pool list
```

## Manage Stratis Pools and Filesystems

Add another physical drive to a Stratis pool:

```bash
sudo stratis pool add-data pool1 /dev/xvdc
```

Create a filesystem on the pool:

```bash
sudo stratis filesystem create pool1 filesys1
```

List filesystems:

```bash
sudo stratis filesystem list
```

Mount a Stratis filesystem:

```bash
sudo mount /stratis/pool1/filesys1 /test
```

Create a snapshot:

```bash
sudo stratis filesystem snapshot pool1 filesys1 filesys1-copy
```

## Basic Server Partition Planning

For a server with a `1 TB` disk, one possible design is:

| Mount Point | Suggested Size | Purpose |
| --- | --- | --- |
| `swap` | RAM size plus 2 GB | Swap space |
| `/boot` | About 1 GB | Kernel and boot files |
| `/var` | About 30 GB | Logs and variable application data |
| `/home` | About 900 GB | User data |
| `/usr` | About 20 GB | System binaries and shared files |

The `/boot` partition should usually have around `1 GB` reserved for kernel and boot files.

## `/etc/fstab` Basics

The `/etc/fstab` file tells Linux which filesystems to mount automatically.

`fstab` means file system table.

The file is located at:

```text
/etc/fstab
```

An example entry:

```text
UUID=1234-5678  /home   ext4    defaults   0   2
```

Each line contains six fields:

| Field | Meaning |
| --- | --- |
| Device | Drive or partition, usually by UUID, device name, or label |
| Mount point | Directory where the filesystem will be mounted |
| Filesystem type | Type such as `ext4`, `xfs`, `btrfs`, `zfs`, or `ntfs` |
| Options | Mount options, such as `defaults` |
| Dump | `1` enables dump backup, `0` disables it |
| fsck order | Filesystem check order at boot |

For the fsck order:

| Value | Meaning |
| --- | --- |
| `0` | Do not check |
| `1` | Check first, usually used for `/` |
| `2` | Check after the root filesystem |

## Find UUIDs with `blkid`

Show UUIDs for block devices and partitions:

```bash
sudo blkid
```

## Add a Drive to `/etc/fstab`

Example entry for a drive labeled `data_drive` mounted at `/data`:

```text
LABEL=data_drive /data ext4 defaults 0 2
```

Explanation:

| Field | Value |
| --- | --- |
| Device | `LABEL=data_drive` |
| Mount point | `/data` |
| Filesystem type | `ext4` |
| Options | `defaults` |
| Dump | `0` |
| fsck order | `2` |

## Add Swap in `/etc/fstab`

Example entry for a swap file:

```text
/swapfile1 none sw 0 0
```

## Safely Edit `/etc/fstab`

Open the file:

```bash
sudo vi /etc/fstab
```

Before making changes, create a backup:

```bash
sudo cp /etc/fstab /etc/fstab.old
```

Restore the backup if needed:

```bash
sudo mv /etc/fstab.old /etc/fstab
```

After making a change, test it without rebooting:

```bash
sudo mount -a
```

`mount -a` mounts all filesystems listed in `/etc/fstab`, except entries marked with `noauto`.

## Backup an NFS Mount by Switching Mount Points

This example shows a workflow where an existing NFS mount is moved to a new directory and a Cohesity NFS appliance is mounted in the old directory.

### Create a New Backup Directory

```bash
mkdir -p /MyCompany/data/elasticsearch_backup1
```

### Unmount the Existing NFS Mount

```bash
umount /MyCompany/data/elasticsearch_backup
```

### Mount the Old NFS Share to the New Directory

```bash
mount -t nfs 172.16.22.1:/vol/els_prod_backup/elasticsearch_intentanalyzer /MyCompany/data/elasticsearch_backup1
```

### Verify the New Mount

```bash
df -h | grep elasticsearch_backup1
```

### Mount the Cohesity NFS Share to the Original Directory

```bash
mount -t nfs va-cohesity.mcdomain.com:/es_va_prod_v7.8_intent /MyCompany/data/elasticsearch_backup
```

Verify the mount:

```bash
df -h | grep elasticsearch_backup
```

### Update `/etc/fstab`

Edit `/etc/fstab`:

```bash
vi /etc/fstab
```

Comment out the old NFS line, then add the new one:

```text
va-cohesity.mcdomain.com:/es_va_prod_v7.8_intent  /MyCompany/data/elasticsearch_backup nfs defaults 0 0
```

sort -n , sorts directories numerically from smallest to largest size
```bash
sudo du /var | sort -n
```

-s → summarize total per directory (don't show every subfolder)
-h → human-readable (MB/GB instead of KB)
/var/* → only top-level subfolders
```bash
sudo du -sh /var/* | sort -h
```

---
systematic approach to diagnosing and resolving high disk usage when the obvious culprits (logs/temp) are already cleared:

### 1. Re-identify What's Actually Consuming Space

Before taking action, pinpoint the real culprit:

```bash
# Top-level usage by directory
du -sh /* 2>/dev/null | sort -rh | head -20

# Drill down recursively
du -sh /var/* | sort -rh | head -10
du -sh /home/* | sort -rh

# Most reliable interactive tool
ncdu /          # Install with: apt install ncdu
```
### 2. Check for Deleted-but-Still-Open Files

This is the **most common surprise** — a process holds a file open, you delete it, but the space isn't freed until the process releases it:

```bash
# Find deleted files still held open by running processes
lsof +L1

# Shows entries like: (deleted) next to the filename
# The SIZE column shows how much space is still consumed
```

**Fix:** Restart the offending process or service:
```bash
systemctl restart <service-name>
# or kill the PID shown by lsof
```

### 3. Check Inode Exhaustion

You can run out of **inodes** (file slots) even if disk bytes are free — `df` will show 100% usage on the inode count:

```bash
df -i          # Check inode usage across all filesystems
```

**Fix:** Look for directories with millions of tiny files (mail spools, session files, cache):
```bash
find / -xdev -printf '%h\n' | sort | uniq -c | sort -rn | head -20
```


### 4. Large Files Anywhere on the System

```bash
# Find all files larger than 1GB
find / -xdev -size +1G -ls 2>/dev/null

# Find files larger than 500MB
find / -xdev -size +500M -type f 2>/dev/null | sort -k 7 -rn
```

### 5. Docker / Container Leftovers

If Docker is installed, it can quietly consume massive amounts:

```bash
docker system df           # See how much Docker is using
docker system prune -a     # Remove unused images, containers, volumes
```

### 6. Snap Package Leftovers (Ubuntu)

Old snap revisions pile up:

```bash
snap list --all
# Remove old revisions
snap remove --revision=<old_rev> <package>
```

Or use this one-liner to clean all old snap revisions:
```bash
snap list --all | awk '/disabled/{print $1, $3}' | while read name rev; do snap remove "$name" --revision="$rev"; done
```
---

## Quick Reference

| Task | Command |
| --- | --- |
| Show disk usage | `df -h` |
| Show directory usage | `du /path/to/directory` |
| List disks and partitions | `lsblk` |
| List partition table | `sudo fdisk -l` |
| Mount NTFS partition | `sudo mount -t ntfs /dev/sdb1 /media` |
| Show block UUIDs | `sudo blkid` |
| Create LVM physical volume | `sudo pvcreate /dev/xvdf1 /dev/xvdf2` |
| Create LVM volume group | `sudo vgcreate vol_group1 /dev/xvdf1 /dev/xvdf2` |
| Create LVM logical volume | `sudo lvcreate -n lv01 -L 500MB vol_group1` |
| Show logical volumes | `sudo lvdisplay` |
| Install Stratis | `sudo yum install stratis-cli stratisd -y` |
| Start Stratis | `sudo systemctl enable --now stratisd` |
| List Stratis pools | `sudo stratis pool list` |
| Create Stratis filesystem | `sudo stratis filesystem create pool1 filesys1` |
| Edit fstab | `sudo vi /etc/fstab` |
| Test fstab changes | `sudo mount -a` |
| Mount NFS share | `mount -t nfs server:/path /mountpoint` |


---

<!-- Source: keystore_java.md -->

# Java Keystore Tutorial

A keystore is a secure storage file used to hold cryptographic keys and certificates. Java applications commonly use keystores for SSL/TLS, authentication, encryption, and secure communication.

## What a Keystore Stores

A keystore can contain several types of security material:

| Item | Purpose |
| --- | --- |
| Private keys | Used for authentication, encryption, and signing |
| Public key certificates | Used to verify identity, often issued by Certificate Authorities |
| Secret keys | Used for symmetric encryption |

## Common Keystore Types

Java supports different keystore formats.

| Type | Description |
| --- | --- |
| `JKS` | Traditional Java KeyStore format used by many Java applications |
| `PKCS12` | Common standard format that can store private keys and certificates |
| `BKS` | Bouncy Castle Keystore format, often used in Android applications |

## Common Uses

Keystores are often used for:

- SSL/TLS configuration
- Storing certificates for Java applications
- Code signing for JAR files and Android APKs
- Authentication and secure credential storage

## Managing Keystores with `keytool`

Java includes a command-line utility called `keytool`. You can use it to create, inspect, and manage keystores.

## Create a New Keystore

Use `keytool -genkeypair` to create a new keystore and generate a key pair:

```bash
keytool -genkeypair -alias mykey -keyalg RSA -keystore mykeystore.jks -storepass changeit
```

Explanation:

| Option | Meaning |
| --- | --- |
| `-genkeypair` | Generates a public/private key pair |
| `-alias mykey` | Gives the key entry a name |
| `-keyalg RSA` | Uses the RSA algorithm |
| `-keystore mykeystore.jks` | Creates or updates the keystore file |
| `-storepass changeit` | Sets the keystore password |

`changeit` is a common example password. For real systems, use a strong password instead.

## List Keystore Contents

Use `keytool -list` to see what is inside a keystore:

```bash
keytool -list -keystore mykeystore.jks -storepass changeit
```

This shows entries such as aliases, certificate fingerprints, and certificate types.

## Import a Certificate

Use `keytool -importcert` to import a certificate into a keystore:

```bash
keytool -importcert -file mycert.crt -keystore mykeystore.jks -alias mycert -storepass changeit
```

Explanation:

| Option | Meaning |
| --- | --- |
| `-importcert` | Imports a certificate |
| `-file mycert.crt` | Certificate file to import |
| `-keystore mykeystore.jks` | Target keystore |
| `-alias mycert` | Name for the imported certificate |
| `-storepass changeit` | Password for the keystore |

## Localhost, Loopback, and `0.0.0.0`

When working with local services, you may see addresses like `127.0.0.1`, `localhost`, and `0.0.0.0`.

| Address | Meaning |
| --- | --- |
| `127.0.0.1` | Loopback IP address for the current machine |
| `localhost` | Hostname that usually resolves to `127.0.0.1` |
| `0.0.0.0` | Refers to all network interfaces on the machine |

## `127.0.0.1` and `localhost`

These usually refer to the same local machine:

```text
127.0.0.1:8080
localhost:8080
```

If a service listens only on `127.0.0.1`, it is available from the same machine, but not from other machines on the network.

## `0.0.0.0`

`0.0.0.0` means the service listens on all available network interfaces.

For example, a server listening on this address:

```text
0.0.0.0:8080
```

may be reachable through:

- `localhost:8080`
- `127.0.0.1:8080`
- The machine's LAN IP address, such as `192.168.1.50:8080`

## Quick Reference

| Task | Command or Address |
| --- | --- |
| Create a keystore | `keytool -genkeypair -alias mykey -keyalg RSA -keystore mykeystore.jks -storepass changeit` |
| List keystore contents | `keytool -list -keystore mykeystore.jks -storepass changeit` |
| Import a certificate | `keytool -importcert -file mycert.crt -keystore mykeystore.jks -alias mycert -storepass changeit` |
| Local machine IP | `127.0.0.1` |
| Local machine hostname | `localhost` |
| All machine interfaces | `0.0.0.0` |


---

<!-- Source: links_alias.md -->

# Linux Links, PATH, and Aliases Tutorial

## What Is a Link?

A link in Linux is similar to a shortcut in Windows. It lets you reference a file by another name or from another location.

Linux has two main link types:

| Link Type | Description |
| --- | --- |
| Soft link | Points to the original file, like a shortcut |
| Hard link | Points to the same file data as the original file |

## Soft Links

A soft link is also called a symbolic link or symlink.

Soft links are more common than hard links.

Important behavior:

- If the original file is deleted, the soft link stops working.
- If you edit the original file, the soft link shows the updated content.
- A soft link has its own inode.
- A soft link can point to files or directories.

Create a soft link:

```bash
ln -s myfile soft_link
```

Delete the soft link:

```bash
unlink soft_link
```

## Hard Links

A hard link is another directory entry that points to the same inode as the original file.

Important behavior:

- If the original filename is deleted, the hard link still works.
- If you edit the file through either name, both names show the change.
- The original name and hard link share the same inode.

Create a hard link:

```bash
ln myfile hard_link
```

Delete the hard link:

```bash
unlink hard_link
```

## Compare Soft Links and Hard Links

| Feature | Soft Link | Hard Link |
| --- | --- | --- |
| Also called | Symbolic link / symlink | Hard link |
| Points to | File path | Same inode/file data |
| Works if original filename is deleted | No | Yes |
| Can point to directories | Yes | Usually no for regular users |
| Has separate inode | Yes | No, shares inode |
| Common usage | Very common | Less common |

## Check Inodes with `ls -i`

Each file and directory is connected to an inode. An inode stores metadata about a file, such as ownership, permissions, and where the file's data lives on disk.

Show inode numbers:

```bash
ls -i
```

If two filenames are hard links to the same file, they show the same inode number.

## Check Inode Usage with `df -i`

Sometimes a machine can fail to save new files even when `df -h` shows free disk space. This can happen when all inodes are used.

Check inode usage:

```bash
df -i
```

This is common on systems with many tiny files, such as cache files.

## See a Real Soft Link

You can check where a command is located with `which`:

```bash
which python3
```

Example output:

```text
/Applications/miniconda3/bin/python3
```

Then inspect that path:

```bash
ls -l /Applications/miniconda3/bin/python3
```

Example output:

```text
lrwxr-xr-x  1 babak  staff  10 Mar 21 16:55 /Applications/miniconda3/bin/python3 -> python3.10
```

The `l` at the beginning means it is a symbolic link. The `-> python3.10` part shows what it points to.

## Understand `PATH`

`PATH` is an environment variable that contains directories where the shell looks for commands.

Show your current `PATH`:

```bash
echo $PATH
```

Example output:

```text
/Applications/miniconda3/bin:/Applications/miniconda3/condabin:/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin
```

The directories are separated by colons. When you run a command, the shell searches these directories from left to right.

## Create Aliases

An alias is a custom shortcut for a command.

Syntax:

```bash
alias name='command'
```

Examples:

```bash
alias k8s='kubectl get pods -n dev'
alias meow='cat'
alias egrep='egrep --color=auto'
```

Now running:

```bash
meow file.txt
```

behaves like:

```bash
cat file.txt
```

## Make Aliases Permanent

Aliases created in the terminal disappear when the shell closes.

To keep aliases after restarting the terminal, add them to your shell configuration file, such as:

```text
~/.bashrc
~/.zshrc
```

## Remove an Alias

Use `unalias` to remove an alias:

```bash
unalias meow
```

## See How the Shell Resolves a Command

Use `type -a` to show every place the shell finds a command, including aliases, functions, built-ins, and executables from `PATH`.

```bash
type -a uptime
```

This is useful when a command behaves differently than expected because an alias or another executable is being used first.

## Quick Reference

| Task | Command |
| --- | --- |
| Create a hard link | `ln myfile hard_link` |
| Create a soft link | `ln -s myfile soft_link` |
| Delete a link | `unlink link_name` |
| Show inode numbers | `ls -i` |
| Show inode usage | `df -i` |
| Find command path | `which python3` |
| Inspect a link | `ls -l /path/to/file` |
| Show `PATH` | `echo $PATH` |
| Create an alias | `alias name='command'` |
| Remove an alias | `unalias name` |
| Show all command matches | `type -a command` |

---

<!-- Source: logs_management.md -->

# Linux Logs Tutorial

## Check the `rsyslog` Service

`rsyslog` is a common logging service on Linux systems. It collects log messages from applications and the system, then writes them to log files.

Check whether `rsyslog` is running:

```bash
systemctl status rsyslog
```

## Common Log Locations

Linux applications and services commonly write logs through:

```text
/dev/log
```

Most log files are stored under:

```text
/var/log
```

Useful examples:

| Path | Purpose |
| --- | --- |
| `/dev/log` | Socket where applications send log messages |
| `/var/log` | Main directory for system and application logs |
| `/var/log/auth.log` | Authentication-related logs |
| `/var/log/lastlog` | Recent user login information |

## View Boot Logs with `dmesg`

`dmesg` shows kernel messages, including messages generated while the machine is booting.

```bash
dmesg | less
```

Using `less` lets you scroll through the output page by page.

## Browse `/var/log`

Move into the log directory:

```bash
cd /var/log
```

List logs sorted by modification time:

```bash
ls -ltrh
```

Useful options:

| Option | Meaning |
| --- | --- |
| `-l` | Long listing format |
| `-t` | Sort by modification time |
| `-r` | Reverse the order |
| `-h` | Human-readable file sizes |

With `ls -ltrh`, the newest files appear near the bottom.

## Manage Logs with `logrotate`

`logrotate` automatically manages log files by rotating, compressing, and deleting old logs. This helps prevent `/var/log` from filling up the disk.

Force log rotation manually:

```bash
sudo logrotate -f /etc/logrotate.conf
```

Edit the main logrotate configuration:

```bash
sudo vi /etc/logrotate.conf
```

On many systems, `logrotate` runs daily from:

```bash
cd /etc/cron.daily/
```

## View Logs with `journalctl`

`journalctl` reads logs collected by `systemd-journald`.

Show all journal logs:

```bash
journalctl
```

Inside the pager, press `Shift+G` to jump to the end.

Show help:

```bash
journalctl --help
```

Show the last 5 log lines:

```bash
journalctl -n 5
```

Jump to the end of the logs:

```bash
journalctl -e
```

Follow logs in real time:

```bash
journalctl -f
```

## View Logs for a Service

Show logs for the SSH service:

```bash
journalctl -u ssh
```

Show SSH logs since yesterday:

```bash
journalctl -u ssh --since yesterday
```

Show SSH logs from 9 AM to 11 AM today:

```bash
journalctl --since "09:00:00" --until "11:00:00" -u ssh
```

## Journal Storage Location

Temporary journal logs are stored under:

```bash
cd /run/log/journal
```

Because `/run` is temporary, logs stored there may disappear after a reboot.

## Make Journal Logs Persistent

To keep journal logs after reboot, edit:

```bash
sudo vi /etc/systemd/journal.conf
```

Set `Storage` to `persistent`:

```ini
[Journal]
Storage=persistent
```

After changing journal configuration, restart the journal service or reboot the system.

## Reduce Log File Size

Sometimes you need to reduce the size of a large log file without deleting the file itself.

Empty a log file with `truncate`:

```bash
truncate -s 0 logfile
```

Another way to empty a file:

```bash
cat /dev/null > file.log
```

Both commands make the file empty.

## Keep Only Recent Log Data

To keep only the last 10 MB of a log file, write the final part of the log into a new file:

```bash
tail -c 10M logfile > newlogfile
```

Explanation:

| Part | Meaning |
| --- | --- |
| `tail` | Reads the end of a file |
| `-c 10M` | Keeps the last 10 megabytes |
| `logfile` | Source log file |
| `> newlogfile` | Writes the result to a new file |

```bash
tail -f /var/log/messages
grep ERROR app.log
journalctl -u nginx -f
```

## Quick Reference

| Task | Command |
| --- | --- |
| Check `rsyslog` status | `systemctl status rsyslog` |
| View boot logs | `dmesg | less` |
| Go to log directory | `cd /var/log` |
| List logs by time | `ls -ltrh` |
| Force log rotation | `sudo logrotate -f /etc/logrotate.conf` |
| Edit logrotate config | `sudo vi /etc/logrotate.conf` |
| Show all journal logs | `journalctl` |
| Show last 5 journal lines | `journalctl -n 5` |
| Jump to end of journal | `journalctl -e` |
| Follow journal logs | `journalctl -f` |
| Show service logs | `journalctl -u ssh` |
| Show logs since yesterday | `journalctl -u ssh --since yesterday` |
| Edit journal config | `sudo vi /etc/systemd/journal.conf` |
| Empty a log file | `truncate -s 0 logfile` |
| Keep last 10 MB | `tail -c 10M logfile > newlogfile` |

---

<!-- Source: networking.md -->

# Linux Networking Tutorial

## Test Connectivity with `ping`

`ping` means Packet Internet Groper. It uses ICMP to send packets to a host and wait for a response.

Syntax:

```bash
ping [option] [hostname_or_ip_address]
```

Ping a domain:

```bash
ping google.com
```

Ping an IP address every 5 seconds:

```bash
ping x.x.x.x -i 5
```

## Trace Network Hops with `traceroute`

`traceroute` shows the path packets take to reach a destination. Each step in the path is called a hop.

```bash
traceroute 4.2.2.4
```

This is useful when you want to see where traffic is going or where a connection may be failing.

## Download Files with `wget`

`wget` downloads files from the internet.

Syntax:

```bash
wget [option] [url]
```

Download a file:

```bash
wget https://wordpress.org/latest.zip
```

Save the downloaded file with a different name:

```bash
wget -O latest-hugo.zip https://github.com/gohugoio/hugo/archive/master.zip
```

Download a file into a specific directory:

```bash
wget -P /mnt/iso http://mirrors.mit.edu/centos/7/isos/x86_64/CentOS-7-x86_64-Minimal-1804.iso
```

Limit download speed:

```bash
wget --limit-rate=1m https://dl.google.com/go/go1.10.3.linux-amd64.tar.gz
```

Useful options:

| Option | Meaning |
| --- | --- |
| `-O` | Save output with a specific filename |
| `-P` | Save output in a specific directory |
| `--limit-rate=1m` | Limit download speed to 1 MB per second |

## View and Change Hostname

The hostname is the machine name on the network.

Show the current hostname:

```bash
hostname
```

Print IP addresses associated with the hostname:

```bash
hostname -i
```

Show hostname aliases:

```bash
hostname -a
```

View the persistent hostname:

```bash
cat /etc/hostname
```

Change the machine name:

```bash
sudo hostnamectl set-hostname babak
```

## Map Hostnames with `/etc/hosts`

The `/etc/hosts` file maps IP addresses to hostnames locally.

Open the file:

```bash
sudo vim /etc/hosts
```

Example entries:

```text
172.167.2.45 dummyhost
127.0.0.1 gaming.ir
```

The first line lets you use `dummyhost` instead of the IP address.

The second line points `gaming.ir` to the local machine. This can be used to block access to a site from that machine.

Test the custom hostname:

```bash
ping dummyhost
```

## Inspect IP Addresses and Routes

Show IP addresses:

```bash
ip addr
```

Show routing table:

```bash
ip route
```

Add a default gateway:

```bash
sudo ip route add default via 192.168.1.1
```

## Transfer Data with `curl`

`curl` is a client for URLs. It transfers data using many protocols, including HTTP and HTTPS.

Fetch a page:

```bash
curl https://www.google.com
```

Show only HTTP response headers:

```bash
curl -I https://www.google.com
```

Example output:

```text
HTTP/1.1 200 OK
Date: Tue, 24 Oct 2023 17:30:12 GMT
Content-Type: text/html; charset=UTF-8
Content-Length: 1256
Server: nginx
```

Add a custom HTTP header:

```bash
curl -H "X-Header: value" https://www.example.com
```

Send a JSON POST request:

```bash
curl -X POST \
  -H "Content-Type: application/json" \
  -H "X-Custom: abc" \
  -d '{"name": "John"}' \
  https://example.com/api
```

Fail the build if the app health endpoint does not return success after 5 retires
```bash
curl --fail --show-error --silent --retry 5 --retry-delay 10 "$HEALTH_URL"
```

Useful options:

| Option | Meaning |
| --- | --- |
| `-I` | Send a HEAD request and show headers only |
| `-H` | Add a custom header |
| `-X` | Specify the HTTP method |
| `-d` | Send request body data |

## Download and Install an APT GPG Key with `curl`

This example downloads a Kubernetes package signing key and converts it for APT:

```bash
curl -fsSL https://pkgs.k8s.io/core:/stable/v1.31/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
```

Explanation:

| Part | Meaning |
| --- | --- |
| `-f` | Fail on HTTP server errors |
| `-s` | Silent mode |
| `-S` | Show errors even in silent mode |
| `-L` | Follow redirects |
| `gpg` | GNU Privacy Guard |
| `--dearmor` | Convert ASCII-armored key to binary format |
| `-o` | Write output to a specific file |

## DNS Lookups with `nslookup`

`nslookup` queries DNS servers.

Syntax:

```bash
nslookup [-option] [name] [server]
```

Look up a domain:

```bash
nslookup www.google.com
```

Look up name servers:

```bash
nslookup -type=ns google.com
```

Look up mail exchange records:

```bash
nslookup -type=mx yahoo.com
```

## Network Interfaces

NIC means network interface card. Linux interface names may look like:

```text
wlan0
eno1
ens1
enp3s2
```

View network interfaces and their status:

```bash
ip link show
```

Show IP addresses:

```bash
ip addr show
```

Install older networking tools if needed:

```bash
sudo apt install net-tools
```

Show detailed interface information:

```bash
ifconfig
```

Shut down a network interface:

```bash
sudo ifconfig <NETWORK_CARD> down
```

Network interface configuration may be found in:

```text
/etc/network/interfaces
```

## NetworkManager with `nmcli`

Show general NetworkManager status:

```bash
nmcli general status
```

Show network devices:

```bash
nmcli device
```

## DNS Configuration Files

Show local DNS resolver configuration:

```bash
cat /etc/resolv.conf
```

Show name service lookup order:

```bash
cat /etc/nsswitch.conf
```

Example entry:

```text
passwd: files systemd
```

This means the system checks local files first, then `systemd`, when resolving passwd information.

## Inspect Network Connections with `netstat`

`netstat` shows network connections, routing tables, and interface statistics.

Show the routing table:

```bash
netstat -nr
```

Show active ports and connections:

```bash
netstat -na
```

Show listening ports:

```bash
netstat -l
```

Check which process is listening on a specific TCP or UDP port:

```bash
sudo netstat -tulnp | grep <PORT_NUMBER>
```

Useful options:

| Option | Meaning |
| --- | --- |
| `-t` | Show TCP connections |
| `-u` | Show UDP connections |
| `-l` | Show listening sockets |
| `-n` | Show numeric addresses and ports |
| `-p` | Show PID and process name |
| `-r` | Show routing table |
| `-a` | Show all sockets |

## Clean Up `netstat` Output

Remove the first two header lines:

```bash
netstat -nutl | grep -v '^Active' | grep -v '^Proto'
```

Extract listening port numbers:

```bash
netstat -nutl | grep ':' | awk '{print $4}' | awk -F ':' '{print $NF}'
```

Count listening ports:

```bash
netstat -nutl | grep ':' | awk '{print $4}' | awk -F ':' '{print $NF}' | sort -n | uniq -c
```

In the `awk` command:

| Part | Meaning |
| --- | --- |
| `$NF` | Last field in the line |
| `{print $NF}` | Print the last field |
| `-F ':'` | Use `:` as the field separator |

## Listen on a Port with `nc`

`nc`, or netcat, can open network connections and listen on ports.

Listen on port `1337`:

```bash
nc -l 1337
```

## Find Which Process Uses a Port with `fuser`

`fuser` shows which process is using a file, socket, or port.

Find the process using TCP port `22`:

```bash
sudo fuser 22/tcp
```

## DNS Lookups with `dig`

`dig` is a DNS lookup tool.

```bash
dig google.com
```

It shows how a domain name resolves to IP addresses and provides detailed DNS response information.

## Capture Traffic with `tcpdump`

Show TCP traffic passing through the machine:

```bash
sudo tcpdump
```

You usually need `sudo` because packet capture requires elevated permissions.

## Capture HTTP Traffic with `tcpflow`

Capture and display HTTP traffic on port `80`:

```bash
sudo tcpflow -c port 80
```

The `-c` option prints captured data to the terminal.

## DNS Record Types

DNS records map names to network information.

| Record | Meaning |
| --- | --- |
| `A` | IPv4 address for a host |
| `AAAA` | IPv6 address for a host |
| `MX` | Mail server address for a domain |

An `A` record maps a domain name to an IPv4 address.

Example:

```text
www.dnsimple.com -> 208.93.64.253
```

## Name Lookups with `getent`

`getent` queries the system's configured name services, such as `/etc/hosts`, DNS, or LDAP.

Show localhost entries:

```bash
getent hosts localhost
```

Show host entries:

```bash
getent hosts
```

Look up a domain:

```bash
getent hosts google.com
```

Example result:

```text
142.250.190.78 google.com
```

## Service and Port Names

Show known ports and related services:

```bash
cat /etc/services
```

## DHCP Basics

DHCP means Dynamic Host Configuration Protocol. It automatically assigns IP addresses to client systems on a network.

Instead of manually assigning IP addresses to many machines, a DHCP server manages an IP range, also called a scope, and distributes addresses to clients.

Install a DHCP server on Ubuntu:

```bash
sudo apt-get install isc-dhcp-server
```

## Network Scanning with `nmap`

List hosts in a subnet:

```bash
sudo nmap -sL 10.0.1.0/24
```

Find a host that contains `nixos` in the scan output:

```bash
sudo nmap -sL 10.0.1.0/24 | grep nixos
```

Ping-scan a specific host:

```bash
sudo nmap -sn 10.0.1.147/32
```

Scan all common ports on a host:

```bash
sudo nmap 10.0.1.147
```

Scan a specific port:

```bash
sudo nmap -p2323 10.0.1.147
```

Useful options:

| Option | Meaning |
| --- | --- |
| `-sL` | List scan; list targets without port scanning |
| `-sn` | Ping scan; discover whether hosts are up |
| `-p2323` | Scan port `2323` |

## Quick Reference

| Task | Command |
| --- | --- |
| Ping a host | `ping google.com` |
| Ping every 5 seconds | `ping x.x.x.x -i 5` |
| Trace hops | `traceroute 4.2.2.4` |
| Download a file | `wget URL` |
| Save download with a name | `wget -O file.zip URL` |
| Show hostname | `hostname` |
| Change hostname | `sudo hostnamectl set-hostname NAME` |
| Show IP addresses | `ip addr` |
| Show routes | `ip route` |
| Add default gateway | `sudo ip route add default via 192.168.1.1` |
| Fetch URL with curl | `curl https://example.com` |
| Show HTTP headers | `curl -I https://example.com` |
| DNS lookup | `nslookup www.google.com` |
| Detailed DNS lookup | `dig google.com` |
| Show interfaces | `ip link show` |
| Show NetworkManager status | `nmcli general status` |
| Show resolver config | `cat /etc/resolv.conf` |
| Show routing table | `netstat -nr` |
| Show listening ports | `netstat -l` |
| Show port process | `sudo netstat -tulnp | grep PORT` |
| Listen with netcat | `nc -l 1337` |
| Find process using port | `sudo fuser 22/tcp` |
| Capture packets | `sudo tcpdump` |
| Show service port names | `cat /etc/services` |
| Install DHCP server | `sudo apt-get install isc-dhcp-server` |
| Scan subnet list | `sudo nmap -sL 10.0.1.0/24` |
| Ping-scan host | `sudo nmap -sn 10.0.1.147/32` |
| Scan one port | `sudo nmap -p2323 10.0.1.147` |


---

<!-- Source: permissions_users.md -->

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


---

<!-- Source: processes_system.md -->

# Linux System, Processes, and Monitoring Tutorial

| Directory     | Purpose                           | Real SRE Use Case                    |
| ------------- | --------------------------------- | ------------------------------------ |
| `/`           | Root of entire filesystem         | Everything starts here               |
| `/bin`        | Essential user binaries           | Commands like `ls`, `cp`, `mv`       |
| `/sbin`       | System/admin binaries             | Commands like `iptables`, `fsck`     |
| `/etc`        | Configuration files               | Edit configs for nginx, ssh, systemd |
| `/var`        | Variable/changing data            | Logs, caches, databases              |
| `/var/log`    | System/application logs           | Incident troubleshooting             |
| `/var/lib`    | Persistent app state/data         | Docker, Kubernetes, DB data          |
| `/var/tmp`    | Temporary files kept after reboot | Large temp operations                |
| `/tmp`        | Temporary runtime files           | Scripts, temp downloads              |
| `/home`       | User home directories             | User configs/files                   |
| `/root`       | Root user home directory          | Admin scripts/configs                |
| `/usr`        | User applications/libraries       | Installed software                   |
| `/usr/bin`    | Most user commands                | `python`, `curl`, `git`              |
| `/usr/sbin`   | Admin commands                    | Service/system binaries              |
| `/usr/local`  | Custom-installed software         | Internal tools/manual installs       |
| `/opt`        | Optional third-party software     | Vendor apps                          |
| `/dev`        | Device files                      | Disks, terminals, pseudo-devices     |
| `/proc`       | Kernel/process virtual filesystem | Runtime process inspection           |
| `/sys`        | Kernel/system hardware info       | Kernel tuning/debugging              |
| `/run`        | Runtime process state             | PID files/sockets                    |
| `/boot`       | Bootloader/kernel files           | Kernel upgrades                      |
| `/lib`        | Shared system libraries           | Needed binaries/libraries            |
| `/mnt`        | Temporary mounts                  | Manual mount testing                 |
| `/media`      | Removable media                   | USB mounts                           |
| `/srv`        | Service data                      | Web/data services                    |
| `/lost+found` | Recovered filesystem fragments    | After fsck recovery                  |


## Linux User Interfaces

Linux can be used through two main types of interfaces:

| Interface | Meaning |
| --- | --- |
| GUI | Graphical user interface |
| Shell | Command-line interface |

Common shell types include:

| Shell | Description |
| --- | --- |
| `sh` | Bourne shell / POSIX shell |
| `csh` | C shell |
| `ksh` | Korn shell |
| `bash` | Bourne Again Shell, common default on Linux |
| `zsh` | Z shell |

## Process Types

Linux runs different kinds of processes.

| Type | Description |
| --- | --- |
| User process | Started by a regular user and runs in user space |
| Daemon | Background process, often started at boot and managed as a service |
| Kernel process | Runs in kernel space and has access to kernel data structures |

## Environment Variables

An environment variable is available to the shell and to child processes started from that shell.

View all environment variables:

```bash
env
printenv
```

View a specific variable:

```bash
printenv SHELL
```

Example output:

```text
/bin/bash
```

Create an environment variable:

```bash
export COMPANYNAME="Goldman Sachs"
```

## Linux Directory Structure

Linux has a standard filesystem layout.

| Directory | Purpose |
| --- | --- |
| `/` | Root of the filesystem |
| `/bin` | Essential user binaries |
| `/sbin` | System binaries |
| `/etc` | Configuration files |
| `/dev` | Device files |
| `/proc` | Process and kernel information |
| `/var` | Variable files, logs, and runtime data |
| `/tmp` | Temporary files |
| `/usr` | User programs and shared resources |
| `/home` | User home directories |
| `/boot` | Bootloader and kernel files |
| `/lib` | System libraries |
| `/opt` | Optional add-on applications |
| `/mnt` | Temporary mount points |
| `/media` | Removable media mount points |
| `/srv` | Service data |

Your home directory holds the files and subdirectories you create.

## Linux File Types

Linux uses several file types.

| Type | Description |
| --- | --- |
| Ordinary files | Regular files |
| Directories | Files that contain references to other files and directories |
| Symbolic links | Shortcut-like files pointing to other files |
| Block and character devices | Device files, such as `/dev/sda` |
| Socket files | Files used for inter-process communication over sockets |
| Named pipes | Inter-process communication files without network socket semantics |

Show file types and permissions:

```bash
ls -l
```

## Firmware, BIOS, UEFI, and `/sys`

Firmware is low-level software that runs on hardware.

| Term | Meaning |
| --- | --- |
| BIOS | Older firmware interface |
| UEFI | Newer firmware interface |
| `/boot` | Stores boot-related Linux files |
| `/sys` | Virtual filesystem with system and hardware information |

Important `/sys` directories include:

```text
block
bus
class
dev
devices
firmware
fs
hypervisor
kernel
module
power
```

Examples:

| Path | Meaning |
| --- | --- |
| `/sys/block` | Block devices such as disks |
| `/sys/bus/cpu/devices` | CPU devices visible to the OS |
| `/dev` | Device files |
| `/proc` | Process and kernel information |

## Shell Startup Files

Common shell configuration files include:

| File | Purpose |
| --- | --- |
| `/etc/profile` | System-wide shell profile |
| `~/.bash_profile` | User login shell configuration |
| `~/.bash_login` | Alternative user login shell file |
| `~/.profile` | User profile file |
| `~/.bashrc` | Interactive Bash configuration, aliases, prompt, history |

## Hardware Inspection Commands

Show attached USB devices:

```bash
lsusb
```

Show PCI devices such as CPU bridges, VGA cards, and controllers:

```bash
lspci
```

Show disks, SSDs, partitions, and swap:

```bash
lsblk
```

Show detailed hardware and firmware information:

```bash
sudo lshw
```

Show kernel boot messages:

```bash
dmesg
```

Boot logs are often available in:

```text
/var/log/dmesg
```

## How Linux GUI Layers Work

A typical Linux GUI stack looks like this:

```text
Hardware
Kernel
Display Server
Desktop Manager or Window Manager
User
```

Examples:

| Component | Examples |
| --- | --- |
| Desktop manager | GNOME, KDE |
| Window manager | OpenBox, i3 |

GNOME is common on Ubuntu. KDE is common on some Arch Linux and Red Hat setups.

## Linux Time Basics

Computers have a hardware clock that continues working even when the machine is shut down.

NTP, or Network Time Protocol, lets a machine synchronize time from network time servers.

Set system time from an NTP server:

```bash
sudo ntpdate pool.ntp.org
```

Write the system time to the hardware clock:

```bash
sudo hwclock -w -u
```

Install and start NTP:

```bash
sudo apt install ntp
sudo systemctl start ntp
```

View NTP configuration:

```bash
cat /etc/ntp.conf
```

Chrony is another NTP implementation:

```bash
chronyc tracking
```

Change the system date:

```bash
sudo date -s "Jan 22 22:22:22 2022"
```

Show the current timezone:

```bash
cat /etc/timezone
```

Change the timezone by linking a timezone file:

```bash
sudo ln -s /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
```

## Job Control

The `jobs` command shows processes started from the current shell session.

Show background jobs with process IDs:

```bash
jobs -l
```

Show paused and background jobs:

```bash
jobs
```

Abort the current foreground process:

```text
Ctrl+C
```

Pause the current foreground process and move it into the background:

```text
Ctrl+Z
```

## Kill Processes

General syntax:

```bash
kill [signal_option] pid
```

Common signals:

| Signal | Number | Meaning |
| --- | --- | --- |
| `SIGHUP` | `1` | Tells a process its controlling shell is gone |
| `SIGTERM` | `15` | Requests graceful termination |
| `SIGKILL` | `9` | Forcefully kills a process |

Examples:

```bash
kill -1 PROCESS_ID
kill -15 PROCESS_ID
kill -9 PROCESS_ID
```

These two commands are equivalent:

```bash
kill -SIGKILL 63773
kill -9 63773
```

Kill processes by name:

```bash
pkill pyt
```

This kills processes with names that contain `pyt`.

## Process Viewers

Show running processes interactively:

```bash
top
```

Press `q` to quit `top`.

Use `htop` for a more visual process viewer:

```bash
htop
```

Set the refresh delay in `htop`:

```bash
htop -d 10
```

## Command History

Show command history:

```bash
history
```

Clear command history:

```bash
history -c
```

## File Type Inspection

Show what kind of file something is:

```bash
file my_file.py
```

## Reboot the System

Restart the system immediately:

```bash
sudo reboot
```

## Keep Processes Running with `nohup`

If a parent shell exits, child processes usually die with it. `nohup` allows a process to continue running after the shell closes.

Run a command with `nohup`:

```bash
nohup ping 4.4.5.1
```

By default, output is appended to:

```text
nohup.out
```

Run a script in the background and redirect output:

```bash
nohup script.sh > mynohup.out 2>&1 &
```

Explanation:

| Part | Meaning |
| --- | --- |
| `nohup script.sh` | Run the script and ignore hangups |
| `> mynohup.out` | Redirect standard output to a file |
| `2>&1` | Redirect standard error to the same place as standard output |
| `&` | Run in the background |

## Standard Streams and Redirection

Linux commands commonly use three standard streams:

| Number | Name | Meaning |
| --- | --- | --- |
| `0` | stdin | Standard input |
| `1` | stdout | Standard output |
| `2` | stderr | Standard error |

Redirect errors to `/dev/null`:

```bash
ls /examples/fakedir 2> /dev/null
```

`/dev/null` is a special file that discards anything written to it.

Redirect standard output and standard error to different files:

```bash
ls -l linefile fakefile > goodfile 2> badfile
```

In this example:

| Redirect | Meaning |
| --- | --- |
| `> goodfile` | Save stdout to `goodfile` |
| `2> badfile` | Save stderr to `badfile` |

## Stop the GUI

On systems using LightDM, stop the GUI service:

```bash
sudo service lightdm stop
```

## Uninstall Packages on Ubuntu

Remove a package and purge configuration files:

```bash
sudo apt-get remove --purge <PACKAGE_NAME>
```

## Change Hostname

Edit the hostname file:

```bash
sudo vi /etc/hostname
```

Update matching entries in `/etc/hosts`:

```bash
sudo vi /etc/hosts
```

Reboot for changes to take effect:

```bash
sudo reboot
```

## Manage Services with `systemctl`

`systemctl` manages `systemd`, the service manager used by many modern Linux distributions.

Check service status:

```bash
systemctl status sshd
```

Start, stop, and restart a service:

```bash
sudo systemctl start sshd
sudo systemctl stop sshd
sudo systemctl restart sshd
```

Enable a service at boot:

```bash
sudo systemctl enable sshd
```

Disable a service at boot:

```bash
sudo systemctl disable sshd
```

Reload systemd after changing service files:

```bash
sudo systemctl daemon-reload
```

## Built-In Commands

Built-in commands are part of the shell itself.

Check whether a command is built in or external:

```bash
type pwd
type who
```

Example output:

```text
pwd is a shell builtin
who is /usr/bin/who
```

## Process Status with `ps`

Show processes attached to the current terminal:

```bash
ps
```

Example output:

```text
PID TTY      TIME     CMD
1234 pts/0    00:00:00 bash
5678 pts/0    00:00:00 ps
```

Meaning:

| Column | Meaning |
| --- | --- |
| `PID` | Process ID |
| `TTY` | Terminal where the process is running |
| `TIME` | CPU time used |
| `CMD` | Command that started the process |

Show threads for processes attached to the current terminal:

```bash
ps -T
```

Show all processes:

```bash
ps -e
```

Count processes:

```bash
ps -e | wc -l
```

Show full-format process listing:

```bash
ps -ef
```

Show all processes with user-oriented details:

```bash
ps aux
```

Useful `ps aux` flags:

| Flag | Meaning |
| --- | --- |
| `a` | Show processes for all users |
| `u` | Display process owner |
| `x` | Include processes not attached to a terminal |

Show processes as a tree:

```bash
pstree
```

Find processes by name and kill them:

```bash
pgrep calc | xargs kill
```

## Memory and Uptime

Show memory and swap usage:

```bash
free
```

Show how long the system has been running:

```bash
uptime
```

Example output:

```text
16:12 up 16 days, 2:45, 2 users, load averages: 2.23 2.19 2.11
```

## Load Average

Load average helps show whether the system is keeping up with its workload.

View load average directly:

```bash
cat /proc/loadavg
```

Example:

```text
0.04 0.05 0.07
```

Meaning:

| Value | Time Period |
| --- | --- |
| `0.04` | Past 1 minute |
| `0.05` | Past 5 minutes |
| `0.07` | Past 15 minutes |

On a single-core system:

| Load | Meaning |
| --- | --- |
| `0.00` | System is mostly idle |
| `1.00` | One CPU core is fully busy |

On a two-core system, `2.00` means both CPU cores are fully busy.

Show CPU information:

```bash
cat /proc/cpuinfo
```

## Repeat Commands with `watch`

Run a command every two seconds:

```bash
watch df -h
```

To filter output, wrap the pipeline in quotes:

```bash
watch 'df -h | grep sda'
```

## `&&` vs `&`

Run the second command only if the first command succeeds:

```bash
command1 && command2
```

Run the first command in the background and immediately run the second command:

```bash
command1 & command2
```

Difference:

| Operator | Meaning |
| --- | --- |
| `&&` | Run the second command only if the first succeeds |
| `&` | Run the first command in the background |

## Resource Limits with `ulimit`

Show current resource limits:

```bash
ulimit
```

Show all limits:

```bash
ulimit -a
```

Show the maximum number of file handles allowed system-wide:

```bash
cat /proc/sys/fs/file-max
```

User limits can be configured in:

```bash
cat /etc/security/limits.conf
```

Example entries:

```text
<username> soft nofile 4096
<username> hard nofile 4096
```

## Show Services

Show available services:

```bash
sudo service --status-all
```

In this output:

| Symbol | Meaning |
| --- | --- |
| `+` | Service is running |
| `-` | Service is not running |

You can also inspect systemd status:

```bash
systemctl status
```

## The `/proc` Filesystem

`/proc` is a virtual filesystem created when the system boots. It contains process and kernel information and disappears when the system shuts down.

List process directories in `/proc`:

```bash
ls -l /proc | grep '^d'
```

Each process has a directory named after its PID.

Inspect a specific process directory:

```bash
ls -ltr /proc/3151
```

Options:

| Option | Meaning |
| --- | --- |
| `-l` | Long listing format |
| `-t` | Sort by modification time |
| `-r` | Reverse sort order |

## The `init` Process

`init` is the parent of all Linux processes and has PID `1`. It is the first process started at boot and runs until shutdown.

Traditional init configuration was stored in:

```text
/etc/inittab
```

Modern Linux systems usually use `systemd` instead.

## Stop PostgreSQL

Stop PostgreSQL with `systemctl`:

```bash
sudo systemctl stop postgresql
```

As a last resort, terminate processes by name:

```bash
sudo killall postgres
```

`killall` terminates processes by name rather than PID.

## Append to Root-Owned Files with `tee`

This command appends to `/etc/hosts` using root privileges:

```bash
echo 1.1.1.1 | sudo tee -a /etc/hosts
```

Explanation:

| Part | Meaning |
| --- | --- |
| `tee` | Reads stdin and writes to stdout and files |
| `-a` | Append instead of overwrite |
| `sudo` | Gives permission to write to the root-owned file |

Count files while also saving the list:

```bash
ls | tee listfile | wc -l
```

## Inotify Limits

`inotify` is a Linux kernel feature for watching filesystem events. Editors, IDEs, and file indexers may need high inotify limits.

Increase the maximum number of inotify instances:

```bash
sudo sysctl -w fs.inotify.max_user_instances=8192
```

Increase the maximum number of watched files:

```bash
sudo sysctl -w fs.inotify.max_user_watches=524288
```

To make these settings permanent, add them to a sysctl configuration file such as `/etc/sysctl.conf`.

## List Open Files with `lsof`

`lsof` means list open files. In Linux, many things are represented as files, including regular files, sockets, pipes, and devices.

Run `lsof`:

```bash
lsof
```

Show what process is using a directory:

```bash
lsof /run
```

Show files opened by a specific process:

```bash
lsof -p 890
```

Show files opened by a specific user:

```bash
lsof -u admin
```

Count open files for a user:

```bash
lsof -u USER | wc -l
```

List open files in the current directory, but not subdirectories:

```bash
lsof +d .
```

List open files in `/var/log` and its subdirectories:

```bash
lsof +D /var/log
```

If `lsof` does not show expected results, you may need `sudo`.

## Audit Rules with `auditctl`

`auditctl` controls the Linux audit system. The audit system uses rules to decide which events are captured in logs.

Set the maximum number of audit buffers:

```bash
sudo auditctl -b 8192
```

Set the rate of generated messages per second:

```bash
sudo auditctl -r 0
```

## File Descriptors

A file descriptor is a numeric handle used by the operating system to track open I/O resources.

File descriptors can represent:

- Regular files
- Network sockets
- Pipes and FIFOs
- Device files such as `/dev/null` and `/dev/random`

Each process has a limit on how many file descriptors it can open. If the limit is exceeded, you may see errors such as:

```text
Too many open files
```

Check the open-file limit with:

```bash
ulimit -n
```

## Find Executables with `which`

`which` locates the executable file that will run for a command by searching the directories in `PATH`.

Show all matching `touch` executables:

```bash
which -a touch
```

Example output:

```text
/usr/bin/touch
/bin/touch
```

`PATH` contains the ordered list of directories searched when running commands.

---
## `sudo apt update` vs `sudo apt-get update`

Both commands are used on Debian-based Linux distributions, such as Ubuntu, to update the local package index.

```bash
sudo apt update
sudo apt-get update
```

Updating the package index means your system downloads the latest information about available packages from configured repositories. This should usually be done before installing or upgrading packages.

### Main Differences

| Feature | `apt` | `apt-get` |
| --- | --- | --- |
| Age | Newer command-line interface | Older, established package tool |
| Best use | Interactive terminal use | Scripts and automation |
| Output | More user-friendly, often with progress bars and cleaner formatting | More stable and verbose output |
| Extra commands | Includes commands like `apt list`, `apt show`, and `apt edit-sources` | More focused on package management operations |

### When to Use Each One

Use `apt` when you are working manually in the terminal:

```bash
sudo apt update
sudo apt install nginx
```

Use `apt-get` when writing scripts or automation, because its behavior and output are more stable:

```bash
sudo apt-get update
sudo apt-get install -y nginx
```

---

## Run Scripts or Commands in the Background

There are several common ways to run scripts or commands in the background.

| Method | Best For |
| --- | --- |
| Cron jobs | Running scripts on a schedule |
| Systemd services | Running long-lived background services |
| `nohup` | Running a command that should continue after logout |

## Run a Command with `nohup`

`nohup` lets a command continue running even after you close the terminal or log out.

```bash
nohup psql -d mydb -c "SELECT * FROM my_table" > output.log &
```

Here is what each part means:

| Part | Meaning |
| --- | --- |
| `nohup` | Prevents the command from stopping after logout |
| `psql -d mydb` | Connects to the `mydb` PostgreSQL database |
| `-c "SELECT * FROM my_table"` | Runs the SQL query |
| `> output.log` | Saves output into `output.log` |
| `&` | Runs the command in the background |

---

## Create a Shell Script Without `vim` or `nano`

Sometimes a Docker container does not include text editors like `vim` or `nano`. You can still create and edit files using shell tools such as `cat`, `echo`, and output redirection.

### Create a Script with Multiple Lines

Use a heredoc to create a shell script and add several lines at once:

```bash
cat << 'EOF' > my-script.sh
#!/bin/bash
echo "Line 1"
echo "Line 2"
echo "Line 3"
EOF
```

What this does:

| Part | Meaning |
| --- | --- |
| `cat << 'EOF'` | Starts a heredoc block |
| `> my-script.sh` | Writes the block into `my-script.sh` |
| `EOF` | Marks the end of the content |

### Make the Script Executable

After creating the file, give it execute permission:

```bash
chmod +x my-script.sh
```

Now you can run it:

```bash
./my-script.sh
```
### Append More Lines to the Script

Use `>>` to add new lines to the end of the file:

```bash
echo 'echo "Line 4"' >> my-script.sh
echo 'echo "Line 5"' >> my-script.sh
```

The `>>` operator appends content. It does not remove the existing file content.

Be careful with `>` because it overwrites the file:

```bash
echo 'new content' > my-script.sh
```

---

## Quick Reference

| Task | Command |
| --- | --- |
| Show environment variables | `env` |
| Show one environment variable | `printenv SHELL` |
| Set an environment variable | `export NAME="value"` |
| Show USB devices | `lsusb` |
| Show PCI devices | `lspci` |
| Show block devices | `lsblk` |
| Show boot messages | `dmesg` |
| Show shell jobs | `jobs -l` |
| Kill a process gracefully | `kill -15 PID` |
| Force kill a process | `kill -9 PID` |
| Show processes | `ps aux` |
| Show process tree | `pstree` |
| Monitor processes | `top` |
| Show memory | `free` |
| Show uptime and load | `uptime` |
| Repeat a command | `watch 'df -h | grep sda'` |
| Show services | `sudo service --status-all` |
| Manage service | `sudo systemctl restart sshd` |
| Run after logout | `nohup script.sh > out.log 2>&1 &` |
| Discard errors | `command 2> /dev/null` |
| Append with sudo | `echo value | sudo tee -a /path/file` |
| Show open files | `lsof` |
| Show files opened by PID | `lsof -p PID` |
| Show file descriptor limit | `ulimit -n` |
| Locate command executable | `which -a command` |

---

<!-- Source: rsync.md -->

# Rsync Tutorial

`rsync` is a command-line tool for copying and synchronizing files or folders. It is useful for local backups, keeping two directories in sync, and copying files between machines over SSH.

## Install Rsync

On Debian or Ubuntu-based systems, install `rsync` with:

```bash
sudo apt-get install rsync
```

## Basic Folder Sync

This command copies all files from the `original` directory into the `backup` directory:

```bash
rsync original/* backup/
```

If you run the command several times, `rsync` does not copy unchanged files again. It checks what already exists in the destination and only transfers what is needed.

## Copy Directories Recursively

Use `-r` to copy folders inside the main folder, including the files inside those folders:

```bash
rsync -r original/ backup/
```

The trailing slash after `original/` matters. This command copies the contents of `original` into `backup`.

## Copy the Whole Directory

If you remove the trailing slash, `rsync` copies the whole `original` directory into the `backup` directory:

```bash
rsync -r original backup/
```

After running this, the destination will look like:

```text
backup/original/
```

## Preview Changes with Dry Run

A dry run shows what would be copied without actually changing any files:

```bash
rsync -rv --dry-run original/ backup/
```

Useful options:

| Option | Meaning |
| --- | --- |
| `-r` | Copy directories recursively |
| `-v` | Show detailed output |
| `--dry-run` | Preview the operation without copying files |

## Keep Two Folders Exactly in Sync

If files exist in `backup` but do not exist in `original`, use `--delete` to remove them from the backup:

```bash
rsync -r --delete original/ backup/
```

Be careful with `--delete`. It makes the destination match the source, which means extra files in the destination will be removed.

## Sync to a Remote Machine

You can copy a local folder to another machine over SSH:

```bash
rsync -zrP ~/folder1/folder2 username@xxx.xxx.xx.xxx:~/destination/folder/
```

Useful options:

| Option | Meaning |
| --- | --- |
| `-z` | Compress data during transfer |
| `-r` | Copy directories recursively |
| `-P` | Show progress and allow partial transfers |

The general format is:

```bash
rsync [options] source username@server-address:destination
```

## Sync from a Remote Machine to Local

You can also copy files from a remote machine back to your local machine:

```bash
rsync -zrP username@xxx.xxx.xx.xxx:~/original/folder ~/destination/folder
```

The general format is:

```bash
rsync [options] username@server-address:source destination
```

## Quick Reference

| Task | Command |
| --- | --- |
| Copy files into a backup folder | `rsync original/* backup/` |
| Copy folder contents recursively | `rsync -r original/ backup/` |
| Copy the whole folder into backup | `rsync -r original backup/` |
| Preview before copying | `rsync -rv --dry-run original/ backup/` |
| Delete destination files missing from source | `rsync -r --delete original/ backup/` |
| Sync local folder to remote machine | `rsync -zrP ~/folder1/folder2 username@xxx.xxx.xx.xxx:~/destination/folder/` |
| Sync remote folder to local machine | `rsync -zrP username@xxx.xxx.xx.xxx:~/original/folder ~/destination/folder` |


---

<!-- Source: sleep_delays.md -->

# Bash Sleep and Delays Tutorial

## What `sleep` Does

The `sleep` command pauses execution for a specified amount of time.

Basic syntax:

```bash
sleep NUMBER
```

Examples:

```bash
sleep 5
sleep 180
sleep 300
```

Common time values:

| Command | Delay |
| --- | --- |
| `sleep 5` | 5 seconds |
| `sleep 180` | 3 minutes |
| `sleep 300` | 5 minutes |

## Add a Delay in a Pipeline

When using piped commands, make sure the delay happens in the correct part of the command sequence.

This command runs a Kubernetes script, waits 3 minutes, and then pipes the combined output to `grep`:

```bash
(kubectl exec v-tools-1 -n v-operators-1 -- ./scripts/posting_failures.sh; sleep 180) | grep '"id":'
```

The parentheses create a command group:

```bash
(command1; command2) | command3
```

In this example:

| Part | Meaning |
| --- | --- |
| `kubectl exec ...` | Runs the script inside the Kubernetes pod |
| `sleep 180` | Waits for 3 minutes |
| `grep '"id":'` | Filters output lines containing `"id":` |

## Use a Temporary File

Another approach is to save command output to a temporary file, wait, and then process the file.

```bash
kubectl exec v-tools-1 -n v-operators-1 -- ./scripts/posting_failures.sh > temp_output.txt
sleep 180
grep '"id":' temp_output.txt
```

This workflow does three things:

1. Saves the script output into `temp_output.txt`
2. Waits for 3 minutes
3. Searches the saved output with `grep`

When you no longer need the temporary file, remove it:

```bash
rm temp_output.txt
```

## Add a Delay Between `curl` Requests with `xargs`

If you are using `xargs` to run one `curl` request per account ID, wrap the `curl` command and `sleep` command inside `bash -c`.

```bash
cat "$EXPORTED_FAILURES" \
  | jq -sr ".[] ${FAILURE_CONDITION} | .account_id" \
  | uniq \
  | xargs -I '{}' -n1 bash -c '
      curl -k "${REPOSTING_URL}:republish" \
        -X POST \
        -H "X-Auth-Token: ${REPOSTING_TOKEN}" \
        -H "Content-Type: Application/Json" \
        --data-binary "{\"account_id\": \"{}\",\"republish_type\": \"REPUBLISH_TYPE_REPUBLISH_FAILURES\"}"
      sleep 300
    '
```

The `sleep 300` command pauses for 5 minutes after each `curl` request.

Why `bash -c` is needed:

| Without `bash -c` | With `bash -c` |
| --- | --- |
| `xargs` runs one command at a time | You can run multiple commands per item |
| Harder to add `sleep` after each request | `curl` and `sleep` run together for each account ID |

## Use a `for` Loop Instead

A loop is often easier to read than a long `xargs` command.

First, extract the account IDs:

```bash
account_ids=$(cat "$EXPORTED_FAILURES" | jq -sr ".[] ${FAILURE_CONDITION} | .account_id" | uniq)
```

Then loop over each account ID:

```bash
for account_id in $account_ids; do
  curl -k "${REPOSTING_URL}:republish" \
    -X POST \
    -H "X-Auth-Token: ${REPOSTING_TOKEN}" \
    -H "Content-Type: Application/Json" \
    --data-binary "{\"account_id\": \"${account_id}\",\"republish_type\": \"REPUBLISH_TYPE_REPUBLISH_FAILURES\"}"

  sleep 300
done
```

This version is easier to modify and debug because each step is visible:

| Step | What Happens |
| --- | --- |
| `account_ids=...` | Collects account IDs from the exported failures file |
| `for account_id in ...` | Runs once for each account ID |
| `curl ...` | Sends the reposting request |
| `sleep 300` | Waits 5 minutes before the next request |

## Quick Reference

| Task | Command |
| --- | --- |
| Sleep for 3 minutes | `sleep 180` |
| Sleep for 5 minutes | `sleep 300` |
| Run two commands before a pipe | `(command1; command2) | command3` |
| Save output to a temp file | `command > temp_output.txt` |
| Search saved output | `grep '"id":' temp_output.txt` |
| Remove temp file | `rm temp_output.txt` |
| Run multiple commands per `xargs` item | `xargs -I '{}' bash -c 'command; sleep 300'` |
| Loop over values | `for item in $items; do command; sleep 300; done` |


---

<!-- Source: ssh.md -->

# SSH Command Tutorial

This guide collects common SSH workflows: connecting to remote machines, setting up passwordless login, copying files, running commands on multiple servers, and enabling GUI forwarding.

## 1. What Is SSH?

SSH stands for **Secure Shell**. It is a network protocol used to securely connect to a remote system from your local machine.

Basic syntax:

```bash
ssh [username]@[hostname_or_ip] -p [port_number]
```

Examples:

```bash
ssh my_user@my_hostname
ssh user1@test.server.com -p 3322
```

When connecting to a server for the first time, SSH may ask you to confirm the server fingerprint. Type `yes` to continue, then enter the password when prompted.

## 2. SSH Keys

SSH keys allow you to connect without typing a password every time.

There are two key files:

- **Private key**: stays on your local machine.
- **Public key**: goes on the remote machine.

Together, these are part of the SSH key-based authentication process.

Common SSH files:

| File | Purpose |
| --- | --- |
| `~/.ssh/id_rsa` | Private key. Keep this secret. |
| `~/.ssh/id_rsa.pub` | Public key. Copy this to remote servers. |
| `~/.ssh/known_hosts` | Stores trusted server host keys. |
| `~/.ssh/authorized_keys` | Remote-server file that lists public keys allowed to log in. |

## 3. Generate an SSH Key

Create a new RSA key pair:

```bash
ssh-keygen -t rsa -b 4096
```

Options used:

| Option | Meaning |
| --- | --- |
| `-t rsa` | Use the RSA algorithm. |
| `-b 4096` | Generate a 4096-bit key. |

When prompted:

1. Press `Enter` to save the key in the default location, usually `~/.ssh/id_rsa`.
2. Press `Enter` again if you do not want to set a passphrase.

After this, both key files should exist inside `~/.ssh`.

## 4. Set Up Passwordless SSH Manually

On the remote machine, create the `.ssh` directory:

```bash
mkdir .ssh
```

From your local machine, copy your public key to the remote machine:

```bash
scp ~/.ssh/id_rsa.pub username@remote_machine:/home/username/.ssh/uploaded_key.pub
```

Then, on the remote machine, append the uploaded key to `authorized_keys`:

```bash
cat ~/.ssh/uploaded_key.pub >> ~/.ssh/authorized_keys
```

The `~/.ssh/authorized_keys` file is required for key-based SSH login. It stores public keys that are allowed to authenticate without a password.

## 5. Fix SSH File Permissions

SSH is strict about permissions. On the remote machine, set the `.ssh` directory permissions:

```bash
chmod 700 ~/.ssh/
```

Permission meaning:

| Value | Owner | Group | Others |
| --- | --- | --- | --- |
| `700` | read, write, execute | none | none |

Set permissions for files inside `.ssh`:

```bash
chmod 600 ~/.ssh/*
```

Permission meaning:

| Value | Owner | Group | Others |
| --- | --- | --- | --- |
| `600` | read, write | none | none |

## 6. Easier Method: `ssh-copy-id`

Instead of manually creating `.ssh`, copying the public key, and updating `authorized_keys`, use:

```bash
ssh-copy-id my_user@my_hostname
```

After that, test the login:

```bash
ssh my_user@my_hostname
```

It should log in without asking for the account password.

## 7. Disable Password-Based SSH Login

After key-based authentication works, you can configure the remote machine to reject password logins.

Open the SSH server config on the remote machine:

```bash
sudo vi /etc/ssh/sshd_config
```

Find or add this setting:

```text
PasswordAuthentication no
```

Restart the SSH service:

```bash
sudo service ssh restart
```

Before closing your current SSH session, open a second terminal and confirm that key-based login still works. This helps avoid locking yourself out.

## 8. Strict Host Key Checking

SSH keeps a database of known host keys. By default, user-level host keys are stored in:

```text
~/.ssh/known_hosts
```

System-wide known hosts may also be checked in:

```text
/etc/ssh/ssh_known_hosts
```

If a host key changes, SSH warns you because the change could indicate server replacement, spoofing, or a man-in-the-middle attack.

To disable strict host key checking for a single command:

```bash
ssh -o StrictHostKeyChecking=no yourHardenedHost.com
```

To make it permanent for all hosts, edit `~/.ssh/config`:

```sshconfig
Host *
    StrictHostKeyChecking no
```

Use this carefully. Disabling strict host key checking makes SSH less protective against connecting to the wrong server.

To remove a trusted host from your known hosts file:

```bash
ssh-keygen -R 192.168.70.2
```

## 9. Jump Servers

A jump server is an intermediate server used to reach other machines.

Connection path:

```text
local machine -> jump server -> remote machine
                           -> remote machine
                           -> remote machine
```

For jump-server workflows, `ssh-agent` and `ssh-add` are often used so the jump server can authenticate to target servers using your local SSH key without copying your private key onto the jump server.

## 10. Run One Remote Command

Use SSH to run one command on a remote host, then exit:

```bash
ssh root@5.161.75.09 uptime
```

This logs in, runs `uptime`, prints the result, and closes the connection.

## 11. Upload Files with `scp`

Use `scp` to upload a file over SSH:

```bash
scp <file_to_upload> <username>@<hostname>:<destination_path>
```

Example:

```bash
scp app.log user1@test.server.com:/tmp/app.log
```

## 12. Parallel SSH With PSSH

PSSH lets you run SSH commands on multiple servers in parallel.

Install it:

```bash
sudo apt-get install pssh -y
```

Create a hosts file:

```bash
vi sshhosts
```

Example when all servers use the same username:

```text
192.168.1.70
192.168.1.71
192.168.1.72
192.168.1.73
```

Example when usernames are different:

```text
user1@192.168.1.70
user2@192.168.1.71
userX@192.168.1.72
user5@192.168.1.73
```

Run `df -h` on all hosts:

```bash
parallel-ssh -A -i -h sshhosts df -h
```

Options used:

| Option | Meaning |
| --- | --- |
| `-A` | Prompt for the remote password. |
| `-i` | Show stdout and stderr inline as each host completes. |
| `-h sshhosts` | Read target hosts from the `sshhosts` file. |

## 13. Run OS Patching

Run a patching script locally:

```bash
./MyCompany/code/lputils/linux/os_patches/lpospatching.sh -y
```

Run patching across several servers with PSSH:

```bash
pssh -h servers.in -t 600 -i '/MyCompany/code/lpospatching.sh -y'
```

Options used:

| Option | Meaning |
| --- | --- |
| `-h servers.in` | Read server list from `servers.in`. |
| `-t 600` | Set timeout to 600 seconds. |
| `-i` | Display output inline. |

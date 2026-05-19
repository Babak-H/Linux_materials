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


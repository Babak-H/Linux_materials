'''
fstab File Basics

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




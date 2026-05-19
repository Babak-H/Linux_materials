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

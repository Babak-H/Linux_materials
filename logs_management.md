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

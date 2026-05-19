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

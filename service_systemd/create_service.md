# Creating Linux Services with systemd

This tutorial shows how to create a simple Linux service with `systemd`, manage it with `systemctl`, inspect logs with `journalctl`, and schedule service execution with `systemd` timers.

The example service is intentionally simple: it prints the current time every second.

## 1. Create the Script

First, create a shell script. This script will be the program that `systemd` runs as a service.

```bash
touch pointless.sh
```

Add this content to `pointless.sh`:

```bash
#!/bin/bash

while true
do
    echo "current time is $(date)"
    sleep 1
done
```

This script runs forever and prints the current date and time once per second.

## 2. Make the Script Executable

Before `systemd` can run the script, give it execute permission:

```bash
chmod +x pointless.sh
```

If the script is stored in `/home/babak/pointless.sh`, the full path will be used in the service file.

## 3. Create a systemd Service File

System-wide service files are usually stored in:

```text
/etc/systemd/system
```

Move to that directory:

```bash
cd /etc/systemd/system
```

Create a service file. Service files should end with the `.service` extension:

```bash
sudo vi pointless.service
```

Add this content:

```ini
[Unit]
Description=My Pointless Service
After=network.target

[Service]
ExecStart=/home/babak/pointless.sh
Restart=always
WorkingDirectory=/home/babak
User=babak
Group=babak
Environment=GOPATH=/home/babak/go USERNAME=babak_g

[Install]
WantedBy=multi-user.target
```

## 4. Understand the Service File

The service file is split into sections.

### `[Unit]`

This section describes the service and its dependencies.

| Option | Meaning |
| --- | --- |
| `Description` | A human-readable description of the service. |
| `After=network.target` | Start this service after the network target has been reached. |

### `[Service]`

This section defines how the service runs.

| Option | Meaning |
| --- | --- |
| `ExecStart` | The command or script that starts the service. |
| `Restart=always` | Restart the service if it exits or fails. |
| `WorkingDirectory` | Directory where the service process should run. |
| `User` | Linux user that runs the service. |
| `Group` | Linux group that runs the service. |
| `Environment` | Environment variables available to the service. |

### `[Install]`

This section controls how the service is enabled.

| Option | Meaning |
| --- | --- |
| `WantedBy=multi-user.target` | Start this service as part of the normal multi-user system startup. |

## 5. Enable and Start the Service

Enable the service so it starts automatically at boot:

```bash
sudo systemctl enable pointless
```

Start the service now:

```bash
sudo systemctl start pointless
```

You can also use the full service name:

```bash
sudo systemctl start pointless.service
```

## 6. Check Service Status

To check whether the service is running:

```bash
sudo systemctl status pointless
```

This shows the service state, process ID, recent logs, and whether the service is enabled.

## 7. View Service Logs

On some systems, general system logs are stored in `/var/log/syslog`:

```bash
sudo tail /var/log/syslog
```

The standard way to view logs for a `systemd` service is `journalctl`:

```bash
sudo journalctl -u pointless
```

Follow the logs in real time:

```bash
sudo journalctl -u pointless -f
```

## 8. Stop or Disable the Service

Stop the service:

```bash
sudo systemctl stop pointless
```

Disable the service so it no longer starts automatically at boot:

```bash
sudo systemctl disable pointless
```

## 9. Reload systemd After Changes

If you edit the service file, reload the `systemd` manager configuration:

```bash
sudo systemctl daemon-reload
```

Then restart the service:

```bash
sudo systemctl restart pointless
```

## 10. Schedule Services with systemd Timers

`systemd` timers work similarly to cron jobs, but they integrate directly with `systemd` services and logs.

For example, if you have this service:

```text
/etc/systemd/system/backup.service
```

You can create a matching timer:

```bash
sudo vi /etc/systemd/system/backup.timer
```

Add this content:

```ini
[Unit]
Description=Run the backup service on the first Saturday of every month

[Timer]
OnCalendar=Sat *-*-1..7 02:42:00
Persistent=true

[Install]
WantedBy=timers.target
```

This timer runs the backup service at `2:42 AM` on the first Saturday of every month.

## 11. Understand the Timer File

| Option | Meaning |
| --- | --- |
| `OnCalendar=Sat *-*-1..7 02:42:00` | Run on Saturday when the day of the month is between `1` and `7`, at `02:42:00`. |
| `Persistent=true` | If the system was off when the timer should have run, run it after the system comes back up. |
| `WantedBy=timers.target` | Enable this timer as part of the system timer target. |

Enable and start the timer:

```bash
sudo systemctl enable backup.timer
sudo systemctl start backup.timer
```

## 12. List Active Timers

To see all active `systemd` timers:

```bash
systemctl list-timers
```

This shows the next run time, last run time, timer unit, and service unit.

## 13. Run Temporary Timers with systemd-run

You can also create temporary timers directly from the terminal.

Run a service every two hours:

```bash
systemd-run --on-active="2hours" --unit="my-test-serv.service"
```

Run a script every three hours:

```bash
systemd-run --on-active="3hours" /usr/local/bin/test-script.sh
```

These commands are useful for quick tests or one-off scheduled tasks.

## Quick Command Reference

| Task | Command |
| --- | --- |
| Enable a service at boot | `sudo systemctl enable pointless` |
| Start a service | `sudo systemctl start pointless` |
| Check service status | `sudo systemctl status pointless` |
| Stop a service | `sudo systemctl stop pointless` |
| Disable a service at boot | `sudo systemctl disable pointless` |
| Reload systemd after file changes | `sudo systemctl daemon-reload` |
| View service logs | `sudo journalctl -u pointless` |
| Follow service logs | `sudo journalctl -u pointless -f` |
| List timers | `systemctl list-timers` |

## Typical Workflow

1. Create the script.
2. Make the script executable with `chmod +x`.
3. Create a `.service` file in `/etc/systemd/system`.
4. Run `sudo systemctl daemon-reload`.
5. Enable the service with `sudo systemctl enable service-name`.
6. Start the service with `sudo systemctl start service-name`.
7. Check status with `sudo systemctl status service-name`.
8. Inspect logs with `sudo journalctl -u service-name`.

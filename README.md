systematic approach to diagnosing and resolving high disk usage when the obvious culprits (logs/temp) are already cleared:

---

## 1. Re-identify What's Actually Consuming Space

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

---

## 2. Check for Deleted-but-Still-Open Files

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

---

## 3. Check Inode Exhaustion

You can run out of **inodes** (file slots) even if disk bytes are free — `df` will show 100% usage on the inode count:

```bash
df -i          # Check inode usage across all filesystems
```

**Fix:** Look for directories with millions of tiny files (mail spools, session files, cache):
```bash
find / -xdev -printf '%h\n' | sort | uniq -c | sort -rn | head -20
```

---

## 4. Check for Large Core Dumps

Applications that crash leave large core dump files:

```bash
find / -name "core" -o -name "core.[0-9]*" 2>/dev/null
ls -lh /var/lib/systemd/coredump/
journalctl --disk-usage        # systemd journal size
```

**Fix:**
```bash
# Clear systemd journal (keep last 2 days)
journalctl --vacuum-time=2d

# Clear core dumps
systemd-tmpfiles --clean
```

---

## 5. Old Kernel Versions (on Ubuntu/Debian)

Old kernels accumulate over time:

```bash
dpkg --list | grep linux-image
uname -r       # Current kernel

# Remove old kernels safely
apt autoremove --purge
```

---

## 6. Docker / Container Leftovers

If Docker is installed, it can quietly consume massive amounts:

```bash
docker system df           # See how much Docker is using
docker system prune -a     # Remove unused images, containers, volumes
```

---

## 7. Snap Package Leftovers (Ubuntu)

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

## 8. Hidden Files in Mount Points

If a directory was used as a mount point and files were written to it while **nothing was mounted**, those files are hidden once the filesystem mounts on top:

```bash
# Temporarily unmount and check
umount /mountpoint
ls -la /mountpoint     # Now you'll see the hidden files
```

---

## 9. Large Files Anywhere on the System

```bash
# Find all files larger than 1GB
find / -xdev -size +1G -ls 2>/dev/null

# Find files larger than 500MB
find / -xdev -size +500M -type f 2>/dev/null | sort -k 7 -rn
```

---

## 10. Check Filesystem-Reserved Space

By default, ext4 reserves **5% of disk space** for root. On large disks, this can be gigabytes:

```bash
tune2fs -l /dev/sda1 | grep -i "reserved"

# Reduce reserved space to 1% (safe on non-root partitions)
tune2fs -m 1 /dev/sda1
```

---

## Quick Decision Tree

```
High disk usage after clearing logs/tmp
        │
        ├─► lsof +L1 ──────────────► Deleted files still open? → Restart service
        ├─► df -i ──────────────────► Inodes full? → Remove millions of tiny files
        ├─► docker system df ───────► Docker bloat? → docker system prune
        ├─► find / -size +500M ─────► Rogue large file? → Investigate & delete
        └─► ncdu / ─────────────────► Visual drill-down to find the culprit
```

The **lsof +L1** trick for deleted-but-open files and **inode exhaustion** are the two most frequently overlooked causes in production systems.

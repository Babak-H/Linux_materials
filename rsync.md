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


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

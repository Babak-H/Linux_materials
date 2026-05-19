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

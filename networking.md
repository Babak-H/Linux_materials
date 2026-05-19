# Linux Networking Tutorial

## Test Connectivity with `ping`

`ping` means Packet Internet Groper. It uses ICMP to send packets to a host and wait for a response.

Syntax:

```bash
ping [option] [hostname_or_ip_address]
```

Ping a domain:

```bash
ping google.com
```

Ping an IP address every 5 seconds:

```bash
ping x.x.x.x -i 5
```

## Trace Network Hops with `traceroute`

`traceroute` shows the path packets take to reach a destination. Each step in the path is called a hop.

```bash
traceroute 4.2.2.4
```

This is useful when you want to see where traffic is going or where a connection may be failing.

## Download Files with `wget`

`wget` downloads files from the internet.

Syntax:

```bash
wget [option] [url]
```

Download a file:

```bash
wget https://wordpress.org/latest.zip
```

Save the downloaded file with a different name:

```bash
wget -O latest-hugo.zip https://github.com/gohugoio/hugo/archive/master.zip
```

Download a file into a specific directory:

```bash
wget -P /mnt/iso http://mirrors.mit.edu/centos/7/isos/x86_64/CentOS-7-x86_64-Minimal-1804.iso
```

Limit download speed:

```bash
wget --limit-rate=1m https://dl.google.com/go/go1.10.3.linux-amd64.tar.gz
```

Useful options:

| Option | Meaning |
| --- | --- |
| `-O` | Save output with a specific filename |
| `-P` | Save output in a specific directory |
| `--limit-rate=1m` | Limit download speed to 1 MB per second |

## View and Change Hostname

The hostname is the machine name on the network.

Show the current hostname:

```bash
hostname
```

Print IP addresses associated with the hostname:

```bash
hostname -i
```

Show hostname aliases:

```bash
hostname -a
```

View the persistent hostname:

```bash
cat /etc/hostname
```

Change the machine name:

```bash
sudo hostnamectl set-hostname babak
```

## Map Hostnames with `/etc/hosts`

The `/etc/hosts` file maps IP addresses to hostnames locally.

Open the file:

```bash
sudo vim /etc/hosts
```

Example entries:

```text
172.167.2.45 dummyhost
127.0.0.1 gaming.ir
```

The first line lets you use `dummyhost` instead of the IP address.

The second line points `gaming.ir` to the local machine. This can be used to block access to a site from that machine.

Test the custom hostname:

```bash
ping dummyhost
```

## Inspect IP Addresses and Routes

Show IP addresses:

```bash
ip addr
```

Show routing table:

```bash
ip route
```

Add a default gateway:

```bash
sudo ip route add default via 192.168.1.1
```

## Transfer Data with `curl`

`curl` is a client for URLs. It transfers data using many protocols, including HTTP and HTTPS.

Fetch a page:

```bash
curl https://www.google.com
```

Show only HTTP response headers:

```bash
curl -I https://www.google.com
```

Example output:

```text
HTTP/1.1 200 OK
Date: Tue, 24 Oct 2023 17:30:12 GMT
Content-Type: text/html; charset=UTF-8
Content-Length: 1256
Server: nginx
```

Add a custom HTTP header:

```bash
curl -H "X-Header: value" https://www.example.com
```

Send a JSON POST request:

```bash
curl -X POST \
  -H "Content-Type: application/json" \
  -H "X-Custom: abc" \
  -d '{"name": "John"}' \
  https://example.com/api
```

Useful options:

| Option | Meaning |
| --- | --- |
| `-I` | Send a HEAD request and show headers only |
| `-H` | Add a custom header |
| `-X` | Specify the HTTP method |
| `-d` | Send request body data |

## Download and Install an APT GPG Key with `curl`

This example downloads a Kubernetes package signing key and converts it for APT:

```bash
curl -fsSL https://pkgs.k8s.io/core:/stable/v1.31/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
```

Explanation:

| Part | Meaning |
| --- | --- |
| `-f` | Fail on HTTP server errors |
| `-s` | Silent mode |
| `-S` | Show errors even in silent mode |
| `-L` | Follow redirects |
| `gpg` | GNU Privacy Guard |
| `--dearmor` | Convert ASCII-armored key to binary format |
| `-o` | Write output to a specific file |

## DNS Lookups with `nslookup`

`nslookup` queries DNS servers.

Syntax:

```bash
nslookup [-option] [name] [server]
```

Look up a domain:

```bash
nslookup www.google.com
```

Look up name servers:

```bash
nslookup -type=ns google.com
```

Look up mail exchange records:

```bash
nslookup -type=mx yahoo.com
```

## Network Interfaces

NIC means network interface card. Linux interface names may look like:

```text
wlan0
eno1
ens1
enp3s2
```

View network interfaces and their status:

```bash
ip link show
```

Show IP addresses:

```bash
ip addr show
```

Install older networking tools if needed:

```bash
sudo apt install net-tools
```

Show detailed interface information:

```bash
ifconfig
```

Shut down a network interface:

```bash
sudo ifconfig <NETWORK_CARD> down
```

Network interface configuration may be found in:

```text
/etc/network/interfaces
```

## NetworkManager with `nmcli`

Show general NetworkManager status:

```bash
nmcli general status
```

Show network devices:

```bash
nmcli device
```

## DNS Configuration Files

Show local DNS resolver configuration:

```bash
cat /etc/resolv.conf
```

Show name service lookup order:

```bash
cat /etc/nsswitch.conf
```

Example entry:

```text
passwd: files systemd
```

This means the system checks local files first, then `systemd`, when resolving passwd information.

## Inspect Network Connections with `netstat`

`netstat` shows network connections, routing tables, and interface statistics.

Show the routing table:

```bash
netstat -nr
```

Show active ports and connections:

```bash
netstat -na
```

Show listening ports:

```bash
netstat -l
```

Check which process is listening on a specific TCP or UDP port:

```bash
sudo netstat -tulnp | grep <PORT_NUMBER>
```

Useful options:

| Option | Meaning |
| --- | --- |
| `-t` | Show TCP connections |
| `-u` | Show UDP connections |
| `-l` | Show listening sockets |
| `-n` | Show numeric addresses and ports |
| `-p` | Show PID and process name |
| `-r` | Show routing table |
| `-a` | Show all sockets |

## Clean Up `netstat` Output

Remove the first two header lines:

```bash
netstat -nutl | grep -v '^Active' | grep -v '^Proto'
```

Extract listening port numbers:

```bash
netstat -nutl | grep ':' | awk '{print $4}' | awk -F ':' '{print $NF}'
```

Count listening ports:

```bash
netstat -nutl | grep ':' | awk '{print $4}' | awk -F ':' '{print $NF}' | sort -n | uniq -c
```

In the `awk` command:

| Part | Meaning |
| --- | --- |
| `$NF` | Last field in the line |
| `{print $NF}` | Print the last field |
| `-F ':'` | Use `:` as the field separator |

## Listen on a Port with `nc`

`nc`, or netcat, can open network connections and listen on ports.

Listen on port `1337`:

```bash
nc -l 1337
```

## Find Which Process Uses a Port with `fuser`

`fuser` shows which process is using a file, socket, or port.

Find the process using TCP port `22`:

```bash
sudo fuser 22/tcp
```

## DNS Lookups with `dig`

`dig` is a DNS lookup tool.

```bash
dig google.com
```

It shows how a domain name resolves to IP addresses and provides detailed DNS response information.

## Capture Traffic with `tcpdump`

Show TCP traffic passing through the machine:

```bash
sudo tcpdump
```

You usually need `sudo` because packet capture requires elevated permissions.

## Capture HTTP Traffic with `tcpflow`

Capture and display HTTP traffic on port `80`:

```bash
sudo tcpflow -c port 80
```

The `-c` option prints captured data to the terminal.

## DNS Record Types

DNS records map names to network information.

| Record | Meaning |
| --- | --- |
| `A` | IPv4 address for a host |
| `AAAA` | IPv6 address for a host |
| `MX` | Mail server address for a domain |

An `A` record maps a domain name to an IPv4 address.

Example:

```text
www.dnsimple.com -> 208.93.64.253
```

## Name Lookups with `getent`

`getent` queries the system's configured name services, such as `/etc/hosts`, DNS, or LDAP.

Show localhost entries:

```bash
getent hosts localhost
```

Show host entries:

```bash
getent hosts
```

Look up a domain:

```bash
getent hosts google.com
```

Example result:

```text
142.250.190.78 google.com
```

## Service and Port Names

Show known ports and related services:

```bash
cat /etc/services
```

## DHCP Basics

DHCP means Dynamic Host Configuration Protocol. It automatically assigns IP addresses to client systems on a network.

Instead of manually assigning IP addresses to many machines, a DHCP server manages an IP range, also called a scope, and distributes addresses to clients.

Install a DHCP server on Ubuntu:

```bash
sudo apt-get install isc-dhcp-server
```

## Network Scanning with `nmap`

List hosts in a subnet:

```bash
sudo nmap -sL 10.0.1.0/24
```

Find a host that contains `nixos` in the scan output:

```bash
sudo nmap -sL 10.0.1.0/24 | grep nixos
```

Ping-scan a specific host:

```bash
sudo nmap -sn 10.0.1.147/32
```

Scan all common ports on a host:

```bash
sudo nmap 10.0.1.147
```

Scan a specific port:

```bash
sudo nmap -p2323 10.0.1.147
```

Useful options:

| Option | Meaning |
| --- | --- |
| `-sL` | List scan; list targets without port scanning |
| `-sn` | Ping scan; discover whether hosts are up |
| `-p2323` | Scan port `2323` |

## Quick Reference

| Task | Command |
| --- | --- |
| Ping a host | `ping google.com` |
| Ping every 5 seconds | `ping x.x.x.x -i 5` |
| Trace hops | `traceroute 4.2.2.4` |
| Download a file | `wget URL` |
| Save download with a name | `wget -O file.zip URL` |
| Show hostname | `hostname` |
| Change hostname | `sudo hostnamectl set-hostname NAME` |
| Show IP addresses | `ip addr` |
| Show routes | `ip route` |
| Add default gateway | `sudo ip route add default via 192.168.1.1` |
| Fetch URL with curl | `curl https://example.com` |
| Show HTTP headers | `curl -I https://example.com` |
| DNS lookup | `nslookup www.google.com` |
| Detailed DNS lookup | `dig google.com` |
| Show interfaces | `ip link show` |
| Show NetworkManager status | `nmcli general status` |
| Show resolver config | `cat /etc/resolv.conf` |
| Show routing table | `netstat -nr` |
| Show listening ports | `netstat -l` |
| Show port process | `sudo netstat -tulnp | grep PORT` |
| Listen with netcat | `nc -l 1337` |
| Find process using port | `sudo fuser 22/tcp` |
| Capture packets | `sudo tcpdump` |
| Show service port names | `cat /etc/services` |
| Install DHCP server | `sudo apt-get install isc-dhcp-server` |
| Scan subnet list | `sudo nmap -sL 10.0.1.0/24` |
| Ping-scan host | `sudo nmap -sn 10.0.1.147/32` |
| Scan one port | `sudo nmap -p2323 10.0.1.147` |


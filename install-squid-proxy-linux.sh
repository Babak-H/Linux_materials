#!/bin/bash

# Install Squid Proxy 
# Squid Proxy proxy is a middle man that processes outgoing requests on your behalf.
# there are two types of proxy: HTTP(S) Proxy | Socket Secure Proxy (SOCKS)

# # Https proxy benefits: anonymity, access region locked content, monitor web traffic, can block content on proxy's config, won't expose client metadata to the server

# install squid
sudo apt install squid

# Make copy of squid.conf 
sudo cp /etc/squid/squid.conf /etc/squid/squid.conf.default

# Edit squid.conf 
sudo vi /etc/squid/squid.conf
# uncomment this section:   "http_access allow localnet"

# restart Squid
sudo systemctl restart squid

# Check if its running 
if systemctl is-active --quiet squid; then
 :
else
 sudo systemctl start squid
fi

# to do it manually
sudo systemctl status squid

# Configure Proxy in Postman and test (Settings, then Proxy tab). Add IP of Proxy Server, then default port (3128)

# Check Access log for entries
sudo tail /var/log/squid/access.log

# Add basic user / password for authentication
sudo vi /etc/squid/squid.conf
# add these lines in the ACL section of the file
    # auth_param basic program /usr/lib/squid/basic_ncsa_auth /etc/squid/htpasswd
    # auth_param basic realm Squid Proxy Caching Web Server
    # acl authenticated proxy_auth REQUIRED
    # acl authenticated_ips src {{CLIENT_IP_ADDRESS}}/32
    # http_access allow authenticated authenticated_ips

# Run the following replacing “username” and “password” accordingly, they will be saved in this file => /etc/squid/htpasswd
sudo printf "USERNAME:$(openssl passwd PASSWORD)\n" | sudo tee -a /etc/squid/htpasswd

# restart Squid
sudo systemctl restart squid

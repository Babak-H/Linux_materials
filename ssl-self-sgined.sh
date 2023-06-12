# ssl certificates are written in x509 standard

# certificate target, is the address of the website that the client will send data to, this should be predefined
        # DNS Name=hello-world.com
        # DNS Name=*.hello-world.com
        # DNS Name=sni.cloudflaressl.com

# certificate validation duration, defined via "Valid from" and "Valid to" parameters

# certificate chain, the order of the location of the certificate CA, you can find it in "certificate path"
# the browswer will check the certificate back to the root CA, to make sure it is trusted, usually public root certificates are saved on the device itself
        # Root CA
        # Intermediate CA
        # Server Certificate

# when you have a self-signed certificate, you should add it to the trusted root certificates on the device, so the device will trust it.

##############################################################################

# genrate an RSA private key
# this will encrypt the private key with AES256, we can use this key to generate ssl certificates
# create a pass phrase for the pem file, it is needed when generateing the public keys later
openssl genrsa -out -aes256 ca-key.pem 4096

# generate a public CA certificate, using private certificate
# use the passphrase entered in the previous step
# it asks for some generic information, but it is not important what you enter here, Issuer Details
openssl req -new -x509 -days 3650 -sha256 -key ca-key.pem -out ca.pem

# view the public certificate
openssl x509 -in ca.pem -text -noout

##############################################################################

# create the self-signed certificate private key, no need to encrypt it here
openssl genrsa -out cert-key.pem 4096

# create a certificate signing request, this is the file that you send to the CA to sign
openssl req -new -sha256 -subj "/CN=hello-world.com" -key cert-key.pem -out cert.csr

# in this configuration file, we eneter the DNS name and IP addresses that we want to be in the certificate target
echo "subjectAltName=DNS:*.hello-world.com,IP:10.0.0.5" >> extfile.cnf

# create the SSL certificate, using public/private CA keys, CA sign request, certificate config file, outputting it into "cert.pem" file
# enter the passphrase for the CA private key (from first step)
openssl x509 -req -sha256 -days 3650 -in cert.csr -CA ca.pem -CAkey ca-key.pem -out cert.pem -extfile extfile.cnf -CAcreateserial

##############################################################################

# now add both CA and certificate to one file, the certificate chain file:
cat cert.pem >> fullchain.pem
cat ca.pem >> fullchain.pem

# now add the cert into trusted certificates of the client device, the process in linux:
cp ca.pem /usr/local/share/ca-certificates/ca.crt
sudo update-ca-certificates
# RAMP IoT Platform
RAMP IoT Plarform is FIWARE installation to be installed on factory premises and is connected with RAMP marketplace. This is 
template platform setup with minumial configurations to get you started. RAMP IoT platform is implemented using FIWARE generic enablers. 
Basic set of FIWARE components are included as Dockerised components. 

## Prerequisite
RAMP IoT platform runs in Docker containers and hence Docker and Docker-Compose are required. Machine where IoT platform can be either virtual machine or real computer, but it needs to have sufficient resources. Environment requires these _minimum_ resources:
- 4GB RAM (Hard minum limit, more is better)
- 60GB Disk space (more as needed for the data that is being stored)
- 4 CPU's (less can work but results in performance loss)

## Quick start
1. Install Ubuntu (at least 20LTS version or newer) to machine with minumum specification from last chapter. 
2. Clone this repository to the computer 
```
git clone https://github.com/karikolehmainen/RAMP-IoT.git
````
3. Run the install script from cloned repository 
```
cd RAMP-IoT
sudo ./install.sh
````
4. verify that containers are up once the install script finishers. Command is ```sudo docker ps``` you should see all container started and what ports they use


## Installation
install.sh shell script install all requisites (uses Debian package manager) and launches docker containers with 
basic configuations. Some environment configurations are done in order to run timeseries database efficiently. Most crucial 
modification is to increase vm.max_map_count to 262144. An other one is to define maximum log file size for docker. These are 
done by install script and if you do not wish to use it, you need to do those manually.

## TLS and Encryption
Communication between components is using TLS encryption. If interfaces are to be exposed to public networks, valid certificates should be used.
For internal use, self-signed (or even unsecured) access might be also applicable. Please note that some systems may not work with self-signed certiface if they 
try to validate the certificates. 

Certificates should be placed in 
```
/etc/cert
```
directory on the host machine and named as server.crt (public key) and server.key (private.key). Or docker-compose.yml file may be modifed to use what ever certificates you have in place

### Creating Self-Signed Certificates
First create Certificate Authority (CA) files with commands:
````
openssl req -x509 \
            -sha256 -days 356 \
            -nodes \
            -newkey rsa:2048 \
            -subj "/CN=<domain or IP>/C=US/L=San Fransisco" \
            -keyout rootCA.key -out rootCA.crt
````
Where <domain or IP> is the domain or IP address of the machine where IoT platform is running. 
Next create server private key file:
  ````
  openssl genrsa -out server.key 2048
  ````
  
Then create configuration file for certficate signing request (can be also given from command prompt):
`````
cat > csr.conf <<EOF
[ req ]
default_bits = 2048
prompt = no
default_md = sha256
req_extensions = req_ext
distinguished_name = dn

[ dn ]
C = <country>
ST = <state>
L = <city>
O = <organization name>
OU = <organization unit name>
CN = <domain name>

[ req_ext ]
subjectAltName = @alt_names

[ alt_names ]
DNS.1 = <domain name 1>
DNS.2 = <domain name n>
IP.1 = <IP 1>
IP.2 = <IP n> 

EOF
`````
Replace the information fields with data that is relevant to your company. You can then use the configuration file with server private key to easily create certificate signing request:
  ````
  openssl req -new -key server.key -out server.csr -config csr.conf
  ````
Up until this point these steps also apply for creating fully authorised certificate, you can use server private key and and certificate signing request (CSR) to apply for certificate from 
public authority. 
  
Next you can create certificate configuration file:
````
cat > cert.conf <<EOF

authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names

[alt_names]
DNS.1 = <domain name>

EOF
````
Finally you can create the server public key using the above created files:
  ````
  openssl x509 -req \
    -in server.csr \
    -CA rootCA.crt -CAkey rootCA.key \
    -CAcreateserial -out server.crt \
    -days 365 \
    -sha256 -extfile cert.conf
  ````
 
## Key Elements
RAMP IoT platform provides set of FIWARE Generic Enablers ready to be used as IoT platform. Here is a list of key components with their interfaces:
* Port 1026 Orion Context Broker without PEP (Policy Enforcement Point) Proxy
* Port 1027 PEP Proxy port to Orion (OAuth2 token is required) 
* Port 3000 Grafana data visualisation. Pre-configured Grafana instance for connecting to timeseries data
* Port 4041 IoT Agent port. This is the port to which sensors should be sending data. FIWARE IoT Agent documentation is recommended read
* Port 4200 Crate timeseries database management interface. This is for monitoring database health and performance
* Port 5432 PostgreSQL port. Crate is basically interface for PostgreSQL and actual data is located in PostgreSQL database
* Port 8088 Keyrock interface. Keyrock can offer OAuth2 authentication service if other service is not used

## Notes
If you ran out of diskspace in your enviroment system obviously stops working. To recover from that, you need to free some space. 
That most likely is not enough for continuing to collect timeseries data. You need to alter Crate table property 
blocks.read_only_allow_delete which is set TRUE when system runs out of diskspace. This you can do from Crate web-interface at 
localhost port 4200

Docker installed with snap -package manager does not work and local database storages are not being created. Docker-compose complains /opt/rampiot being read-only file system. Fix to this issue is to remove docker with "snap remove docker" and use this install script or manual install using offcial package manager apt or apt-get





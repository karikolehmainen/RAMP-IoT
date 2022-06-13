# RAMP IoT Platform
RAMP IoT Plarform is FIWARE installation to be installed on factory premises and is connected with RAMP marketplace. This is 
template platform setup with minumial configurations to get you started.

## Prerequisite
RAMP IoT platform runs in Docker containers and hence Docker and Docker-Compose are required

## Installation
install.sh shell script install all requisites (uses Debian package manager) and launches docker containers with 
basic configuations. Some environment configurations are done in order to run timeseries database efficiently. Most crucial 
modification is to increase vm.max_map_count to 262144. An other one is to define maximum log file size for docker. These are 
done by install script and if you do not wish to use it, you need to do those manually.

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





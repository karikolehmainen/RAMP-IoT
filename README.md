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

## Notes
If you ran out of diskspace in your enviroment system obviously stops working. To recover from that, you need to free some space. 
That most likely is not enough for continuing to collect timeseries data. You need to alter Crate table property 
blocks.read_only_allow_delete which is set TRUE when system runs out of diskspace. This you can do from Crate web-interface at 
localhost port 4200






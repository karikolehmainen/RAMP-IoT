#!/bin/bash

#
# Ramp Installation Script
#

IFS=$(printf '\n\t')

#
# Configure Grafana datasource 
#
sudo mkdir /etc/grafana
sudo cp -r provisioning /etc/grafana/
# Docker
if [[ $(docker -v) == *" 20.10."* ]]; then
    echo 'Docker version sufficient'
else
    echo 'Docker update needed'
	sudo apt remove --yes docker docker-engine docker.io containerd runc
	sudo apt update
	sudo apt --yes --no-install-recommends install apt-transport-https ca-certificates
	wget --quiet --output-document=- https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
	sudo add-apt-repository "deb [arch=$(dpkg --print-architecture)] https://download.docker.com/linux/ubuntu $(lsb_release --codename --short) stable"
	sudo apt update
	sudo apt --yes --no-install-recommends install docker-ce docker-ce-cli containerd.io
	sudo usermod --append --groups docker "$USER"
	sudo systemctl enable docker
	printf '\nDocker installed successfully\n\n'
	printf 'Waiting for Docker to start...\n\n'
	sleep 5
fi

# Docker Compose
if [[ $(docker-compose version) == *" 1.29."* ]]; then
    echo 'Docker version sufficient'
else
	sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
	sudo chmod +x /usr/local/bin/docker-compose
	printf '\nDocker Compose installed successfully\n\n'

	sleep 5
fi
#
# Copy docker daemon conf file
#
cp daemon.json /etc/docker/


printf 'Launch RAMP IoT platform containers...\n\n'
export RAMP_PATH=/opt/rampiot

sudo sysctl -w vm.max_map_count=262144
sudo docker-compose up -d



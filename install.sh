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
currentver="$(docker-compose --version | cut -d' ' -f4)"
requiredver="2.2.3"
if [ "$(printf '%s\n' "$requiredver" "$currentver" | sort -V | head -n1)" = "$requiredver" ]; then 
	echo "Docker-Compose Greater than or equal to ${requiredver}"
else
	echo "Docker-Compose Less than ${requiredver}"
	wget https://github.com/docker/compose/releases/download/v2.2.3/docker-compose-linux-x86_64 -O /usr/local/bin/docker-compose
	chmod +x /usr/local/bin/docker-compose
	printf '\nDocker Compose installed successfully\n\n'
	#
	# Copy docker daemon conf file
	#
	cp daemon.json /etc/docker/
fi


printf 'Launch RAMP IoT platform containers...\n\n'
export RAMP_PATH=/opt/rampiot


if grep -q "vm.max_map_count=262144" /etc/sysctl.conf; then
	echo "vm.max_map_count sufficient"
else
	echo "vm.max_map_count=262144" >> /etc/sysctl.conf
fi

sudo sysctl -w vm.max_map_count=262144
sudo docker-compose up -d


#
# Copy desktop launcher
#
cp rampiot.desktop /opt/rampiot/
FILE=/usr/share/applications/rampiot.desktop
if test -f "$FILE"; then
	echo "$FILE exists."
else
	sudo ln -s /opt/rampiot/rampiot.desktop /usr/share/applications/
fi

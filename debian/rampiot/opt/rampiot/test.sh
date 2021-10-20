#!/bin/bash

if [[ $(docker-compose version) == *" 1.29."* ]]; then
#if [[ $(docker -v) == *" 20.10."* ]]; then
    echo 'Docker version 20.10!'
else 
    echo 'Docker version not 20.10!'
fi

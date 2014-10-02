#!/bin/bash

# Stops all running docks
sudo docker stop $(sudo docker ps | awk 'NR>1{print $1}')
# Remove the instances
sudo docker rm $(sudo docker ps -a | awk 'NR>1{print $1}')

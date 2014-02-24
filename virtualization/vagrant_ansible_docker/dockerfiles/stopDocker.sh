#!/bin/bash

# Stops all running docks
sudo docker stop $(sudo docker ps | awk 'NR>1{print $1}')

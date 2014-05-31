#!/bin/bash

# Stops all running Cassandra docks
sudo docker stop $(sudo docker ps | grep cassandra | awk '{print $1}')

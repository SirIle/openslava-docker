#!/bin/bash

# Stops all running docks
docker stop $(docker ps | awk 'NR>1{print $1}')

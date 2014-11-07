#!/bin/bash
sudo service docker restart
sleep 3
docker kill $(docker ps | awk 'NR>1{print $1}')
docker rm $(docker ps -a -q)
docker rmi $(docker images -a | grep "^<none>" | awk '{print $3}')

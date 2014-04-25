#!/bin/bash
sudo service docker restart
sleep 3
sudo docker kill $(sudo docker ps | awk 'NR>1{print $1}')
sudo docker rm $(sudo docker ps -a -q)
sudo docker rmi $(sudo docker images -a | grep "^<none>" | awk '{print $3}')

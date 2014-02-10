#!/bin/bash

IMAGE_NAME=test/mongodb
hostname="mongo"
ip=10.1.3.1

echo "== Checking if the MongoDB container has already been built."
sudo docker images | grep "^$IMAGE_NAME"
if [ $? == 1 ]; then
	echo "== Container has not been built, building now."
	sudo docker build -rm -t $IMAGE_NAME . 
else
	echo "== Container has been built; skipping build step."
fi

echo "== Starting mongodb, hostname $hostname, ip $ip, ssh port 1031"

ports="-p 27017 -p 1031:22"

cid=$(sudo docker run -d $ports -h $hostname -dns 10.1.1.1 $IMAGE_NAME)
sudo pipework br1 $cid $ip/21

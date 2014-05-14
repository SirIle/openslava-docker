#!/bin/bash
IMAGE_NAME=test/opscenter
echo "== Checking if the container for opscenter has already been built."
sudo docker images | grep "^$IMAGE_NAME"
if [ $? == 1 ]; then
	echo "== Container has not been built, building now."
	sudo docker build --rm -t $IMAGE_NAME . 
else
	echo "== Container has been built; skipping build step."
fi

echo "== Starting the opscenter container."

CONTAINER=$(sudo docker run -d -p 8888:8888 -p 1121:22 --dns 127.0.0.1 -h opscenter $IMAGE_NAME)
sudo pipework br1 $CONTAINER 10.1.2.100/21

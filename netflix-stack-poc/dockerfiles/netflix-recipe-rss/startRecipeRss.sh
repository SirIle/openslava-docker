#!/bin/bash
IMAGE_NAME=test/recipes-rss
echo "== Checking if the container fhas already been built."

sudo docker images | grep "^$IMAGE_NAME"
if [ $? == 1 ]; then
	echo "== Container has not been built, building now."
	sudo docker build -rm -t $IMAGE_NAME . 
else
	echo "== Container has been built; skipping build step."
fi

echo "== Starting the Netflix RSS Recipe container."

NODENS_CONTAINER=$(sudo docker run -d -p 1401:22 -p 80:80 -p 9090:9090 -p 9092:9092 -p 9192:9192 -p 9190:9190 $IMAGE_NAME)
sudo pipework br1 $NODENS_CONTAINER 10.1.3.1/22

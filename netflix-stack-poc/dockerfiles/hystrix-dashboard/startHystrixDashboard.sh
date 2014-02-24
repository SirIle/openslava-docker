#!/bin/bash
IMAGE_NAME=test/hystrix-dashboard
echo "== Checking if the container fhas already been built."

sudo docker images | grep "^$IMAGE_NAME"
if [ $? == 1 ]; then
	echo "== Container has not been built, building now."
	sudo docker build -rm -t $IMAGE_NAME . 
else
	echo "== Container has been built; skipping build step."
fi

echo "== Starting the Netflix Hystrix Dashboard container ($IMAGE_NAME)."

NODENS_CONTAINER=$(sudo docker run -d -p 1401:22 -p 8080:8080 $IMAGE_NAME)
sudo pipework br1 $NODENS_CONTAINER 10.1.4.1/22
#!/bin/bash
IMAGE_NAME=test/nodens
echo "== Checking if the container for NodeNS has already been built."
docker images | grep "^$IMAGE_NAME"
if [ $? == 1 ]; then
	echo "== Container has not been built, building now."
	docker build -t $IMAGE_NAME . 
else
	echo "== Container has been built; skipping build step."
fi

echo "== Starting the nodens container."

NODENS_CONTAINER=$(sudo docker run -d -p 8053:8053 -p 1001:22 -e DNSPORT=53 test/nodens)
sudo pipework br1 $NODENS_CONTAINER 10.1.1.1/22

#!/bin/bash
IMAGE_NAME=test/core
echo "== Checking if the container for core has already been built."
sudo docker images | grep "^$IMAGE_NAME"
if [ $? == 1 ]; then
        echo "== Container has not been built, building now."
        sudo docker build -t $IMAGE_NAME . 
else
        echo "== Container has been built; skipping build step."
fi

echo "== Starting the core container."

NODENS_CONTAINER=$(sudo docker run -d -p 1000:22 -h core --dns 127.0.0.1 $IMAGE_NAME)
sudo pipework br1 $NODENS_CONTAINER 10.1.1.1/21

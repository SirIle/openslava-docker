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

sudo docker run -d -p 1000:22 -p 9200:9200 -p 80:80 -p 8500:8500 -h core --name core --dns 127.0.0.1 $IMAGE_NAME

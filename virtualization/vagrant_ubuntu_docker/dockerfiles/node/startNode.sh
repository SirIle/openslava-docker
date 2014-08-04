#!/bin/bash

# Argc test + usage help
function check_usage() {
        argc=$1
        expected=$2
        usage=$3

        if [[ $argc -ne $expected ]]; then
                echo -e $usage
                exit 1
        fi
}

check_usage $# 1 "Usage: $0 <NODE_NUMBER>"

NODE=$1
IMAGE_NAME=test/node
HOSTNAME="node$NODE"
PORTS="-p 104$NODE:22"

echo "== Checking if the bare container has already been built."
sudo docker images | grep "^$IMAGE_NAME"
if [ $? == 1 ]; then
	echo "== Container has not been built, building now."
	sudo docker build -t $IMAGE_NAME .
else
	echo "== Container has been built; skipping build step."
fi

echo "== Starting node instance $NODE, hostname $HOSTNAME, ssh port 104$NODE"

sudo docker run -d $PORTS -h $HOSTNAME --dns 127.0.0.1 --link core:core $IMAGE_NAME

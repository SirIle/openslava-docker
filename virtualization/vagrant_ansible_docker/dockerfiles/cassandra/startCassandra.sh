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
IMAGE_NAME=test/cassandra
hostname="cassandra$NODE"
ip=10.1.2.$NODE

echo "== Checking if the Cassandra container has already been built."
sudo docker images | grep "^$IMAGE_NAME"
if [ $? == 1 ]; then
	echo "== Container has not been built, building now."
	sudo docker build -t $IMAGE_NAME . 
else
	echo "== Container has been built; skipping build step."
fi

echo "== Starting cassandra instance $NODE, hostname $hostname, ip $ip, ssh port 111$NODE"

# If it's the first instance, expose the ports
if [[ $NODE == 1 ]]; then
        ports="-p 9160:9160 -p 9042:9042 -p 111$NODE:22"
else
        ports="-p 111$NODE:22"
fi

cid=$(sudo docker run -d $ports -h $hostname -dns 10.1.1.1 $IMAGE_NAME)
sudo pipework br1 $cid $ip/21

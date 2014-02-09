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

check_usage $# 1 "Usage: $0 <PROJECT_DIR>"

project_dir=$1
IMAGE_NAME=test/meteorite
hostname="meteorite"
ip=10.1.4.1

echo "== Checking if the Meteorite container has already been built."
sudo docker images | grep "^$IMAGE_NAME"
if [ $? == 1 ]; then
	echo "== Container has not been built, building now."
	sudo docker build -rm -t $IMAGE_NAME . 
else
	echo "== Container has been built; skipping build step."
fi

echo "== Starting meteorite, hostname $hostname, ip $ip, ssh port 1131"

ports="-p 3000:3000 -p 1131:22"

cid=$(sudo docker run -d $ports -h $hostname -dns 10.1.1.1 -e MONGO_URL=mongodb://mongo:27017/meteor -v $project_dir:/project $IMAGE_NAME)
sudo pipework br1 $cid $ip/21

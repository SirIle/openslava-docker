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

hostname="cassandra$NODE"
ip=10.1.2.$NODE

echo "Starting cassandra instance $NODE, hostname $hostname, ip $ip, ssh port 111$NODE"

# If it's the first instance, expose the ports
if [[ $NODE == 1 ]]; then
        ports="-p 9160:9160 -p 9042:9042 -p 111$NODE:22"
else
        ports="-p 111$NODE:22"
fi

#exit 0

cid=$(sudo docker run -d $ports -h $hostname -dns 10.1.1.1 test/cassandra)
sudo pipework br1 $cid $ip/22

# Register the host to the dns server
curl -X PUT -H "Content-Type: application/json" http://localhost:8053/lookup -d '{"address":"'$ip'","name":"'$hostname'","ttl":"10","expires":"3600","type":1}'
curl -X PUT -H "Content-Type: application/json" http://localhost:8053/lookup -d '{"address":"'$ip'","name":"cassandra","ttl":"10","expires":"3600","type":1}'

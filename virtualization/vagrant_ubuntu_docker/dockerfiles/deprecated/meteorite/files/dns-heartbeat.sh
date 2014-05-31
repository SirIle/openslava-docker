#!/bin/bash

#
# This file acts as a "heartbeat" for the DNS server, running every 58 seconds to renew the name record; if for some reason this
# node dies or is stopped, it will not be resolved anymore in max 60 seconds since that's the expiration for the name record
#

OWN_HOSTNAME=`hostname`
# Please note that this works because we know that eth1 is the interface that we want that has the IP address we want to 
# advertise (it's the one created by pipeworks)
OWN_IP=`ifconfig eth1 | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*'`

# Default expiration time
DEFAULT_EXPIRES_SEC=60
# how long to wait before sending a new heartbeat
DEFAULT_SLEEP_SEC=58
# IP address of the DNS server
DNS_SERVER=10.1.1.1

echo "Hostname: $OWN_HOSTNAME"
echo "IP: $OWN_IP"
echo "Expiration: $DEFAULT_EXPIRES_SEC"
echo "Heartbeat period: $DEFAULT_SLEEP_SEC"

while true; do
	echo "Sending DNS heart beat at `date`"

	# Register its own host name
	curl -X PUT -H "Content-Type: application/json" http://$DNS_SERVER:8053/lookup -d '{"address":"'$OWN_IP'","name":"'$OWN_HOSTNAME'","ttl":"10","expires":"'$DEFAULT_EXPIRES_SEC'","type":1}'

	# And also register itself as 'cassandra'
	curl -X PUT -H "Content-Type: application/json" http://$DNS_SERVER:8053/lookup -d '{"address":"'$OWN_IP'","name":"cassandra","ttl":"10","expires":"'$DEFAULT_EXPIRES_SEC'","type":1}'

	# wait some time until we send the next heartbeat
	echo "Waiting $DEFAULT_SLEEP_SEC seconds"
	sleep $DEFAULT_SLEEP_SEC
done

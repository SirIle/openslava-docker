#!/bin/bash
# Make sure that weave is running
sudo weave launch 10.0.0.2/16 10.10.10.30
# Core
sudo weave run 10.0.2.1/22 -t -p 1000:22 -p 80:80 -p 8500:8500 -p 9200:9200 \
--dns 127.0.0.1 -h core --name core -v /etc/localtime:/etc/localtime:ro \
-v /etc/timezone:/etc/timezone:ro -e DC=east -i registry.local/core
echo "Core started, sleeping a while"
sleep 10
# Cassandra4
sudo weave run 10.0.2.2/22 -t -p 9160:9160 -p 1021:22 --dns 127.0.0.1 \
-h cassandra4 --link core:core -v /etc/localtime:/etc/localtime:ro \
-v /etc/timezone:/etc/timezone:ro -e DC=east -i registry.local/cassandra
echo "Cassandra4 started, sleeping a while"
sleep 20
# Cassandra5
sudo weave run 10.0.2.3/22 -t -p 1022:22 --dns 127.0.0.1 \
-h cassandra5 --link core:core -v /etc/localtime:/etc/localtime:ro \
-v /etc/timezone:/etc/timezone:ro -e DC=east -i registry.local/cassandra

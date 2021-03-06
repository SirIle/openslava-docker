#!/bin/bash
# Make sure that weave is running
sudo weave launch
# Core
sudo weave run 10.0.1.1/22 -t -p 1000:22 -p 80:80 -p 8500:8500 -p 9200:9200 \
--dns 127.0.0.1 -h core --name core -v /etc/localtime:/etc/localtime:ro \
-v /etc/timezone:/etc/timezone:ro -e DC=west -e DOCKER_HOST_IP=10.10.10.30 -i registry.local/core
echo "Core started, sleeping a while"
sleep 10
# OpsCenter
sudo weave run 10.0.1.10/22 -t -p 1121:22 -p 8888:8888 --dns 127.0.0.1 -h opscenter \
--link core:core -v /etc/localtime:/etc/localtime:ro -v /etc/timezone:/etc/timezone:ro  \
-e DC=west -i registry.local/opscenter
echo "OpsCenter started, sleeping a while"
sleep 20
# Cassandra1
sudo weave run 10.0.1.2/22 -t -p 9160:9160 -p 1021:22 --dns 127.0.0.1 \
-h cassandra1 --link core:core -v /etc/localtime:/etc/localtime:ro \
-v /etc/timezone:/etc/timezone:ro -e DC=west -i registry.local/cassandra
echo "Cassandra1 started, sleeping a while"
sleep 20
# Cassandra2
sudo weave run 10.0.1.3/22 -t -p 1022:22 --dns 127.0.0.1 -h cassandra2 --link core:core \
-v /etc/localtime:/etc/localtime:ro -v /etc/timezone:/etc/timezone:ro -e DC=west \
-i registry.local/cassandra
echo "Cassandra2 started, sleeping a while"
sleep 20
# Cassandra3
sudo weave run 10.0.1.4/22 -t -p 1023:22 --dns 127.0.0.1 -h cassandra3 --link core:core \
-v /etc/localtime:/etc/localtime:ro -v /etc/timezone:/etc/timezone:ro -e DC=west \
-i registry.local/cassandra
echo "Cassandra3 started"
# Node for testing
sudo weave run 10.0.1.20/22 -t -p 1001:22 --dns 127.0.0.1 -h node --link core:core \
-v /etc/localtime:/etc/localtime:ro -v /etc/timezone:/etc/timezone:ro -v /home/vagrant/Projects:/root/Projects \
-e DC=west -i registry.local/node
echo "Node started"

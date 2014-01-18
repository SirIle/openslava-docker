#!/bin/bash

echo Starting the riak container

RIAK_CONTAINER=$(sudo docker run -d -p 8098:8098 -p 8087:8087 -p 1002:22 -dns=10.1.1.1 test/riak)
sudo pipework br1 $RIAK_CONTAINER 10.1.1.2/22

# Register the host to the dns server
curl -X PUT -H "Content-Type: application/json" http://localhost:8053/lookup -d '{ "address": "10.1.1.2", "name": "1.riak.local", "ttl": "10", "expires": "3600", "type": 1 }'

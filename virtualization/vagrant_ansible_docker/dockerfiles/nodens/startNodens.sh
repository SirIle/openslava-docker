#!/bin/bash
echo Starting the nodens container

NODENS_CONTAINER=$(sudo docker run -d -p 8053:8053 -p 1001:22 -e DNSPORT=53 test/nodens)
sudo pipework br1 $NODENS_CONTAINER 10.1.1.1/24

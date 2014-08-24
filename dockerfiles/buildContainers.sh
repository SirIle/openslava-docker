#!/bin/bash
(cd core && sudo docker build -t registry.local/core .)
(cd cassandra && sudo docker build -t registry.local/cassandra .)
(cd opscenter && sudo docker build -t registry.local/opscenter .)
(cd node && sudo docker build -t registry.local/node .)

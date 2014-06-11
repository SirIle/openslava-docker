#!/bin/bash
(cd core && sudo docker build -t test/core .)
(cd cassandra && sudo docker build -t test/cassandra .)
(cd opscenter && sudo docker build -t test/opscenter .)

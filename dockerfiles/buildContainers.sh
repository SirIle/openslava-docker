#!/bin/bash
(cd core && docker build -t registry.local/core .)
(cd cassandra && docker build -t registry.local/cassandra .)
(cd opscenter && docker build -t registry.local/opscenter .)
(cd node && docker build -t registry.local/node .)

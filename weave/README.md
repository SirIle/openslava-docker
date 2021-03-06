# Multiple nodes with Weave-based networking

Weave can be found at https://github.com/zettio/weave.

Start Weave in one of the nodes like this (node1):

```bash
  sudo weave launch 10.0.0.1/16
```

Make sure that the containers have been built (by running the command
`/buildContainers.sh` in *~/dockerfiles* folder).

Containers can be launched via the script in *~/weave* directory:

```bash
  ./startNode1.sh
```

They can also be started individually.

A bit of magic has been added to Consul and Cassandra startups so that the
bootstrap IP is determined at run time. A shell script is used to check if
the interface "ethwe" exists and the IP address provided by it is used. If
no such interface is found, then the IP address is obtained by using
"hostname -i" which gives the Docker internal IP. This way the containers should
work both in weaver and normal environments.

Containers on node2 can be started with

```bash
   ./startNode2.sh
```

Joining the clusters (for example on node2):

```bash
   ssh root@localhost -p 1000 'consul join -wan 10.0.1.1'
```

Restart Cassandra on one of the nodes (for example Cassandra4):

```bash
   ssh root@localhost -p 1021 'supervisorctl restart cassandra'
```

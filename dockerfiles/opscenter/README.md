# OpsCenter container

Opscenter is a tool by Datastax for monitoring Cassandra clusters. For
Opscenter and the Cassandra dock to work, Core has to be running.

Easiest way to start the cluster is by using maestro, example can be found from
directory above.

After Opscenter has been started, you can access it using a web browser by
going to the address:

	http://10.10.10.30:8888

When Cassandra nodes start, they will automatically start a datastax-client
which reports status information to Opscenter.

When you configure the cluster, you can use address "cassandra.service.consul"
or "cassandra1.node.consul". This has been added as default to the opscenter image.

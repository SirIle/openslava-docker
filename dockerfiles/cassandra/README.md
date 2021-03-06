# Cassandra-container

Dockerfile for building Cassandra instances. Uses the Datastax community edition.

Build with running the *./buildContainers.sh* script in the upper directory or manually with:

```bash
	sudo docker build --rm -t test/cassandra .
```

The memory limits have been configured to be quite small (max heap 64M) so that more simultaneous 
instances can be started. This value can be changed in the Dockerfile. Instructions in minimizing 
the Cassandra memory footprint are by John Berryman and can be found from 
http://architects.dzone.com/articles/building-perfect-cassandra.

After subsequent instances are started they should join the ring automatically. Internally they are
known with the names cassandraX.node.consul, where X is the instance number. The ssh ports are exposed to
the host as 102X with X being the instance number.

Test with DataStax devcenter and point it to: 10.10.10.30 and it should work.

You can also use cqlsh in one of the instances with `ssh root@localhost -p 1021 -t cqlsh`.

```sql
CREATE KEYSPACE demo WITH REPLICATION = { 'class' : 'SimpleStrategy', 'replication_factor' : 2 };

CREATE TABLE demo.users ( 
	userid text,
	firstname text,
	lastname text, 
	PRIMARY KEY (userid) 
);

INSERT INTO demo.users (userid, firstname, lastname) VALUES ('ile','Ilkka','Anttonen');
INSERT INTO demo.users (userid, firstname, lastname) VALUES ('toinen','Some','User');

SELECT * FROM demo.users where userid = 'ile';
```

and the result should be returned.

For programmatically getting the result (CoffeeScript):

```coffeescript
cql = require 'node-cassandra-cql'
client = new cql.Client({hosts:['cassandra.service.consul'],keyspace: 'demo'})
client.execute 'SELECT * FROM demo.users where userid = ?', ['ile'], (err, result) ->
        console.log 'Result: ' + result.rows[0].firstname
```

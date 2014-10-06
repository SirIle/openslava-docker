# Running the Cassandra cluster example

## Checking out the project and contents

You can check out the project from InnerSource with
```
git clone git@innersource.accenture.com:eti-nordic-playground/eti-nordic-playground.git
```

This README document assumes that *eti-nordic-playground* directory is the root.

Under it are four relevant directories for setting up and running the container demo:
  - dockerfiles (contains the script and container descriptors)
  - maestro (MaestroNG orchestration files)
  - vagrant (contains the Vagrant configuration files)
  - weave (contains the shell scripts for running containers and weave)

## Prerequisites

The environment has been tested in Windows 7 and Mac OS X. It should also run in Linux.

Following software has to be installed on the host (tested version numbers in parenthesis):
  - VirtualBox (4.3.16)
  - Vagrant (1.6.5)

On OS X and Linux you also need
  - Ansible (1.7.2)

The Vagrant scripts also assume that you have a directory called *~/Projects* created. It can be empty. On Windows, it should be *c:\users\<username>\Projects* and in other operating systems under your home directory.

## Running in one node with MaestroNG orchestration

### Setting up the environment

Start and enter node1
```
cd vagrant/ubuntu_docker
vagrant up
vagrant ssh
```

You can also connect to the running node1 with other terminals. It has the host only network IP of 10.10.10.30. You need to use the Vagrant ssh key for the connection. Instructions for doing this for PuTTY can be found from https://blog.accenture.com/ilkka_anttonen/2014/04/15/connecting-to-vagrant-vm-on-windows-using-putty/.

This launches the node1 virtual machine and provisions it using Ansible. You can use `tmux` for multiple sessions.

### Building the images

Build the container images
```
cd ~/dockerfiles
./buildContainers.sh
```

### Running the containers

Use MaestroNG to start the containers
```
cd ~/maestro
maestro -f cassandra.yaml start
```

## Running in two nodes with Weave and registry

### Setting up the environment

Start node1
```
cd vagrant/ubuntu_docker
vagrant up
```

Start node2
```
vagrant up node2
```

Start docker registry
```
cd ../ubuntu_docker_registry
vagrant up
```

### Building and pushing the images

On node1 build the images and push core and cassandra to the local registry
```
cd dockerimages
./buildContainers.sh
./pushContainers.sh
```

### Running containers in node1

On node1 use the shell script to start containers
```
cd ~/weave
./startNode1.sh
```

### Running containers in node2

On node2 use the shell script to start containers. This will pull them from the local registry first.
```
cd ~/weave
./startNode2.sh
```

### Connecting the nodes

On either of the nodes, connect to the *core* instance and join the Consul master nodes. For example on node2
```
ssh root@localhost -p 1000 'consul join -wan 10.0.1.1'
```

Restart Cassandra instance on that node so that it reconnects to the other datacenter
```
ssh root@localhost -p 1021 'supervisorctl restart cassandra'
```

After a while the nodes have joined to the same ring. This can be checked with
```
ssh root@localhost -p 1021 'nodetool status'
```

### Cleanup

To stop the running containers and clear out the instances use
```
~/weave/stopNode.sh
```

## Checking that everything is working

Different services can be reached with a browser from the host. Services can be found from:

|Service           | URL                             |
|-------           | ---                             |
|Logstash on node1 | http://10.10.10.30              |
|Logstash on node2 | http://10.10.10.40              |
|ConsulUI          | http://10.10.10.30:8500/ui/dist |
|Opscenter         | http://10.10.10.30:8888         |

Inside the Docker node the different containers can be accessed using ssh (username/password is root/root):

|Container          | Ssh port | Weave IP
|---------          | -------- | --------
|Core               | 1000     | 10.0.1.1
|Cassandra1         | 1021     | 10.0.1.2
|Cassandra2         | 1022     | 10.0.1.3
|Cassandra3         | 1023     | 10.0.1.4
|Opscenter          | 1121     | 10.0.1.10
|Node               | 1001     | 10.0.1.20
|Core (node2)       | 1000     | 10.0.2.1
|Cassadra4 (node2)  | 1021     | 10.0.2.2
|Cassandra5 (node2) | 1022     | 10.0.2.3

The command to connect to for example Cassandra1 on node1 is:
```
ssh root@localhost -p 1021
```

### Creating a keyspace and few test rows

Ssh into one of the Cassandra containers and start up cqlsh
```
ssh root@localhost -p 1021
cqlsh
```

Enter the following (you can exit cqlsh with either exit or ctrl+d)
```
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

Status of the Cassandra ring can be displayed with `nodetool status`.

### Using icedcoffeescript to query the cluster

Connect to the node container
```
ssh root@localhost -p 1001
```

Install the *node-cassandra-cql* module with npm
```
npm install node-cassandra-cql
```

Create the following program, use your favourite editor and name the file cql.iced
```
cql = require 'node-cassandra-cql'
client = new cql.Client({hosts:['cassandra.service.consul'],keyspace: 'demo'})
client.execute 'SELECT * FROM demo.users where userid = ?', ['ile'], (err, result) ->
  console.log 'Result: ' + result.rows[0].firstname
  process.exit 0
```

Now this program can be run
```
iced cql.iced
```

You should get the result if you have previously created the test data as described in previous step.

# Cleanup scripts

To stop the containers and clean out unused images and remove instances use
```
/vagrant/scripts/cleanDocker.sh
```

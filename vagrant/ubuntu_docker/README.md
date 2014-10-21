# Ubuntu based Docker node

This vagrant file will set up a Ubuntu 14.04 box on VirtualBox with
local networking enabled that will run in 10.10.10.30. It contains
a Docker environment and orchestration services.

It also contains the configuration to start a second node.

Prerequisites:
 - VirtualBox
 - Vagrant
   - vagrant-vbguest plugin ("vagrant plugin install vagrant-vbguest")
     (This keeps the VirtualBox guest additions in synch so shared
     folders work)
 - Ansible (Linux, OS X only - will use the Shell provisioner in Windows)

Usage:

```bash
  vagrant up
```

Starting the second node:

```bash
vagrant up node2
```

This will download the box from canonical if it doesn't exist in the
local cache. It will then use ansible to provision the rest. It will
also install the correct version of the VirtualBox guest additions.

You can then connect to the box using either `vagrant ssh` or just `ssh vagrant@10.10.10.30` 
with the password "vagrant". Second node can be accessed with `vagrant ssh node2` or
`ssh vagrant@10.10.10.40`.

Note: If you get an ssh error when provisioning, remove the relevant
entries from the *~/.ssh/known_hosts* file.

After you have logged in, the dockerfiles for building the docker
images can be found from *~/dockerfiles*.

Building the files needed to run the Cassandra example happens by running:

```bash
	./buildContainers.sh
```

Then you can list the images using:

```bash
  sudo docker images
```

Starting the MaestroNG-orchestrated cassandra example:

```bash
  cd maestro
	maestro -f cassandra.yaml start
```

Status can be checked with:

```bash
  maestro -f cassandra.yaml status
```

Cluster can be stopped with:

```bash
  maestro -f cassandra.yaml stop
```

For more information, check the *README.md* file at the root level.

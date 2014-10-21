# MaestroNG based orchestration

This folder contains the example configuration file for running the Cassandra-example
using a modified MaestroNG for orchestration.

### Running the containers

Starting the containers is done with

```bash
cd ~/maestro
maestro -f cassandra.yaml start
```

Stopping the containers is done with

```bash
cd ~/maestro
maestro -f cassandra.yaml stop
```

Status of the containers can be listed with

```bash
maestro -f cassandra.yaml status
```

More information can be found from the README.md file at the root level.

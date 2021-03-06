# Template for containers

This folder contains a template that can be used as a base for new containers.

For clarity it's suggested that the files are renamed to match the actual
target container, for example buildTemplate.sh would be build<Container>.sh.

Building the core image is not included in the buildTemplate.sh, but it can 
be built in the core-directory with:

```bash
  sudo docker build -t test/core .
```

The items that need configuring when defining a new container:
  - template.yaml
    * Add/modify port definitions for the services like sshd and others
    * Add possible exposed volumes
  - buildTemplate.sh
    * Change the name of the target container, should match the one defined
      in template.yaml
  - Dockerfile
    * Add the actual build of the container
    * Add the configuration files that should be transferred
  - files/supervisord.conf
    * Add the services that should be executed in the container
  - files/rsyslog.conf
    * Add the service logs that should be aggregated to logstash
  - files
    * Add the <service>-consul.json definitions for service registration
    * Add other configuration files, remember to modify the Dockerfile

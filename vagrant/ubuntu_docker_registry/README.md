# Ubuntu based Docker registry

This vagrant file will set up a Ubuntu 14.04 box on VirtualBox with
local networking enabled that will run in 10.10.10.100. It contains
a Docker registry environment.

Usage:

```bash
  vagrant up
```

This will download the box from canonical if it doesn't exist in the
local cache. It will then use ansible to provision the rest. It will
also install the correct version of the VirtualBox guest additions.

If needed, the box can be accessed with ssh, but that may not be 
necessary. Connect with `vagrant ssh` or just `ssh vagrant@10.10.10.100` 
with the password "vagrant". 

Note: If you get an ssh error when provisioning, remove the relevant
entries from the *~/.ssh/known_hosts* file.

For more information, check the *README.md* file at the root level.

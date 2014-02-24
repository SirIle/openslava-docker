#!/bin/bash

#
# This is the file used by the shell provisioner in Windows environments where Ansible is not available
#

# configure apt
echo "Installing the Docker GPG key for apt"
wget -qO- https://get.docker.io/gpg | apt-key add -

# add the docker key and repos, and install docker
echo "Adding the Docker apt source"
echo deb http://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list
echo "Running apt-get update"
apt-get update
echo "Installing tools (Docker, git, etc)"
apt-get install -y lxc-docker git-core

# install pipework
echo "Installing pipework"
curl -o /usr/local/bin/pipework https://raw2.github.com/jpetazzo/pipework/master/pipework
chmod ugo+rx /usr/local/bin/pipework

echo "Done"

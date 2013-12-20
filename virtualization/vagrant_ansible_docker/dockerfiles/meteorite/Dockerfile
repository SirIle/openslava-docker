# Create a docker image to run Riak
FROM ubuntu:latest

# Hack for initctl
RUN dpkg-divert --local --rename --add /sbin/initctl
RUN ln -s /bin/true /sbin/initctl

# Update the APT cache
RUN sed -i.bak 's/main$/main universe/' /etc/apt/sources.list
RUN apt-get update
RUN apt-get upgrade -y

# Install and setup project dependencies
RUN apt-get install -y curl lsb-release supervisor openssh-server rsyslog 
RUN mkdir -p /var/run/sshd
RUN mkdir -p /var/log/supervisor
RUN locale-gen en_US en_US.UTF-8
ADD supervisord.conf /etc/supervisor/conf.d/supervisor.conf
# Set the root account password
RUN echo 'root:meteor' | chpasswd

# Install node, npm
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C7917B12
RUN echo "deb http://ppa.launchpad.net/chris-lea/node.js/ubuntu $(lsb_release -cs) main" > /etc/apt/sources.list.d/node.list
RUN apt-get update
RUN apt-get -y install nodejs

# Install meteor, kludge for libssl bug
ENV HOME /root
RUN echo tlsv1 > ~/.curlrc
RUN curl https://install.meteor.com | /bin/sh

# Install meteorite
RUN npm -g install meteorite

# Expose the ports
EXPOSE 22 3000

# Start the supervisord
CMD ["/usr/bin/supervisord"]

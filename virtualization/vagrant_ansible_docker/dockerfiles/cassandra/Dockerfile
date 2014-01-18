# Create a docker image to run Cassandra
FROM ubuntu:latest

# Update the APT cache
RUN sed -i.bak 's/main$/main universe/' /etc/apt/sources.list
RUN apt-get update
RUN apt-get upgrade -y

# Hack for initctl
RUN dpkg-divert --local --rename --add /sbin/initctl
RUN ln -s /bin/true /sbin/initctl

# Install and setup project dependencies
RUN apt-get install -y curl lsb-release supervisor openssh-server rsyslog net-tools
RUN mkdir -p /var/run/sshd
RUN mkdir -p /var/log/supervisor
RUN locale-gen en_US en_US.UTF-8
ADD supervisord.conf /etc/supervisor/conf.d/supervisor.conf
# Set the root account password
RUN echo 'root:root' | chpasswd

# Add the repositories
RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu $(lsb_release -cs) main" > /etc/apt/sources.list.d/oracle.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886
RUN echo "deb http://debian.datastax.com/community stable main" > /etc/apt/sources.list.d/datastax.list
RUN curl -L http://debian.datastax.com/debian/repo_key | apt-key add -
RUN apt-get update

# Install Oracle JRE 1.7
RUN echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
RUN apt-get install -y oracle-java7-installer

# Install Cassandra
RUN apt-get install -y libjna-java dsc20 python-cql
RUN ln -s /usr/share/java/jna.jar /usr/share/cassandra/lib
RUN sed -i.bak 's/^# num_tokens.*/num_tokens: 256/' /etc/cassandra/cassandra.yaml
RUN sed -i.bak 's/listen_address: localhost/listen_address: /' /etc/cassandra/cassandra.yaml
RUN sed -i.bak 's/rpc_address: localhost/rpc_address: 0.0.0.0/' /etc/cassandra/cassandra.yaml
RUN sed -i.bak 's/seeds: "127.0.0.1"/seeds: "cassandra1,cassandra"/g' /etc/cassandra/cassandra.yaml
RUN sed -i.bak 's/#MAX_HEAP_SIZE="4G"/MAX_HEAP_SIZE="256M"/' /etc/cassandra/cassandra-env.sh
RUN sed -i.bak 's/#HEAP_NEWSIZE="800M"/HEAP_NEWSIZE="64M"/' /etc/cassandra/cassandra-env.sh

# Change the system to use dns before files for host name resolution
RUN sed -i.bak 's/files dns/dns files/' /etc/nsswitch.conf

# Expose the ports
EXPOSE 9042 9160 22

# Start the supervisord
CMD ["/usr/bin/supervisord"]

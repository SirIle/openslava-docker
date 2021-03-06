# Create a docker image to run Cassandra
FROM sirile/oraclejre:0.9
MAINTAINER Ilkka Anttonen

# Add the repository for Cassandra
RUN echo "deb http://debian.datastax.com/community stable main" > /etc/apt/sources.list.d/datastax.list
RUN curl -L http://debian.datastax.com/debian/repo_key | apt-key add -
RUN apt-get update

# Install and configure Cassandra
RUN apt-get install -y dsc21 python-cql datastax-agent sysstat
#RUN ln -s /usr/share/java/jna.jar /usr/share/cassandra/lib

# Copy the configuration files into place
ADD files/cassandra.yaml /etc/cassandra/cassandra.yaml
ADD files/cassandra-env.sh /etc/cassandra/cassandra-env.sh

# Copy the start file in place so that listen to address is correct
ADD files/startCassandra.sh /usr/local/bin/startCassandra.sh

# Configure the address of opscenter (used if agents are enabled in supervisord.conf)
RUN echo "stomp_interface: opscenter.service.west.consul" | tee -a /etc/datastax-agent/address.yaml

# Add the rsyslog-configuration file
ADD files/rsyslog.conf /etc/rsyslog.conf

# Add the supervisor configuration (last so it can be changed without full rebuild)
ADD files/supervisord.conf /etc/supervisor/conf.d/supervisor.conf

# Add the Consul start script so that the IP address can be resolved
ADD files/startConsul.sh /usr/local/bin/startConsul.sh

# Add the consul configuration for DNS and the services
ADD files/config-consul.json /etc/consul.d/config-consul.json
ADD files/cassandra-consul.json /etc/consul.d/cassandra-consul.json

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Expose the ports
EXPOSE 9042 9160 22 61621

# Start the supervisord
CMD ["/usr/bin/supervisord"]

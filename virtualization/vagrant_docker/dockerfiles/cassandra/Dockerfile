# Create a docker image to run Cassandra
FROM sirile/oraclejre:0.2

# Add the heartbeat script
ADD files/dns-heartbeat.sh /usr/local/bin/dns-heartbeat.sh
RUN chmod ugo+rx /usr/local/bin/dns-heartbeat.sh

# Add the repository for Cassandra
RUN echo "deb http://debian.datastax.com/community stable main" > /etc/apt/sources.list.d/datastax.list
RUN curl -L http://debian.datastax.com/debian/repo_key | apt-key add -
RUN apt-get update

# Install and configure Cassandra
RUN apt-get install -y dsc20 python-cql datastax-agent sysstat
#RUN ln -s /usr/share/java/jna.jar /usr/share/cassandra/lib

# Change the system to use dns before files for host name resolution
RUN sed -i.bak 's/files dns/dns files/' /etc/nsswitch.conf

# Copy the configuration files into place
ADD files/cassandra.yaml /etc/cassandra/cassandra.yaml
ADD files/cassandra-env.sh /etc/cassandra/cassandra-env.sh

# Configure the address of opscenter (used if agents are enabled in
# supervisord.conf)
RUN echo "stomp_interface: 10.1.2.100" >> /etc/datastax-agent/address.yaml

# Add the supervisor configuration (last so it can be changed without full rebuild)
ADD supervisord.conf /etc/supervisor/conf.d/supervisor.conf

# Expose the ports
EXPOSE 9042 9160 22 61621

# Start the supervisord
CMD ["/usr/bin/supervisord"]

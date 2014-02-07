# Create a docker image to run Cassandra
FROM sirile/oraclejre:0.1

# Add the supervisor configuration
ADD supervisord.conf /etc/supervisor/conf.d/supervisor.conf

# Add the heartbeat script
ADD files/dns-heartbeat.sh /usr/local/bin/dns-heartbeat.sh
RUN chmod ugo+rx /usr/local/bin/dns-heartbeat.sh

# Add the repository for Cassandra
RUN echo "deb http://debian.datastax.com/community stable main" > /etc/apt/sources.list.d/datastax.list
RUN curl -L http://debian.datastax.com/debian/repo_key | apt-key add -
RUN apt-get update

# Install and configure Cassandra
RUN apt-get install -y dsc20 python-cql 
#RUN ln -s /usr/share/java/jna.jar /usr/share/cassandra/lib

# Change the system to use dns before files for host name resolution
RUN sed -i.bak 's/files dns/dns files/' /etc/nsswitch.conf

# Copy the configuration files into place
ADD files/cassandra.yaml /etc/cassandra/cassandra.yaml
ADD files/cassandra-env.sh /etc/cassandra/cassandra-env.sh

# Expose the ports
EXPOSE 9042 9160 22

# Start the supervisord
CMD ["/usr/bin/supervisord"]

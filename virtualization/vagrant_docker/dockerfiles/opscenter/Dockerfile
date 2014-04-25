# Create a docker image to run Cassandra
FROM sirile/oraclejre:0.2

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
RUN apt-get install -y opscenter

# Change the system to use dns before files for host name resolution
RUN sed -i.bak 's/files dns/dns files/' /etc/nsswitch.conf
RUN echo 'Acquire::ForceIPv4 "true";' > /etc/apt/apt.conf

# Expose the ports
EXPOSE 8888 22 61620

# Start the supervisord
CMD ["/usr/bin/supervisord"]

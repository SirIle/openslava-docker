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

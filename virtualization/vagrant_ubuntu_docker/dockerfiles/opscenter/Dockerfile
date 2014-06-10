# Create a docker image to run Cassandra
FROM sirile/oraclejre:0.5


# Add the repository for Cassandra
RUN echo "deb http://debian.datastax.com/community stable main" > /etc/apt/sources.list.d/datastax.list
RUN curl -L http://debian.datastax.com/debian/repo_key | apt-key add -
RUN apt-get update

# Install and configure Cassandra
RUN apt-get install -y opscenter

# Add the supervisor configuration
ADD files/supervisord.conf /etc/supervisor/conf.d/supervisor.conf

# Add the consul configuration for DNS and the services
ADD files/config-consul.json /etc/consul.d/config-consul.json
ADD files/opscenter-consul.json /etc/consul.d/opscenter-consul.json

# Add the cluster configuration files
RUN mkdir /etc/opscenter/clusters
ADD files/Test_Cluster.conf /etc/opscenter/clusters/Test_Cluster.conf

# Expose the ports
EXPOSE 8888 22 61620

# Start the supervisord
CMD ["/usr/bin/supervisord"]

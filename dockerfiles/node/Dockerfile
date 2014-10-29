# Create a docker image to run core services Consul, Elasticsearch, Logstash and Kibana
FROM sirile/node:0.9
MAINTAINER Ilkka Anttonen

# Install CoffeeScript
RUN npm install -g coffee-script

# Install IcedCoffeeScript
RUN npm install -g iced-coffee-script

# Set up the supervisor configuration
ADD files/supervisord.conf /etc/supervisor/conf.d/supervisor.conf

# Add the Consul start script so that the IP address can be resolved
ADD files/startConsul.sh /usr/local/bin/startConsul.sh

# Add the consul configuration for DNS
ADD files/config-consul.json /etc/consul.d/config-consul.json

# Add the rsyslog configuration for log aggregation
ADD files/rsyslog.conf /etc/rsyslog.conf

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Expose the port(s)
EXPOSE 22

# Start the supervisord
CMD ["/usr/bin/supervisord"]

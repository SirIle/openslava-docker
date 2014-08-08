# Create a docker image to run core services Consul, Elasticsearch, Logstash and Kibana
FROM sirile/node:0.6
MAINTAINER Ilkka Anttonen

# Install CoffeeScript
RUN npm install -g coffee-script

# Install IcedCoffeeScript
RUN npm install -g iced-coffee-script

# Set up the supervisor configuration
ADD files/supervisord.conf /etc/supervisor/conf.d/supervisor.conf

# Add the consul configuration for DNS
ADD files/config-consul.json /etc/consul.d/config-consul.json

# Add the rsyslog configuration for log aggregation
ADD files/rsyslog.conf /etc/rsyslog.conf

# Expose the port(s)
EXPOSE 22

# Start the supervisord
CMD ["/usr/bin/supervisord"]

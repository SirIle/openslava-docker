# Example Dockerfile that can be used as a template
FROM sirile/ubuntu:0.8
MAINTAINER Ilkka Anttonen

# Expose the port(s)
EXPOSE 22

# Start the supervisord
CMD ["/usr/bin/supervisord"]

# Set up the supervisor configuration
ADD files/supervisord.conf /etc/supervisor/conf.d/supervisor.conf

# Add the Consul start script so that the IP address can be resolved
ADD files/startConsul.sh /usr/local/bin/startConsul.sh

# Add the consul configuration for DNS
ADD files/config-consul.json /etc/consul.d/config-consul.json
# Add an example consul-file for service registration
ADD files/example-consul.json /etc/consul.d/example-consul.json

# Add the rsyslog configuration for log aggregation
ADD files/rsyslog.conf /etc/rsyslog.conf

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

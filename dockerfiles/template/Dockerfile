# Example Dockerfile that can be used as a template
FROM sirile/ubuntu:0.7
MAINTAINER Ilkka Anttonen

# Set up the supervisor configuration
ADD files/supervisord.conf /etc/supervisor/conf.d/supervisor.conf

# Add the consul configuration for DNS
ADD files/config-consul.json /etc/consul.d/config-consul.json
# Add an example consul-file for service registration
ADD files/example-consul.json /etc/consul.d/example-consul.json

# Add the rsyslog configuration for log aggregation
ADD files/rsyslog.conf /etc/rsyslog.conf

# Expose the port(s)
EXPOSE 22

# Start the supervisord
CMD ["/usr/bin/supervisord"]

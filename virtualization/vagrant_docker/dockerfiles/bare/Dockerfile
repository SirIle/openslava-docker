# Create a docker image to run core services Consul, Elasticsearch, Logstash and Kibana
FROM sirile/ubuntu:0.4
MAINTAINER Ilkka Anttonen

# Install Consul, this probably will move to the parent container
RUN apt-get install -y unzip dnsutils
RUN wget https://dl.bintray.com/mitchellh/consul/0.2.0_linux_amd64.zip -O /tmp/consul.zip
RUN unzip /tmp/consul.zip -d /usr/local/bin
RUN chmod oug+rx /usr/local/bin/consul

# Set up the Consul configuration
RUN mkdir /etc/consul.d

# Set up the supervisor configuration
ADD files/supervisord.conf /etc/supervisor/conf.d/supervisor.conf

# Add the consul configuration for DNS
ADD files/config-consul.json /etc/consul.d/config-consul.json

# Expose the port(s)
EXPOSE 22

# Start the supervisord
CMD ["/usr/bin/supervisord"]

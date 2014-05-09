# Create a docker image to run core services Consul, Elasticsearch, Logstash and Kibana
FROM sirile/oraclejre:0.4
MAINTAINER Ilkka Anttonen

# Install Consul, this probably will move to the parent container
RUN apt-get install -y unzip dnsutils
RUN wget https://dl.bintray.com/mitchellh/consul/0.2.0_linux_amd64.zip -O /tmp/consul.zip
RUN unzip /tmp/consul.zip -d /usr/local/bin
RUN chmod oug+rx /usr/local/bin/consul

# Set up the Consul configuration
RUN mkdir /etc/consul.d

# Install Elasticsearch and logstash, newer versions are nicer
RUN wget https://download.elasticsearch.org/logstash/logstash/logstash-1.4.1.tar.gz -O /tmp/logstash.tar.gz
RUN (cd /opt && tar xzf /tmp/logstash.tar.gz)
RUN wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.1.1.tar.gz -O /tmp/elasticsearch.tar.gz
RUN (cd /opt && tar xzf /tmp/elasticsearch.tar.gz)
ADD files/logstash-syslog.json /opt/logstash-1.4.1/logstash-syslog.json

# Install nginx and Kibana
RUN apt-get install -y nginx-full
RUN (cd /tmp && wget --no-check-certificate http://download.elasticsearch.org/kibana/kibana/kibana-latest.zip -O pkg.zip && unzip pkg.zip && cd kibana-* && cp -rf ./* /usr/share/nginx/html/)
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
RUN rm -rf /tmp/*
RUN sed -i "s/elasticsearch: \"http:\/\/\"+window.location.hostname+\":9200\",/elasticsearch: \"http:\/\/10.10.10.30:9200\",/g"  /usr/share/nginx/html/config.js

# Set up the supervisor configuration
ADD files/supervisord.conf /etc/supervisor/conf.d/supervisor.conf

# Expose the ports
EXPOSE 22 80 5000 9200 9300

# Start the supervisord
CMD ["/usr/bin/supervisord"]

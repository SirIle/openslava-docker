# Create a docker image to run core services Consul, Elasticsearch, Logstash and Kibana
FROM sirile/oraclejre:0.8
MAINTAINER Ilkka Anttonen

# Set up Consul UI
RUN wget https://dl.bintray.com/mitchellh/consul/0.3.1_web_ui.zip -O /tmp/consul_ui.zip
RUN unzip /tmp/consul_ui.zip -d /opt/consul_ui

# Install Elasticsearch and logstash, newer versions are nicer
RUN wget https://download.elasticsearch.org/logstash/logstash/logstash-1.4.2.tar.gz -O /tmp/logstash.tar.gz
RUN (cd /opt && tar xzf /tmp/logstash.tar.gz)
RUN wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.1.1.tar.gz -O /tmp/elasticsearch.tar.gz
RUN (cd /opt && tar xzf /tmp/elasticsearch.tar.gz)
ADD files/logstash-syslog.json /opt/logstash-1.4.2/logstash-syslog.json

# Install nginx and Kibana
RUN apt-get install -y nginx-full
RUN (cd /tmp && wget --no-check-certificate http://download.elasticsearch.org/kibana/kibana/kibana-3.0.1.zip -O pkg.zip && unzip pkg.zip && cd kibana-* && cp -rf ./* /usr/share/nginx/html/)
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
RUN rm -rf /tmp/*
RUN sed -i "s/elasticsearch: \"http:\/\/\"+window.location.hostname+\":9200\",/elasticsearch: \"http:\/\/10.10.10.30:9200\",/g"  /usr/share/nginx/html/config.js
# Set logstash as the default dashboard in Kibana
RUN mv /usr/share/nginx/html/app/dashboards/logstash.json /usr/share/nginx/html/app/dashboards/default.json

# Add the Consul start script so that the IP address can be resolved
ADD files/startConsul.sh /usr/local/bin/startConsul.sh

# Add the rsyslog-configuration file
ADD files/rsyslog.conf /etc/rsyslog.conf

# Set up the supervisor configuration
ADD files/supervisord.conf /etc/supervisor/conf.d/supervisor.conf

# Add the services provided by this container
ADD files/log-consul.json /etc/consul.d/log-consul.json
ADD files/config-consul.json /etc/consul.d/config-consul.json

# Expose the ports
EXPOSE 22 80 5000 8500 9200 9300

# Start the supervisord
CMD ["/usr/bin/supervisord"]

# Create a docker image to run Cassandra
FROM sirile/oraclejre:0.1

# Set up the supervisor configuration
ADD ./files/supervisord.conf /etc/supervisor/conf.d/supervisor.conf

# Install needed packages
RUN apt-get install -y oracle-java7-set-default tomcat7

# Tomcat configuration to use port 80
#RUN rm /var/lib/tomcat7/conf/server.xml
ADD ./files/server.xml /etc/tomcat7/server.xml

# Check out the needed projects from github and build it; use depth 1 to avoid retrieving
# all history from the repository since we're not interested anyway
RUN git clone --depth 1 https://github.com/Netflix/recipes-rss.git ~/recipes-rss
RUN git clone --depth 1 https://github.com/Netflix/eureka.git ~/eureka

# Build Eureka and deploy to Tomcat
RUN cd ~/eureka && ./gradlew clean build
RUN cp ~/eureka/eureka-server/build/libs/eureka-server-*-SNAPSHOT.war /var/lib/tomcat7/webapps/eureka.war 

# Build the edge and middle tiers of the RSS application
RUN cd ~/recipes-rss && ./gradlew clean build

# Note: this is a hack required for the rss-edge component to find its web resources; I am not sure
# why they are not being packaged as part of the JAR but for demonstration purposes, it should do
RUN ln -s /recipes-rss/rss-edge /rss-edge

# Expose the ports
EXPOSE 22 80 9090 9092 9190 9192

# Start the supervisord
CMD ["/usr/bin/supervisord"]
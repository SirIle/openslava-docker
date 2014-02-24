# Create a docker image to run Cassandra
FROM sirile/oraclejre:0.1

# Set up the supervisor configuration
ADD ./files/supervisord.conf /etc/supervisor/conf.d/supervisor.conf

# Install needed packages
RUN apt-get install -y oracle-java7-set-default tomcat7

# Clone the Hystrix repo
RUN git clone --depth 1 https://github.com/Netflix/Hystrix.git ~/hystrix

# Build it, and deploy to Tomcat
RUN cd ~/hystrix/hystrix-dashboard && ../gradlew clean build
RUN cp ~/hystrix/hystrix-dashboard/build/libs/hystrix-dashboard-*-SNAPSHOT.war ./var/lib/tomcat7/webapps/hystrix-dashboard.war

# Expose the ports
EXPOSE 22 8080

# Start the supervisord
CMD ["/usr/bin/supervisord"]
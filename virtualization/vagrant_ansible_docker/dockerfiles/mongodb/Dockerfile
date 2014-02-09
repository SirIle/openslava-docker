# Create a docker image to run MongoDB
FROM sirile/ubuntu:0.1

# Set up the supervisor configuration
ADD supervisord.conf /etc/supervisor/conf.d/supervisor.conf

# Add the heartbeat script
ADD files/dns-heartbeat.sh /usr/local/bin/dns-heartbeat.sh
RUN chmod ugo+rx /usr/local/bin/dns-heartbeat.sh

# Add 10gen official apt source to the sources list
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
RUN echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | tee /etc/apt/sources.list.d/10gen.list

# Install MongoDB
RUN apt-get update
RUN apt-get install mongodb-10gen

# Create the MongoDB data directory
RUN mkdir -p /data/db

# Expose the ports
EXPOSE 22 27017

# Start the supervisord
CMD ["/usr/bin/supervisord"]

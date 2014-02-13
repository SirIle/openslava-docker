# Create a docker image to run meteorite
FROM sirile/node:0.2

# Set up the supervisor configuration
ADD supervisord.conf /etc/supervisor/conf.d/supervisor.conf

# Add the heartbeat script
ADD files/dns-heartbeat.sh /usr/local/bin/dns-heartbeat.sh
RUN chmod ugo+rx /usr/local/bin/dns-heartbeat.sh

# Install meteor
ENV HOME /root
RUN curl https://install.meteor.com | /bin/sh

# Install meteorite
RUN npm -g install meteorite

# Change the system to use dns before files for host name resolution
RUN sed -i.bak 's/files dns/dns files/' /etc/nsswitch.conf

# Create the temp directory for linking the local-folder to
RUN mkdir /tmp/local
ENV MONGO_URL mongodb://mongo:27017/meteor
RUN echo "export MONGO_URL=mongodb://mongo:27017/meteor" > ~/.bash_profile

# Expose the ports
EXPOSE 22 3000

# Start the supervisord
CMD ["/usr/bin/supervisord"]

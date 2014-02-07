# Create a docker image to run meteorite
FROM sirile/node:latest

# Install meteor, kludge for libssl bug
ENV HOME /root
RUN curl https://install.meteor.com | /bin/sh

# Install meteorite
RUN npm -g install meteorite

# Expose the ports
EXPOSE 22 3000

# Start the supervisord
CMD ["/usr/bin/supervisord"]

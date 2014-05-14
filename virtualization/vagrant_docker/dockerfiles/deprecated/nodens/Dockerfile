# Create a docker image to run nodens by Oscar Renalias
FROM sirile/node:0.4

# Set up the supervisor configuration
ADD supervisord.conf /etc/supervisor/conf.d/supervisor.conf

# Check out the project from github and build it
RUN git clone https://github.com/oscarrenalias/nodens.git ~/nodens
RUN cd ~/nodens && npm install
RUN mkdir -p ~/nodens/db

# Expose the ports
EXPOSE 22 8053 15353

# Start the supervisord
CMD ["/usr/bin/supervisord"]

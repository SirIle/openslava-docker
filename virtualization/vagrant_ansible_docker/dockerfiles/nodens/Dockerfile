# Create a docker image to run nodens by Oscar Renalias
FROM ubuntu:latest

# Hack for initctl
RUN dpkg-divert --local --rename --add /sbin/initctl
RUN ln -s /bin/true /sbin/initctl

# Update the APT cache
RUN sed -i.bak 's/main$/main universe/' /etc/apt/sources.list
RUN apt-get update
RUN apt-get upgrade -y

# Install and setup project dependencies
RUN apt-get install -y curl lsb-release supervisor openssh-server rsyslog git
RUN mkdir -p /var/run/sshd
RUN mkdir -p /var/log/supervisor
RUN locale-gen en_US en_US.UTF-8
#RUN echo "LC_ALL=C" > /etc/default/locale 
ADD supervisord.conf /etc/supervisor/conf.d/supervisor.conf
# Set the root account password
RUN echo 'root:nodens' | chpasswd

# Install node, npm
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C7917B12
RUN echo "deb http://ppa.launchpad.net/chris-lea/node.js/ubuntu $(lsb_release -cs) main" > /etc/apt/sources.list.d/node.list
RUN apt-get update
RUN apt-get -y install nodejs

# Check out the project from github and build it
RUN git clone https://github.com/oscarrenalias/nodens.git ~/nodens
RUN cd ~/nodens && npm install
RUN mkdir -p ~/nodens/db

# Expose the ports
EXPOSE 22 8053 15353

# Start the supervisord
CMD ["/usr/bin/supervisord"]

# Create a docker image to run Riak
FROM ubuntu:latest

# Update the APT cache
RUN sed -i.bak 's/main$/main universe/' /etc/apt/sources.list
RUN apt-get update
RUN apt-get upgrade -y

# Install and setup project dependencies
RUN apt-get install -y curl lsb-release supervisor openssh-server rsyslog
RUN mkdir -p /var/run/sshd
RUN mkdir -p /var/log/supervisor
RUN locale-gen en_US en_US.UTF-8
ADD supervisord.conf /etc/supervisor/conf.d/supervisor.conf
# Set the root account password
RUN echo 'root:password' | chpasswd

# install additional tools
RUN apt-get install -y git mercurial vim dnsutils

RUN curl https://go.googlecode.com/files/go1.2.linux-amd64.tar.gz -o /tmp/go1.2.linux-amd64.tar.gz
RUN tar zxvf /tmp/go1.2.linux-amd64.tar.gz -C /tmp

# clone the skydns repository and build the app (we can do a shallow clone to do it faster)
RUN git clone --depth 1 https://github.com/skynetservices/skydns.git
ENV GOPATH /tmp
ENV GOROOT /tmp/go 
RUN cd /skydns && /tmp/go/bin/go get -d -v ./... && /tmp/go/bin/go build -v .

# skydns is now built in the /skydns folder
RUN mkdir /skydns/data

# Hack for initctl
RUN dpkg-divert --local --rename --add /sbin/initctl
RUN ln -s /bin/true /sbin/initctl

# Start the supervisord
CMD ["/usr/bin/supervisord"]

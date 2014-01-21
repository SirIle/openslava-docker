FROM ubuntu:precise

MAINTAINER Kamesh Sampath, kamesh.sampath@hotmail.com

# Update the APT cache
RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN apt-get update
RUN apt-get upgrade -y

# Hack for initctl
RUN dpkg-divert --local --rename --add /sbin/initctl
RUN ln -s /bin/true /sbin/initctl

# Install and setup project dependencies
RUN apt-get install -y curl unzip lsb-release supervisor openssh-server rsyslog net-tools
RUN mkdir -p /var/run/sshd
RUN mkdir -p /var/log/supervisor
RUN locale-gen en_US en_US.UTF-8
ADD supervisord.conf /etc/supervisor/conf.d/supervisor.conf
# Set the root account password
RUN echo 'root:root' | chpasswd

# Install JRE 6, Liferay is yet to support JDK 7 officially
RUN apt-get -q -y install openjdk-6-jre

# Dowload Liferay Portal 6.2.0-ga1 Community Edition
RUN wget -Oliferay-portal-tomcat-6.2.0-ce-ga1-20131101192857659.zip  http://sourceforge.net/projects/lportal/files/Liferay%20Portal/6.2.0%20GA1/liferay-portal-tomcat-6.2.0-ce-ga1-20131101192857659.zip/download

# Unzip the Portal Tomcat Bundle
RUN unzip liferay-portal-tomcat-6.2.0-ce-ga1-20131101192857659.zip

# Create a soft link 
RUN ln -s /liferay-portal-6.2.0-ce-ga1 liferay

# Remove the bundle
RUN rm liferay-portal-tomcat-6.2.0-ce-ga1-20131101192857659.zip

# Update the sysctl.conf file

RUN sed -i.bak '$ i \ fs.file.max = 300000' /etc/sysctl.conf


# Update the limits.conf file

RUN sed -i.bak '$ i \
\*             hard     nofile         8192\n \*             soft     nofile         8192' /etc/security/limits.conf
 

# Update the setenv.sh for optimal JDK settings
RUN sed -i.bak '/CATALINA_OPTS\=/ c \CATALINA_OPTS\="$CATALINA_OPTS -server -Duser.timezone\=GMT -Djava.awt.headless\=true -Dfile.encoding\=UTF-8 -Xms1024m -Xmx1024m -XX:NewSize\=256m -XX:MaxNewSize\=256m -XX:PermSize\=256m -XX:MaxPermSize\=256m -XX:+DisableExplicitGC  -Dorg.apache.catalina.loader.WebappClassLoader.ENABLE_CLEAR_REFERENCES\=false"' /liferay/tomcat-7.0.42/bin/setenv.sh

# Change the system to use dns before files for host name resolution
RUN sed -i.bak 's/files dns/dns files/' /etc/nsswitch.conf

# Expose the ports
EXPOSE 22 8080

# Start the supervisord
CMD ["/usr/bin/supervisord"]


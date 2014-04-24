#!/bin/bash
#title           :wildfly-install.sh
#description     :The script to install Wildfly 8.x
#more            :http://sukharevd.net/wildfly-8-installation.html
#author	         :Dmitriy Sukharev
#date            :20140312
#usage           :/bin/bash wildfly-install.sh

WILDFLY_VERSION=8.1.0.CR1
WILDFLY_FILENAME=wildfly-$WILDFLY_VERSION
WILDFLY_ARCHIVE_DIR=/tmp
WILDFLY_ARCHIVE_NAME=$WILDFLY_FILENAME.tar.gz
WILDFLY_FULL_ARCHIVE_DIR=$WILDFLY_ARCHIVE_DIR/$WILDFLY_ARCHIVE_NAME
WILDFLY_DOWNLOAD_ADDRESS=http://download.jboss.org/wildfly/$WILDFLY_VERSION/$WILDFLY_ARCHIVE_NAME

INSTALL_DIR=/opt
WILDFLY_FULL_DIR=$INSTALL_DIR/$WILDFLY_FILENAME
WILDFLY_DIR=$INSTALL_DIR/wildfly

WILDFLY_USER="wildfly"
WILDFLY_SERVICE="wildfly"

WILDFLY_STARTUP_TIMEOUT=240
WILDFLY_SHUTDOWN_TIMEOUT=30

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root."
   exit 1
fi

echo "Downloading: $WILDFLY_DOWNLOAD_ADDRESS..."
[ -e "$WILDFLY_ARCHIVE_NAME" ] && echo 'Wildfly archive already exists.'
if [ ! -e "$WILDFLY_FULL_ARCHIVE_DIR" ]; then
  wget -q $WILDFLY_DOWNLOAD_ADDRESS -O $WILDFLY_FULL_ARCHIVE_DIR
  if [ $? -ne 0 ]; then
    echo "Not possible to download Wildfly."
    exit 1
  fi
fi

echo "Cleaning up..."
rm -f "$WILDFLY_DIR"
rm -rf "$WILDFLY_FULL_DIR"
rm -rf "/var/run/$WILDFLY_SERVICE/"
rm -f "/etc/init.d/$WILDFLY_SERVICE"

echo "Installation..."
mkdir $WILDFLY_FULL_DIR
tar -xzf $WILDFLY_FULL_ARCHIVE_DIR -C $INSTALL_DIR
ln -s $WILDFLY_FULL_DIR/ $WILDFLY_DIR
useradd -s /sbin/nologin $WILDFLY_USER
chown -R $WILDFLY_USER:$WILDFLY_USER $WILDFLY_DIR
chown -R $WILDFLY_USER:$WILDFLY_USER $WILDFLY_DIR/

echo "Registrating Wildfly as service..."
# if Debian-like distribution
if [ -r /lib/lsb/init-functions ]; then
    cp $WILDFLY_DIR/bin/init.d/wildfly-init-debian.sh /etc/init.d/$WILDFLY_SERVICE
    sed -i -e 's,NAME=wildfly,NAME='$WILDFLY_SERVICE',g' /etc/init.d/$WILDFLY_SERVICE
    WILDFLY_SERVICE_CONF=/etc/default/$WILDFLY_SERVICE
fi

# if RHEL-like distribution
if [ -r /etc/init.d/functions ]; then
    cp $WILDFLY_DIR/bin/init.d/wildfly-init-redhat.sh /etc/init.d/$WILDFLY_SERVICE
    WILDFLY_SERVICE_CONF=/etc/default/wildfly.conf
fi

# if neither Debian nor RHEL like distribution
if [ ! -r /lib/lsb/init-functions -a ! -r /etc/init.d/functions ]; then
cat > /etc/init.d/$WILDFLY_SERVICE << "EOF"
#!/bin/sh
### BEGIN INIT INFO
# Provides:          ${WILDFLY_SERVICE}
# Required-Start:    $local_fs $remote_fs $network $syslog
# Required-Stop:     $local_fs $remote_fs $network $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Start/Stop ${WILDFLY_FILENAME}
### END INIT INFO

WILDFLY_USER=${WILDFLY_USER}
WILDFLY_DIR=${WILDFLY_DIR}

case "$1" in
start)
echo "Starting ${WILDFLY_FILENAME}..."
start-stop-daemon --start --background --chuid $WILDFLY_USER --exec $WILDFLY_DIR/bin/standalone.sh
exit $?
;;
stop)
echo "Stopping ${WILDFLY_FILENAME}..."

start-stop-daemon --start --quiet --background --chuid $WILDFLY_USER --exec $WILDFLY_DIR/bin/jboss-cli.sh -- --connect command=:shutdown
exit $?
;;
log)
echo "Showing server.log..."
tail -500f $WILDFLY_DIR/standalone/log/server.log
;;
*)
echo "Usage: /etc/init.d/wildfly {start|stop}"
exit 1
;;
esac
exit 0
EOF
sed -i -e 's,${WILDFLY_USER},'$WILDFLY_USER',g; s,${WILDFLY_FILENAME},'$WILDFLY_FILENAME',g; s,${WILDFLY_SERVICE},'$WILDFLY_SERVICE',g; s,${WILDFLY_DIR},'$WILDFLY_DIR',g' /etc/init.d/$WILDFLY_SERVICE
fi

chmod 755 /etc/init.d/$WILDFLY_SERVICE

if [ ! -z "$WILDFLY_SERVICE_CONF" ]; then
    echo "Configuring service..."
    echo JBOSS_HOME=\"$WILDFLY_DIR\" > $WILDFLY_SERVICE_CONF
    echo JBOSS_USER=$WILDFLY_USER >> $WILDFLY_SERVICE_CONF
    echo STARTUP_WAIT=$WILDFLY_STARTUP_TIMEOUT >> $WILDFLY_SERVICE_CONF
    echo SHUTDOWN_WAIT=$WILDFLY_SHUTDOWN_TIMEOUT >> $WILDFLY_SERVICE_CONF
fi

echo "Configuring application server..."
sed -i -e 's,<deployment-scanner path="deployments" relative-to="jboss.server.base.dir" scan-interval="5000"/>,<deployment-scanner path="deployments" relative-to="jboss.server.base.dir" scan-interval="5000" deployment-timeout="'$WILDFLY_STARTUP_TIMEOUT'"/>,g' $WILDFLY_DIR/standalone/configuration/standalone.xml
sed -i -e 's,<inet-address value="${jboss.bind.address:127.0.0.1}"/>,<any-address/>,g' $WILDFLY_DIR/standalone/configuration/standalone.xml
sed -i -e 's,<inet-address value="${jboss.bind.address.management:127.0.0.1}"/>,<any-address/>,g' $WILDFLY_DIR/standalone/configuration/standalone.xml
#sed -i -e 's,<socket-binding name="ajp" port="${jboss.ajp.port:8009}"/>,<socket-binding name="ajp" port="${jboss.ajp.port:28009}"/>,g' $WILDFLY_DIR/standalone/configuration/standalone.xml
#sed -i -e 's,<socket-binding name="http" port="${jboss.http.port:8080}"/>,<socket-binding name="http" port="${jboss.http.port:28080}"/>,g' $WILDFLY_DIR/standalone/configuration/standalone.xml
#sed -i -e 's,<socket-binding name="https" port="${jboss.https.port:8443}"/>,<socket-binding name="https" port="${jboss.https.port:28443}"/>,g' $WILDFLY_DIR/standalone/configuration/standalone.xml
#sed -i -e 's,<socket-binding name="osgi-http" interface="management" port="8090"/>,<socket-binding name="osgi-http" interface="management" port="28090"/>,g' $WILDFLY_DIR/standalone/configuration/standalone.xml

service $WILDFLY_SERVICE start

echo "Done."
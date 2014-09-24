#!/bin/bash
IP=`ip -4 -o addr show dev ethwe 2> /dev/null |awk '{split($4,a,"/") ;print a[1]}'`
if [ -z $IP  ]
then
  IP=`hostname -i`
fi
if [ -z $DC ]
then
  DC=west
fi
exec /usr/local/bin/consul agent -server -advertise $IP -bootstrap-expect=1 -client 0.0.0.0 -data-dir /tmp/consul -dc $DC -config-dir /etc/consul.d -ui-dir /opt/consul_ui

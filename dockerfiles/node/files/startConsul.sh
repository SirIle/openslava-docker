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
exec /usr/local/bin/consul agent -advertise $IP -join=core -dc $DC -data-dir /tmp/consul -config-dir /etc/consul.d -ui-dir /opt/consul_ui

IP=`ip -4 -o addr show dev ethwe 2> /dev/null |awk '{split($4,a,"/") ;print a[1]}'`
if [ -z $IP  ]
then
  IP=`hostname -i`
fi
sed -i "s/^listen_address:.*/listen_address: $IP/" /etc/cassandra/cassandra.yaml
sed -i "s/^rpc_address:.*/rpc_address: 0.0.0.0/" /etc/cassandra/cassandra.yaml
sed -i "s/^# broadcast_rpc_address:.*/broadcast_rpc_address: $IP/" /etc/cassandra/cassandra.yaml
exec /usr/sbin/cassandra -f start

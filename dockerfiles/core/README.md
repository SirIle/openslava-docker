# Core container

This container includes the following:
	- Consul 0.4.1 (runs in bootstrap mode as the Consul master node)
	- Consul UI 0.4.1
	- Logstash 1.4.2
	- ElasticSearch 1.3.4
	- Nginx + Kibana 3.1.1

Core acts as the place to push the logs to using rsyslog and also
acts as the base container for Consul. The startup script names the
container "core" and when it is linked in other containers (using
the command line switch --link core:core) the other consul agents
can connect to it using just the hostname "core".

Consul UI can be found from the address http://10.10.10.30:8500/ui/dist

Kibana UI can be found from the address http://10.10.10.30

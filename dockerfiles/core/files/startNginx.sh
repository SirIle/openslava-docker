if [ -z $DOCKER_HOST_IP ]
then
  DOCKER_HOST_IP=10.10.10.30
fi
sed -i "s/elasticsearch: \"http:\/\/\"+window.location.hostname+\":9200\",/elasticsearch: \"http:\/\/$DOCKER_HOST_IP:9200\",/g"  /usr/share/nginx/html/config.js
exec /usr/sbin/nginx -c /etc/nginx/nginx.conf

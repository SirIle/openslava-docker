sudo docker rm $(sudo docker ps -a -q)
sudo docker rmi $(sudo docker images -a | grep "^<none>" | awk '{print $3}')

sudo docker rmi $(sudo docker images -a | grep "^<none>" | awk '{print $3}')

#!/bin/bash

# Stops running meteorite dock
sudo docker stop $(sudo docker ps | grep meteorite | awk '{print $1}')

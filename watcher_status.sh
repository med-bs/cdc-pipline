#!/bin/bash

#if [ "$(docker ps -q -f name=^/$1$)" ]; then
#    echo "Container $1 is running."
#else
#    echo "Container $1 is not running."
#fi

container_name=$1
container_status=$(docker inspect --format '{{.State.Status}}' "$container_name" 2>/dev/null)

if [ $? -eq 0 ]; then
    echo "Container $container_name is $container_status"
else
    echo "Container $container_name not found"
fi


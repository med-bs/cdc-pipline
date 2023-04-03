#!/bin/bash

container_name=$1
container_status=$(docker inspect --format '{{.State.Status}}' "$container_name" 2>/dev/null)

if [ $? -eq 0 ]; then
	echo "$container_status"
else
	echo "not found"
fi

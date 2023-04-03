#!/bin/bash

if docker info > /dev/null 2>&1; then

# start Watcher container
docker run -it --name watcher --link zookeeper:zookeeper --link kafka:kafka quay.io/debezium/kafka:2.1 watch-topic -a -k dbserver1.bank.transaction

else
    echo "Docker is not running"
    exit 1
fi

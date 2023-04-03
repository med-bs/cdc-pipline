#!/bin/bash

if docker info > /dev/null 2>&1; then

	# start ZooKeeper container

	./run.sh zookeeper "docker run -d --name zookeeper -p 2181:2181 -p 2888:2888 -p 3888:3888 quay.io/debezium/zookeeper:2.1"

	# wait for ZooKeeper to start
	sleep 30

	# start Kafka container
	./run.sh kafka "docker run -d --name kafka -p 9092:9092 --link zookeeper:zookeeper quay.io/debezium/kafka:2.1"

	# wait for Kafka to start
	sleep 30

	# start Connect container
	./run.sh  connect "docker run -d --name connect -p 8083:8083 -e GROUP_ID=1 -e CONFIG_STORAGE_TOPIC=my_connect_configs -e OFFSET_STORAGE_TOPIC=my_connect_offsets -e STATUS_STORAGE_TOPIC=my_connect_statuses --link kafka:kafka --link mysql:mysql quay.io/debezium/connect:2.1"

	# wait for Connect to start
	sleep 15

else
  echo "Docker is not running"
  exit 1
fi

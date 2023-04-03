#!/bin/bash

if docker info > /dev/null 2>&1; then

	# start MySQL container

	./run.sh mysql "docker run -d --name mysql --hostname mysql -p 3306:3306 -e MYSQL_ROOT_PASSWORD=root -e MYSQL_USER=mysqluser -e MYSQL_PASSWORD=mysqlpw -v db_data:/var/lib/mysql quay.io/debezium/example-mysql:2.1"

	# wait for MySQL to start
	sleep 1

else
	echo "Docker is not running"
	exit 1
fi

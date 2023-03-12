#1 zookeeper

docker run -it --name zookeeper -p 2181:2181 -p 2888:2888 -p 3888:3888 quay.io/debezium/zookeeper:2.1

#2 kafka

docker run -it --name kafka -p 9092:9092 --link zookeeper:zookeeper quay.io/debezium/kafka:2.1

#3 mysql

docker run -it --name mysql -p 3306:3306 -e MYSQL_ROOT_PASSWORD=debezium -e MYSQL_USER=mysqluser -e MYSQL_PASSWORD=mysqlpw quay.io/debezium/example-mysql:2.1


create database bank and table transaction

#4 connect

docker run -it --name connect -p 8083:8083 -e GROUP_ID=1 -e CONFIG_STORAGE_TOPIC=my_connect_configs -e OFFSET_STORAGE_TOPIC=my_connect_offsets -e STATUS_STORAGE_TOPIC=my_connect_statuses --link kafka:kafka --link mysql:mysql quay.io/debezium/connect:2.1

#5 crul ----

Open a new terminal and check the status of the Kafka Connect service:

curl -H "Accept:application/json" localhost:8083/

Check the list of connectors registered with Kafka Connect:

curl -H "Accept:application/json" localhost:8083/connectors/

Registering a connector to monitor the bank database

#########

curl -i -X POST -H "Accept:application/json" -H "Content-Type:application/json" localhost:8083/connectors/ -d '{ "name": "bank-connector", "config": { "connector.class": "io.debezium.connector.mysql.MySqlConnector", "tasks.max": "1", "database.hostname": "mysql", "database.port": "3306", "database.user": "root", "database.password": "debezium", "database.server.id": "184054", "topic.prefix": "dbserver1", "database.include.list": "bank", "schema.history.internal.kafka.bootstrap.servers": "kafka:9092", "schema.history.internal.kafka.topic": "schemahistory.bank" } }'

#########

Verify that inventory-connector is included in the list of connectors:
$ curl -H "Accept:application/json" localhost:8083/connectors/

Review the connector’s tasks:
$ curl -i -X GET -H "Accept:application/json" localhost:8083/connectors/bank-connector

#6 watcher

docker run -it --name watcher --link zookeeper:zookeeper --link kafka:kafka quay.io/debezium/kafka:2.1 watch-topic -a -k dbserver1.bank.transaction



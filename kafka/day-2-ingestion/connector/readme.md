# Apache Kafka ~ Connectors
> data sources for ingestion


### data sources ~ source
```sh
# data sources ~ datagrip

# sql server
# mysql
# postgres
# mongodb
```

### apply yaml files into k8s
```sh
# connect into k8s cluster
kubectx aks-owshq-event-stream

# access namespace
kubens ingestion

# deploy yaml files
#jdbc
k apply -f day-2-ingestion/connector/yamls/jdbc/ingest-src-postgres-food-avro.yaml -n ingestion
k apply -f day-2-ingestion/connector/yamls/jdbc/ingest-src-sqlserver-subscription-json.yaml -n ingestion
k apply -f day-2-ingestion/connector/yamls/jdbc/ingest-src-mysql-commerce-json.yaml -n ingestion

#mongodb
k apply -f day-2-ingestion/connector/yamls/mongodb/ingest-src-mongodb-restaurant-json.yaml -n ingestion

#debezium event sourcing
k apply -f day-2-ingestion/connector/yamls/debezium/ingest-src-mysql-cdc-tables-avro.yaml -n ingestion
k apply -f day-2-ingestion/connector/yamls/debezium/ingest-src-mongodb-cdc-tables-avro.yaml -n ingestion
k apply -f day-2-ingestion/connector/yamls/debezium/ingest-src-sqlserver-cdc-tables-avro.yaml -n ingestion


```

#### consume data into kafka connect source topics

```sh
# avro topics
#connect into schema registry pod
CSR=schema-registry-cp-schema-registry-544df87546-j5tvb
k exec $CSR -c cp-schema-registry-server -i -t -- bash

# unset the jmx port to use consume command lines
unset JMX_PORT;

# mongodb cdc
kafka-avro-console-consumer \
--bootstrap-server edh-kafka-bootstrap:9092 \
--property schema.registry.url=http://localhost:8081 \
--property print.key=true \
--topic cdc-mongodb.owshq.payments

kafka-avro-console-consumer \
--bootstrap-server edh-kafka-bootstrap:9092 \
--property schema.registry.url=http://localhost:8081 \
--property print.key=true \
--topic cdc-mongodb.owshq.user


# mysql cdc
kafka-avro-console-consumer \
--bootstrap-server edh-kafka-bootstrap:9092 \
--property schema.registry.url=http://localhost:8081 \
--property print.key=true \
--topic cdc-mysql.owshq.device


# sql server cdc
kafka-avro-console-consumer \
--bootstrap-server edh-kafka-bootstrap:9092 \
--property schema.registry.url=http://localhost:8081 \
--property print.key=true \
--topic cdc-sqlserver.dbo.credit_card

# postgres jdbc
kafka-avro-console-consumer \
--bootstrap-server edh-kafka-bootstrap:9092 \
--property schema.registry.url=http://localhost:8081 \
--property print.key=true \
--topic src-postgres-food-avro


# Json

# mysql jdbc
kubectl exec edh-kafka-0 -c kafka -i -t -- \
  bin/kafka-console-consumer.sh \
    --bootstrap-server localhost:9092 \
    --topic src-mysql-commerce-json

# sqlserver jdbc
kubectl exec edh-kafka-0 -c kafka -i -t -- \
  bin/kafka-console-consumer.sh \
    --bootstrap-server localhost:9092 \
    --topic src-sqlserver-subscription-json

# mongodb source connector
kubectl exec edh-kafka-0 -c kafka -i -t -- \
  bin/kafka-console-consumer.sh \
    --bootstrap-server localhost:9092 \
    --topic src.mongodb.owshq.restaurant


```

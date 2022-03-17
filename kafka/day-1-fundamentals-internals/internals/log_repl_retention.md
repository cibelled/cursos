# Apache Kafka Storage Internals
> * log replication and retention

### log replication and retention
```shell
# replication
# using the same creation of users-json
# replication factor is the configuration of how many broker will have this topic data replicated
k exec -ti edh-kafka-0 -- bin/kafka-topics.sh --create --bootstrap-server localhost:9092 --replication-factor 3 --partitions 6 --topic users-json

# retention
# retention.ms is the configuration of how many milliseconds will 
# this topic retain data, default 604800000 (7 days)
k exec -ti edh-kafka-0 -- bin/kafka-configs.sh --bootstrap-server localhost:9092 --entity-type topics --entity-name users-json --alter --add-config "retention.ms=604800000"

# this configuration [-1] is for infinity storage in this case the data of the topic would be flush
k exec -ti edh-kafka-0 -- bin/kafka-configs.sh --bootstrap-server localhost:9092 --entity-type topics --entity-name users-json --alter --add-config "retention.ms=-1"

# delete topic
k exec edh-kafka-0 -c kafka -i -t -- bin/kafka-topics.sh --bootstrap-server localhost:9092 --delete --topic users-json
```

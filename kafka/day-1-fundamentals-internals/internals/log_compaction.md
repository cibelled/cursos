# Apache Kafka Storage Internals
> * log compaction

### log compaction
```shell
# creating a topic with cleanup policy equals to compact to enable log compaction, 
# the default is delete which will delete old segments when their retention time and size limit has been reached
# delete.retention.ms = The amount of time to retain delete tombstone markers for log compacted topics
# segment.ms = This configuration controls the period of time after which kafka will force the log to roll even if 
# the segment file isn't full to ensure that retention can delete or compact old data
# min.cleanable.dirty.ratio = is configuration controls how frequently the log compactor will attempt to clean the log
k exec -ti edh-kafka-0 -- bin/kafka-topics.sh --create --bootstrap-server localhost:9092 --replication-factor 1 --partitions 1 --topic tp-log-compaction-json --config "cleanup.policy=compact" --config "delete.retention.ms=100" --config "segment.ms=100" --config "min.cleanable.dirty.ratio=0.01"

# describe topic to show configurations are in place
k exec edh-kafka-2 -c kafka -i -t -- bin/kafka-topics.sh --bootstrap-server localhost:9092 --describe --topic tp-log-compaction-json

# produce data into compact topic key:value
kubectl exec edh-kafka-0 -c kafka -i -t -- \
  bin/kafka-console-producer.sh \
  --topic tp-log-compaction-json \
  --bootstrap-server localhost:9092 \
  --property parse.key=true \
  --property key.separator=":"
  
1:Luan
2:Mateus
3:Priscila
4:Nayara

# consume data from topic to show that only the latest value is store in same 
# key for example key 1 value luan is the latest only will be show value luan
kubectl exec edh-kafka-0 -c kafka -i -t -- \
  bin/kafka-console-consumer.sh \
  --bootstrap-server localhost:9092 \
  --property print.key=true \
  --from-beginning \
  --topic tp-log-compaction-json
  
# produce data into compact topic key:value
kubectl exec edh-kafka-0 -c kafka -i -t -- \
  bin/kafka-console-producer.sh \
  --topic tp-log-compaction-json \
  --bootstrap-server localhost:9092 \
  --property parse.key=true \
  --property key.separator=":"
  
1:Paulo
2:Adilson

# consume data from topic to show that only the latest value is store in same key for example 
# key 1 value luan is the latest only will be show value luan
kubectl exec edh-kafka-0 -c kafka -i -t -- \
  bin/kafka-console-consumer.sh \
  --bootstrap-server localhost:9092 \
  --property print.key=true \
  --from-beginning \
  --topic tp-log-compaction-json
  
# alter exist topic using command line below
# create raw topic
k exec -ti edh-kafka-0 -- bin/kafka-topics.sh --create --bootstrap-server localhost:9092 --replication-factor 1 --partitions 1 --topic tp-log-compaction-alter-json

# alter topic with compact configurations
# retrieve the internal ip from cluster
kubectl exec edh-zookeeper-0 -i -t -- bin/kafka-configs.sh --bootstrap-server 10.0.218.250:9092 --entity-type topics --entity-name tp-log-compaction-alter-json --alter --add-config "cleanup.policy=compact"
kubectl exec edh-zookeeper-0 -i -t -- bin/kafka-configs.sh --bootstrap-server 10.0.218.250:9092 --entity-type topics --entity-name tp-log-compaction-alter-json --alter --add-config "min.cleanable.dirty.ratio=0.01"
kubectl exec edh-zookeeper-0 -i -t -- bin/kafka-configs.sh --bootstrap-server 10.0.218.250:9092 --entity-type topics --entity-name tp-log-compaction-alter-json --alter --add-config "delete.retention.ms=100"
kubectl exec edh-zookeeper-0 -i -t -- bin/kafka-configs.sh --bootstrap-server 10.0.218.250:9092 --entity-type topics --entity-name tp-log-compaction-alter-json --alter --add-config "segment.ms=100"

# describe topic to show the new configurations are in place
k exec edh-kafka-2 -c kafka -i -t -- bin/kafka-topics.sh --bootstrap-server localhost:9092 --describe --topic tp-log-compaction-alter-json

# delete topics
k exec edh-kafka-0 -c kafka -i -t -- bin/kafka-topics.sh --bootstrap-server localhost:9092 --delete --topic tp-log-compaction-json
k exec edh-kafka-0 -c kafka -i -t -- bin/kafka-topics.sh --bootstrap-server localhost:9092 --delete --topic tp-log-compaction-alter-json
```
# Apache Kafka Storage Internals
> * topic, partition, offset and segment

### using strimzi cluster
```shell
# set cluster and select namespace
kubectx aks-owshq-orion
kubens ingestion

# kafka and zookeeper
edh-kafka-0
edh-kafka-1
edh-kafka-2
edh-zookeeper-0
edh-zookeeper-1
edh-zookeeper-2
```

### topic, partition & offset
```shell
# create topic
k exec -ti edh-kafka-0 -- bin/kafka-topics.sh --create --bootstrap-server localhost:9092 --replication-factor 3 --partitions 6 --topic src-app-users-json

# list & describe topics
k exec -ti edh-zookeeper-0 -- bin/kafka-topics.sh --list --zookeeper localhost:12181
k exec -ti edh-zookeeper-0 -- bin/kafka-topics.sh --zookeeper localhost:12181 --describe --topic src-app-users-json

k get kafkatopics
k describe kafkatopic src-app-users-json

# produce new events to topic = src-app-users-json
# ingestion-data-stores-app
# 100 events sent to topic
# retrieve lb
python3.9 cli.py 'strimzi-users-json'

# count topic events
# get the latest offset info
TOPIC=src-app-users-json
k exec -ti edh-kafka-0 -- bin/kafka-run-class.sh kafka.tools.GetOffsetShell --broker-list localhost:9092 --topic $TOPIC --time -1 --offsets 1 | awk -F ":" '{sum += $3} END {print sum}'
k exec -ti edh-kafka-0 -- bin/kafka-run-class.sh kafka.tools.GetOffsetShell --broker-list localhost:9092 --topic $TOPIC topicName:partitionID:offset

# read messages using kafkacat
BROKER_IP=20.94.97.41:9094
kafkacat -C -b $BROKER_IP -t src-app-users-json -J -o end
```

### segments
```shell
# list directory of logs
# find log dirs - data stored
k exec -ti edh-kafka-0 -- bin/kafka-log-dirs.sh --bootstrap-server localhost:9092 --describe

# log into kafka broker
# default loc = /opt/kafka
# logDir: /var/lib/kafka/data-0/kafka-log0
k exec -ti edh-kafka-0 -- /bin/bash
/var/lib/kafka/data-0/kafka-log0

# topic name and partition
# src-app-users-json-0
# accessing partition 0
ls
ls -lh src-app-users-json-0

-rw-r--r-- 1 kafka root 10M Aug 21 13:52 00000000000000000000.index
-rw-r--r-- 1 kafka root 85K Aug 21 13:52 00000000000000000000.log
-rw-r--r-- 1 kafka root 10M Aug 21 13:52 00000000000000000000.timeindex
-rw-r--r-- 1 kafka root   8 Aug 21 13:47 leader-epoch-checkpoint

# kafka tool to dump information about segments
# partitions are sub-divided into segments [collection of messages]
# same format as received from producer and sends to producer [zero copy]
/opt/kafka/bin/kafka-run-class.sh kafka.tools.DumpLogSegments --deep-iteration --print-data-log --files /var/lib/kafka/data-0/kafka-log0/src-app-users-json-0/00000000000000000000.log
/opt/kafka/bin/kafka-run-class.sh kafka.tools.DumpLogSegments --deep-iteration --print-data-log --files /var/lib/kafka/data-0/kafka-log0/src-app-users-json-1/00000000000000000000.log
/opt/kafka/bin/kafka-run-class.sh kafka.tools.DumpLogSegments --deep-iteration --print-data-log --files /var/lib/kafka/data-0/kafka-log0/src-app-users-json-2/00000000000000000000.log

# access another broker
# broker = 1
k exec -ti edh-kafka-1 -- /bin/bash
/var/lib/kafka/data-0/kafka-log1
ls
ls -lh src-app-users-json-0
/opt/kafka/bin/kafka-run-class.sh kafka.tools.DumpLogSegments --deep-iteration --print-data-log --files /var/lib/kafka/data-0/kafka-log1/src-app-users-json-0/00000000000000000000.log

# access another broker
# broker = 2
k exec -ti edh-kafka-2 -- /bin/bash
/var/lib/kafka/data-0/kafka-log2
ls -lh src-app-users-json-0
/opt/kafka/bin/kafka-run-class.sh kafka.tools.DumpLogSegments --deep-iteration --print-data-log --files /var/lib/kafka/data-0/kafka-log2/src-app-users-json-0/00000000000000000000.log
```

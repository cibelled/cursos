# Apache Kafka Storage Internals
> * partition leadership & replication

### partition leadership & replication
```shell
# describe a topic to see the partition leadership and configs
k exec edh-kafka-0 -c kafka -i -t -- bin/kafka-topics.sh --bootstrap-server localhost:9092 --describe --topic src-app-users-json

# output:
opic: src-app-users-json       TopicId: zJnhBnJ_Rx2PJIi7SaSiTw PartitionCount: 6       ReplicationFactor: 3    Configs: message.format.version=2.8-IV1
        Topic: src-app-users-json       Partition: 0    Leader: 0       Replicas: 0,1,2 Isr: 0,1,2
        Topic: src-app-users-json       Partition: 1    Leader: 2       Replicas: 2,0,1 Isr: 2,0,1
        Topic: src-app-users-json       Partition: 2    Leader: 1       Replicas: 1,2,0 Isr: 1,2,0
        Topic: src-app-users-json       Partition: 3    Leader: 0       Replicas: 0,2,1 Isr: 0,2,1
        Topic: src-app-users-json       Partition: 4    Leader: 2       Replicas: 2,1,0 Isr: 2,1,0
        Topic: src-app-users-json       Partition: 5    Leader: 1       Replicas: 1,0,2 Isr: 1,0,2

# delete a broker to see partition leadership election
k delete pod/edh-kafka-0

# run describe in the available broker node
k exec edh-kafka-1 -c kafka -i -t -- bin/kafka-topics.sh --bootstrap-server localhost:9092 --describe --topic src-app-users-json

# output:
Topic: src-app-users-json       TopicId: zJnhBnJ_Rx2PJIi7SaSiTw PartitionCount: 6       ReplicationFactor: 3    Configs: message.format.version=2.8-IV1
        Topic: src-app-users-json       Partition: 0    Leader: 1       Replicas: 0,1,2 Isr: 1,2
        Topic: src-app-users-json       Partition: 1    Leader: 2       Replicas: 2,0,1 Isr: 2,1
        Topic: src-app-users-json       Partition: 2    Leader: 1       Replicas: 1,2,0 Isr: 1,2
        Topic: src-app-users-json       Partition: 3    Leader: 2       Replicas: 0,2,1 Isr: 2,1
        Topic: src-app-users-json       Partition: 4    Leader: 2       Replicas: 2,1,0 Isr: 2,1
        Topic: src-app-users-json       Partition: 5    Leader: 1       Replicas: 1,0,2 Isr: 1,2

# output:
# 0 is not a leader anymore
# removed from leader election
# kept into isr process 
Topic: src-app-users-json       TopicId: zJnhBnJ_Rx2PJIi7SaSiTw PartitionCount: 6       ReplicationFactor: 3    Configs: message.format.version=2.8-IV1
        Topic: src-app-users-json       Partition: 0    Leader: 1       Replicas: 0,1,2 Isr: 1,2,0
        Topic: src-app-users-json       Partition: 1    Leader: 2       Replicas: 2,0,1 Isr: 2,1,0
        Topic: src-app-users-json       Partition: 2    Leader: 1       Replicas: 1,2,0 Isr: 1,2,0
        Topic: src-app-users-json       Partition: 3    Leader: 2       Replicas: 0,2,1 Isr: 2,1,0
        Topic: src-app-users-json       Partition: 4    Leader: 2       Replicas: 2,1,0 Isr: 2,1,0
        Topic: src-app-users-json       Partition: 5    Leader: 1       Replicas: 1,0,2 Isr: 1,2,0

# now lets delete one of the in-sync replicas
# verify logs from kafka
k delete pod/edh-kafka-1
k logs strimzi-cluster-operator-c8ddd59d-kwc2j -f 
k logs pod/edh-kafka-0 -f
```
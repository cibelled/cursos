# Kubernetes & Apache Kafka ~ Strimzi

### cluster selection
```sh
# connect into k8s cluster
kubectx aks-owshq-event-stream
```

### create namespace
```sh
# create namespace
k create namespace ingestion
```

### add & update repositories
```sh
# add & update helm list repo
helm repo add strimzi https://strimzi.io/charts/
helm repo update
```

### install crd's [custom resources]
```sh
# strimzi
helm install kafka strimzi/strimzi-kafka-operator --namespace ingestion --version 0.24.0
```

```sh
# cluster name
https://kubernetes.default.svc

# secrets
k create secret generic mssql-credentials --from-file=day-1-fundamentals-internals/deployment-options/kubernetes/strimzi/kafka-connect/mssql-credentials.properties --namespace ingestion
k create secret generic minio-credentials --from-file=day-1-fundamentals-internals/deployment-options/kubernetes/strimzi/kafka-connect/minio-credentials.properties --namespace ingestion
k create secret generic yugabytedb-credentials --from-file=day-1-fundamentals-internals/deployment-options/kubernetes/strimzi/kafka-connect/yugabytedb-credentials.properties --namespace ingestion
k create secret generic postgresql-credentials --from-file=day-1-fundamentals-internals/deployment-options/kubernetes/strimzi/kafka-connect/postgresql-credentials.properties --namespace ingestion
k create secret generic mysql-credentials --from-file=day-1-fundamentals-internals/deployment-options/kubernetes/strimzi/kafka-connect/mysql-credentials.properties --namespace ingestion
k create secret generic mongodb-credentials --from-file=day-1-fundamentals-internals/deployment-options/kubernetes/strimzi/kafka-connect/mongodb-credentials.properties --namespace ingestion
k create secret generic bq-credentials --from-file=bq-credentials.json=day-1-fundamentals-internals/deployment-options/kubernetes/strimzi/kafka-connect/bq-credentials.json

# config maps
k apply -f day-1-fundamentals-internals/deployment-options/kubernetes/strimzi/metrics/kafka-metrics-config.yaml
k apply -f day-1-fundamentals-internals/deployment-options/kubernetes/strimzi/metrics/zookeeper-metrics-config.yaml
k apply -f day-1-fundamentals-internals/deployment-options/kubernetes/strimzi/metrics/connect-metrics-config.yaml
k apply -f day-1-fundamentals-internals/deployment-options/kubernetes/strimzi/metrics/cruise-control-metrics-config.yaml

# ingestion
k apply -f day-1-fundamentals-internals/deployment-options/kubernetes/strimzi/broker/kafka-jbod.yaml -n ingestion
k apply -f day-1-fundamentals-internals/deployment-options/kubernetes/strimzi/kafka-connect/kafka-connect.yaml -n ingestion
helm install schema-registry day-1-fundamentals-internals/deployment-options/kubernetes/strimzi/cp-schema-registry --namespace ingestion
```

```sh
# service
k apply -f day-1-fundamentals-internals/deployment-options/kubernetes/strimzi/lb/svc-lb-schema-registry.yaml
```

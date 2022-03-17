# HDInsight ~ Apache Kafka

https://docs.microsoft.com/en-us/azure/hdinsight/kafka/apache-kafka-introduction  
https://docs.microsoft.com/en-us/azure/hdinsight/kafka/apache-kafka-producer-consumer-api  
https://docs.microsoft.com/en-us/azure/hdinsight/kafka/apache-kafka-get-started  
https://azure.microsoft.com/en-us/blog/processing-trillions-of-events-per-day-with-apache-kafka-on-azure/  
https://docs.microsoft.com/en-us/azure/hdinsight/kafka/apache-kafka-connect-vpn-gateway  

> * deployment option = arm templates & terraform 
> * subscription = microsoft azure sponsorship
> * resource group = eastus2_owshq
> * name = owshq-apache-kafka
> * region = eastus2
> * cluster type = kafka
> * version = kafka 2.4.1 [hdi 4.0]
> * login = luanmoreno
> * pwd = Qq11ww22!!@@
> * ssh user = sshuser
> * primary storage = azure storage
> * storage account = owshqapachekafkahdistorage
> * container = owshq-apache-kafka
> * virtual network = eastus2_owshq-vnet
> * subnet = default
> * worker node = 4 cores with 32 gb of ram [3]
> * total cost per hour = [2.76 USD] 
> * time to provision = [~ 15 min]

### log & access hdinsight cluster
```sh
# ssh into driver node
ssh sshuser@owshq-apache-kafka-ssh.azurehdinsight.net

# list files inside of storage
hdfs dfs -ls /

# get cluster access info
# kafka -> summary
https://owshq-apache-kafka.azurehdinsight.net/

# get brokers
wn0-owshq.0aspga4phjdezjfl3vxdvvnlig.cx.internal.cloudapp.net
wn1-owshq.0aspga4phjdezjfl3vxdvvnlig.cx.internal.cloudapp.net
wn2-owshq.0aspga4phjdezjfl3vxdvvnlig.cx.internal.cloudapp.net

# configure kafka for ip advertising 
# kafka -> config -> kafka-env
# add into the bottom 
IP_ADDRESS=$(hostname -i)
echo advertised.listeners=$IP_ADDRESS
sed -i.bak -e '/advertised/{/advertised@/!d;}' /usr/hdp/current/kafka-broker/conf/server.properties
echo "advertised.listeners=PLAINTEXT://$IP_ADDRESS:9092" >> /usr/hdp/current/kafka-broker/conf/server.properties

# kafka -> config -> listeners
PLAINTEXT://0.0.0.0:9092

# turn [on] maintenance mode for kafka
# restart required for all components
# turn [off] maintenance mode for kafka

# retrieve fqdn
az login
az account list --output table
az account set --subscription "495322cb-95ae-4e66-b31d-1ea25d0b4ada"
az network nic list --resource-group eastus2_owshq --output table --query "[?contains(name,'node')].{NICname:name,InternalIP:ipConfigurations[0].privateIpAddress,InternalFQDN:dnsSettings.internalFqdn}"
```
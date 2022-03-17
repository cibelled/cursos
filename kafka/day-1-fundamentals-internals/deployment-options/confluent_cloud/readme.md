# Confluent Cloud

https://docs.confluent.io/ccloud-cli/current/overview.html  
https://docs.confluent.io/cloud/current/cp-component/clients-cloud-config.html  
https://docs.confluent.io/cloud/current/client-apps/config-client.html  
https://docs.confluent.io/platform/current/tutorials/examples/clients/docs/python.html  

### installing and configuring ccloud cli
```shell
# install cli
PATH='curl -L --http1.1 https://cnfl.io/ccloud-cli | sh -s -- -b /Users/luanmorenomaciel/confluent-cloud'
curl -L --http1.1 https://cnfl.io/ccloud-cli | sh -s -- -b $PATH

# add to path ~ shell
export PATH=/Users/luanmorenomaciel/confluent-cloud:$PATH;
```

### connect into cluster ~ confluent cloud
```shell
# log into the platform
# https://confluent.cloud/login
# luan.moreno@owshq.com
ccloud login

# list environment
ccloud environment list
ccloud environment use t15676

# get kafka cluster id
ccloud kafka cluster list
ccloud kafka cluster use lkc-528x8

# create an api key to connect into
# api key = VBYFU7RI6XFAYVTI
# secret = S0PlgaqXp3EQKb2OYMYOkeJiVYpHPh/sYSJtOLYK1Vg6WA24YssYFrEaIUXF0V9Q
ccloud api-key create --resource lkc-528x8
ccloud api-key use VBYFU7RI6XFAYVTI --resource lkc-528x8

# describe cluster info
ccloud kafka cluster describe lkc-528x8

# list and create topic
ccloud kafka topic list --cluster lkc-528x8

ccloud kafka topic create src-app-music-data-json
ccloud kafka topic create src-app-users-json
```

### generate streams of data 
```shell
# ingestion app
# apache kafka ~ confluent cloud
python3.9 cli.py 'confluent-cloud-users-json'
python3.9 cli.py 'confluent-cloud-musics-json'
python3.9 cli.py 'confluent-cloud-rides-json'
```
# Amazon [MSK] ~ Managed Streaming Kafka

https://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html  
https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-mac.html    
https://docs.aws.amazon.com/msk/latest/developerguide/msk-get-bootstrap-brokers.html    
https://docs.aws.amazon.com/msk/latest/developerguide/msk-default-configuration.html  
https://docs.aws.amazon.com/msk/latest/developerguide/client-access.html  
https://docs.aws.amazon.com/msk/latest/developerguide/troubleshooting.html  

> * deployment option = arm templates & terraform 
> * subscription = one-way-solution
> * cluster name = owshq-msk
> * kafka version = 2.7.1
> * cluster configuration = msk default configuration
> * vpc = vpc-6a5ecd01
> * security groups = default settings
> * brokers = kafka.m5.large

### installing and configuring aws cli
```shell
# installing aws cli v.2
curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
sudo installer -pkg AWSCLIV2.pkg -target /

# verify installation
which aws
aws --version

# latest version installed
aws-cli/2.2.18 Python/3.8.8 Darwin/20.5.0 exe/x86_64 prompt/off
```

### using aws cli to interact with amazon msk cluster
```sh
# configure cli ~ my security credentials [access keys]
# access key = AKIAZDM5WLRLENOKMKYQ
# secret access key = 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
# region name = us-east-2
# format = json
aws configure

# get and describe cluster info
aws kafka get-bootstrap-brokers --cluster-arn arn:aws:kafka:us-east-2:625785330774:cluster/owshq-msk-event-sourcing/f881f064-ff8f-4e6f-817c-e00195785636-4
aws kafka describe-cluster --cluster-arn arn:aws:kafka:us-east-2:625785330774:cluster/owshq-msk-event-sourcing/f881f064-ff8f-4e6f-817c-e00195785636-4

# brokers
b-2.owshq-msk-event-sourci.ugoz7u.c4.kafka.us-east-2.amazonaws.com:9092
b-1.owshq-msk-event-sourci.ugoz7u.c4.kafka.us-east-2.amazonaws.com:9092

# get security groups [sg] info
# access vpc ~ security groups
# set inbound rule
# pre-requisite - inside of same vpc
sg = sg-2dbbf35a
all traffic -> myip
```

# Terraform

https://www.terraform.io/
https://www.terraform.io/docs/commands/index.html

> is an open-source infrastructure as a code created by
> a company called hashicorp.
> this tool build, change, and version infrastructure safely and efficiently.
> it's common used to create a immutable infrastructure where anytime
> components are replaced the entire service or machine is created from scratch

### microsoft azure environments [prod & dev]

```sh
# building infrastructure for one machine [dev]
/Users/luanmorenomaciel/BitBucket/apache-kafka/1-deployment/vms/terraform/azure/dev-env

# building infrastructure for three machines [prod]
/Users/luanmorenomaciel/BitBucket/apache-kafka/1-deployment/vms/terraform/azure/prod-env
```

### terraform [cli]

```sh
# cli
terraform

# init process
terraform init

# generate plan
terraform plan

# apply resources
terraform apply -auto-approve

# remove resources
terraform destroy -auto-approve
```

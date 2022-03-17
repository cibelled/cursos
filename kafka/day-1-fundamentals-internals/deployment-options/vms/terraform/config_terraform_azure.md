# Configuring Terraform on Azure
> how to configure terraform to connect into the
> microsoft azure cloud resource

https://docs.microsoft.com/en-us/azure/virtual-machines/linux/terraform-install-configure

### install terraform on microsoft azure
```sh
# install using brew
brew install terraform

# update if necessary
brew upgrade terraform
```

### initial command
```sh
# initial command
terraform
```

### set up microsoft azure
```sh

# list available subscriptions
az account list --query "[].{name:name, subscriptionId:id, tenantId:tenantId}"

# subscription
{
  "name": "Microsoft Azure Sponsorship",
  "subscriptionId": "495322cb-95ae-4e66-b31d-1ea25d0b4ada",
  "tenantId": "876c68e8-02d9-4abc-912e-4b9d8fc61c1e"
}

# set up subscription
SUBSCRIPTION_ID="495322cb-95ae-4e66-b31d-1ea25d0b4ada"
az account set --subscription="${SUBSCRIPTION_ID}"

# create a service principal
az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/${SUBSCRIPTION_ID}"

# output info
{
  "appId": "eed98ee9-966f-492c-a950-bf2bf757f9ad",
  "displayName": "azure-cli-2020-02-01-20-04-51",
  "name": "http://azure-cli-2020-02-01-20-04-51",
  "password": "2a6e4605-cfbe-4bbf-9af8-83e5c19da2c9",
  "tenant": "876c68e8-02d9-4abc-912e-4b9d8fc61c1e"
}
```

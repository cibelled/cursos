# Ansible Playbook for Confluent Platform
> ansible is a configuration management tool that allows us to create  
> playbooks to install and configure resources. this playbook created by  
> confluent configures apache kafka in multiple machines

https://docs.ansible.com/ansible/latest/user_guide/intro_inventory.html  
https://docs.confluent.io/current/installation/installing_cp/cp-ansible.html  
https://github.com/confluentinc/cp-ansible  
https://docs.confluent.io/current/installation/scripted-install.html  
https://docs.confluent.io/current/installation/available_packages.html#available-packages  
https://docs.confluent.io/current/installation/cli-reference.html  

### install ansible
https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html  
```sh
# install ansible
brew install ansible
```

### pull latest ansible playbook
```sh
# ansible location
/Users/luanmorenomaciel/BitBucket/apache-kafka/1-deployment/vms/ansible

# delete old version [make this only when new stable version available]
rm -rf cp-ansible

# clone branch [functional]
git clone --branch 6.0.x https://github.com/confluentinc/cp-ansible
```

### cp-playbook [confluent platform]
```sh
# location of files
/Users/luanmorenomaciel/BitBucket/apache-kafka/1-deployment/vms/ansible/cp-ansible

# remove vms from /Users/luanmorenomaciel/.ssh/known_hosts
nano /Users/luanmorenomaciel/.ssh/known_hosts

# ssh-agent and add ssh private key
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa

# connect on [vms] to fill know_hosts

# dev
ssh luanmoreno@dev-kafka-confluent.eastus2.cloudapp.azure.com

# prod
ssh luanmoreno@prod-kafka-confluent-1.eastus2.cloudapp.azure.com
ssh luanmoreno@prod-kafka-confluent-2.eastus2.cloudapp.azure.com
ssh luanmoreno@prod-kafka-confluent-3.eastus2.cloudapp.azure.com

# confirm ansible can connect over ssh
ansible -i hosts-dev.yml all -m ping
ansible -i hosts-prod.yml all -m ping

# running playbook installation
ansible-playbook -i hosts-dev.yml all.yml
ansible-playbook -i hosts-prod.yml all.yml
```

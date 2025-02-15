## Install ansible

```
sudo apt update
sudo apt install software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install ansible
```

## Install dependencies

```
wget https://github.com/ansible-collections/azure/blob/dev/requirements.txt
pip install -r requirements.txt && \
ansible-galaxy collection install azure.azcollection:1.11.0
```

## Run Dynamic inventory for VMs
### inventory file must end with azure_rm.yml
```
ansible-inventory -i vmazure_rm.yml --graph
```

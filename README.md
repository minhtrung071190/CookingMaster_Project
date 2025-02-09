# ARCHITECTURE:
![alt text](Cloud_Architecture.jpg)

## PREREQUISITES:
## Install Azure CLI:

```
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
```
## Login to Azure

```
az login
```

## Set credentials to env variables:

```
export TF_VAR_DOCKER_REGISTRY_USER="docker username"
export TF_VAR_DOCKER_REGISTRY_PASSWORD="docker password"
export ARM_SUBSCRIPTION_ID="azure subscription ID"
```

## Deploy terraform

```
terraform apply -var="docker_registry_username=$TF_VAR_DOCKER_REGISTRY_USERNAME" -var="docker_registry_password=$TF_VAR_DOCKER_REGISTRY_PASSWORD" --auto-approve

```


# Ansible

## Overview

This repo is used for a personal lab.
It leverages the following:
 - Ansible (Configuration Management)
 - HashiCorp Vault (Secrets Management)

## Getting Started

Stage host environment variables

```bash
export VAULT_TOKEN="SuperInsecureP@ssw0rd"
export VAULT_ADDR=http://127.0.0.1:8200
```

Launch a development Vault instance

```Docker
docker run --name vault \
--cap-add=IPC_LOCK \
-e 'VAULT_DEV_ROOT_TOKEN_ID=${VAULT_TOKEN}' \
-e 'VAULT_DEV_LISTEN_ADDRESS=0.0.0.0:8200' \
-p 8200:8200 \
-d vault
```

Download HashiCorp Vault CLI
```wget
https://www.vaultproject.io/downloads
```

Create default secrets

```bash
vault kv put secret/junos username=foo password=bar
vault kv put secret/cisco/asa username=foo password=bar enable=secret
```

Stand up Ansible

```python
######
# Note: Update inventory.py as needed
######

# Install pipenv to create a virtual env
cd ansible
pip3 install pipenv

# Launch virtual env
pipenv shell

# Install requirements
pip install -r requirements.txt
ansible-galaxy collection install juniper.device

# Make inventory.py executable
chmod +x inventory.py
```

Test Ansible

```python
# Test inventory
ansible all -i inventory.py -m ping

# Test playbook
ansible-playbook playbooks/example.yml

```
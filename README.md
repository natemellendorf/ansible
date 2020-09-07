# Ansible

## Overview

This project was created to help manage/orchestrate a lab environment.  
With Docker, It streamlines the deployment of Ansible and HashiCorp Vault to quickly get you testing.  
Python and HashiCorp Vault are leveraged to keep inventory dynamic and secrets secure.

## Tools

 - [Ansible](https://www.ansible.com/)
 - [HashiCorp Vault](https://www.vaultproject.io/)
 - [Docker](https://docs.docker.com/get-docker/)
 - [Python](https://www.python.org/)

## Demo

![init.sh](demo/init.gif)

## Assumptions

This project assumues the following are True:
 - You have docker installed on your lab workstation
 - For the first run of init.sh, you'll have internet access
 - You have a lab environment with either Junos or Cisco ASAs deployed
 - You're comfortible editing strings in Python

## Getting Started

To save time and to reduce steps, I've created an init script for this project.  
To begin, simply run the init script with the steps below.  

```bash
git clone https://github.com/natemellendorf/ansible.git
cd ansible

# Edit ./init.sh, and update the [Replace as needed] section
# Edit ./ansible/inventory/inventory.py, and update the hostvars as needed

chmod +x init.sh
sh init.sh
```

### What does init.sh do?

Watch the [demo](demo/init.gif) to see it in action.  
This init script will perform the following tasks:
 - Set temp environment variables for HashiCorp Vault
 - Download the HashiCorp Vault container
 - Build an Ansible container
   - The container will use the files located in the ansible directoy
 - Start the Vault container
 - Exec into the Vault container, and create the secrets you set in init.sh
 - Start the Ansible container
   - At this point, you'll be free to run ansible commands
 - When complete, remove the containers

### How does [inventory.py](ansible/inventory/inventory.py) work?

[Inventory.py](ansible/inventory/inventory.py) is a dynamic inventory script written in Python.  
Currently, it's outputs are hard coded with an exception for device secrets.  
Using the [HashiCorp Python SDK](https://pypi.org/project/hvac/), it will retrieve the secrets created by init.sh on each playbook run.

## Testing

```bash
# Test your inventory
ansible all -m ping

# Run an example playbook against all devices
ansible-playbook playbooks/example.yml

```

## To Do

- Integrate [Vagrant](https://www.vagrantup.com/) to deploy a fleet of network devices with init.sh
- Integrate NetBox, and rewrite [inventory.py](ansible/inventory/inventory.py) to leverage its API for device inventory
- Update [docker-compose.yml](docker-compose.yml) to deploy additional containers
- Write additonal tests in GitHub actions
- Go to the beach...

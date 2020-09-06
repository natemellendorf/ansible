#!/bin/bash

red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`

# Create Vault Secret
if export DEV_VAULT_TOKEN="SuperInsecureP@ssw0rd" ; then
    echo "Create env: DEV_VAULT_TOKEN: ${green}SUCCESS${reset}"
else
    echo "Create env: DEV_VAULT_TOKEN: ${red}FAILED${reset}"
    exit 1
fi

# Create Vault Address
if export DEV_VAULT_ADDR=http://127.0.0.1:8200 ; then
    echo "Create env: DEV_VAULT_ADDR: ${green}SUCCESS${reset}"
else
    echo "Create env: DEV_VAULT_ADDR: ${red}FAILED${reset}"
    exit 1
fi


# Build Dockerfiles
if docker-compose build ; then
    echo "Create env: DEV_VAULT_ADDR: ${green}SUCCESS${reset}"
else
    echo "Create env: DEV_VAULT_ADDR: ${red}FAILED${reset}"
    exit 1
fi


# Start containers
if docker compose up ; then
    echo "Create env: DEV_VAULT_ADDR: ${green}SUCCESS${reset}"
else
    echo "Create env: DEV_VAULT_ADDR: ${red}FAILED${reset}"
    exit 1
fi

# Create Junos secret
if docker exec -it vault "vault kv put secret/junos username=foo password=bar" ; then
    echo "Create env: DEV_VAULT_ADDR: ${green}SUCCESS${reset}"
else
    echo "Create env: DEV_VAULT_ADDR: ${red}FAILED${reset}"
    exit 1
fi

# Create ASA Secret
if docker exec -it vault "vault kv put secret/cisco/asa username=foo password=bar enable=secret" ; then
    echo "Create env: DEV_VAULT_ADDR: ${green}SUCCESS${reset}"
else
    echo "Create env: DEV_VAULT_ADDR: ${red}FAILED${reset}"
    exit 1
fi

echo "Script: ${green}COMPLETE!${reset}"
exit 0

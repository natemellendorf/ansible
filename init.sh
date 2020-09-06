#!/bin/bash
lock="\360\237\224\222"
pass="\342\234\205\n"
fail="\342\235\214\n"
bold=$(tput bold)
normal=$(tput sgr0)

# Create Vault Secret
if export DEV_VAULT_TOKEN="SuperInsecureP@ssw0rd" ; then
    printf "${bold}> CREATE ENV:${normal} DEV_VAULT_TOKEN: ${pass}"
else
    echo "${bold}> CREATE ENV:${normal} DEV_VAULT_TOKEN: ${fail}"
    exit 1
fi

# Create Vault Address
if export DEV_VAULT_ADDR=http://127.0.0.1:8200 ; then
    printf "${bold}> CREATE ENV:${normal} DEV_VAULT_ADDR: ${pass}"
else
    echo "${bold}> CREATE ENV:${normal} DEV_VAULT_ADDR: ${fail}"
    exit 1
fi


# Build Dockerfiles
if docker-compose build ; then
    echo "Build Images: ${pass}"
else
    echo "Build Images: ${fail}"
    exit 1
fi


# Start containers
if docker-compose up -d ; then
    echo "Start Containers: ${pass}"
else
   echo "Start Containers: ${fail}"
    exit 1
fi

# Create Junos secret
if docker exec -it vault "vault kv put secret/junos username=foo password=bar" ; then
    echo "${lock} Vault - Create Junos Secret: ${pass}"
else
    echo "${lock} Vault - Create Junos Secret: ${fail}"
    exit 1
fi

# Create ASA Secret
if docker exec -it vault "vault kv put secret/cisco/asa username=foo password=bar enable=secret" ; then
    echo "${lock} Vault - Create ASA Secret: ${pass}"
else
    echo "${lock} Vault - Create ASA Secret: ${fail}"
    exit 1
fi

echo "${pass} ${pass} ${pass} Complete! "
exit 0

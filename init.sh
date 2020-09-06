#!/bin/bash
lock="\360\237\224\222"
pass="\342\234\205"
fail="\342\235\214"

bold=$(tput bold)
normal=$(tput sgr0)


# Create Vault Secret
echo "\n${bold}> ${lock} CREATE ENV DEV_VAULT_TOKEN ${normal}"
if export DEV_VAULT_TOKEN="SuperInsecureP@ssw0rd" ; then
    echo "\n> ${pass} Success\n"
else
    echo "\n> ${fail} Failure\n"
    exit 1
fi

# Create Vault Address
echo "\n${bold}> ${lock} CREATE ENV DEV_VAULT_ADDR ${normal}"
if export DEV_VAULT_ADDR=http://127.0.0.1:8200 ; then
    echo "\n> ${pass} Success\n"
else
    echo "\n> ${fail} Failure\n"
    exit 1
fi


# Build Dockerfiles
echo "\n${bold}> ${lock} Build Images ${normal}"
if docker-compose build > /dev/null ; then
    echo "\n> ${pass} Success\n"
else
    echo "\n> ${fail} Failure\n"
    exit 1
fi


# Start containers
echo "\n${bold}> ${lock} Start Containers ${normal}"
if docker-compose up -d > /dev/null ; then
    echo "\n> ${pass} Success\n"
else
    echo "\n> ${fail} Failure\n"
    exit 1
fi

# Give Vault a moment to init
sleep 5

# Create Junos secret
echo "\n${bold}> ${lock} Vault ${lock} - Create Junos Secret ${normal}"
if docker exec -it ansible_vault_1 vault kv put secret/junos username=foo password=bar > /dev/null ; then
    echo "\n> ${pass} Success\n"
else
    echo "\n> ${fail} Failure\n"
    exit 1
fi

# Create ASA Secret
echo "\n${bold}> ${lock} Vault ${lock} - Create ASA Secret ${normal}"
if docker exec -it ansible_vault_1 vault kv put secret/cisco/asa username=foo password=bar enable=secret > /dev/null ; then
    echo "\n> ${pass} Success\n"
else
    echo "\n> ${fail} Failure\n"
    exit 1
fi

echo "\n${bold}---->> COMPLETE <<----${normal}"

# Start containers
#if docker-compose down ; then
#    echo "\n${bold}> Stop Containers ${normal}"
#else
#   echo "\n${bold}> Stop Containers ${normal}"
#    exit 1
#fi

#!/bin/bash
lock="\360\237\224\222"
pass="\342\234\205"
fail="\342\235\214"
info="\360\237\214\237"
bold=$(tput bold)
normal=$(tput sgr0)

success () {
    echo "\n> ${pass} Success\n"
}

failure () {
    echo "\n> ${fail} Failure\n"
}

info () {
    echo "\n${bold}> ${info} $1 ${normal}"
}

vault () {
    echo "\n${bold}> ${lock} Vault ${lock} - $1 ${normal}"
}

# Create Vault Secret
info "CREATE ENV DEV_VAULT_TOKEN"
if export DEV_VAULT_TOKEN="SuperInsecureP@ssw0rd" ; then
    success
else
    failure
fi

# Create Vault Address
info "CREATE ENV DEV_VAULT_ADDR"
if export DEV_VAULT_ADDR=http://127.0.0.1:8200 ; then
    success
else
    failure
fi

# Build Dockerfiles
info "BUILD IMAGES"
if docker-compose build ; then
    success
else
    failure
fi

# Start containers
info "START CONTAINERS"
if docker-compose up -d > /dev/null ; then
    success
else
    failure
fi

# Give Vault a moment to init
sleep 5

# Create Junos secret
vault "Create Junos Secret"
if docker exec -it ansible_vault_1 vault kv put secret/junos username=foo password=bar ; then
    success
else
    failure
fi

# Create ASA Secret
vault "Create ASA Secret"
if docker exec -it ansible_vault_1 vault kv put secret/cisco/asa username=foo password=bar enable=secret ; then
    success
else
    failure
fi

echo "\n${bold}---->> COMPLETE <<----${normal}"

# Start containers
#if docker-compose down ; then
#    echo "\n${bold}> Stop Containers ${normal}"
#else
#   echo "\n${bold}> Stop Containers ${normal}"
#    exit 1
#fi

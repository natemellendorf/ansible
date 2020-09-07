#!/bin/bash

# Replace as needed
# Secrets to access devices

junos_username="user"
junos_password="password"
asa_username="user"
asa_password="password"
asa_enable_secret="password"

# Set emojis
lock="\360\237\224\222"
pass="\342\234\205"
fail="\342\235\214"
info="\360\237\214\237"

# Be bold!
bold=$(tput bold)
normal=$(tput sgr0)

# Reusable echos
success () {
    echo -e "\n> ${pass} Success\n"
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

# Set Vault Secret
info "CREATE ENV DEV_VAULT_TOKEN"
if export DEV_VAULT_TOKEN="SuperInsecureP@ssw0rd" ; then
    success
else
    failure
fi

# Set Vault Address
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

# Create Junos secretin vault
vault "Create Junos Secret"
if docker exec -it ansible_vault_1 \
       vault kv put secret/junos \
       username=${junos_username} \
       password=${junos_password} ; then
    success
else
    failure
fi

# Create ASA Secret in vault
vault "Create ASA Secret"
if docker exec -it ansible_vault_1 \
       vault kv put secret/cisco/asa \
       username=${asa_username} \
       password=${asa_password} \
       enable=${asa_enable_secret} ; then
    success
else
    failure
fi

echo "\n${bold}---->> READY <<----${normal}"

# Create ASA Secret in vault
info "Start Ansible container"
if docker-compose run ansible ; then
    success
else
    failure
fi

# Cleanup
info "Clean up containers"
if docker-compose down ; then
   success
else
  faulire
fi

echo "\n${bold}---->> COMPLETE <<----${normal}"

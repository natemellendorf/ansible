#!/usr/bin/env python3

'''
Example custom dynamic inventory script for Ansible, in Python.
'''

import os
import sys
import argparse
import hvac

try:
    import json
except ImportError:
    import simplejson as json

class Inventory(object):

    def __init__(self):
        self.inventory = {}
        self.read_cli_args()
        self.inventory = self.empty_inventory()

        hcv_url = os.environ.get("VAULT_ADDR")
        hcv_token = os.environ.get("VAULT_TOKEN")
        env = (sys.executable)

        # Authenticate to HashiCorp Vault
        client = hvac.Client(url=hcv_url, token=hcv_token)

        # If authenticated, continue
        if client.is_authenticated():

            # Called with `--list`.
            # Note: Ansible will invoke --list automatically
            if self.args.list:
                self.inventory = self.device_inventory(client=client, env=env)
            # Called with `--host [hostname]`.
            elif self.args.host:
                # Not implemented, since we return _meta info `--list`.
                self.inventory = self.empty_inventory()
            # If no groups or vars are present, return an empty inventory.
            else:
                self.inventory = self.device_inventory(client=client, env=env)

        # Print the inventory for Ansible
        print(json.dumps(self.inventory, sort_keys=True, indent=4))

    # Example inventory for testing.
    def device_inventory(self, **kwargs):

        client = kwargs["client"]
        env = kwargs["env"]

        junos_secrets = client.secrets.kv.read_secret_version(path='junos')
        asa_secrets = client.secrets.kv.read_secret_version(path='cisco/asa')

        device_dict = {
            'asa': {
                'hosts': ['asa1', 'asa2'],
                'vars': {
                    'ansible_connection': 'network_cli',
                    'ansible_network_os': 'asa',
                    'ansible_python_interpreter': env,
                    'ansible_user': asa_secrets['data']['data'].get('username'),
                    'ansible_ssh_pass': asa_secrets['data']['data'].get('password'),
                    'ansible_become': 'yes',
                    'ansible_become_method': 'enable',
                    'ansible_become_pass': asa_secrets['data']['data'].get('enable')
                }
            },
            'junos': {
                'hosts': ['edge_fw1', 'srx1', 'srx2'],
                'vars': {
                    'ansible_connection': 'network_cli',
                    'ansible_network_os': 'junos',
                    'ansible_python_interpreter': env,
                    'ansible_user': junos_secrets['data']['data'].get('username'),
                    'ansible_ssh_pass': junos_secrets['data']['data'].get('password'),
                }
            },
            '_meta': {
                'hostvars': {
                    'asa1': {
                        'ansible_host': '10.10.0.43'
                    },
                    'asa2': {
                        'ansible_host': '10.10.0.47'
                    },
                    'edge_fw1': {
                        'ansible_host': '10.10.0.1'
                    },
                    'srx1': {
                        'ansible_host': '10.10.0.46'
                    },
                    'srx2': {
                        'ansible_host': '10.10.0.45'
                    }
                }
            }
        }

        return device_dict

    # Empty inventory for testing.
    def empty_inventory(self):
        return {'_meta': {'hostvars': {}}}

    # Read the command line args passed to the script.
    def read_cli_args(self):
        parser = argparse.ArgumentParser()
        parser.add_argument('--list', action = 'store_true')
        parser.add_argument('--host', action = 'store')
        self.args = parser.parse_args()

# Get the inventory.
Inventory()
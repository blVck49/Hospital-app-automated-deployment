#!/bin/bash -eux

# Uninstall Ansible and remove PPA.
sudo apt-get autoremove --purge ansible -y
sudo add-apt-repository --remove ppa:ansible/ansible

# Add `sync` so Packer doesn't quit too early, before files are deleted.
sudo sync

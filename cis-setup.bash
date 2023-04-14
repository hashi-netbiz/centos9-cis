#!/usr/bin/env bash
# This script sets up the CIS benchmark a centos 9 stream VM in Azure.

# install ansible and configure CIS benchmark
dnf install ansible-core -y
# update hosts file
cat << 'EOF' >> /etc/ansible/hosts
localhost ansible_connection=local

EOF

# execute ansible playbook to install CIS benchmarks
ansible-playbook '/root/centos9-cis/cis_5.2.yml'

# Tidy up
rm -rf centos9-cis
yum erase git-core -y
rm -f .gitconfigS
rm -f ~/.bash_history
export HISTSIZE=0



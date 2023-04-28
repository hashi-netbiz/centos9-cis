#!/bin/bash
# update hosts file
cat << 'EOF' >> /etc/ansible/hosts
localhost ansible_connection=local
EOF

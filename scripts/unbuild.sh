#!/bin/sh

. scripts/env.sh
ansible-playbook --extra-vars "ec2_keypair=$EC2_KEYPAIR" -i playbooks/cluster.hosts --private-key="$PEM_FILE" playbooks/aws_teardown.yml

## Cleanup
test -z "$PEM_FILE" || rm -f "$PEM_FILE"
$EC2_HOME/bin/ec2-delete-keypair vgonzalez_jenkins


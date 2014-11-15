#!/bin/bash

. "scripts/env.sh" || exit -1
. "$WD/aws/credentials.sh" || exit -1

test -d $EC2_HOME || exit -1

ansible-playbook \
	-i hosts \
	"$WD/playbooks/aws_bootstrap.yml"

ansible all -i playbooks/cluster.hosts -m ping

ansible-playbook \
	-i playbooks/cluster.hosts \
	"$WD/playbooks/install_cluster.yml"


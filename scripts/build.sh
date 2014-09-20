#!/bin/bash

. "scripts/env.sh" || exit -1
. "$WD/aws/credentials.sh" || exit -1

test -d $EC2_HOME || exit -1

$EC2_HOME/bin/ec2-delete-keypair $EC2_KEYPAIR
$EC2_HOME/bin/ec2-create-keypair $EC2_KEYPAIR | grep -A 50 BEGIN > $PEM_FILE
chmod 0600 $PEM_FILE

ansible-playbook \
	--extra-vars "ec2_keypair=$EC2_KEYPAIR ec2_name_tag=$CLUSTER_NAME" \
	-i hosts \
	--private-key="$PEM_FILE" "$WD/playbooks/aws_bootstrap.yml"

ansible all -i playbooks/cluster.hosts --private-key $PEM_FILE -m ping

ansible-playbook \
	--extra-vars "ec2_keypair=$EC2_KEYPAIR ec2_name_tag=$CLUSTER_NAME" \
	-i playbooks/cluster.hosts \
	--private-key="$PEM_FILE" "$WD/playbooks/install_cluster.yml"


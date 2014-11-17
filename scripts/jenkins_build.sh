#!/bin/bash

# . "scripts/env.sh" || exit -1
# . "$WD/aws/credentials.sh" || exit -1

export CLUSTER_NAME="jenkins-vgonzalez"
export EC2_KEYPAIR="jenkins-vgonzalez"
export PEM_FILE="jenkins-vgonzalez.pem"
export EC2_HOME=/opt/ec2-api-tools-1.7.0.2

test -d $EC2_HOME || exit -1

$EC2_HOME/bin/ec2-delete-keypair $EC2_KEYPAIR
$EC2_HOME/bin/ec2-create-keypair $EC2_KEYPAIR | grep -A 50 BEGIN > $PEM_FILE
chmod 0600 $PEM_FILE

ansible-playbook \
	-i hosts \
	--extra-vars "ec2_keypair=$EC2_KEYPAIR ec2_name_tag=$CLUSTER_NAME" \
	--extra-vars "cluster_node_type=m3.xlarge cluster_node_price=0.17" \
	--extra-vars "edge_node_type=m3.xlarge edge_node_price=0.17" \
	--private-key="$PEM_FILE" "$WD/playbooks/aws_bootstrap.yml"

ansible all -i playbooks/cluster.hosts --private-key $PEM_FILE -m ping

ansible-playbook \
	-i playbooks/cluster.hosts \
	--extra-vars "ec2_keypair=$EC2_KEYPAIR ec2_name_tag=$CLUSTER_NAME" \
	--private-key="$PEM_FILE" "$WD/playbooks/install_cluster.yml"

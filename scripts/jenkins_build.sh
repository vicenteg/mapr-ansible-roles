#!/bin/bash

export JAVA_HOME="/usr/lib/jvm/java-7-openjdk-amd64"
export CLUSTER_NAME="jenkins-vgonzalez"
export EC2_KEYPAIR="jenkins-vgonzalez"
export PEM_FILE="jenkins-vgonzalez.pem"
export EC2_HOME=/opt/ec2-api-tools-1.7.0.2
export ANSIBLE_FORCE_COLOR=true

test -z INSTANCE_TYPE && INSTANCE_TYPE=m3.xlarge
test -z INSTANCE_PRICE && INSTANCE_PRICE=""

test -d $EC2_HOME || exit -1

$EC2_HOME/bin/ec2-delete-keypair $EC2_KEYPAIR
$EC2_HOME/bin/ec2-create-keypair $EC2_KEYPAIR | grep -A 50 BEGIN > $PEM_FILE
chmod 0600 $PEM_FILE

ansible-playbook \
	-i hosts \
	--extra-vars "ec2_keypair=$EC2_KEYPAIR ec2_name_tag=$CLUSTER_NAME" \
	--extra-vars "cluster_node_type=$INSTANCE_TYPE cluster_node_price=$INSTANCE_PRICE" \
	--extra-vars "edge_node_type=$INSTANCE_TYPE edge_node_price=$INSTANCE_PRICE" \
	--extra-vars "cluster_node_count=6" \
	--private-key="$PEM_FILE" playbooks/aws_bootstrap.yml

ansible all -i playbooks/cluster.hosts --private-key="$PEM_FILE" -u root -m ping

ansible-playbook \
	-i playbooks/cluster.hosts -u root \
	--extra-vars "ec2_keypair=$EC2_KEYPAIR ec2_name_tag=$CLUSTER_NAME" \
	--private-key="$PEM_FILE" playbooks/install_cluster.yml

# ansible-playbook \
# 	-i playbooks/cluster.hosts -u root \
# 	--private-key="$PEM_FILE" playbooks/install_spark.yml

# ansible-playbook \
# 	-i playbooks/cluster.hosts -u root \
# 	--private-key="$PEM_FILE" playbooks/install_impala.yml


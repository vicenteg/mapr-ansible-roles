#!/bin/bash

export JAVA_HOME="/usr/lib/jvm/java-7-openjdk-amd64"
export CLUSTER_NAME="jenkins-vgonzalez"
export EC2_KEYPAIR="jenkins-vgonzalez"
export PEM_FILE="jenkins-vgonzalez.pem"
export ANSIBLE_FORCE_COLOR=true

ansible-playbook \
	-i playbooks/cluster.hosts -u root \
	--extra-vars "ec2_keypair=$EC2_KEYPAIR" \
	--private-key="$PEM_FILE" playbooks/test_cluster.yml



#!/bin/sh

export JAVA_HOME="/usr/lib/jvm/java-7-openjdk-amd64"
export CLUSTER_NAME="jenkins-vgonzalez"
export EC2_KEYPAIR="jenkins-vgonzalez"
export PEM_FILE="jenkins-vgonzalez.pem"
export EC2_HOME=/opt/ec2-api-tools-1.7.0.2
export ANSIBLE_FORCE_COLOR=true

ansible-playbook --extra-vars "ec2_keypair=$EC2_KEYPAIR" -i playbooks/cluster.hosts --private-key="$PEM_FILE" playbooks/aws_teardown.yml

## Cleanup
test -z "$PEM_FILE" || rm -f "$PEM_FILE"
$EC2_HOME/bin/ec2-delete-keypair "$EC2_KEYPAIR"


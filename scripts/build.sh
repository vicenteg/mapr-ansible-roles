#!/bin/bash

EC2_KEYPAIR=vgonzalez_keypair
KEYPAIR_PATH=~/.ssh/vgonzalez_keypair.pem
CLUSTER_NAME="my.cluster.com"
CLUSTER_NODE_TYPE="m1.large"
EDGE_NODE_TYPE="m1.large"
CLUSTER_NODE_PRICE=
EDGE_NODE_PRICE=
ROOT_DEVICE="/dev/xvde"
ROOT_FS="/dev/xvde1"
MAPR_DISKS='["/dev/xvdf","/dev/xvdg"]'

if [ ! -e playbooks/cluster.hosts ]; then
	ansible-playbook \
		-i hosts \
		-e "cluster_node_type=$CLUSTER_NODE_TYPE" \
		-e "cluster_node_price=$CLUSTER_NODE_PRICE" \
		-e "edge_node_type=$EDGE_NODE_TYPE" \
		-e "edge_node_price=$EDGE_NODE_PRICE" \
		-e "ec2_keypair=$EC2_KEYPAIR" \
		-e "root_device_path=$ROOT_DEVICE" \
		-e "root_fs=$ROOT_FS" \
		-e "mapr_cluster_name=$CLUSTER_NAME" \
		"playbooks/aws_bootstrap.yml"
fi

if ansible all -f6 --private-key $KEYPAIR_PATH -i playbooks/cluster.hosts -m ping; then
	echo ansible-playbook \
		-f6 \
		--private-key $KEYPAIR_PATH \
		-i playbooks/cluster.hosts \
		-e \'{ \"mapr_cluster_name\": \"$CLUSTER_NAME\", \"mapr_disks\": $MAPR_DISKS }\' \
		"playbooks/install_cluster.yml" | sh -s
fi

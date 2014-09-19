#!/bin/bash

. scripts/env.sh

ansible-playbook -i "$WD/playbooks/cluster.hosts" --private-key="$PEM_FILE" "$WD/playbooks/test_cluster.yml"


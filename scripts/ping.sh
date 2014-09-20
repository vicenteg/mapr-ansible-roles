#!/bin/bash

if [ -x playbooks/cluster.hosts ]; then
	echo "No cluster inventory found."
	exit 1
fi

. scripts/env.sh

ansible -m ping --private-key "$PEM_FILE" -i playbooks/cluster.hosts all 

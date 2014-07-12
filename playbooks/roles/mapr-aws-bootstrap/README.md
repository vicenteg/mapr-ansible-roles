mapr-aws-bootstrap
========

This role uses the ec2 module via a local action to set up a multi-node MapR cluster with 3 non-cluster nodes. The service layout attempts to mostly follow the 5-node HA M5 cluster described here: http://doc.mapr.com/display/MapR/Planning+the+Cluster#PlanningtheCluster-ExampleClusterDesigns

It does not yet automatically set up service layout to match larger clusters.

This role will only create the nodes - it will not apply any configuration or install any packages. Once you've bootstrapped your cluster, you can follow the instructions at the below link to do the installation:

https://github.com/vicenteg/mapr-singlenode-vagrant#installation---aws


Requirements
------------

1. AWS credentials (account ID and secret key). If you don't know what this means, read this: http://docs.aws.amazon.com/general/latest/gr/getting-aws-sec-creds.html
2. We will provision nodes in a VPC. A VPC must exist, with at least one subnet. You'll need the subnet ID.
3. You will need a base image. This has been tested with the CentOS 6.5 AMI in us-east-1 having ID `ami-8997afe0`.
4. You will need your SSH keypair already generated and available in AWS.
5. You will need a security group. The cluster that results from the install_cluster play uses a security group that allows ports 22 and 8443 as well as all traffic originating from the VPC subnet.

When run, the play will expect to obtain AWS credentials from environment variables. A sample file is provided here: https://github.com/vicenteg/mapr-singlenode-vagrant/blob/master/aws/credentials.sh.sample

Copy the contents to your own `credentials.sh`, edit the variables, and run `source credentials.sh` prior to running the play.

Once your credentials are sourced into the environment, you can run the playbook:

```
ansible-playbook -i hosts playbooks/aws_bootstrap.yml
```

The `-i hosts` tells ansible to use the inventory file called hosts, which is useful only to the play because it defines localhost. The AWS tasks that run are all initiated from your local machine; your machine uses your credentials to connect to AWS and create the new instances.

Role Variables
--------------

The following need to be modified from these (personal) defaults. Odds are excellent these will not work at all for you, so you need to supply your own. Others may creep in over time, so be sure to check all the variables.

ec2_keypair: 'vgonzalez_keypair'

ec2_security_group: 'sg-d152d7b4'

ec2_region: 'us-east-1'

ec2_zone: 'us-east-1b'

ec2_image: 'ami-8997afe0'

vpc_subnet: 'subnet-9bfae2ef'


Dependencies
------------

python module boto (python AWS library)

Example Playbook
-------------------------

```
- hosts: localhost
  roles:
    - mapr-aws-bootstrap
```

License
-------

WTFPL

Author Information
------------------

Vince Gonzalez - vgonzalez@mapr.com

mapr-aws-bootstrap
========

This role uses the ec2 module via a local action to set up a 5-node MapR cluster, 1 edge node and 1 MySQL server. The service layout attempts to mostly follow the 5-node HA M5 cluster described here: http://doc.mapr.com/display/MapR/Planning+the+Cluster#PlanningtheCluster-ExampleClusterDesigns

Requirements
------------

1. AWS credentials (account ID and secret key)
2. As we will provision nodes in a VPC, one will have to exist, and you'll need the subnet ID.
3. You will need a base image. This has been tested with the CentOS 6.5 AMI in us-east-1 - ami-8997afe0
4. You will need your SSH keypair already generated and available in AWS. 
5. You will need a security group. The cluster that results from the install_cluster play uses a security group that allows ports 22 and 8443 as well as all traffic originating from the VPC subnet.

When run, the play will expect to obtain AWS credentials from environment variables. A sample file is provided here: https://github.com/vicenteg/mapr-singlenode-vagrant/blob/master/aws/credentials.sh.sample

Copy the contents to your own file, edit the variables, and run `source credentials.sh` prior to running the play.


Role Variables
--------------

The following need to be modified from these defaults:

ec2_keypair: 'vgonzalez_keypair'

ec2_security_group: 'sg-d152d7b4'

ec2_region: 'us-east-1'

ec2_zone: 'us-east-1b'

ec2_image: 'ami-8997afe0'

vpc_subnet: 'subnet-9bfae2ef'


Dependencies
------------

None

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


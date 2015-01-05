[![Build Status](http://test-1085049401.us-east-1.elb.amazonaws.com/buildStatus/icon?job=mapr-enterprise-develop)](https://test-1085049401.us-east-1.elb.amazonaws.com/job/mapr-enterprise-develop/)

IMPORTANT!
==

The AWS playbooks now assume the use of internal ec2 hostnames, in a VPC. This means the playbooks below should be run from an EC2 host in your VPC, or over a VPN connection.

Quick Start
============

Before you start, you should know where to get your AWS credentials, your VPC subnet, and
your preferred image ID (this varies by region).  You should have your ec2 keypair
already set up on the machine from which you'll run these playbooks.

Be aware that if you change the instance type, that can cascade into a series of
other changes, so if you're not comfortable with that, take the defaults.

Here's the step-by-step:

1. Ensure you have your AWS credentials.
2. Copy `aws/credentials.sh.sample` to `aws/credentials.sh` and edit it.
3. Check `playbooks/group_vars/all` to see if there's anything there you need to change.
4. Review `playbooks/aws_bootstrap.yml` and see if any variables need to change.
5. Source your credentials file, then bootstrap your nodes as follows.

  source aws/credentials.sh
  ansible-playbook -i hosts playbooks/aws_bootstrap.yml

6. Install the cluster.

  ansible-playbook -i playbooks/cluster.hosts playbooks/install_cluster.yml


mapr-ansible-roles
==================

Intro
======

This repo contains Ansible playbooks that do the following:

* Launch EC2 instances for MapR [playbooks/aws_bootstrap.yml](https://github.com/vicenteg/mapr-ansible-roles/blob/master/playbooks/aws_bootstrap.yml)
* Apply MapR OS prerequisites per http://doc.mapr.com/display/MapR/Preparing+Each+Node [playbooks/prerequisites.yml](https://github.com/vicenteg/mapr-ansible-roles/blob/master/playbooks/prerequisites.yml)
* Install a cluster [playbooks/install_cluster.yml](https://github.com/vicenteg/mapr-ansible-roles/blob/master/playbooks/install_cluster.yml)
* Install MapR Metrics & MySQL
* Install ecosystem projects:
  * Hive
  * Impala
  * HBase
* Print some information about the resulting cluster
  * webserver URLs

This project also includes a Vagrantfile that creates a single local VM instance, or a local VM cluster, suitable to run MapR. The playbooks here can be used either for vagrant instances or EC2 instances.

This will install MapR release 4.0.1 by default. It will not work for earlier releases.

This does not include a license, so to enable licensed features, you'll need to obtain a license here: http://www.mapr.com/user/addcluster

AWS Instances
==============

AWS instances you create will be spot instances by default unless you comment out the lines in `aws_bootstrap.yml` that specify the bid price. If you comment those out, you will get on demand instances, which will cost significantly more. The recommendation is that you consider using spot instances if the following apply:

1. You will not use the cluster for a live demonstration in front of important people
2. You will not store any important or long-lived data
3. You are OK with the cluster being terminated (i.e., destroyed forever) without warning
4. You don't need the instances to survive a reboot

If any of the above are not true (i.e, you will be doing a live demo, or you need the cluster to come up if you reboot a node) you should use on demand instances.

Be sure to check the latest spot prices for the instances you're looking to create. Also keep in mind that not all instances are available as spot instances. Importantly, remember that spot instances can be terminated by Amazon at any time if the bid price goes above the maximum price you set. So don't use spot instances if you absolutely must keep the instances running!

If you prefer on-demand instances (so that you're not at risk of automatic termination), edit `playbooks/aws_bootstrap.yml` and comment out the lines with `spot_price`.

Prerequisites
=============

You need to have installed boto, which is a python module ansible requires to use the EC2 API.

`pip install boto` should be all you need (use sudo or become root if needed).

Prerequisites - Vagrant
=======================

You will want VirtualBox and Vagrant installed. The versions I'm using are below.

```
$ VirtualBox --help
Oracle VM VirtualBox Manager 4.3.8
```

```
$ vagrant --version
Vagrant 1.5.1
```

Prerequisites - AWS
====================

Please review [the README for mapr-aws-bootstrap](https://github.com/vicenteg/mapr-singlenode-vagrant/tree/master/playbooks/roles/mapr-aws-bootstrap).

Before starting the installation, you will want to edit some variables. Variables can be modified in the top-level playbooks. For each group, you can inspect the role variables. An example, so you know what to look for is here:

```
- hosts: CentOS;RedHat
  max_fail_percentage: 0
  sudo: yes
  roles:
    - { role: mapr-redhat-prereqs,
        mapr_user_pw: '$1$yoPLWBQ6$6fvQchDTBu3Ccs3PVURpA.',
        mapr_uid: 2147483632,
        mapr_gid: 2147483632,
        mapr_home: '/home/mapr',
        mapr_version: 'v4.0.1' }
```

Edit them in the file, or you can override these using the `--extra-vars` argument to ansible-playbook. For example, the argument would look like this to change mapr_version:

```
--extra-vars "mapr_version=v4.0.1"
```

You could edit role variables to override the "default" choices there, or you could use `--extra-vars`. Using `--extra-vars` is probably easier to maintain if you're doing multiple installs from the same tree.

For mapr-metrics, review [its README file](https://github.com/vicenteg/mapr-ansible-roles/blob/master/playbooks/roles/mapr-metrics/README.md).


Pre-Install - AWS & Vagrant
===========================

1. Create a password for the mapr user. You'll use the mapr user to log into MCS. Use `openssl passwd -1` and put the hashed password in either extra-vars or in the role variables in the top-level playbook.
2. Make sure that the list of disks you want to use aligns with the disks present on the systems. If you didn't change the bootstrap playbook, you should not have to do anything. If you have a configuration that uses more than two disks, or uses different disks, you will want to inspect the `configure-cluster.yml` playbook, and make changes to the `mapr_disks` role variables there.
3. Check all the ec2 related variables. Chances are excellent you need to change something there.

Installation - Vagrant
=======================

Issue `vagrant up`, and watch as vagrant sets up your VM and provisions it.


Installation - AWS
===================

After modifying configuration files as needed, run the playbook as follows, being sure to substitute the path to your private key.

```
ansible-playbook -i playbooks/cluster.hosts --private-key <path/to/your/private_key> -u root \
	--extra-vars "mapr_cluster_name=my.cluster.com mapr_version=v4.0.1" \
	playbooks/install_cluster.yml
```

AWS: Variations
===============

Obviously, you have many choices when starting AWS instances. In this area, you'll find some ansible-playbook invocations that override variables in order to achieve different results, such as using different instance types, AMIs or regions.

## Use i2.2xlarge instances

```
ansible-playbook -i hosts \
        -e cluster_node_type=i2.2xlarge \
        -e edge_node_type=c3.large \
        -e mapr_cluster_name=vgonzalez-spark  \
        -e cluster_node_price= \
        -e edge_node_price= \
        -e ec2_image=ami-b66ed3de  \
        -e root_device_path=/dev/xvda \
        -e ssh_user=ec2-user \
        playbooks/aws_bootstrap.yml
```

## Use m3.xlarge spot instances

The spot instances will be bid ad $0.09:

```
ansible-playbook -i hosts \
	-e "cluster_node_price=0.09 cluster_node_type=m3.xlarge" \
	-e "edge_node_type=m3.xlarge edge_node_price=0.09" \
	playbooks/aws_bootstrap.yml
```



Post-Install - Vagrant - license key
=======================

After issuing `vagrant up`, the VM should be provisioned. Place your license key file in the directory along side the Vagrantfile. In your Vagrant directory, say:

`vagrant ssh`

And you should be dropped into a shell in your VM.

If your license key is called demolicense.txt, the steps following will add the key, start the NFS gateway and (additional) CLDB service.

```
sudo maprcli license add -license /vagrant/demolicense.txt -is_file true
sudo maprcli node services -filter "[csvc==nfs]" -nfs start
```

No need to manually mount the loopback NFS - warden will take care of that for you.

Post-Install - AWS - license key
=======================

After the installation is complete, the ansible plays will print the webserver URLs for you. Copy and paste the URL into your browser, log in with user `mapr` and the password you set earlier. Then add the license key via upload to MCS, using the upper right hand "Manage Licenses" link. You could, of course, upload the file using scp and then add it as above (with maprcli) if you choose.

Once done, start up NFS and the additional CLDB instance(s):

```
sudo maprcli node services -filter "[csvc==nfs]" -nfs start
sudo maprcli node services -filter "[csvc==cldb]" -cldb start
```

No need to manually mount the loopback NFS - warden will take care of that for you.

Post-Install Validation - Vagrant and AWS
========================

For a simple smoke test, try running a teragen:

```
hadoop jar /opt/mapr/hadoop/hadoop-0.20.2/hadoop-0.20.2-dev-examples.jar \
	teragen 100000 /user/vagrant/teragen
```

If you don't see a java traceback, things are probably mostly OK.

For a little more, try running the test playbook:

```
ansible -i playbooks/cluster.hosts playbooks/test_cluster.yml
```

If nothing comes back failed, you should be ready to rock.


Have fun.

Potential Gotchas
==

## Amazon Credentials

If you see messages like the following:

```
failed: [localhost] => {"assertion": "ansible_env.AWS_ACCESS_KEY is defined", "evaluated_to": false, "failed": true}
```

You missed the step about sourcing your Amazon credentials.

## Empty inventory groups

If you have issues and on inspection of the inventory file notice that some groups are empty, it might be that you specified the cluster node count on the command line. If that's the case, pass a JSON object to `--extra-vars` instead: `--extra-vars '{"cluster_node_count": 3}'`. This will allow ansible to treat cluster_node_count's value as an integer rather than a string. The interpretation of the value as a string will break the logic that selects the correct inventory template.

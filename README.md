mapr-ansible-roles
=======================

[![Build Status](https://magnum.travis-ci.com/vicenteg/mapr-ansible-roles.svg?token=JzqxKHfcdq9e6TfMmyz7&branch=master)](https://magnum.travis-ci.com/vicenteg/mapr-ansible-roles)

Read This
=========

First off, you need to change stuff in order to log in to the cluster that results from running these playbooks. 

Please skim through this README and look at what needs to change before you build.


Intro
======

This repo contains Ansible playbooks that do the following:

* Launch EC2 instances for MapR
* Install a basic cluster
* Install some ecosystem packages (Hive, Spark)

This project also includes a Vagrantfile that creates a single VM instance suitable to run MapR. The playbooks here can be used either for vagrant instances or EC2 instances.

This will install MapR release 3.1.1 by default. 3.0.2, 3.0.3 should also work. 

This does not include a license, so to enable licensed features, you'll need to obtain a license here: http://www.mapr.com/user/addcluster

AWS Instances
==============


AWS instances you create will be spot instances by default. Be sure to check the latest spot prices for the instances you're looking to create. Also keep in mind that not all instances are available as spot instances. Importantly, remember that spot instances can be terminated by Amazon at any time if the bid price goes above the maximum price you set. So don't use spot instances if you absolutely must keep the instances running!

If you prefer on-demand instances (so that you're not at risk of automatic termination), edit `playbooks/roles/mapr-aws-bootstrap/tasks/main.yml` and command out the lines with `spot_price`.

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

Before starting the installation, you'll need to edit the following variables. Note that if the variables do not exist in the file, you can add them. You can also add these variables to your playbook invocation using something like `--extra-vars "mykey=myvalue"` where mykey is the variable name below, and the myvalue is what you set.

Copy `playbooks/roles/mapr-aws-bootstrap/defaults/main.yml` to `playbooks/roles/mapr-aws-bootstrap/vars/main.yml`. Variables set in `vars/main.yml` override variable set in `defaults/main.yml`.

Review `vars/main.yml` - it has comments that will explain what each variable is for.

For mapr-metrics, review [its README file](https://github.com/vicenteg/mapr-ansible-roles/blob/master/playbooks/roles/mapr-metrics/README.md).


Pre-Install - AWS & Vagrant
===========================

1. Create a password for the mapr user. You'll use the mapr user to log into MCS. Use `openssl passwd -1` and put the hashed password in `playbooks/group_vars/all` in the variable `mapr_user_pw`.
2. Take a look at the rest of the variables in group_vars/all and override them as needed.
3. For each subdirectory of `roles`, there is a file `defaults/main.yml` which contains (you guessed it!) defaults for each role. It's worth a look at these to see if there's anything you want to override. In particular, look at `playbooks/roles/mapr-fileserver/defaults/main.yml` and add the disks to 

Installation - Vagrant
=======================

Issue `vagrant up`, and watch as vagrant sets up your VM and provisions it.


Installation - AWS
===================

After modifying configuration files as needed, run the playbook as follows, substituting your keypair for mine:

```
ansible-playbook -i playbooks/cluster.hosts --private-key <path/to/your/private_key> -u root playbooks/install_cluster.yml
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

To test, try running a teragen:

```
hadoop jar /opt/mapr/hadoop/hadoop-0.20.2/hadoop-0.20.2-dev-examples.jar \
	teragen 100000 /user/vagrant/teragen
```

If you don't see a java traceback, things are probably mostly OK.

Have fun.
